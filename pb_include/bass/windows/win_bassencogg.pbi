; === BASSenc_OGG Constants ===

#BASS_ENCODE_OGG_RESET = $1000000

; === Prototypes ===

Prototype.l BASS_Encode_OGG_GetVersion()
Prototype.l BASS_Encode_OGG_Start(handle.l, *options, flags.l, *proc, *user)
Prototype.l BASS_Encode_OGG_StartFile(handle.l, *options, flags.l, *filename)
Prototype.l BASS_Encode_OGG_NewStream(handle.l, *options, flags.l)

; === Threaded Global Handle ===

Threaded _BASSENC_OGG_Load_Library_DLL_.i

Procedure BASSENC_OGG_Free_Library()
  If IsLibrary(_BASSENC_OGG_Load_Library_DLL_)
    CloseLibrary(_BASSENC_OGG_Load_Library_DLL_)
  EndIf
EndProcedure

Procedure.i BASSENC_OGG_Load_Library(dllpath$)
  Protected dll.i

  If IsLibrary(_BASSENC_OGG_Load_Library_DLL_)
    ProcedureReturn #False
  EndIf

  _BASSENC_OGG_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)
  dll = _BASSENC_OGG_Load_Library_DLL_
  If Not IsLibrary(dll)
    ProcedureReturn #False
  EndIf

  GetFunctionProto(dll, BASS_Encode_OGG_GetVersion)
  GetFunctionProto(dll, BASS_Encode_OGG_Start)
  GetFunctionProto(dll, BASS_Encode_OGG_StartFile)
  GetFunctionProto(dll, BASS_Encode_OGG_NewStream)

  ProcedureReturn #True
EndProcedure

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 28
; Folding = -
; EnableXP
; DPIAware