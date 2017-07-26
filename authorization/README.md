Code Learning Lab - SMART(R) Authorization
==========================================

# Lab 1: Authorization Code Flow

## Step 1:  Load the demo

https://authz-demo.sandboxcerner.com/client/demo

## Step 2:  Open the web console

The web console will output useful information about the specific steps 
being performed to orchestrate the authorization process.  Perform the 
following steps to open it in your browser:

- Chrome:        Ellipsis Menu->More Tools->Developer Tools->Console
- Firefox:       Tools->Web Developer->Web Console
- Edge / IE:     F12 key->Console

## Step 3:  Populate authorization request parameters

In the box labeled "2", fill out the following parameters.  These
parameters are used to construct the authorization request to the
authorization server.

- Auth Server URI:  https://authorization.sandboxcerner.com/tenants/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/protocols/oauth2/profiles/smart-v1/personas/provider/authorize
  - This is the "authorization" endpoint where the authorization 
    request will be submitted to.
  - It is the entry point that will guide the user through steps 
    to confirm their identity, and conditionally, provide consent.

- Client ID:        c4093c13-1ed1-47ef-95a6-a225d3e47023
  - This is the unique identifier that this application uses 
    to identify itself with the above authorization server.

- Scope(s):         user/Patient.read
  - This is the access being requested by the demo application.
  
- Aud:              https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca
  - This is the base URL hosting the services that will be accessed.
  - The authorization server verifies this is a URL known to it, as 
    to prevent you from accidentally sending tokens to a malicious party.
	
_Note_:  An additional parameter "state" is automatically generated for you by the demo application.  Your client application should generate and store its own state value associated to a given device to prevent malicious parties from orchestrating a "session fixation"-style attack.

## Step 4:  Submit the request

- Click "Get Authorization Code"
- A second window will open to orchestrate authentication / authorization.
- Enter the lab credentials, click log-in.
- This tab should close, and the previous tab should foreground.

## Step 5:  Verify token request parameters

In the box labeled "3", make sure the following parameters
have been pre-populated:

- Token URI:    https://authorization.sandboxcerner.com/tenants/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/protocols/oauth2/profiles/smart-v1/token
  - This is the URL where the token request will be submitted.

- Client ID:    c4093c13-1ed1-47ef-95a6-a225d3e47023
  - This is the unique identifier that this application uses 
    to identify itself with the above authorization server.

- Code:        	(varies)
  - This the authorization code sent by the authorization
    server at the completion of step 4.

## Step 6:  Submit token request

- Click "Get Access Token"
  - If an error occurs, the authorization code may have expired.
  - In this event, perform step 3, 4, immediately followed by this 
    step.

## Step 7:  Examining the output

- The text area in the box labeled "3" contains the token response
  from the server.
  - The "access_token" is a bearer token that is used to access
    web services.
  - The "scope" indicates what the server or person granted your
    client application (more on scopes later).
  - "expires_in" declares the number of seconds for which the 
    access token will remain valid.
- Examine the web console for details on how the field values
  were constructed into requests used to orchestrate authorization.

# Lab 2: Utilizing an access token 

## Step 1:  Submit an Authorization Request

- Repeat steps 1-4 of Lab 1.

## Step 2:  Submit a token request

- Click "Get Access Token".

## Step 3:  Request a patient record

- In the demo application, locate the field named "Resource Server"
  section 4 "Access protected resource"
  - Enter the value:
    https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Patient/1316024
- Click "Access Protected Resource"

## Step 4:  Tamper with the access token

- In the text field labeled "Access Token", modify the value of the JSON
  value of "access_token".
- Click "Access Protected Resource"
- What response was returned from the service?

# Lab 3: Scopes

## Step 1:  Submit an authorization request

- Repeat steps 1-4 of Lab 1.

## Step 2:  Submit a token request

- Click "Get Access Token"

## Step 3:  Access a protected resource without appropriate scopes

- In the demo application, locate the field named "Resource Server" in section 4 "Access protected resource"
  - Enter the value:
    https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Practitioner/1272007
- Submit the Request	
  - Note the "403" error response code (the scopes requested did not include the Practitioner resource.)

