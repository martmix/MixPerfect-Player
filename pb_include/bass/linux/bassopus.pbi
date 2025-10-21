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

PrototypeC BASS_OPUS_StreamCreate(*head.BASS_OPUS_HEAD, flags.l, *proc, *user)
PrototypeC BASS_OPUS_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l)
PrototypeC BASS_OPUS_StreamCreateURL(*url, offset.l, flags.l, *proc, *user)
PrototypeC BASS_OPUS_StreamCreateFileUser(system.l, flags.l, *procs, *user)
PrototypeC BASS_OPUS_StreamPutData(handle.l, *buffer, length.l)
 

; === Library loader ===

Global libBASSOPUS = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassopus.so")
If Not libBASSOPUS
  libBASSOPUS = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassopus.so")
  If Not libBASSOPUS
    MessageRequester("Library loading error", "Failed to load libbassopus.so", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

; === Bind functions ===

Global BASS_OPUS_StreamCreate.BASS_OPUS_StreamCreate = GetFunction(libBASSOpus, "BASS_OPUS_StreamCreate")
Global BASS_OPUS_StreamCreateFile.BASS_OPUS_StreamCreateFile = GetFunction(libBASSOpus, "BASS_OPUS_StreamCreateFile")
Global BASS_OPUS_StreamCreateURL.BASS_OPUS_StreamCreateURL = GetFunction(libBASSOpus, "BASS_OPUS_StreamCreateURL")
Global BASS_OPUS_StreamCreateFileUser.BASS_OPUS_StreamCreateFileUser = GetFunction(libBASSOpus, "BASS_OPUS_StreamCreateFileUser")
Global BASS_OPUS_StreamPutData.BASS_OPUS_StreamPutData = GetFunction(libBASSOpus, "BASS_OPUS_StreamPutData")

; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 46
; FirstLine = 7
; EnableXP
; DPIAware