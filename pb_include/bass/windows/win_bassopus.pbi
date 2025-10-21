; === BASSOPUS Constants ===

#BASS_CTYPE_STREAM_OPUS     = $11200

#BASS_ATTRIB_OPUS_ORIGFREQ  = $13000
#BASS_ATTRIB_OPUS_GAIN      = $13001

#BASS_STREAMPROC_OPUS_LOSS  = $40000000

; === Structs ===

Structure BASS_OPUS_HEAD
  version.a
  channels.a
  preskip.u
  inputrate.l
  gain.w
  mapping.a
  streams.a
  coupled.a
  chanmap.a[255]
EndStructure

; === Prototypes ===

Prototype.l BASS_OPUS_StreamCreate(*head.BASS_OPUS_HEAD, flags.l, *proc, *user)
Prototype.l BASS_OPUS_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l)
Prototype.l BASS_OPUS_StreamCreateURL(*url, offset.l, flags.l, *proc, *user)
Prototype.l BASS_OPUS_StreamCreateFileUser(system.l, flags.l, *procs, *user)
Prototype.l BASS_OPUS_StreamPutData(handle.l, *buffer, length.l)

; === Library loader ===

Threaded _BASS_OPUS_Load_Library_DLL_.i

Procedure BASS_OPUS_Free_Library()
  If IsLibrary(_BASS_OPUS_Load_Library_DLL_)
    CloseLibrary(_BASS_OPUS_Load_Library_DLL_)
  EndIf
EndProcedure

Procedure.i BASS_OPUS_Load_Library(dllpath$)
  Protected dll.i

  If IsLibrary(_BASS_OPUS_Load_Library_DLL_)
    ProcedureReturn #False
  EndIf

  _BASS_OPUS_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)
  dll = _BASS_OPUS_Load_Library_DLL_
  If Not IsLibrary(dll)
    ProcedureReturn #False
  EndIf

  GetFunctionProto(dll, BASS_OPUS_StreamCreate)
  GetFunctionProto(dll, BASS_OPUS_StreamCreateFile)
  GetFunctionProto(dll, BASS_OPUS_StreamCreateURL)
  GetFunctionProto(dll, BASS_OPUS_StreamCreateFileUser)
  GetFunctionProto(dll, BASS_OPUS_StreamPutData)

  ProcedureReturn #True
EndProcedure

; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 62
; Folding = -
; EnableXP
; DPIAware