## Step 4:  Access a protected resource with appropriate scopes
- Repeat the authorization request with the additional scope of "user/Practitioner.read"
- Repeat the token request.  
  - Confirm that "user/Practitioner.read" is returned in the list of scopes.
- Repeat the resource request.  
  - Confirm a resource is successfully returned.
  
## Step 5:  Request fictitious/unauthorized scopes

- Repeat the authorization request with the additional scopes of "user/Fictitious.read system/Patient.read"
- Repeat the token request.  
  - Confirm that neither of these scopes are returned in the list of scopes.
  
	
# Lab 4: Discovering Authorization Endpoints via Conformance

## Step 1:  Clear previous URI values

- In section "2" of the demo application, delete the value of "Auth Server URI" and "Aud".
- In the section "3" of the demo application, delete the value of "Token URI".

## Step 2:  Discover endpoints via the conformance document

- In section "1" of the demo application, enter the following value for "FHIR Base URL"
  - https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca
- Click "Discover Authorization URLs"

## Step 3:  Confirm discovery succeeded

- Verify content for the conformance document was returned.
- Verify that "Auth Server URI" in section "2" of the demo application now matches the value from Lab 1.
- Verify that value "Aud" in section "2" of the demo application now matches the value from Lab 1.
- Verify that "Token URI" in section "3" of the demo application now matches the value from Lab 1.

# Lab 5: Launch

_Note_:  This lab requires a launch code generated by the presenter. 

## Step 1:  Receive and parse a launch request

- The instructor will generate a launch code, append it to the launch URL of the demo application, then generate a bit.ly link.
  - Transcribe the bit.ly URL into your browser.
- Note the FHIR Base URL is populated with the "iss" value.
- Note in section 2 of the demo application that the "Launch Code" value is populated with the "launch" value.
- Note in section 2 of the demo application that the "aud" (audience) value is populated with the "iss" value.

_Instructor Note_: The callback URL for the demo app is as follows:

- https://authz-demo.sandboxcerner.com/client/demo?iss=https%3A%2F%2Ffhir-ehr.sandboxcerner.com%2Fdstu2%2F0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca&launch=

## Step 2:  Perform discovery

- In section "1" of the demo application, click "Discover Authorization URLs".

## Step 3:  Submit an authorization request

- In section "2" of the demo application, enter the scopes "patient/Patient.read launch"
- Click "Get Authorization Code".
- If prompted, enter credentials.

## Step 4:  Submit a token request

- Click "Get Access Token"
- Note the additional fields returned in the token response, including the identifier for the patient record (Patient/1316024)

## Step 5:  Request a patient record

- In the demo application, locate the field named "Resource Server" section 4 "Access protected resource".
  - Enter the value:
    https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Patient/4342012
- Click "Access Protected Resource"

## Step 6:  Request a different patient record

- In the demo application, locate the field named "Resource Server" section 4 "Access protected resource".
  - Enter the value:
    https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/Patient/4342008
- Click "Access Protected Resource"
- Note Access is Denied (Status = 403).
- Switch the scopes to "user/Patient.read launch", then click "Get Authorization Code".
- Click "Get Access Token"
- Click "Access Protected Resource"
- Note that you are able to access the resource using the "user"-qualified scope, whereas previously the "patient"-qualified scope constrained the client's permissions to the launched patient record.

# Lab 6: OpenID

## Step 1:  Prepare an authorization request with the openid scope

- Visit the following URL: https://authz-demo.sandboxcerner.com/client/demo?iss=https%3A%2F%2Ffhir-ehr.sandboxcerner.com%2Fdstu2%2F0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca
- In section "1" of the demo application, click "Discover Authorization URLs".
- In section "2" of the demo application, enter the scopes "user/Patient.read openid"

## Step 2:  Submit the authorization request

- Click "Get Authorization Code".
- If prompted, enter credentials.

## Step 3:  Submit a token request

- Click "Get Access Token"
- Note the presence of "id_token" in the token response.

## Step 4:  Introspect the id_token

- Open the website http://jwt.io/ in a new tab.
- Paste the contents of the id_token into the website.
- Examine the decoded contents

