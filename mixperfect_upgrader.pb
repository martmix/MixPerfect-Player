;compile this program to:
;  - assets/mixperfect_upgrader
;  - assets/mixperfect_upgrader.exe
 
EnableExplicit

Procedure.s OSPath(Path.s)
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ProcedureReturn ReplaceString(Path, "\", "/")     
  CompilerEndIf
 
  ProcedureReturn ReplaceString(Path, "/", "\")       
EndProcedure

Define.s DownloadFile = Trim(ProgramParameter(1))
Define.s ProgramFile = Trim(ProgramParameter(2))
 
If ProgramParameter(0) <> "upgrade" Or CountProgramParameters() <> 3
  MessageRequester("MixPerfect Upgrader", "This program is ment to be run internally by MixPerfect Player", #PB_MessageRequester_Error)
  End
EndIf

Define.s Source = OSPath(GetPathPart(ProgramFilename()) + "/" + DownloadFile)
Define.s Destination = OSPath(GetPathPart(ProgramFilename()) + "/_" + DownloadFile)

If FileSize(Destination) <> -1 
  DeleteFile(Destination)
EndIf

If RenameFile(Source, Destination)
  ;hier moet het main programma eerst worden afgesloten
  Delay(1000)
  
  If CopyFile(Destination, ProgramFile)
    DeleteFile(Destination)
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
      RunProgram("chmod", "+x " + ProgramFile, "", #PB_Program_Wait)  
    CompilerEndIf
    
    ;main programma opstarten
    RunProgram(ProgramFile, "upgraded", "")   
  EndIf
EndIf
; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 41
; Folding = -
; EnableXP
; DPIAware
; Executable = assets/mixperfect_upgrader
; DisableDebugger