; BASS_Tags_Load_Library

Prototype.l TAGS_GetVersion() 
Prototype.l TAGS_SetUTF8(enable) 
Prototype.i TAGS_Read(handle, fmt.p-ascii)
Prototype.i TAGS_ReadEx(handle, fmt.p-ascii, tagtype, codepage)
Prototype.i TAGS_GetLastErrorDesc()
 
Threaded _BASS_Tags_Load_Library_DLL_.i

Procedure BASS_Tags_Free_Library()
	If IsLibrary(_BASS_Tags_Load_Library_DLL_)
		CloseLibrary(_BASS_Tags_Load_Library_DLL_)
	EndIf
EndProcedure

Procedure.i BASS_Tags_Load_Library(dllpath$)
	Protected dll.i, result.i
	
	If IsLibrary(_BASS_Tags_Load_Library_DLL_)
		ProcedureReturn #False
	EndIf
	
	_BASS_Tags_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)
	dll = _BASS_Tags_Load_Library_DLL_
	If IsLibrary(dll) = #False
		ProcedureReturn #False
	EndIf
	
	GetFunctionProto(dll, TAGS_GetVersion)
	If TAGS_GetVersion = #Null
		BASS_Tags_Free_Library()
		ProcedureReturn #False
	EndIf
	 
	GetFunctionProto(dll, TAGS_SetUTF8) 
	GetFunctionProto(dll, TAGS_Read)
	GetFunctionProto(dll, TAGS_ReadEx)
	GetFunctionProto(dll, TAGS_GetLastErrorDesc)
	
	ProcedureReturn #True
EndProcedure


; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 34
; Folding = -
; EnableXP
; SubSystem = .
; CompileSourceDirectory
; Compiler = PureBasic 6.11 LTS (Windows - x64)