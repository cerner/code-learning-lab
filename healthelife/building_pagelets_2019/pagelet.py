from flask import Flask, url_for, render_template, request, abort, make_response
import requests
from jose import jwt
from fhirclient import client
from fhirclient.models.patient import Patient
from fhirclient.models.procedure import Procedure

app = Flask(__name__)

TRUSTED_ORIGIN = 'https://chc2019-pageletclass.patientportal.us.healtheintent.com'
MY_ORIGIN = 'https://localpagelet.test:8000'
CERNER_JWKS = 'https://authorization.cerner.com/jwk'
CERNER_FPA_URN = 'urn:oid:2.16.840.1.113883.3.13.6'
DEMO_USER_FPA = 'URN:CERNER:IDENTITY-FEDERATION:REALM:2E882EFF-FA72-4882-ADC8-A685F7D2BFA6:PRINCIPAL:20A8C75B4900A689D48A72837BF7618B'

def process_token(encoded_token):
    """ Decode the token. Verify the JWT's signature and validate its claims. 

    Args:
        encoded_token: A base64-encoded string representation of the BCS Token.

    Returns:
        Dict of token claims.

    Raises:
        HTTPException: 403 if the signature can't be verified or if the claims are invalid.
    """
    keyset = requests.get(CERNER_JWKS).json()
    try:
        token = jwt.decode(encoded_token, keyset,
            audience=MY_ORIGIN,
            issuer=TRUSTED_ORIGIN,
            options= {
                'verify_iat': True,
                'verify_exp': True,
            }
        )

        # OK, this is schenanigans to always "be" a test user in the FHIR sandbox no matter
        # what test user you're really using. You won't do this in a real app :) 
        token['sub'] = DEMO_USER_FPA
        return token

    except (jwt.JWTError, jwt.ExpiredSignatureError, jwt.JWTClaimsError) as e:
        app.logger.info('BCS Token process failure: %s', e)
        abort(403)
    return 

def prevent_clickjacking(response, token):
    """ Add response headers to prevent clickjacking attacks. 

    Args:
        response: The flask response.
        token: A dict of token claims.

    Returns:
        The response, now with extra headers.
    """
    response.headers['Content-Security-Policy'] = f"frame-ancestors {token['iss']};"
    response.headers['X-Frame-Options'] = f"allow-from {token['iss']}"

    return response

def demo_fhir_server():
    """ Builds a SMART server against Cerner's open playground for querying. 

    See http://fhir.cerner.com/millennium/dstu2/#open-sandbox.

    Returns:
        A SMART server that requires no auth tokens to use.
    """
    return client.FHIRClient(settings={
        'app_id': "example",
        'api_base': 'https://fhir-open.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca'
    }).server

def lookup_patient(federated_principal_alias):
    """ Queries a patient by FPA. 

    Args:
        federated_principal_alias: ID of a person in Cerner's Identity Federation. 

    Returns:
        {"name": "<patient's name>", "id": <FHIR server's patient ID>}
    """
    identifier = f'{CERNER_FPA_URN}|{federated_principal_alias}'
    search = Patient.where(struct={'identifier': identifier})
    patients = search.perform_resources(demo_fhir_server())
    
    return {'name': patients[0].name[0].text, 'id': patients[0].id}

def lookup_procedures(patient):
    search =Procedure.where(struct={'patient': patient['id']})
    procedures = search.perform_resources(demo_fhir_server())

    return [{'name': pro.code.text, 'date': pro.performedDateTime.date} if pro.performedDateTime 
            else {'name': pro.code.text} 
            for pro in procedures]

def format_date(value):
    """ Produce a human-readible date from an ISO date.
        
    Args:
        value: a Date object

    Returns: A human-readible date string, or empty string if _value_ is None.
    """

    if value:
        return value.strftime('%Y-%m-%d') 

    return 'No date given.'

app.jinja_env.filters['date'] = format_date

    
@app.route('/')
def procedures():
    """ Serves a pagelet showing the user's patient's procedures.

    Assumes the user is the patient. Only works when embedded in the Cerner portal,
    because the BCS Token is required.

    Query parameters:
        bcs_token: Base64-encoded string representation of a BCS Token.

    Raises:
        HTTPException: 400 if the BCS token query param is missing.
        HTTPException: 403 if the BCS token can't be verified and validated.

    Returns:
        Response object.
    """
    try:
        encoded_token = request.args['bcs_token']
    except KeyError:
        abort(400, 'Missing BCS Token!');

    token = process_token(encoded_token)
    patient = lookup_patient(token['sub'])
    procedures = lookup_procedures(patient)

    content = render_template('procedures.html', 
        procedures=procedures,
        stylesheet=url_for('static', filename='style.css')
    )

    response = make_response(content)
    response = prevent_clickjacking(response, token)
    
    return response
