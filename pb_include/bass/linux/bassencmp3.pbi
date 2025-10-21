PrototypeC BASS_Encode_MP3_GetVersion() 
PrototypeC BASS_Encode_MP3_StartFile(chan.l,  options.s,  flags.l, filename.l)

Global libBASSEncMP3 = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassenc_mp3.so" )
If Not libBASSEncMP3 
  libBASSEncMP3 = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassenc_mp3.so")
  If Not libBASSEncMP3
  MessageRequester("Library loading error", "Failed to load libbassenc_mp3.so" + Chr(13) + Chr(13) + 
                                            "To solve the problem, open the subfolder 'assets' in your terminal and enter this command:" + Chr(13)+ Chr(13) + 
                                            "sudo cp -avr bass /usr/lib/", #PB_MessageRequester_Error)
  EndIf
EndIf

Global BASS_Encode_MP3_GetVersion.BASS_Encode_MP3_GetVersion = GetFunction(libBASSEncMP3, "BASS_Encode_MP3_GetVersion")
Global BASS_Encode_MP3_StartFile.BASS_Encode_MP3_StartFile = GetFunction(libBASSEncMP3, "BASS_Encode_MP3_StartFile")


 
; IDE Options = PureBasic 6.03 LTS (Linux - x64)
; CursorPosition = 3
; EnableXP