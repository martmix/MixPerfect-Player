; === FLAC Add-on for BASS ===

PrototypeC BASS_FLAC_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l)
PrototypeC BASS_FLAC_StreamCreateURL(*url, offset.l, flags.l, *proc, *user)
PrototypeC BASS_FLAC_StreamCreateFileUser(system.l, flags.l, *procs, *user)

; === Constants from bassflac.h ===

; BASS_CHANNELINFO types
#BASS_CTYPE_STREAM_FLAC     = $10900
#BASS_CTYPE_STREAM_FLAC_OGG = $10901

; Additional tag types
#BASS_TAG_FLAC_CUE       = 12
#BASS_TAG_FLAC_PICTURE   = $12000
#BASS_TAG_FLAC_METADATA  = $12400

; TAG_FLAC_CUE_TRACK flags
#TAG_FLAC_CUE_TRACK_DATA = 1
#TAG_FLAC_CUE_TRACK_PRE  = 2

; === Structs from bassflac.h ===

Structure TAG_FLAC_PICTURE
  apic.l
  *mime ; const char*
  *desc ; const char*
  width.l
  height.l
  depth.l
  colors.l
  length.l
  *data ; const void*
EndStructure

Structure TAG_FLAC_CUE_TRACK_INDEX
  offset.q
  number.l
EndStructure

Structure TAG_FLAC_CUE_TRACK
  offset.q
  number.l
  *isrc ; const char*
  flags.l
  nindexes.l
  *indexes.TAG_FLAC_CUE_TRACK_INDEX ; pointer to array
EndStructure

Structure TAG_FLAC_CUE
  *catalog ; const char*
  leadin.l
  iscd.l ; BOOL
  ntracks.l
  *tracks.TAG_FLAC_CUE_TRACK ; pointer to array
EndStructure

Structure TAG_FLAC_METADATA
  id.a[4]
  length.l
  *data ; const void*
EndStructure

; === Library loading ===

Global libBASSFLAC = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassflac.so")
If Not libBASSFLAC
  libBASSFLAC = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassflac.so")
  If Not libBASSFLAC
    MessageRequester("Library loading error", "Failed to load libbassflac.so", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

Global BASS_FLAC_StreamCreateFile.BASS_FLAC_StreamCreateFile = GetFunction(libBASSFLAC, "BASS_FLAC_StreamCreateFile")
Global BASS_FLAC_StreamCreateURL.BASS_FLAC_StreamCreateURL = GetFunction(libBASSFLAC, "BASS_FLAC_StreamCreateURL")
Global BASS_FLAC_StreamCreateFileUser.BASS_FLAC_StreamCreateFileUser = GetFunction(libBASSFLAC, "BASS_FLAC_StreamCreateFileUser") 
; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 76
; FirstLine = 33
; EnableXP
; DPIAware