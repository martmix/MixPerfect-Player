; === BASSFLAC Constants ===

#BASS_CTYPE_STREAM_FLAC     = $10900
#BASS_CTYPE_STREAM_FLAC_OGG = $10901

#BASS_TAG_FLAC_CUE       = 12
#BASS_TAG_FLAC_PICTURE   = $12000
#BASS_TAG_FLAC_METADATA  = $12400

#TAG_FLAC_CUE_TRACK_DATA = 1
#TAG_FLAC_CUE_TRACK_PRE  = 2

; === Structs ===

Structure TAG_FLAC_PICTURE
  apic.l
  *mime
  *desc
  width.l
  height.l
  depth.l
  colors.l
  length.l
  *data
EndStructure

Structure TAG_FLAC_CUE_TRACK_INDEX
  offset.q
  number.l
EndStructure

Structure TAG_FLAC_CUE_TRACK
  offset.q
  number.l
  *isrc
  flags.l
  nindexes.l
  *indexes.TAG_FLAC_CUE_TRACK_INDEX
EndStructure

Structure TAG_FLAC_CUE
  *catalog
  leadin.l
  iscd.l
  ntracks.l
  *tracks.TAG_FLAC_CUE_TRACK
EndStructure

Structure TAG_FLAC_METADATA
  id.a[4]
  length.l
  *data
EndStructure

; === Prototypes ===

Prototype.l BASS_FLAC_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l)
Prototype.l BASS_FLAC_StreamCreateURL(*url, offset.l, flags.l, *proc, *user)
Prototype.l BASS_FLAC_StreamCreateFileUser(system.l, flags.l, *procs, *user)

; === Threaded Global Handle ===

Threaded _BASS_FLAC_Load_Library_DLL_.i

; === Free the FLAC library ===

Procedure BASS_FLAC_Free_Library()
	If IsLibrary(_BASS_FLAC_Load_Library_DLL_)
		CloseLibrary(_BASS_FLAC_Load_Library_DLL_)
	EndIf
EndProcedure

; === Load the FLAC library dynamically ===

Procedure.i BASS_FLAC_Load_Library(dllpath$)
	Protected dll.i
	
	If IsLibrary(_BASS_FLAC_Load_Library_DLL_)
		ProcedureReturn #False
	EndIf
	
	_BASS_FLAC_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)
	dll = _BASS_FLAC_Load_Library_DLL_
	If IsLibrary(dll) = #False
		ProcedureReturn #False
	EndIf

	GetFunctionProto(dll, BASS_FLAC_StreamCreateFile)
	GetFunctionProto(dll, BASS_FLAC_StreamCreateURL)
	GetFunctionProto(dll, BASS_FLAC_StreamCreateFileUser)
	
	ProcedureReturn #True
EndProcedure

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 62
; FirstLine = 48
; Folding = -
; EnableXP
; DPIAware