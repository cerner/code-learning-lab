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

def get_keyset():
    return {}

def process_token(encoded_token):
    keyset = get_keyset()
    return {'sub': DEMO_USER_FPA}

def prevent_clickjacking(response, token):
    response.headers['Content-Security-Policy'] = "frame-ancestors  'none'"
    response.headers['X-Frame-Options'] = "SAMEORIGIN"

    return response

def lookup_patient(token):
    return {'name': 'Joan Ishikawa', 'id': '123456'}

def lookup_procedures(patient):
    import datetime
    return [
        {'name': 'Appendectomy', 'date': datetime.date(1970, 1, 1)},
        {'name': 'Cataract surgery', 'date': datetime.date(2000, 1, 1)}
    ]

def format_date(date):
    if date:
        return date.strftime('%B %d, %Y') 

    return 'No date given.'

app.jinja_env.filters['date'] = format_date

    
@app.route('/')
def procedures():
    encoded_token = 'dG9rZW4='
   
    token = process_token(encoded_token)
    patient = lookup_patient(token)
    procedures = lookup_procedures(patient)

    content = render_template('procedures.html', 
        procedures=procedures,
        stylesheet=url_for('static', filename='style.css')
    )

    response = make_response(content)
    response = prevent_clickjacking(response, token)
    
    return response
