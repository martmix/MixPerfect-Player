Prototype.l BASS_Encode_MP3_Start(chan.l, options.s, flags.l,  proc.l,  user.l)
Prototype.l BASS_Encode_MP3_StartFile(chan.l,  options.s,  flags.l, filename.l)

; BASS_Encode_MP3_Load_Library

Threaded _BASS_Encode_MP3_Load_Library_DLL_.i

Procedure BASS_Encode_MP3_Free_Library()
	If IsLibrary(_BASS_Encode_MP3_Load_Library_DLL_)
		CloseLibrary(_BASS_Encode_MP3_Load_Library_DLL_)
	EndIf
EndProcedure

Procedure.i BASS_Encode_MP3_Load_Library(dllpath$)
	Protected dll.i, result.i

	If IsLibrary(_BASS_Encode_MP3_Load_Library_DLL_)
		ProcedureReturn #False
	EndIf

	_BASS_Encode_MP3_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)

	dll = _BASS_Encode_MP3_Load_Library_DLL_

	If IsLibrary(dll) = #False
		ProcedureReturn #False
	EndIf

  GetFunctionProto(dll, BASS_Encode_MP3_Start)
  GetFunctionProto(dll, BASS_Encode_MP3_StartFile)
  
	ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 5.70 LTS beta 3 (Windows - x64)
; CursorPosition = 3
; Folding = -
; EnableXP