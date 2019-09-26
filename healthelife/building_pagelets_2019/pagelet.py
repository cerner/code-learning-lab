from flask import Flask, url_for, render_template, request, abort, make_response
import requests
from jose import jwt
from fhirclient import client

app = Flask(__name__)

TRUSTED_ORIGIN = 'https://chc2019-pageletclass.patientportal.us.healtheintent.com'
MY_ORIGIN = 'https://localpagelet.test:8000'
CERNER_JWKS = 'https://authorization.cerner.com/jwk'
CERNER_EHR_FHIR = 'https://fhir-open.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca'

def process_token(encoded_token):
    keyset = requests.get(CERNER_JWKS).json()
    try:
        return jwt.decode(encoded_token, keyset,
            audience=MY_ORIGIN,
            issuer=TRUSTED_ORIGIN,
            options= {
                'verify_iat': True,
                'verify_exp': True,
            }
        )
    except (jwt.JWTError, jwt.ExpiredSignatureError, jwt.JWTClaimsError) as e:
        app.logger.info('BCS Token process failure: %s', e)
        abort(403)

    return 

def prevent_clickjacking(response, token):
    response.headers['Content-Security-Policy'] = f"frame-ancestors {token['iss']};"
    response.headers['X-Frame-Options'] = f"allow-from {token['iss']}"

    return response

# def make_fhir():
#     settings = {
#         'app_id': 'example',
#         'api_base': CERNER_EHR_FHIR
#     }

#     return client.FHIRClient(settings=settings)

@app.route('/')
def pagelet():
    try:
        encoded_token = request.args['bcs_token']
    except KeyError:
        abort(400, 'Missing BCS Token!');

    token = process_token(encoded_token)
    # fhir = make_fhir()

    content = render_template('hello.html', src=url_for('static', filename='pic.png'))
    response = make_response(content)
    # response = prevent_clickjacking(response, token)
    
    return response
