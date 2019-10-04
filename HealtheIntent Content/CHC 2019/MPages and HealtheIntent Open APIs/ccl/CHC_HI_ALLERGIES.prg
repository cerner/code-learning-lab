drop program chc_hi_patient_allergies go
create program chc_hi_patient_allergies

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

declare numAllergies            = i4 with protect, noconstant(0.0)

; Build URL to call the patient allergy list endpoint.
; https://docs.healtheintent.com/api/v1/allergy/#retrieve-a-list-of-allergies
set URL = build2("https://" , hiTenant
        , ".api.us.healtheintent.com/allergy/v1/populations/", populationID
        , "/patients/", hiPatientID
        , "/allergies")

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
      1 ALLERGIES[*]
        2 ASSERTED_ON = vc
        2 CATEGORY = vc
        2 CODE = vc
        2 CRITICALITY = vc
        2 ONSET = vc
        2 STATUS = vc
        2 REACTION_TYPE = vc
  )

  ; Convert response to record structure
  free record REPLY_REC
  set stat = CNVTJSONTOREC(build2(^{"REPLY_REC":^, proxyReply->httpreply->body, "}"))

  ; Resize allergy list
  set numAllergies = size(REPLY_REC->items, 5)
  set stat = ALTERLIST(OUTREC->ALLERGIES, numAllergies)

  ; Set Return values
  if(validate(proxyReply->httpreply->STATUS))
    set OUTREC->STATUS_CODE = proxyReply->httpreply->STATUS
  endif
  for(num = 1 to numAllergies)
    if(validate(REPLY_REC->items[num].assertedon))
      set OUTREC->ALLERGIES[num].ASSERTED_ON = REPLY_REC->items[num].assertedon
    endif
    if(validate(REPLY_REC->items[num].category.text))
      set OUTREC->ALLERGIES[num].CATEGORY = REPLY_REC->items[num].category.text
    endif
    if(validate(REPLY_REC->items[num].code.text))
      set OUTREC->ALLERGIES[num].CODE = REPLY_REC->items[num].code.text
    endif
    if(validate(REPLY_REC->items[num].criticality.text))
      set OUTREC->ALLERGIES[num].CRITICALITY = REPLY_REC->items[num].criticality.text
    endif
    if(validate(REPLY_REC->items[num].onset))
      set OUTREC->ALLERGIES[num].ONSET = REPLY_REC->items[num].onset
    endif
    if(validate(REPLY_REC->items[num].status.text))
      set OUTREC->ALLERGIES[num].STATUS = REPLY_REC->items[num].status.text
    endif
    if(validate(REPLY_REC->items[num].type.text))
      set OUTREC->ALLERGIES[num].REACTION_TYPE = REPLY_REC->items[num].type.text
    endif
  endfor

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