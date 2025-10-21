; === BASSenc_FLAC Constants ===

#BASS_ENCODE_FLAC_RESET = $1000000

; === Prototypes ===

Prototype.l BASS_Encode_FLAC_GetVersion()
Prototype.l BASS_Encode_FLAC_Start(handle.l, *options, flags.l, *proc, *user)
Prototype.l BASS_Encode_FLAC_StartFile(handle.l, *options, flags.l, *filename)
Prototype.l BASS_Encode_FLAC_NewStream(encode.l, *options, flags.l)

; === Threaded DLL handle ===

Threaded _BASSENCO_FLAC_Lib_.i

; === Free function ===

Procedure BASSENCO_FLAC_Free_Library()
  If IsLibrary(_BASSENCO_FLAC_Lib_)
    CloseLibrary(_BASSENCO_FLAC_Lib_)
  EndIf
EndProcedure

; === Load function ===

Procedure.i BASSENCO_FLAC_Load_Library(dllpath$)
  Protected dll.i

  If IsLibrary(_BASSENCO_FLAC_Lib_)
    ProcedureReturn #False
  EndIf

  _BASSENCO_FLAC_Lib_ = OpenLibrary(#PB_Any, dllpath$)
  dll = _BASSENCO_FLAC_Lib_

  If Not IsLibrary(dll)
    ProcedureReturn #False
  EndIf

  GetFunctionProto(dll, BASS_Encode_FLAC_GetVersion)
  GetFunctionProto(dll, BASS_Encode_FLAC_Start)
  GetFunctionProto(dll, BASS_Encode_FLAC_StartFile)
  GetFunctionProto(dll, BASS_Encode_FLAC_NewStream)

  ProcedureReturn #True
EndProcedure

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 25
; FirstLine = 1
; Folding = -
; EnableXP
; DPIAware