_Note_:  The subject + issuer combined are considered the globally unique "identifier" for a given user.
_Note_:  _NEVER_ enter tokens from a production environment into jwt.io unless such tokens are expired.

## Step 5:  Evaluate if the token is signed

- Examine the decoded token header in jwt.io
  - Note that the "alg" parameter is RS256.
  - This token is signed using an RSA key over a SHA-2 hash.
  - Tokens from other implementations may be signed with an "alg" of "none".
  - Note the value of "kid" (key ID) for step 7.
- Note that the "iss" (issuer) is different than the token endpoint.

## Step 6:  Fetch the OpenID configuration document

- Append "/.well-known/openid-configuration" to the issuer value:
  - https://authorization.sandboxcerner.com/tenants/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/oidc/idsps/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca/.well-known/openid-configuration
- Paste this URL into a new tab in your browser.

## Step 7:  Fetch the JSON Web Key Set document

- Note the URL in the field "jwks_uri" in the OpenID configuration document.
- Paste this URL into a new tab in your browser.
- Locate the RSA key with a key ID ("kid") matching that from step 5.
- This is the key that would be utilized to verify the signed JSON Web Token.

_Note_:  Many JWT libraries provide utilities to perform token signature verification and for parsing JSON Web Key Set documents. 

# Lab 7: Refresh Tokens

## Step 1:  Prepare an authorization request with the online_access scope

- Visit the following URL: https://authz-demo.sandboxcerner.com/client/demo?iss=https%3A%2F%2Ffhir-ehr.sandboxcerner.com%2Fdstu2%2F0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca
- In section "1" of the demo application, click "Discover Authorization URLs".
- In section "2" of the demo application, enter the scopes "user/Patient.read online_access"

## Step 2:  Submit the authorization request

- Click "Get Authorization Code".
- If prompted, enter credentials.

## Step 3:  Submit a token request

- Click "Get Access Token"
- Note the presence of "refresh_token" in the token response.
- Note a "Refresh Access Token" button appears.

## Step 4:  Submit a token refresh request

- Note the content of the current token response.
- Click "Refresh Access Token"
- Note that a new access token is returned with a new token response.

## Step 5:  Trigger a "user log-out"

- In a separate tab, open the following URL:
  - https://authorization.sandboxcerner.com/session-api/log-out

_Note_:  This is a private log-out mechanism, used by the authorization server to end a session, and not a contract offered by SMART.

## Step 6:  Submit a second token refresh request

- Click "Refresh Access Token"
- Note that the refresh fails.

_Note_:  Existing access tokens are still valid until they expire.

# Lab 8: Exception Cases

## Step 1:  Make an authorization request without the required audience parameter

- In section 2, remove the "aud" parameter.
- Click "Get Authorization Code".

## Step 2:  Examine the authorization response

- Note the x-www-form-urlencoded query parameters returned in response contain an error and error_uri.
- Extract the error_uri parameter
- URI-decode the error_uri value (https://www.bing.com/search?q=url+decoder)
- Visit the URL in a separate tab.
- Note the user-facing elements of Cerner's error pages:
  - An error message with support contact information.
  - An error message for developers.
  - A "correlation ID" for assisting troubleshooting / diagnosis.

## Step 3:  Submit a new authorization request

- In section "2" of the demo application, replace the value of "aud" with the following:
  - https://fhir-ehr.sandboxcerner.com/dstu2/0b8a0111-e8e6-4c26-a91c-5069cbc6b1ca
- Click "Get Authorization Code"

## Step 4:  Submit a token request, twice

- Click "Get Access Token".
- Click "Get Access Token" a second time.
- Note the error that returns.

## Step 5:  Submit an authorization request specifying a redirect_uri

- In section "2" of the demo application, replace the value of "redirect_uri" with the following:
  - https://authz-demo.sandboxcerner.com/client/demo/cb?1=1
- Click "Get Authorization Code"
- In section "2" of the demo application, replace the value of "redirect_uri" with the following:
  - https://authz-demo.sandboxcerner.com/client/demo/cb/?1=1
  - Note the addition of a trailing space
- Click "Get Authorization Code"
- Note the error that an error page is presented directly to the user
  - The authorization server will not redirect the user to an "untrusted" callback URI per specifications.