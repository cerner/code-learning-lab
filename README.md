Handy Cut & Paste items for Labs:

Lab 1:
- Demo Link: http://bit.ly/2f0GBOc
- Client ID: 94bbd90d-482a-4a10-b7df-b40edb278da2
- Scope: patient/Patient.read patient/Encounter.read launch
- Resource URL: https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Patient/1316024


Lab 2:
- Scope: user/Patient.read user/Encounter.read launch
- Resource URL: https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Patient/4342008

Lab 3:
- Scope: user/Patient.read user/Encounter.read

Lab 4:
- Scope: user/Patient.read openid

Lab 5:
- Scope: user/Patient.read user/Encounter.read online_access
- Log Out URL: https://authorization.sandboxcerner.com/session-api/log-out

Lab 6:
- Audience: https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca

Lab 7:
- Scope: user/Patient.read user/Imaginary.read

Lab 9:
- Valid Callback URI: https://authz-demo.sandboxcerner.com/client/demo/cb
- Invalid Callback URI: https://authz-demo.sandboxcerner.com/client/demo/cb/

Lab 10:
- Scope: user/Encounter.read
- Resource URL: https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Patient/1316024
- Scope: user/Encounter.read user/Patient.read

Lab 14:

Launch.html modifications:

```
Add no-cache meta tags to make prototyping easier:
<meta http-equiv="cache-control" content="max-age=0" />
<meta http-equiv="cache-control" content="no-cache" />
<meta http-equiv="expires" content="0" />
<meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
<meta http-equiv="pragma" content="no-cache" />

Modify  'scope': 

user/Patient.read user/MedicationStatement.read user/MedicationStatement.write
```

Index.html modifications: http://bit.ly/2fSCc0Q


