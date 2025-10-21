; === BASSenc_FLAC Constants ===

#BASS_ENCODE_FLAC_RESET = $1000000

; === Prototypes ===

PrototypeC.l BASS_Encode_FLAC_GetVersion()
PrototypeC.l BASS_Encode_FLAC_Start(handle.l, *options, flags.l, *proc, *user)
PrototypeC.l BASS_Encode_FLAC_StartFile(handle.l, *options, flags.l, *filename)
PrototypeC.l BASS_Encode_FLAC_NewStream(encode.l, *options, flags.l)

; === Library loading ===

Global libBASSencFLAC = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassenc_flac.so")
If Not libBASSencFLAC
  libBASSencFLAC = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassenc_flac.so")
  If Not libBASSencFLAC
    MessageRequester("Library loading error", "Failed to load libbassenc_flac.so", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

; === Bind function pointers ===

Global BASS_Encode_FLAC_GetVersion.BASS_Encode_FLAC_GetVersion = GetFunction(libBASSencFLAC, "BASS_Encode_FLAC_GetVersion")
Global BASS_Encode_FLAC_Start.BASS_Encode_FLAC_Start = GetFunction(libBASSencFLAC, "BASS_Encode_FLAC_Start")
Global BASS_Encode_FLAC_StartFile.BASS_Encode_FLAC_StartFile = GetFunction(libBASSencFLAC, "BASS_Encode_FLAC_StartFile")
Global BASS_Encode_FLAC_NewStream.BASS_Encode_FLAC_NewStream = GetFunction(libBASSencFLAC, "BASS_Encode_FLAC_NewStream")

; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 28
; EnableXP
; DPIAware