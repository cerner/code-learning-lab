; https://docs.healtheintent.com/api/alpha/registries/#healtheregistries-api
drop program chc_hi_patient_registries go
create program chc_hi_patient_registries

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

declare numPrograms             = i4 with protect, noconstant(0.0)
declare numMeasures             = i4 with noconstant(0.0)

; Build URL to call the registries summary endpoint.
; https://docs.healtheintent.com/api/alpha/registries/
set URL = build2("https://" , hiTenant
        , ".registries.healtheintent.com/api/populations/", populationID
        , "/people/", hiPatientID
        , "/registries")


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
      1 QUALITY_SCORE = vc
      1 MARA_RISK_SCORE = f8
      1 PROGRAMS[*]
        2 NAME = vc
        2 MEASURE_COUNT = i4
        2 MET_COUNT = i4
        2 MEASURES[*]
          3 DUE = i4
          3 NAME = vc
          3 OUTCOME = vc
  )

  ; Convert response to record structure
  free record REPLY_REC
  set stat = CNVTJSONTOREC(build2(^{"REPLY_REC":^, proxyReply->httpreply->body, "}"))

  ; Resize program list
  set numPrograms = size(REPLY_REC->programs, 5)
  set stat = ALTERLIST(OUTREC->PROGRAMS, numPrograms)

  ; Set Return values
  if(validate(proxyReply->httpreply->STATUS))
    set OUTREC->STATUS_CODE = proxyReply->httpreply->STATUS
  endif
  if(validate(REPLY_REC->QUALITY_SCORE))
    set OUTREC->QUALITY_SCORE = REPLY_REC->QUALITY_SCORE
  endif
  if(validate(REPLY_REC->MARA_TOTAL_RISK_SCORE))
    set OUTREC->MARA_RISK_SCORE = REPLY_REC->MARA_TOTAL_RISK_SCORE
  endif

  for(i = 1 to numPrograms)
    if(validate(REPLY_REC->PROGRAMS[i].name))
      set OUTREC->PROGRAMS[i].name = REPLY_REC->PROGRAMS[i].name
    endif
    if(validate(REPLY_REC->PROGRAMS[i].total_measure_count))
      set OUTREC->PROGRAMS[i].measure_count = REPLY_REC->PROGRAMS[i].total_measure_count
    endif
    if(validate(REPLY_REC->PROGRAMS[i].met_measure_count))
      set OUTREC->PROGRAMS[i].met_count = REPLY_REC->PROGRAMS[i].met_measure_count
    endif

    set numMeasures = size(REPLY_REC->PROGRAMS[i].measures, 5)
    set stat = ALTERLIST(OUTREC->PROGRAMS[i].measures, numMeasures)
    for(j = 1 to numMeasures)
      if(validate(REPLY_REC->PROGRAMS[i].measures[j].measure_due))
        set OUTREC->PROGRAMS[i].measures[j].due = REPLY_REC->PROGRAMS[i].measures[j].measure_due
      endif
      if(validate(REPLY_REC->PROGRAMS[i].measures[j].name))
        set OUTREC->PROGRAMS[i].measures[j].name = REPLY_REC->PROGRAMS[i].measures[j].name
      endif
      if(validate(REPLY_REC->PROGRAMS[i].measures[j].outcome))
        set OUTREC->PROGRAMS[i].measures[j].outcome = REPLY_REC->PROGRAMS[i].measures[j].outcome
      endif
    endfor

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

	record _tempJson(
		1 val = gvc
	)

  ; Returns the record data as a json string with the record 
  ; name 'record_data' as the top-level key.
	set _tempJson->val = cnvtrectojson(record_data)

  set originalMaxStringLength = curmaxvarlen
  set newMaxStringLength = textlen(_tempJson->val) + 1000

  if (newMaxStringLength > originalMaxStringLength)
    set modify maxvarlen newMaxStringLength
  endif

  set _Memory_Reply_String = _tempJson->val

  if(newMaxStringLength > originalMaxStringLength)
	  set modify maxvarlen originalMaxStringLength
  endif

end

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