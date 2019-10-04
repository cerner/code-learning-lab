drop program chc_hi_patient_lookup go
create program chc_hi_patient_lookup

; Parameters for the script
; Output:                 Set output to "MINE"
; Population ID:          The population ID of the patient.
; Data Partition ID:      The data partition ID of the patient
; Millennium Person ID:   The local patient ID in the calling system.
prompt
  "Output" = "MINE",
  "Population ID" = "",
  "Data Partition ID" = "",
  "Millennium Person ID" = 0.0

with OUTDEV, populationID, dataPartitionID, millenniumPersonID

; Declare a subroutine used to return the response from the API
declare ReturnRecordAsJSON(record_data = VC(REF)) = null with protect

; Declare tenant mnemonic
declare hiTenant                = vc with protect, constant("cernerdemo")

; Declare local variables
declare URL                     = vc with protect, noconstant("")
declare millenniumPersonID      = f8 with protect, noconstant($millenniumPersonID)
declare dataPartitionID         = vc with protect, noconstant($dataPartitionID)
declare populationID            = vc with protect, noconstant($populationID)

; Build URL for patient look-up
set URL = build2("https://" , hiTenant
        , ".api.us.healtheintent.com/patient/v1/populations/", populationID
				, "/patient-id-lookup?"
				, "dataPartitionId=", dataPartitionID
				, "&sourcePersonId=", CNVTSTRING(millenniumPersonID, 0))

; Look up HealtheIntent patient ID
execute hi_http_proxy_get_request "MINE", URL

; Check response code
if(proxyReply->httpreply->status = 200)

  ; Declare the record structure to be returned
  free record OUTREC
  record OUTREC(
    1 STATUS_CODE = i4
    1 HI_PATIENT_ID = vc
  )

  ; Pull out HealtheIntent person ID
  free record REPLY_REC
  set stat = CNVTJSONTOREC(build2(^{"REPLY_REC":^, proxyReply->httpreply->body, "}"))
  if(validate(proxyReply->httpreply->STATUS))
    set OUTREC->STATUS_CODE = proxyReply->httpreply->STATUS
  endif
  if(validate(REPLY_REC->items[1].patient.id))
    set OUTREC->HI_PATIENT_ID = REPLY_REC->items[1].patient.id
  endif

  ; Return JSON structure containing the Patient ID
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

  ; Return JSON structure containing the error message
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
