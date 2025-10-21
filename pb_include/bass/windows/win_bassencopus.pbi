; === BASSenc_OPUS Constants ===

#BASS_ENCODE_OPUS_RESET    = $1000000
#BASS_ENCODE_OPUS_CTLONLY  = $2000000

; === Prototypes ===

Prototype.l BASS_Encode_OPUS_GetVersion()
Prototype.l BASS_Encode_OPUS_Start(handle.l, *options, flags.l, *proc, *user)
Prototype.l BASS_Encode_OPUS_StartFile(handle.l, *options, flags.l, *filename)
Prototype.l BASS_Encode_OPUS_NewStream(handle.l, *options, flags.l)

; === Library loader ===

Threaded _BASS_Enc_OPUS_DLL_.i

Procedure BASS_Enc_OPUS_Free_Library()
  If IsLibrary(_BASS_Enc_OPUS_DLL_)
    CloseLibrary(_BASS_Enc_OPUS_DLL_)
  EndIf
EndProcedure

Procedure.i BASS_Enc_OPUS_Load_Library(dllpath$)
  Protected dll.i

  If IsLibrary(_BASS_Enc_OPUS_DLL_)
    ProcedureReturn #False
  EndIf

  _BASS_Enc_OPUS_DLL_ = OpenLibrary(#PB_Any, dllpath$)
  dll = _BASS_Enc_OPUS_DLL_
  If Not IsLibrary(dll)
    ProcedureReturn #False
  EndIf

  GetFunctionProto(dll, BASS_Encode_OPUS_GetVersion)
  GetFunctionProto(dll, BASS_Encode_OPUS_Start)
  GetFunctionProto(dll, BASS_Encode_OPUS_StartFile)
  GetFunctionProto(dll, BASS_Encode_OPUS_NewStream)

  ProcedureReturn #True
EndProcedure

; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 42
; Folding = -
; EnableXP
; DPIAware