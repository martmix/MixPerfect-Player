; === BASSenc_OGG Constants ===

#BASS_ENCODE_OGG_RESET = $1000000

; === Prototypes ===

PrototypeC.l BASS_Encode_OGG_GetVersion()
PrototypeC.l BASS_Encode_OGG_Start(handle.l, *options, flags.l, *proc, *user)
PrototypeC.l BASS_Encode_OGG_StartFile(handle.l, *options, flags.l, *filename)
PrototypeC.l BASS_Encode_OGG_NewStream(handle.l, *options, flags.l)

; === Library loader ===

Global libBASSOGG = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassenc_ogg.so")
If Not libBASSOGG
  libBASSOGG = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassenc_ogg.so")
  If Not libBASSOGG
    MessageRequester("Library loading error", "Failed to load libbassenc_ogg.so", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

; === Bind functions ===

Global BASS_Encode_OGG_GetVersion.BASS_Encode_OGG_GetVersion = GetFunction(libBASSOGG, "BASS_Encode_OGG_GetVersion")
Global BASS_Encode_OGG_Start.BASS_Encode_OGG_Start = GetFunction(libBASSOGG, "BASS_Encode_OGG_Start")
Global BASS_Encode_OGG_StartFile.BASS_Encode_OGG_StartFile = GetFunction(libBASSOGG, "BASS_Encode_OGG_StartFile")
Global BASS_Encode_OGG_NewStream.BASS_Encode_OGG_NewStream = GetFunction(libBASSOGG, "BASS_Encode_OGG_NewStream")

; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 28
; EnableXP
; DPIAware