PrototypeC TAGS_GetVersion() 
PrototypeC TAGS_SetUTF8(enable) 
PrototypeC TAGS_Read(handle, fmt.p-ascii)

Global libBASSTags = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libtags.so")
If Not libBASSTags
  libBASSTags = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libtags.so")
  If Not libBASSTags
    MessageRequester("Library loading error", "Failed to load libtags.so" + Chr(13) + Chr(13) + 
                                            "To solve the problem, open the subfolder 'assets' in your terminal and enter this command:" + Chr(13)+ Chr(13) + 
                                            "sudo cp -avr bass /usr/lib/", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

Global TAGS_GetVersion.TAGS_GetVersion = GetFunction(libBASSTags, "TAGS_GetVersion")
Global TAGS_SetUTF8.TAGS_SetUTF8 = GetFunction(libBASSTags, "TAGS_SetUTF8")
Global TAGS_Read.TAGS_Read = GetFunction(libBASSTags, "TAGS_Read")














 
 
; IDE Options = PureBasic 6.03 LTS (Linux - x64)
; CursorPosition = 4
; EnableXP
; Executable = SmartMixPlayer
; SubSystem = .
; CompileSourceDirectory