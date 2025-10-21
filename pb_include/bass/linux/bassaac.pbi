PrototypeC BASS_AAC_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l) 
; PrototypeC BASS_AAC_StreamCreateURL(*url, offset.l, flags.l, *proc, *user)  
; PrototypeC BASS_AAC_StreamCreateFileUser(system.l, flags.l, *procs, *user)  
; PrototypeC BASS_MP4_StreamCreateFile(mem.l, *file, offset.q, length.q, flags.l) 
; PrototypeC BASS_MP4_StreamCreateFileUser(system.l, flags.l, *procs, *user)  

Global libBASSAac = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbass_aac.so")
If Not libBASSAac
  libBASSTags = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbass_aac.so")
  If Not libBASSTags
    MessageRequester("Library loading error", "Failed to load libbass_aac.so" + Chr(13) + Chr(13) + 
                                            "To solve the problem, open the subfolder 'assets' in your terminal and enter this command:" + Chr(13)+ Chr(13) + 
                                            "sudo cp -avr bass /usr/lib/", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

Global BASS_AAC_StreamCreateFile.BASS_AAC_StreamCreateFile = GetFunction(libBASSAac, "BASS_AAC_StreamCreateFile") 
; Global BASS_AAC_StreamCreateURL.BASS_AAC_StreamCreateURL = GetFunction(libBASSAac, "BASS_AAC_StreamCreateURL")  
; Global BASS_AAC_StreamCreateFileUser.BASS_AAC_StreamCreateFileUser = GetFunction(libBASSAac, "BASS_AAC_StreamCreateFileUser")  
; Global BASS_MP4_StreamCreateFile.BASS_MP4_StreamCreateFile = GetFunction(libBASSAac, "BASS_MP4_StreamCreateFile") 
; Global BASS_MP4_StreamCreateFileUser.BASS_MP4_StreamCreateFileUser = GetFunction(libBASSAac, "StreamCreateFileUser")  

#BASS_ERROR_MP4_NOSTREAM = 6000 ; non-streamable due to MP4 atom order ("mdat" before "moov")

; BASS_SetConfig options
#BASS_CONFIG_MP4_VIDEO    = $10700 ; play the audio from MP4 videos
#BASS_CONFIG_AAC_MP4      = $10701 ; support MP4 in BASS_AAC_StreamCreateXXX functions
#BASS_CONFIG_AAC_PRESCAN  = $10702 ; pre-scan ADTS AAC files for seek points and accurate length

; BASS_AAC_StreamCreateFile/etc flags
#BASS_AAC_FRAME960 = $1000    ; 960 samples per frame
#BASS_AAC_STEREO   = $400000  ; downmatrix to stereo

; BASS_CHANNELINFO type
#BASS_CTYPE_STREAM_AAC = $10b00 ; AAC
#BASS_CTYPE_STREAM_MP4 = $10b01 ; AAC in MP4
; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; EnableXP
; DPIAware