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

    
@app.route('/')
def procedures():
    token_param = request.args['bcs_token']
    
    content = render_template('procedures.html', 
        stylesheet=url_for('static', filename='style.css')
    )

    response = make_response(content)
    
    return response
