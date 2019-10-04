drop program chc_hi_patient_demographics go
create program chc_hi_patient_demographics

; Parameters for the script
; Output:                    Set output to "MINE"
; Population ID:             The population ID of the patient.
; HealtheIntent Patient ID:  The HealtheIntent patient identifier.
prompt
  "Output" = "MINE",
  "Population ID" = "",
  "HealtheIntent Patient ID" = 0.0
with OUTDEV, populationID, healtheintentPatientID

; Declare a subroutine used to return the response from the API
declare ReturnRecordAsJSON(record_data = VC(REF)) = null with protect

; Declare tenant mnemonic
declare hiTenant                = vc with protect, constant("cernerdemo")

; Declare local variables
declare URL                     = vc with protect, noconstant("")
declare hiPatientID             = vc with protect, noconstant($healtheintentPatientID)
declare populationID            = vc with protect, noconstant($populationID)

; Build URL to call the patient demographics list endpoint.
; https://docs.healtheintent.com/api/v1/patient/#retrieve-a-list-of-demographic-records
set URL = build2("https://" , hiTenant
        , ".api.us.healtheintent.com/patient/v1/populations/", populationID
        , "/patients/", hiPatientID
        , "/demographics")

; Make call
execute hi_http_proxy_get_request "MINE", URL

; Check response code
if(proxyReply->httpreply->status = 200)

  ; Declare the record structure to be returned
  ; Note that this is a small subset of the information that is provided by
  ; the API for demonstration purposes.
  free record OUTREC
  record OUTREC(
      1 STATUS_CODE = i4
      1 FORMATTED_NAME = vc
      1 DEMOGRAPHIC_ID = vc
      1 BIRTH_DATE = vc
      1 BIRTH_SEX = vc
      1 MARITAL_STATUS = vc
      1 RACE = vc
      1 ETHNICITY = vc
  )
  
  ; Convert response to record structure
  free record REPLY_REC
  set stat = CNVTJSONTOREC(build2(^{"REPLY_REC":^, proxyReply->httpreply->body, "}"))

  ; Set Return values
  if(validate(proxyReply->httpreply->STATUS))
    set OUTREC->STATUS_CODE = proxyReply->httpreply->STATUS
  endif
  if(validate(REPLY_REC->items[1].names[1].familynames[1]) and validate(REPLY_REC->items[1].names[1].givennames[1]))
    set OUTREC->FORMATTED_NAME = build2(REPLY_REC->items[1].names[1].givennames[1], " ",
                                      REPLY_REC->items[1].names[1].familynames[1])
  endif
  if(validate(REPLY_REC->items[1].id))
    set OUTREC->DEMOGRAPHIC_ID = REPLY_REC->items[1].id
  endif
  if(validate(REPLY_REC->items[1].birthdate))
    set OUTREC->BIRTH_DATE = REPLY_REC->items[1].birthdate
  endif
  if(validate(REPLY_REC->items[1].birthsex))
    set OUTREC->BIRTH_SEX = REPLY_REC->items[1].birthsex
  endif
  if(validate(REPLY_REC->items[1].maritalstatus))
    set OUTREC->MARITAL_STATUS = REPLY_REC->items[1].maritalstatus
  endif
  if(validate(REPLY_REC->items[1].races[1].text))
    set OUTREC->RACE = REPLY_REC->items[1].races[1].text
  endif
  if(validate(REPLY_REC->items[1].ethnicities[1].text))
    set OUTREC->ETHNICITY = REPLY_REC->items[1].ethnicities[1].text
  endif
  
  call ReturnRecordAsJSON(OUTREC)
  call echorecord(OUTREC)

else

  ; Declare the record structure to be returned
  free record OUTREC
  record OUTREC(
      1 STATUS_CODE = i4
      1 ERROR_MESSAGE = vc
  )

  ; Set return values
  if(validate(proxyReply->httpreply->STATUS))
    set OUTREC->STATUS_CODE = proxyReply->httpreply->STATUS
  endif
  if(validate(proxyReply->httpreply->body))
    set OUTREC->ERROR_MESSAGE = proxyReply->httpreply->body
  endif

  call ReturnRecordAsJSON(OUTREC)
  call echorecord(OUTREC)

endif

subroutine ReturnRecordAsJSON(record_data)

  declare originalMaxStringLength = i4 with noconstant(0)
  declare newMaxStringLength = i4 with noconstant(0)

  ; Declares a temporary stucture to hold the response data as a string
	record tempJson(
		1 val = gvc
	)

  ; Returns the record data as a json string with the record 
  ; name 'record_data' as the top-level key.
	set tempJson->val = cnvtrectojson(record_data)

  ; Set to the current maximum string length
  set originalMaxStringLength = curmaxvarlen

  ; Set to the length of the record converted to json, plus a buffer
  set newMaxStringLength = textlen(tempJson->val) + 1000

  ; If needed, adjust the max string length so that the entire
  ; json response can be returned
  if (newMaxStringLength > originalMaxStringLength)
    set modify maxvarlen newMaxStringLength
  endif

  set _Memory_Reply_String = tempJson->val

  ; Reset the max string length
  if(newMaxStringLength > originalMaxStringLength)
	  set modify maxvarlen originalMaxStringLength
  endif

end

end
go