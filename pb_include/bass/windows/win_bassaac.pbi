Prototype.l BASS_AAC_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l) 

#BASS_ERROR_MP4_NOSTREAM = 6000 ; non-streamable due to MP4 atom order ("mdat" before "moov")
 
; BASS_SetConfig options
#BASS_CONFIG_MP4_VIDEO    = $10700 ; play the audio from MP4 videos
#BASS_CONFIG_AAC_MP4      = $10701 ; support MP4 in BASS_AAC_StreamCreateXXX functions
#BASS_CONFIG_AAC_PRESCAN  = $10702 ; pre-scan ADTS AAC files for seek points and accurate length

; BASS_AAC_StreamCreateFile/etc flags
#BASS_AAC_FRAME960 = $1000    ; 960 samples per frame
#BASS_AAC_STEREO   = $400000  ; downmatrix to stereo

; BASS_CHANNELINFO type
#BASS_CTYPE_STREAM_AAC = $10b00 ; AAC
#BASS_CTYPE_STREAM_MP4 = $10b01 ; AAC in MP4

Threaded _BASS_AAC_Load_Library_DLL_.i

Procedure BASS_AAC_Free_Library()
	If IsLibrary(_BASS_AAC_Load_Library_DLL_)
		CloseLibrary(_BASS_AAC_Load_Library_DLL_)
	EndIf
EndProcedure

Procedure.i BASS_AAC_Load_Library(dllpath$)
	Protected dll.i, result.i
	
	If IsLibrary(_BASS_AAC_Load_Library_DLL_)
		ProcedureReturn #False
	EndIf  
	
	_BASS_AAC_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)
	dll = _BASS_AAC_Load_Library_DLL_
	If IsLibrary(dll) = #False
		ProcedureReturn #False
	EndIf
 	 
	GetFunctionProto(dll, BASS_AAC_StreamCreateFile) 

	ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 34
; Folding = -
; EnableXP
; DPIAware