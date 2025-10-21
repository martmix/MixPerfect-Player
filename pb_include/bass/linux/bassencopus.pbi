; === BASSenc_OPUS Constants ===

#BASS_ENCODE_OPUS_RESET    = $1000000
#BASS_ENCODE_OPUS_CTLONLY  = $2000000

; === Prototypes ===

PrototypeC.l BASS_Encode_OPUS_GetVersion()
PrototypeC.l BASS_Encode_OPUS_Start(handle.l, *options, flags.l, *proc, *user)
PrototypeC.l BASS_Encode_OPUS_StartFile(handle.l, *options, flags.l, *filename)
PrototypeC.l BASS_Encode_OPUS_NewStream(handle.l, *options, flags.l)

; === Library loader ===

Global libBASSEncOpus = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassenc_opus.so")
If Not libBASSEncOpus
  libBASSEncOpus = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassenc_opus.so")
  If Not libBASSEncOpus
    MessageRequester("Library loading error", "Failed to load libbassenc_opus.so", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

; === Bind functions ===

Global BASS_Encode_OPUS_GetVersion.BASS_Encode_OPUS_GetVersion = GetFunction(libBASSEncOpus, "BASS_Encode_OPUS_GetVersion")
Global BASS_Encode_OPUS_Start.BASS_Encode_OPUS_Start = GetFunction(libBASSEncOpus, "BASS_Encode_OPUS_Start")
Global BASS_Encode_OPUS_StartFile.BASS_Encode_OPUS_StartFile = GetFunction(libBASSEncOpus, "BASS_Encode_OPUS_StartFile")
Global BASS_Encode_OPUS_NewStream.BASS_Encode_OPUS_NewStream = GetFunction(libBASSEncOpus, "BASS_Encode_OPUS_NewStream")

; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 29
; EnableXP
; DPIAware