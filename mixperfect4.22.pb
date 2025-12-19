;**************************************************************************************************
;* MixPerfect Player for Linux (64 bit / GTK) and Windows (64 bit). (c) 2024-2025, Martin Verlaan *
;* Programmed with PureBasic 6.10. (c) Fantaisie Software                                         *
;* Using the BASS audio library. (c) Un4seen Developments Ltd.                                    *
;*                                                                                                *
;* Enable these compiler options:                                                                 *
;* - create threadsafe executable                                                                 *
;* - create temporary executable in source directory                                              *
;**************************************************************************************************
 
EnableExplicit

;-- Constants

#AppName = "MixPerfect Player"
#Version = "4.22" 
#VersionYear = "2025"
;Changes:
;Improved zoom to selection in database panel --> add/edit record window
;Solved bug with ALT+A key-shortcut in Player panel
;Solved bug with restoring picklist after loading file in custom playlist window

#DebugMusicAndSleeves = #False
 
Enumeration #PB_Event_FirstCustomValue
  #PB_Event_SizeWindowFinished
EndEnumeration

Enumeration Windows
  #WindowMain
  #WindowMainTemp
  #WindowSettings
  #WindowCustomPlaylist 
  #WindowExportToAudioFile  
  #WindowMusicLibraryProgress
  #WindowDatabase
  #WindowDatabaseAddRecord
  #WindowBeatSyncTest
  #WindowHelp 
EndEnumeration

Enumeration SettingsGadgetTypes
  #SettingCombobox  
  #SettingListview
  #SettingPathRequester    
EndEnumeration

Enumeration Timers
  #PlayingMixTimer
  #TrackbarPicklistTimer
  #TrackbarMusicLibraryTimer
  #TrackbarDatabaseTimer
  #DatabaseAddRecordTimer  
  #TrackbarIntroBeatSyncTestTimer  
  #TrackbarBreakBeatSyncTestTimer  
  #TrackbarCustomTransitionTimer  
  #TimerSizeWindow
  #TimerDownload
EndEnumeration

Enumeration KeyShortcuts
  #EnterKey
  #EscKey
  #UpKey
  #DownKey  
  #AltC
  #AltR
  #AltS
  #AltL
  #AltE
  #AltP
  #AltA
  #AltO
EndEnumeration

Enumeration Databases
  #DBMusic 
  #DBFiles
EndEnumeration

Enumeration Various
  #Font 
  #File  
  #FirstSong
  #InBetweenSong
  #LastSong
EndEnumeration
 
Enumeration WaveformImages
  #OriginalWaveImage  
  #CursorWaveImage  
  #FirstWaveImage    
  #SelectionWaveImage  
EndEnumeration
 
Enumeration Gadgets
  ;Main window
  #Panel = 500
  #C1
  #C2
  #C3
  #C4
  #C5
  #c6
   
  ;Temporarily main window
  #LabelLoading
  
  ;Player panel
  #ListiconPlaylist 
  #ButtonPrevious
  #ButtonPlay
  #ButtonPause
  #ButtonStop
  #ButtonNext 
  #ButtonVolume  
  #ButtonDynAmpOn
  #ButtonDynAmpOff  
  #TrackInfo
  #Trackbar
  #TrackbarTransition  
  #LabelTime  
  #LabelMix
  #LabelRemainingTime
  #CanvasSpectrum
  #ContainerVolume
  #ScrollAreaSongInfo
  #ContainerSongInfo 
  #TrackbarVolume
  #CheckboxDynAmp
  #PopupImageMenu
  #ButtonCreateRandomPlaylist1 
  #ButtonCreateCustomPlaylist1    
  #ButtonAlternativeSong
  #ButtonExportMP3
  #ButtonExportTXT
  #ButtonSavePlaylist1
  #ButtonLoadPlaylist1
     
  ;Settings panel 
  #ScrollArea
  #ButtonDefaultSettings  
  #ButtonOpenFolderAudio
  #ButtonOpenFolderSleeves  
  #ButtonResetArtists
  #ButtonResetCountries
  #ButtonResetGenres
  #ButtonResetYears
  #ButtonResetLabels
  
  ;Files panel
  #ButtonAddFolder
  #ListiconMusicLibrary  
  #ListiconMusicLibrarySearch  
  #ButtonRemoveFile  
  #ComboboxSortFiles 
  #StringSearchFiles    
  #ButtonAddFiletoDatabase  
  #ButtonClearList    
  #ButtonPlayFile
  #ButtonStopMusicLibrarySong
  #TrackbarMusicLibrary  
  
  ;Database panel
  #ListiconDatabase
  #ListiconDatabaseSearch  
  #ButtonDeleteRecord
  #ButtonAddRecord
  #ButtonEditRecord
  #StringSearchDatabase
  #ComboboxSortDatabase
  #LabelTotalRecords
  #ButtonPlayDatabaseSong
  #ButtonStopDatabaseSong
  #TrackbarDatabase
  
  ;Help panel
  #EditorHelp 
  #EditorContainer
  #PanelHelp
  #HyperlinkSettings   
  #HyperlinkAbout
  #HyperlinkFiles
  #HyperlinkDatabase
  #HyperlinkPlayer
  #HyperlinkUpgrade
  
  ;Upgrade panel
  #VersionCheck
  #CurrentVersion
  #ButtonUpgrade
  #DownloadProgress
  #ButtonCancelDownload
  
  ;Export to audiofile window
  #ButtonCancelExport  
  #ProgressbarExport
  #LabelExport
  #LabelExportPercent    
  
  ;Database add record window
  #TrackbarScale
  #GenreString
  #ArtistString
  #TitleString
  #YearString
  #LabelString
  #CatNoString
  #CountryString
  #BPMString  
  #SleeveString  
  #ListviewArtist
  #ContainerArtist
  #ListviewLabel
  #ContainerLabel
  #ListviewCountry
  #ContainerCountry
  #ListviewYear
  #ContainerYear
  #ListviewGenre
  #ContainerGenre
  #ButtonCancelDatabaseAddRecord 
  #ScrollAreaDatabaseAddRecord
  #IntroFadeIn
  #IntroHasBass
  #IntroHasMelody
  #IntroHasVocal
  #IntroHasBeats
  #BreakFadeOut
  #BreakHasBass
  #BreakHasMelody
  #BreakHasVocal
  #BreakHasBeats  
  #CanvasWaveform 
  #ButtonSleeveString  
  #ButtonPlaySong  
  #ButtonStopSong    
  #ButtonTestBeatSync
  #ButtonZoomIn
  #ButtonZoomOut
  #ButtonZoomToSelection
  #ButtonZoomFull
  #Combo_Marker
  #ButtonSaveDatabaseAddRecord  
  #SelLengthString
  #ViewLengthString
  #SelEndString
  #ViewEndString
  #SelBeginString
  #ViewBeginString  
  #ButtonAddMarker
  #ButtonDeleteMarker
  #CursorPosString  
  #LabelArtist
  #LabelTitle
  #LabelYear
  #LabelCountry
  #LabelGenre
  #LabelLabel
  #LabelCatNo
  #LabelBPM
  #LabelSleeve
  #LabelBegin
  #LabelEnd
  #LabelSelection
  #LabelLength
  #LabelView
  #LabelCursor
  
  ;Beat sync test window
  #ButtonCancelBeatSyncTest  
  #ButtonPlayIntroBeatSyncTest
  #ButtonStopIntroBeatSyncTest
  #TrackbarIntroBeatSyncTest
  #ButtonPlayBreakBeatSyncTest
  #ButtonStopBreakBeatSyncTest
  #TrackbarBreakBeatSyncTest  
  #LabelTestIntroTime
  #LabelTestBreakTime
  #TrackbarBeatTestVolume  
  
  ;Files progress window  
  #LabelFile
  #ButtonCancelAddFolder     

  ;Custom playlist window
  #ListiconPicklist
  #ListiconPicklistSearch
  #ListiconCustomPlaylist
  #ButtonAddSong
  #ButtonRemoveSong
  #ButtonApplyCustomPlaylist
  #ButtonCancelCustomPlaylist    
  #ComboboxSortPicklist
  #StringSearchPicklist
  #FramePicklist
  #FrameTracklist
  #ButtonPlayPicklistSong
  #ButtonStopPicklistSong
  #TrackbarPicklist  
  #ButtonPlayCustomTransition  
  #ButtonStopCustomTransition  
  #TrackbarCustomTransition  
  #ButtonLoadCustomPlaylist
  #ButtonSaveCustomPlaylist  
EndEnumeration

CompilerIf #PB_Compiler_OS = #PB_OS_Linux
  #DownloadFile = "mixperfect_download"  
  #UpdateProgram = "mixperfect_upgrader" ;don't change this filename! 
  
  If FileSize("assets/app-icon.png") <> -1
    ImportC ""
      gtk_window_set_icon_from_file(window.i, filename.p-utf8, error.i)
    EndImport
  EndIf    
CompilerElse
  #DownloadFile = "mixperfect_download.exe"  
  #UpdateProgram = "mixperfect_upgrader.exe" ;don't change this filename!
CompilerEndIf

;--Upgrading
Declare.s OSPath(path.s)
If FileSize(OSPath(GetPathPart(ProgramFilename()) + "assets/" + #DownloadFile)) <> -1 
  Define Now.q = ElapsedMilliseconds()
  If RunProgram(OSPath(GetPathPart(ProgramFilename()) + "assets/" + #UpdateProgram), "upgrade " + #DownloadFile + " " + ProgramFilename(), "")
    While FileSize(OSPath(GetPathPart(ProgramFilename()) + "assets/" + #DownloadFile)) <> -1 
      If ElapsedMilliseconds() - Now >= 2000
        Break
      EndIf
    Wend
    End
  EndIf
EndIf

;-- Macro's

CompilerIf #PB_Compiler_OS = #PB_OS_Windows
  Macro GetFunctionProtoQuote
  	"
  EndMacro
  
  Macro GetFunctionProto(dll, name) 
  	Global name.name
  	name = GetFunction(dll, GetFunctionProtoQuote#name#GetFunctionProtoQuote)
  EndMacro
  
  Macro DuplicateFunctionProto(dst, src)
  	Global dst.dst
  	dst = src
  EndMacro    
CompilerEndIf

;-- Includes

;Initialize theme colors for Windows  
CompilerIf #PB_Compiler_OS = #PB_OS_Windows  
  XIncludeFile "pb_include/ObjectTheme.pbi"
  UseModule ObjectTheme 
CompilerEndIf


CompilerIf #PB_Compiler_OS = #PB_OS_Windows  
  IncludeFile "pb_include/bass/windows/win_bass.pbi"     
  IncludeFile "pb_include/bass/windows/win_bassmix.pbi"
  IncludeFile "pb_include/bass/windows/win_bassfx.pbi"
  IncludeFile "pb_include/bass/windows/win_bassenc.pbi"
  IncludeFile "pb_include/bass/windows/win_bassencmp3.pbi"
  IncludeFile "pb_include/bass/windows/win_basstags.pbi"   
  IncludeFile "pb_include/bass/windows/win_bassaac.pbi"   
  IncludeFile "pb_include/bass/windows/win_bassflac.pbi"   
  IncludeFile "pb_include/bass/windows/win_bassopus.pbi"   
  IncludeFile "pb_include/bass/windows/win_bassencopus.pbi"   
  IncludeFile "pb_include/bass/windows/win_bassencflac.pbi"   
  IncludeFile "pb_include/bass/windows/win_bassencogg.pbi"     
CompilerElse     
  IncludeFile "pb_include/bass/linux/bass.pbi"
  IncludeFile "pb_include/bass/linux/bassmix.pbi"
  IncludeFile "pb_include/bass/linux/bassfx.pbi"
  IncludeFile "pb_include/bass/linux/bassenc.pbi"
  IncludeFile "pb_include/bass/linux/bassencmp3.pbi"
  IncludeFile "pb_include/bass/linux/basstags.pbi" 
  IncludeFile "pb_include/bass/linux/bassaac.pbi"   
  IncludeFile "pb_include/bass/linux/bassflac.pbi"  
  IncludeFile "pb_include/bass/linux/bassopus.pbi"       
  IncludeFile "pb_include/bass/linux/bassencopus.pbi"   
  IncludeFile "pb_include/bass/linux/bassencflac.pbi"   
  IncludeFile "pb_include/bass/linux/bassencogg.pbi"     
CompilerEndIf


;-- Structures

Structure RealTimeFXStructure
  Mute.b
  FadeIn.b
  FadeOut.b
EndStructure

Structure VisibleStructure
  ListiconDatabaseSearch.b
  ListiconPicklistSearch.b
  ListiconMusicLibrarySearch.b
  Volume.b
  Container.b
EndStructure

Structure GadgetNumberStructure
  MinSongs.i
  MaxSongs.i
  MinPlaybackTime.i
  MaxPlaybackTime.i 
  SleeveDatabase.i
EndStructure

Structure ChanStructure
  Database.i
  DecodedDatabase.i
  Beat.i
  Song.i
  Mixer.i
  MixerBeatTest.i
  MixerCustomTransition.i
  CustomTransitionBreak.i
  CustomTransitionIntro.i
  FX1.i 
  FX2.i
EndStructure

Structure SettingsPanelStructure
  Section.s
  Description.s
  Gadget.i
  Options.s  
  DefaultValue.s
  Tooltip.s
EndStructure 

Structure SongsStructure
  Channel.i
  OrigFreq.i
  Number.i  
  ID.s
  AudioFilename.s
  SleeveFilename.s
  Artist.s
  Title.s
  Year.s
  Label.s
  Catno.s
  Country.s 
  Playtime.f
  PlaylistStartTime.f
  BPM.f
  PlaybackBPM.f
  Pitch.s
  BeatCounter.i
  IntroBeatList.s
  IntroBeatListFromDB.s
  IntroFade.b
  IntroBeats.b
  IntroPrefix.f
  IntroStart.f
  IntroEnd.f
  IntroLoopStart.f
  IntroLoopEnd.f
  IntroLoopRepeat.i
  IntroLoopCounter.i
  BreakBeatList.s
  BreakBeatListFromDB.s
  BreakFade.b
  BreakBeats.b
  BreakStart.f
  BreakEnd.f
  BreakContinue.f
  BreakLoopStart.f
  BreakLoopEnd.f
  BreakLoopRepeat.i
  BreakLoopCounter.i
  BreakMute.f
  SkipStart.f
  SkipEnd.f
  Samplerate.i
  PreviousSamplerate.i
  PlaybackSamplerate.i
  Shorten.b  
  FX.i
  ViewLength.f
  ViewBegin.f
  ViewEnd.f
  SelectionLength.f
  SelectionBegin.f
  SelectionEnd.f
  CursorSec.f
  CursorX.i
  BytesPerPixel.q
  NoMatch.b
  Mixing.b
  Fading.b
EndStructure

Structure PreferencesStructure
  PlaylistType.s
  PlaylistString.s
  PlaylistPosition.i
  PathAudio.s
  PathSleeves.s
  MinimumNumberOfSongs.s
  MaximumNumberOfSongs.s
  MinimumPlaybackTime.s
  MaximumPlaybackTime.s
  ShortenSongs.s
  UniqueSongsBeforeRepeating.i
  BPMOfFirstSong.s
  BPMOrderOfSongs.s
  MaximumBPMdistance.f
  PitchRange.f
  FilterOverlappedBeats.s
  KeepBeatsGoing.s
  CombineBeats.s
  CombineBasses.s
  CombineVocals.s
  CombineMelodies.s
  IgnoreCombine.s
  GainControl.s
  Countries.s
  Genres.s
  Years.s
  RecordLabels.s
  Artists.s
  LastValidDate.s
  WindowsTheme.s
  EvolutionMode.s
EndStructure

Structure _ffT
  _ffT.f[1024]
EndStructure

Structure BASS_FX_VOLUME_PARAM
  fTarget.f
  fCurrent.f
  fTime.f
  lCurve.l
EndStructure

Structure MinMax
  min.b[2]
  max.b[2]
  avg.b[2]
  rms.a[2]
EndStructure


;-- Declarations

Declare.i UpdateSongInPlaylist()
Declare.i DeselectListviewItems(Gadget.i, Description.s)
Declare.i ButtonResetArtists()
Declare.i ButtonResetLabels()
Declare.i ButtonResetGenres()
Declare.i ButtonResetCountries()
Declare.i ButtonResetYears()  
Declare.i EditSong()
Declare.i ButtonLoadCustomPlaylist()
Declare.i ButtonSaveCustomPlaylist()
Declare.i CreateAppIcon(Window.i)
Declare.i CustomBeatFilter(ChannelNumber, fGainLow.f = 0.0, fGainMid.f = 0.0, fGainHigh.f = 0.0)  
Declare.i BeatSynchronizer(Stream.i, Channel.i, BassData.i, Samplerate.i) 
Declare.i Upgrade()
Declare.i CancelDownload()
Declare.i WriteWAVHeaderStream(File, DataSize.q, SampleRate, NumChannels, BitsPerSample)
Declare.b ConvertRawToWav_Stream(RawFile.s, WavFile.s, SampleRate, NumChannels, BitsPerSample)
Declare.l CreateChannel(File.s, Flags.l = #Null)
Declare.i ButtonAlternativeSong()
Declare.s GenerateFilterQuery()
Declare.f DBLowestBPM()
Declare.f DBHighestBPM()
Declare.s ToDisplayInArtist()
Declare.s ToDisplayInLabel()
Declare.s ToDisplayInGenre()
Declare.s ToDisplayInYear() 
Declare.s ToDisplayInCountry() 
Declare.i GetWindowBackgroundColor(hwnd = 0) 
Declare.i ChangeWindowsTheme()
Declare.s OSPath(path.s)
Declare.s Seconds2LongTime(seconds.f)
Declare.s WinTitle()
Declare.i StopBreakBeatSyncTest() 
Declare.i BtnStopBreakBeatSyncTest(Stream.i, Channel.i, BassData.i, BreakCont.i) 
Declare.i ButtonStopBreakBeatSyncTest() 
Declare.i StartBeatSyncLoop(Stream.i, Channel.i, BassData.i, User.i)
Declare.i Mute(Stream.i, Channel.i, BassData.i, User.i)
Declare.s AllGadgetsData()
Declare.i SectionX(Pos.f)
Declare.i RealTimeSyncs(PosSec.f)
Declare.s AbsoluteDir(Path.s)
Declare.i BeatCustomTransitionSynchronizer(Stream.i, Channel.i, BassData.i, User.i) 
Declare.i CustomTransitionIntroLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
Declare.i CustomTransitionBreakLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
Declare.i ButtonPlayCustomTransition()
Declare.i ButtonStopCustomTransition()
Declare.b CheckSettingMinMaxSongs()
Declare.b CheckSettingMinMaxPlaybackTime()  
Declare.i ApplySettings()
Declare.s GeneratePlaylistIDsString()
Declare.i ResizeSongInfo(Song.i)
Declare.b LightMode()
Declare.s RestoredData()
Declare.i SetHyperlinkFonts(BlackItem.i)
Declare.i HyperlinkAbout()
Declare.i HyperlinkPlayer()   
Declare.i HyperlinkPlaylists()     
Declare.i HyperlinkDatabase() 
Declare.i HyperlinkFiles()   
Declare.i HyperlinkSettings()
Declare.i HyperlinkUpgrade()
Declare.i CreatePanelItemPlayer()
Declare.i CreatePanelItemDatabase()
Declare.i CreatePanelItemFiles()
Declare.i CreatePanelItemSettings()
Declare.i CreatePanelItemHelp()
Declare.i CreatePanelItemUpgrade()
Declare.i ButtonCreateRandomPlaylist()  
Declare.i ButtonCreateCustomPlaylist()
Declare.i ButtonLoadPlaylist()
Declare.i ButtonSavePlaylist()  
Declare.i ButtonExportToAudioFile() 
Declare.i ButtonExportToTextFile() 
Declare.i CreatePanelItemDatabase()
Declare.i CreatePanelItemFiles()
Declare.i CreatePanelItemHelp()
Declare.s ExpireDate()
Declare.b SongInPlaylist(ID.s)
Declare.i LoadPreviousPlaylist()
Declare.i ButtonClearList()
Declare.i PrepareMix(Row.i, DecodingMix.b = #False)
Declare.i SelectRow(gadget, index)  
Declare.s CalculateEstimatedBPM(File.s)
Declare.i CheckBoxIntroFadeIn()  
Declare.i CheckboxBreakFadeout()
Declare.i TrackbarBeatTestVolume()
Declare.i IntroTestLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
Declare.i BreakTestLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
Declare.s GenerateBeatList(Beats.s, PosBegin.f, PosEnd.f, Intro.i, LoopStart.f, LoopEnd.f, LoopRepeat.i)
Declare.i BeatTestSynchronizer(Stream.i, Channel.i, BassData.i, Intro.i)   
Declare.i ButtonPlayIntroBeatSyncTest()
Declare.i ButtonPlayBreakBeatSyncTest()
Declare.i ButtonStopIntroBeatSyncTest()
Declare.i ButtonCancelBeatSyncTest()
Declare.i ButtonTestBeatSync()
Declare.s DatabaseSongErrors()
Declare.i Skip(Stream.i, Channel.i, BassData.i, EndPosition.q) 
Declare.i CalcScale()
Declare.i TrackbarScale()
Declare.i FieldPopup(EventType.i, ListviewID.i, StringID.i, ContainerID.i)
Declare.i FieldPopupSelect(EventType.i, ListviewID.i, StringID.i)
Declare.i CreateFieldPopup(DBField.s, ContainerID.i, StringId.i, ListviewID.i) 
Declare.i RedrawSelection() 
Declare.i CalcCursorPos(StartPos.f)
Declare.i ButtonZoomIn()
Declare.i ButtonZoomOut()
Declare.i ButtonZoomFull()
Declare.i ButtonZoomToSelection()
Declare.i UpdateMarkerButtons()
Declare.f CalculateExactBPM()
Declare.i ButtonAddMarker()
Declare.i ButtonDeleteMarker()
Declare.s CleanString(String.s)
Declare.i ListviewGenre(EventType)
Declare.i ListviewLabel(EventType)
Declare.i ListviewCountry(EventType)
Declare.i ListviewYear(EventType)
Declare.i ListviewArtist(EventType)
Declare.s RemoveDuplicates(String.s)
Declare.i ButtonSleeveString()
Declare.i GenreString(EventType)
Declare.i ArtistString(EventType)
Declare.i LabelString(EventType)
Declare.i CountryString(EventType)
Declare.i YearString(EventType)
Declare.i BPMString()
Declare.i ButtonCancelDatabaseAddRecord()
Declare.i ButtonSaveDatabaseAddRecord()
Declare.i ButtonPlayDatabaseAddRecordSong()
Declare.i ButtonStopDatabaseAddRecordSong()
Declare.i DrawSelection(x.i)
Declare.i DoubleClickSelection(Left.b)
Declare.i AskRepeatQuestion(Part.s, Value.i)
Declare.b MarkerSelection(StartPos.f, EndPos.f) 
Declare.i DrawMarkers(Image = #OriginalWaveImage)
Declare.i DrawCursor()
Declare.i ButtonEditRecord()
Declare.i UpdateCanvas(Offset = 0)
Declare.l MinMaxScaled(*MinMaxArray, SamplesPerElement, *SampleData, SampleCount, Scale = 48, Stereo = #True, Cont.l = 0)
Declare.i LoadDatabaseFile(FileFullPath.s, BPM.s = "")
Declare.i TrackbarDatabase()
Declare.i UpdateTrackbarDatabase()   
Declare.i ButtonStopDatabaseSong()
Declare.i ButtonPlayDatabaseSong()
Declare.i ButtonAddRecord()
Declare.i ButtonDeleteRecord()
Declare.i ComboboxSortDatabase()
Declare.i StringSearchDatabase(EventType)
Declare.i FillListiconDatabase(ListIcon = #ListiconDatabase)
Declare.i FillListiconMusicLibrary(ListIcon = #ListiconMusicLibrary)
Declare.i ButtonRemoveFile()
Declare.i ComboboxOrderFiles()   
Declare.i ButtonAddFileToDatabase()
Declare.i StringSearchFiles(EventType)
Declare.i ButtonPlayFile()   
Declare.i ButtonStopMusicLibrarySong()     
Declare.i TrackbarMusicLibrary()   
Declare.i ThreadNextSong(void)
Declare.i ThreadCollectFiles(void)
Declare.i ThreadGetBPM(void)
Declare.i CreateDatabaseIndex(DB.i, Field.s)
Declare.i ListFilesRecursive(Dir.s, List Files.s())
Declare.i ButtonAddFolder()
Declare.i ButtonCancelAddFolder()
Declare.i ExitProgram(Restart.b = #False)
Declare.i ListiconPlaylist(EventType) 
Declare.i ThreadDecoding(Void)
Declare.i ListviewSongInfo()  
Declare.i SetTrackBarMaximum()
Declare.i UpdateSongInfo(Song.i)
Declare.i SetSynchronizers()
Declare.i ListviewSettings()
Declare.i ButtonCancelExport()
Declare.i ButtonOpenFolderSleeves()
Declare.i ButtonOpenFolderAudio()
Declare.i ButtonDefaultSettings()   
Declare.i ButtonPlayPicklistsong() 
Declare.i ButtonStopPicklistSong()   
Declare.i ButtonApplyCustomPlaylist()
Declare.i ButtonCancelCustomPlaylist()
Declare.i ButtonAddSongToCustomPlaylist()    
Declare.i ButtonRemoveSongFromCustomPlaylist()      
Declare.i ComboboxSortPicklist()
Declare.i TrackbarPicklist()
Declare.i ButtonPrevious(EventType)
Declare.i ButtonNext(EventType)  
Declare.i ButtonPlay(EventType)
Declare.i ButtonPause(EventType)
Declare.i ButtonStop(EventType)   
Declare.i ButtonVolume(EventType)
Declare.i ButtonDynAmpOn(EventType)
Declare.i ButtonDynAmpOff(EventType)
Declare.i Trackbar()
Declare.i TrackbarVolume()
Declare.i UpdateSpectrum()
Declare.i CreatePanelItemSettings()
Declare.i CreateWindowCustomPlaylist()
Declare.i LoadPreferences()
Declare.i FillListiconPicklist(ListIcon.i = #ListiconPicklist, ListLoadedFromFile.b = #False)
Declare.i CopySong(Song.i)
Declare.i UpdateTimeLabels()
Declare.i MaxSongs(Text.s)
Declare.i MinPlaybackTime(Text.s)
Declare.i MaxPlaybackTime(Text.s)
Declare.i Volume(Channel, Volume.f, InitVolume.f = -1, Seconds.f = 0.0)
Declare.i CustomButton(Gadget.i, X.i, Y.i, Width.i, Height.i, *ImageBlack, *ImageWhite = 0, Tooltip.s = "", ButtonWidth.i = 0, ButtonHeight.i = 0)
Declare.i StartTransition(Handle.i, Channel.i, BassData.i, User.i) 
Declare.i StopTransition(Handle.i, Channel.i, BassData.i, FX.i) 
Declare.f PrestartRestSeconds(Position.f, NoSkip = #True)
Declare.b PreferencesFile()
Declare.b FillListiconPlaylist(IDString.s, PreviousSession.b = #False)
Declare.s GenerateRandomPlaylist()
Declare.s GetDefaultSetting(SettingDescription.s)
Declare.s GetDistinct(Field.s)  
Declare.s OptionValue(OptionDescription.s)
Declare.s Seconds2Time(Seconds.f, DisplayHours.b)
Declare.s Seconds2TimeMS(Sec.f, Digits = 3)
Declare.f Time2Seconds(Time.s)
Declare.f TransitionLength(MixPointStart.f, MixPointEnd.f, MixPointLoopStart.f, MixPointLoopEnd.f, MixPointLoopRepeat.i)
Declare.f PlayLength(SongType.i, IntroPrefix.f, 
                     IntroStart, IntroEnd.f, IntroLoopStart.f, IntroLoopEnd.f, IntroLoopRepeat.i,
                     BreakStart.f, BreakEnd.f, BreakLoopStart.f, BreakLoopend.f, BreakLoopRepeat.i, BreakContinue.f,
                     FileFullPath.s = "") 


;-- Globals

Global NewList Songs.SongsStructure()
Global NewList SettingsPanel.SettingsPanelStructure()

Global Dim MM.MinMax(0)
Global Dim Mix.SongsStructure(1)
Global Dim LabelSongInfo(2, 1) 
Global Dim SleeveGadget(1)
Global Dim ImageFlag(1)
Global Dim FlagVisible.b(1)   
Global Dim SleeveLoaded.b(1)
Global Dim Sync.i(2)

Global RealTimeFX.RealTimeFXStructure
Global Visible.VisibleStructure
Global GadgetNumber.GadgetNumberStructure
Global Chan.ChanStructure
Global Preferences.PreferencesStructure 
Global DatabaseSong.SongsStructure 
Global CustomTransition.SongsStructure
Global *FullWaveData

Global.s RawFile, DatabaseRecordData, CustomPlaylistPreviousIDs, CollectingFilesPath, FirstSongID
Global.i SystemBackgroundColor, VolFX, TracklistPosition, DynAmp, startTime, elapsedTime, isPaused, CollectingFiles
Global.i FileSamplerateBreak, FileSamplerateIntro, CurrentSong, NextSong = 1
Global.b Busy, IntroSyncTestPlaying, BreakSyncTestPlaying, Decoding, StopDecoding, InitializationReady, InitializationReady1
Global.b StopCollectingFiles, ButtonDown, PlayerPausedByProgram, CancelDownload, RefreshPlaylist, ExitProgram, EndOfMix
Global.q PausedCurrentSongPos, PausedNextSongPos

CompilerIf #PB_Compiler_OS = #PB_OS_Windows  
  GadgetNumber\MinSongs = 54
  GadgetNumber\MaxSongs = 55
  GadgetNumber\MinPlaybackTime = 56
  GadgetNumber\MaxPlaybackTime = 57
CompilerElse
  GadgetNumber\MinSongs = 53
  GadgetNumber\MaxSongs = 54
  GadgetNumber\MinPlaybackTime = 55
  GadgetNumber\MaxPlaybackTime = 56
CompilerEndIf

;-- Initialization
 
UseSQLiteDatabase() 
UseJPEGImageDecoder()
UsePNGImageDecoder()

;------------------------------------ Resize windows

Procedure ResizeWindowsTimer()     
  Protected dx, dy, delta_dx, delta_dy

  Static old_dx, old_dy, timer, time_dx, time_dy
  
  If EventWindow() <> #WindowDatabaseAddRecord 
    ProcedureReturn 
  EndIf

  dx = WindowWidth(#WindowDatabaseAddRecord)
  dy = WindowHeight(#WindowDatabaseAddRecord)
  
  Select Event()
    Case #PB_Event_SizeWindow
      If Not timer
        timer = #True
        AddWindowTimer(#WindowDatabaseAddRecord, #TimerSizeWindow, 200)
      EndIf
      delta_dx = old_dx - dx
      delta_dy = old_dy - dy
      
      If Abs(delta_dx) > 5 Or Abs(delta_dy) > 5
        old_dx = dx
        old_dy = dy
      EndIf
    Case #PB_Event_Timer
      If EventTimer() <> #TimerSizeWindow 
        ProcedureReturn 
      EndIf

      delta_dx = time_dx - dx
      delta_dy = time_dy - dy
      time_dx = dx
      time_dy = dy
      
      If delta_dx = 0 And delta_dy = 0
        PostEvent(#PB_Event_SizeWindowFinished, #WindowDatabaseAddRecord, 0)
        timer = #False
        RemoveWindowTimer(#WindowDatabaseAddRecord, #TimerSizeWindow) 
      EndIf
  EndSelect  
EndProcedure

Procedure ResizeWindows() 
  Protected.i Gadget = 51 ;Start number of combobox gadgets in settings window
  Protected.i Frame = 101 ;Start number of frame gadgets in settings window
  Protected.i Width, Column, X, Y, Container
 
  ;**************************
  ;Resize main window gadgets
  ;**************************
  
  ResizeGadget(#Panel, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  
  For Container = #C1 To #C4
    ResizeGadget(Container, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  Next
  ResizeGadget(#C5, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain), WindowHeight(#WindowMain) - 20)
  ResizeGadget(#C6, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  
  If IsGadget(#ButtonCancelCustomPlaylist)
    ;*************************************
    ;Resize custom playlist window gadgets
    ;*************************************
        
    ResizeGadget(#ButtonPlayPicklistSong,  15, WindowHeight(#WindowCustomPlaylist) - 55, #PB_Ignore, #PB_Ignore) 
    ResizeGadget(#ButtonStopPicklistSong,  55, WindowHeight(#WindowCustomPlaylist) - 55, #PB_Ignore, #PB_Ignore)      
    ResizeGadget(#ButtonApplyCustomPlaylist,  WindowWidth(#WindowCustomPlaylist) - 230, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ResizeGadget(#ButtonCancelCustomPlaylist, WindowWidth(#WindowCustomPlaylist) - 110, #PB_Ignore, #PB_Ignore, #PB_Ignore) 
    ResizeGadget(#FramePicklist, #PB_Ignore, #PB_Ignore, (WindowWidth(#WindowCustomPlaylist) / 2) - 10, WindowHeight(#WindowCustomPlaylist) - 65)  
    ResizeGadget(#FrameTracklist, 5 + (WindowWidth(#WindowCustomPlaylist) / 2), #PB_Ignore, (WindowWidth(#WindowCustomPlaylist) / 2) - 10, WindowHeight(#WindowCustomPlaylist) - 65)  
    ResizeGadget(#ListiconPicklist, #PB_Ignore, #PB_Ignore, (WindowWidth(#WindowCustomPlaylist) / 2) - 20, WindowHeight(#WindowCustomPlaylist) - 180)  
    ResizeGadget(#ListiconPicklistSearch, #PB_Ignore, #PB_Ignore, (WindowWidth(#WindowCustomPlaylist) / 2) - 20, WindowHeight(#WindowCustomPlaylist) - 180)      
    ResizeGadget(#ListiconCustomPlaylist, 10 + (WindowWidth(#WindowCustomPlaylist) / 2), #PB_Ignore, (WindowWidth(#WindowCustomPlaylist) / 2) - 20, WindowHeight(#WindowCustomPlaylist) - 180)  
    ResizeGadget(#TrackbarPicklist,  95, WindowHeight(#WindowCustomPlaylist) - 55, GadgetWidth(#ListiconCustomPlaylist) - 90, #PB_Ignore)      
    ResizeGadget(#StringSearchPicklist, #PB_Ignore,  WindowHeight(#WindowCustomPlaylist) - 95, GadgetWidth(#ListiconPicklist) - 190, #PB_Ignore)   
    ResizeGadget(#ButtonAddSong, GadgetX(#StringSearchPicklist) + GadgetWidth(#StringSearchPicklist) + 10, WindowHeight(#WindowCustomPlaylist) - 95, #PB_Ignore, #PB_Ignore)      
    ResizeGadget(#ComboboxSortPicklist, #PB_Ignore, WindowHeight(#WindowCustomPlaylist) - 95, #PB_Ignore, #PB_Ignore)            
    ResizeGadget(#ButtonRemovesong,  15 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 95, #PB_Ignore, #PB_Ignore) 
    
    ResizeGadget(#ButtonPlayCustomTransition,  15 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 55, #PB_Ignore, #PB_Ignore) 
    ResizeGadget(#ButtonStopCustomTransition,  55 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 55, #PB_Ignore, #PB_Ignore)          
    ResizeGadget(#TrackbarCustomTransition,  95 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 55, GadgetWidth(#ListiconCustomPlaylist) - 90, #PB_Ignore)      
    
    SetGadgetItemAttribute(#ListiconPicklist, -1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconPicklist) - 60, 1) 
    SetGadgetItemAttribute(#ListiconPicklistSearch, -1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconPicklistSearch) - 60, 1) 
     
    If GadgetWidth(#ListiconCustomPlaylist) > 570
      SetGadgetItemAttribute(#ListiconCustomPlaylist, -1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconCustomPlaylist) - 475, 1) 
    Else
      SetGadgetItemAttribute(#ListiconCustomPlaylist, -1, #PB_ListIcon_ColumnWidth, 110, 1)       
    EndIf       
    
    ;Keep last listicon columns hidden
    SetGadgetItemAttribute(#ListiconPicklist, -1, #PB_ListIcon_ColumnWidth, 0, 2)    
    SetGadgetItemAttribute(#ListiconPicklistSearch, -1, #PB_ListIcon_ColumnWidth, 0, 2)      
    
    For Column = 7 To 10
      SetGadgetItemAttribute(#ListiconCustomPlaylist, -1, #PB_ListIcon_ColumnWidth, 0, Column)  
    Next       
  EndIf
 
  If IsGadget(#CursorPosString)
    ;*****************************************
    ;Resize database add record window gadgets
    ;*****************************************
 
    ResizeGadget(#ScrollAreaDatabaseAddRecord, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord), WindowHeight(#WindowDatabaseAddRecord) - 50)           
    SetGadgetAttribute(#ScrollAreaDatabaseAddRecord, #PB_ScrollArea_InnerWidth, WindowWidth(#WindowDatabaseAddRecord) - 22)
    
    X = WindowWidth(#WindowDatabaseAddRecord) / 2 - 80
    
    ResizeGadget(#ButtonCancelDatabaseAddRecord, WindowWidth(#WindowDatabaseAddRecord) - 110, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ResizeGadget(#ButtonSaveDatabaseAddRecord, WindowWidth(#WindowDatabaseAddRecord) - 220, #PB_Ignore, #PB_Ignore, #PB_Ignore)   
    ResizeGadget(#ArtistString, #PB_Ignore, #PB_Ignore, X - 10, #PB_Ignore)
    ResizeGadget(#LabelTitle, X + 75, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ResizeGadget(#TitleString, X + 145 , #PB_Ignore, X - 15 , #PB_Ignore)    
    ResizeGadget(#LabelString, #PB_Ignore, #PB_Ignore, X - 10, #PB_Ignore)
    ResizeGadget(#LabelCatno, X + 75, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ResizeGadget(#CatNoString, X + 145 , #PB_Ignore, X - 15 , #PB_Ignore)        
    ResizeGadget(#CountryString, #PB_Ignore, #PB_Ignore, X - 10, #PB_Ignore)
    ResizeGadget(#LabelYear, X + 75, #PB_Ignore, #PB_Ignore, #PB_Ignore)
    ResizeGadget(#YearString, X + 145 , #PB_Ignore, X - 15 , #PB_Ignore)            
    ResizeGadget(#GenreString, #PB_Ignore, #PB_Ignore, X - 10, #PB_Ignore)    
    ResizeGadget(#BPMString, #PB_Ignore, #PB_Ignore, X - 10, #PB_Ignore)    
    ResizeGadget(#SleeveString, #PB_Ignore, #PB_Ignore, X - 10, #PB_Ignore)   
    ResizeGadget(#ButtonSleeveString, X + 80, #PB_Ignore, #PB_Ignore, #PB_Ignore)            
    ResizeGadget(GadgetNumber\SleeveDatabase, X + 145, #PB_Ignore, #PB_Ignore, #PB_Ignore)        
     
    If GadgetHeight(#CanvasWaveform) < 200
      ResizeGadget(#CanvasWaveform, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord) - 200, WindowHeight(#WindowDatabaseAddRecord) - 195)  
    Else
      ResizeGadget(#CanvasWaveform, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord) - 200, #PB_Ignore)              
    EndIf
    
    If GadgetHeight(#CanvasWaveform) > 200
      ResizeGadget(#CanvasWaveform, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord) - 200, 200)            
    EndIf    
 
    ResizeGadget(#ContainerGenre, #PB_Ignore, #PB_Ignore, GadgetWidth(#GenreString) - 30, #PB_Ignore)    
    ResizeGadget(#ListviewGenre, #PB_Ignore, #PB_Ignore, GadgetWidth(#GenreString) - 30, #PB_Ignore)
    
    ResizeGadget(#ContainerArtist, #PB_Ignore, #PB_Ignore, GadgetWidth(#ArtistString) - 30, #PB_Ignore)    
    ResizeGadget(#ListviewArtist, #PB_Ignore, #PB_Ignore, GadgetWidth(#ArtistString) - 30, #PB_Ignore)
    
    ResizeGadget(#ContainerLabel, #PB_Ignore, #PB_Ignore, GadgetWidth(#LabelString) - 30, #PB_Ignore)    
    ResizeGadget(#ListviewLabel, #PB_Ignore, #PB_Ignore, GadgetWidth(#LabelString) - 30, #PB_Ignore)
    
    ResizeGadget(#ContainerCountry, #PB_Ignore, #PB_Ignore, GadgetWidth(#CountryString) - 30, #PB_Ignore)    
    ResizeGadget(#ListviewCountry, #PB_Ignore, #PB_Ignore, GadgetWidth(#CountryString) - 30, #PB_Ignore)
    
    ResizeGadget(#ContainerYear, GadgetX(#YearString) + 30, #PB_Ignore, GadgetWidth(#YearString) - 30, #PB_Ignore)    
    ResizeGadget(#ListviewYear, #PB_Ignore, #PB_Ignore, GadgetWidth(#YearString) - 30, #PB_Ignore)
  
    Y = GadgetY(#CanvasWaveform) + GadgetHeight(#CanvasWaveform)  
    
    ResizeGadget(#ButtonZoomToSelection, #PB_Ignore, Y + 15, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#ButtonZoomIn, #PB_Ignore, Y + 15, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#ButtonZoomOut, #PB_Ignore, Y + 15, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#ButtonZoomFull, #PB_Ignore, Y + 15, #PB_Ignore, #PB_Ignore)    
     
    Y + 40
     
    ResizeGadget(#LabelBegin, WindowWidth(#WindowDatabaseAddRecord) - 300, Y + 15, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#LabelEnd, WindowWidth(#WindowDatabaseAddRecord) - 200, Y + 15, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#LabelLength, WindowWidth(#WindowDatabaseAddRecord) - 100, Y + 15, #PB_Ignore, #PB_Ignore)       
    ResizeGadget(#SelBeginString, WindowWidth(#WindowDatabaseAddRecord) - 300, Y + 35, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#SelEndString, WindowWidth(#WindowDatabaseAddRecord) - 200, Y + 35, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#SelLengthString, WindowWidth(#WindowDatabaseAddRecord) - 100, Y + 35, #PB_Ignore, #PB_Ignore)       
    ResizeGadget(#ViewBeginString, WindowWidth(#WindowDatabaseAddRecord) - 300, Y + 55, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#ViewEndString, WindowWidth(#WindowDatabaseAddRecord) - 200, Y + 55, #PB_Ignore, #PB_Ignore)    
    ResizeGadget(#ViewLengthString, WindowWidth(#WindowDatabaseAddRecord) - 100, Y + 55, #PB_Ignore, #PB_Ignore)        
    ResizeGadget(#LabelSelection, WindowWidth(#WindowDatabaseAddRecord) - 380, Y + 35, #PB_Ignore, #PB_Ignore)     
    ResizeGadget(#LabelView, WindowWidth(#WindowDatabaseAddRecord) - 380, Y + 55, #PB_Ignore, #PB_Ignore)     
    
    If WindowWidth(#WindowDatabaseAddRecord) < 710
      ResizeGadget(#LabelCursor, WindowWidth(#WindowDatabaseAddRecord) - 540, Y + 15, #PB_Ignore, #PB_Ignore)         
      ResizeGadget(#CursorPosString, WindowWidth(#WindowDatabaseAddRecord) - 540, Y + 35, #PB_Ignore, #PB_Ignore)     
    Else
      ResizeGadget(#LabelCursor, GadgetX(#CanvasWaveform), Y + 15, #PB_Ignore, #PB_Ignore)                 
      ResizeGadget(#CursorPosString, GadgetX(#CanvasWaveform), Y + 35, #PB_Ignore, #PB_Ignore)           
    EndIf
    
    SetGadgetAttribute(#ScrollAreaDatabaseAddRecord, #PB_ScrollArea3D_InnerHeight, Y + 80)
  EndIf
  
  ;***************************
  ;Resize player panel gadgets
  ;***************************     
  
  ResizeGadget(#CanvasSpectrum, WindowWidth(#WindowMain) - 130, WindowHeight(#WindowMain) - 140, #PB_Ignore, #PB_Ignore)      
  ResizeGadget(#ListiconPlaylist, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain), WindowHeight(#WindowMain) - 225) 
  
  If GadgetWidth(#ListiconPlaylist) > 600
    SetGadgetItemAttribute(#ListiconPlaylist, 1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconPlaylist) - 533, 1)      
  Else
    SetGadgetItemAttribute(#ListiconPlaylist, 1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconPlaylist) - 393, 1)      
  EndIf
  
  Protected w

  
  If Not Visible\Volume   
    w = WindowWidth(#WindowMain) - 680
    If w < 0
      w = 0
    EndIf  
    ResizeGadget(#Trackbar,           320, #PB_Ignore, w,  #PB_Ignore)
    ResizeGadget(#TrackbarTransition, 320, #PB_Ignore, w, #PB_Ignore)
    ResizeGadget(#LabelTime, 260, #PB_Ignore, #PB_Ignore, #PB_Ignore)   
    ResizeGadget(#LabelMix, 260, #PB_Ignore, WindowWidth(#WindowMain) - 300, #PB_Ignore)   
  Else
    w = WindowWidth(#WindowMain) - 810
    If w < 0
      w = 0
    EndIf      
    ResizeGadget(#Trackbar,           450, #PB_Ignore, 2,  #PB_Ignore)
    ResizeGadget(#TrackbarTransition, 450, #PB_Ignore, 2, #PB_Ignore)
    ResizeGadget(#LabelTime, 385, #PB_Ignore, #PB_Ignore, #PB_Ignore)  
    ResizeGadget(#LabelMix, 385, #PB_Ignore, WindowWidth(#WindowMain) - 400, #PB_Ignore)       
  EndIf
  
  ResizeGadget(#LabelRemainingTime, WindowWidth(#WindowMain) - 350, #PB_Ignore, #PB_Ignore, #PB_Ignore)          
  
  ResizeSongInfo(CurrentSong)  
  ResizeSongInfo(NextSong)       
  
  ResizeGadget(#ButtonLoadPlaylist1, WindowWidth(#WindowMain) - 260, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonSavePlaylist1, WindowWidth(#WindowMain) - 220, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonCreateRandomPlaylist1, WindowWidth(#WindowMain) - 185, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonCreateCustomPlaylist1, WindowWidth(#WindowMain) - 150, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonExportTXT, WindowWidth(#WindowMain) - 115, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonExportMP3, WindowWidth(#WindowMain) - 80, #PB_Ignore, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonAlternativeSong, WindowWidth(#WindowMain) - 40, #PB_Ignore, #PB_Ignore, #PB_Ignore) 

    
  ;*****************************
  ;Resize settings panel gadgets
  ;*****************************
  
  ResizeGadget(#ScrollArea, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain), WindowHeight(#WindowMain) - 50)            
  SetGadgetAttribute(#ScrollArea, #PB_ScrollArea_InnerWidth, WindowWidth(#WindowMain) - 22)    
 
  ForEach SettingsPanel()      
    If SettingsPanel()\Section <> "" 
      ResizeGadget(Frame, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 40, #PB_Ignore)
      Frame + 1
    EndIf       
    
    If Gadget < 53
      ;Folder string gadgets needs to be resized smaller
      Width = 340 
    Else
      Width = 300
    EndIf
    
    ResizeGadget(Gadget, 260, #PB_Ignore, WindowWidth(#WindowMain) - Width, #PB_Ignore)
    Gadget + 1        
  Next      
  
  ResizeGadget(#ButtonOpenFolderAudio, WindowWidth(#WindowMain) - 70, #PB_Ignore, #PB_Ignore, #PB_Ignore)   
  ResizeGadget(#ButtonOpenFolderSleeves, WindowWidth(#WindowMain) - 70, #PB_Ignore, #PB_Ignore, #PB_Ignore)          

  
  
  ;***********************************
  ;Resize files panel gadgets
  ;***********************************
  
  ResizeGadget(#ListiconMusicLibrary, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 165)     
  ResizeGadget(#ListiconMusicLibrarySearch, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 165)         
  ResizeGadget(#ButtonRemoveFile, #PB_Ignore, WindowHeight(#WindowMain) - 105, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ComboboxSortFiles, #PB_Ignore, WindowHeight(#WindowMain) - 105, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonAddFiletoDatabase, #PB_Ignore, WindowHeight(#WindowMain) - 105, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#StringSearchFiles, #PB_Ignore, WindowHeight(#WindowMain) - 105, WindowWidth(#WindowMain) - 425, #PB_Ignore)    
  ResizeGadget(#ButtonPlayFile, #PB_Ignore, WindowHeight(#WindowMain) - 65, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonStopMusicLibrarySong, #PB_Ignore, WindowHeight(#WindowMain) - 65, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#TrackbarMusicLibrary, #PB_Ignore, WindowHeight(#WindowMain) - 60, WindowWidth(#WindowMain) - 145, #PB_Ignore)
  
  SetGadgetItemAttribute(#ListiconMusicLibrary, -1, #PB_ListIcon_ColumnWidth, (GadgetWidth(#ListiconMusicLibrary) - 120) / 2 , 2)  
  SetGadgetItemAttribute(#ListiconMusicLibrarySearch, -1, #PB_ListIcon_ColumnWidth, (GadgetWidth(#ListiconMusicLibrarySearch) - 120) / 2 , 2)  
  
  SetGadgetItemAttribute(#ListiconMusicLibrary, -1, #PB_ListIcon_ColumnWidth, (GadgetWidth(#ListiconMusicLibrary) - 120) / 2 , 3)     
  SetGadgetItemAttribute(#ListiconMusicLibrarySearch, -1, #PB_ListIcon_ColumnWidth, (GadgetWidth(#ListiconMusicLibrarySearch) - 120) / 2 , 3)     
  
       
  ;******************************
  ;Resize database panel gadgets
  ;******************************

  ResizeGadget(#LabelTotalRecords, WindowWidth(#WindowMain) - 240, #PB_Ignore, 230 , #PB_Ignore)
  ResizeGadget(#ListiconDatabase, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 175)
  ResizeGadget(#ListiconDatabaseSearch, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 175)
  ResizeGadget(#ButtonEditRecord, #PB_Ignore, WindowHeight(#WindowMain) - 110, #PB_Ignore, #PB_Ignore)    
  ResizeGadget(#ButtonDeleteRecord, #PB_Ignore, WindowHeight(#WindowMain) - 110, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ComboboxSortDatabase, #PB_Ignore, WindowHeight(#WindowMain) - 110, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#StringSearchDatabase, #PB_Ignore, WindowHeight(#WindowMain) - 110, WindowWidth(#WindowMain) - 310, #PB_Ignore)      
  ResizeGadget(#ButtonPlayDatabaseSong, #PB_Ignore, WindowHeight(#WindowMain) - 70, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#ButtonStopDatabaseSong, #PB_Ignore, WindowHeight(#WindowMain) - 70, #PB_Ignore, #PB_Ignore)
  ResizeGadget(#TrackbarDatabase, #PB_Ignore, WindowHeight(#WindowMain) - 65, WindowWidth(#WindowMain) - 145, #PB_Ignore)   
   
  SetGadgetItemAttribute(#ListiconDatabase, 1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconDatabase) - 660, 1) 
  SetGadgetItemAttribute(#ListiconDatabaseSearch, 1, #PB_ListIcon_ColumnWidth, GadgetWidth(#ListiconDatabaseSearch) - 660, 1)              

  ;Keep ID column hidden
  SetGadgetItemAttribute(#ListiconDatabase, 0, #PB_ListIcon_ColumnWidth, 0, Column)  
  SetGadgetItemAttribute(#ListiconDatabaseSearch, 0, #PB_ListIcon_ColumnWidth, 0, Column)        
 
  ;**************************
  ;Resize help panel gadgets
  ;**************************

  ResizeGadget(#EditorContainer, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 40, WindowHeight(#WindowMain) - 100) 
  ResizeGadget(#EditorHelp, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMain) - 36, WindowHeight(#WindowMain) - 96)
EndProcedure

;------------------------------------ Create windows

Procedure CreateWindowMainTemp()  
  Protected.i Icon
  Protected.i WinWidth, WinHeight
  Protected.i Big = LoadFont(#PB_Any, "Bebas-Regular", 20)  
  Protected.i Params = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_WindowCentered
   
  If ProgramParameter(0) = "youtube"
    WinWidth = 1920
    WinHeight = 1080     
  Else
    WinWidth = 900
    WinHeight = 640
    Params | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget      
  EndIf

  If Not OpenWindow(#WindowMainTemp, #PB_Ignore, #PB_Ignore, WinWidth, WinHeight, WinTitle(), Params)  
    MessageRequester("Program aborted", "Window could not be opened.", #PB_MessageRequester_Error)
    ExitProgram()
  EndIf
  
  ;Set the window bounds
  
  If ProgramParameter(0) = "youtube"
    WindowBounds(#WindowMainTemp, WinWidth, WinHeight, WinWidth, WinHeight)  
  Else
    WindowBounds(#WindowMainTemp, WinWidth, WinHeight, #PB_Ignore, #PB_Ignore)      
  EndIf
  
  SystemBackgroundColor = GetWindowBackgroundColor(#WindowMainTemp)
   
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows  
    If Preferences\WindowsTheme = "Fancy dark" 
      SetObjectTheme(#ObjectTheme_Auto, RGB(36, 36, 36))
    ElseIf Preferences\WindowsTheme = "Fancy light" 
      SetObjectTheme(#ObjectTheme_Auto, SystemBackgroundColor)      
    EndIf  
  CompilerElse
    CreateAppIcon(#WindowMainTemp)
  CompilerEndIf   
  
  ;Set the application icon
  Icon = CatchImage(#PB_Any, ?icon)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    SendMessage_(WindowID(#WindowMainTemp), #WM_SETICON, 0, ImageID(Icon))
  CompilerEndIf  
 
  TextGadget(#LabelLoading, (WinWidth / 2) - 50, (WinHeight / 2) - 25, 100, 30, "Loading...")
  SetGadgetFont(#LabelLoading, FontID(Big))   
EndProcedure

Procedure CreateWindowMain()   
  Protected.i Icon
  Protected.i Params = #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_TitleBar | #PB_Window_ScreenCentered | #PB_Window_WindowCentered | #PB_Window_Invisible
  
  Dim Image(5) 

  If LightMode()
    Image(0) = CatchImage(#PB_Any, ?musiclibwhite)
    Image(1) = CatchImage(#PB_Any, ?databasewhite)    
    Image(2) = CatchImage(#PB_Any, ?openwhite)
    Image(3) = CatchImage(#PB_Any, ?settingswhite)
    Image(4) = CatchImage(#PB_Any, ?helpwhite)   
    Image(5) = CatchImage(#PB_Any, ?upgradewhite)       
  Else
    Image(0) = CatchImage(#PB_Any, ?musiclibblack)
    Image(1) = CatchImage(#PB_Any, ?databaseblack)
    Image(2) = CatchImage(#PB_Any, ?openblack)
    Image(3) = CatchImage(#PB_Any, ?settingsblack)
    Image(4) = CatchImage(#PB_Any, ?helpblack)
    Image(5) = CatchImage(#PB_Any, ?upgradeblack)       
  EndIf  
  
  If ProgramParameter(0) <> "youtube"
    Params | #PB_Window_SizeGadget | #PB_Window_MaximizeGadget   
  EndIf
  
  OpenWindow(#WindowMain, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowMainTemp), WindowHeight(#WindowMainTemp), WinTitle(), Params)
  
 
  ;Set the window bounds
  If ProgramParameter(0) = "youtube"
    WindowBounds(#WindowMain, 1920, 1080, 1920, 1080)   
  Else
    WindowBounds(#WindowMain, 875, 300, DesktopWidth(0), DesktopHeight(0))   
  EndIf  
  
  ;Set the application icon
  Icon = CatchImage(#PB_Any, ?icon)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    SendMessage_(WindowID(#WindowMain), #WM_SETICON, 0, ImageID(Icon))
  CompilerElse
    CreateAppIcon(#WindowMain)
  CompilerEndIf
  
  ;Create tabs
  PanelGadget(#Panel, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
   
  AddGadgetItem(#Panel, -1, "Player", ImageID(Image(0))) 
  CreatePanelItemPlayer()
   
  AddGadgetItem(#Panel, -1, "Database", ImageID(Image(1)))
  CreatePanelItemDatabase()
 
  AddGadgetItem(#Panel, -1, "Files", ImageID(Image(2)))
  CreatePanelItemFiles()
   
  AddGadgetItem(#Panel, -1, "Settings", ImageID(Image(3)))
  CreatePanelItemSettings()
 
  AddGadgetItem(#Panel, -1, "Help", ImageID(Image(4)))  
  CreatePanelItemHelp()
  
  AddGadgetItem(#Panel, -1, "Upgrade", ImageID(Image(5)))  
  CreatePanelItemUpgrade()
  
  ;Close panel gadget
  CloseGadgetList()
  
  SetGadgetFont(#Panel, FontID(#Font))   
  
  ;Create keyboard shortcuts 
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_L, #AltL)  
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_S, #AltS)  
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_E, #AltE)  
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_R, #AltR)  
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_C, #AltC)    
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_P, #AltP)  
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_A, #AltA)  
  AddKeyboardShortcut(#WindowMain, #PB_Shortcut_Alt | #PB_Shortcut_O, #AltO)    
EndProcedure

Procedure CreateWindowDatabaseAddRecord(Filename.s, Action.s = "Add")
  Protected.i Bold = LoadFont(#PB_Any, "Bebas-Regular", 10, #PB_Font_Bold)       
  Protected.i Big = LoadFont(#PB_Any, "Bebas-Regular", 20) 
  Protected.i Label, X, Y
  Protected.i WinWidth = WindowWidth(#WindowMain), WinHeight = WindowHeight(#WindowMain)

  If WinWidth < 900
    WinWidth = 900
  EndIf
  
  If WinHeight < 700
    WinHeight = 700
  EndIf
   
  If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING
    PlayerPausedByProgram = #True
    ButtonPause(#PB_EventType_LeftClick)    
  EndIf
 
  OpenWindow(#WindowDatabaseAddRecord, WindowX(#WindowMain) + 10, WindowY(#windowMain) + 10, WinWidth, WinHeight, #AppName + " - Database - " + Action + " record [" + Filename + "]", #PB_Window_Invisible | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget | #PB_Window_TitleBar, WindowID(#WindowMain))
  
  WindowBounds(#WindowDatabaseAddRecord, 700, 400, DesktopWidth(0), 700)  
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    CreateAppIcon(#WindowDatabaseAddRecord)  
  CompilerEndIf
  
  X = WindowWidth(#WindowDatabaseAddRecord) / 2 - 80  
 
  ButtonGadget(#ButtonTestBeatSync, 10, 10, 130, 30, "Beat sync test")
  SetGadgetFont(#ButtonTestBeatSync, FontID(#Font))   
   
  ButtonGadget(#ButtonSaveDatabaseAddRecord, WindowWidth(#WindowDatabaseAddRecord) - 220, 10, 100, 30, "Save")
  SetGadgetFont(#ButtonSaveDatabaseAddRecord, FontID(#Font))      
  
  ButtonGadget(#ButtonCancelDatabaseAddRecord, WindowWidth(#WindowDatabaseAddRecord) - 110, 10, 100, 30, "Cancel")
  SetGadgetFont(#ButtonCancelDatabaseAddRecord, FontID(#Font))         

  ScrollAreaGadget(#ScrollAreaDatabaseAddRecord, 0, 50, WindowWidth(#WindowDatabaseAddRecord), WindowHeight(#WindowDatabaseAddRecord) - 50, 550, 550+40)
  SetGadgetAttribute(#ScrollAreaDatabaseAddRecord, #PB_ScrollArea_InnerWidth, WindowWidth(#WindowDatabaseAddRecord) - 22)    
  
  TextGadget(#LabelArtist, 10, 15, 60, 30, "Artist", #PB_Text_Right)
  SetGadgetFont(#LabelArtist, FontID(#Font))     
  StringGadget(#ArtistString, 80, 10, X - 10, 30, "")
  SetGadgetFont(#ArtistString, FontID(#Font))     
    
  TextGadget(#LabelTitle, X + 75, 15, 60, 30, "Title", #PB_Text_Right)
  SetGadgetFont(#labelTitle, FontID(#Font))     
  StringGadget(#TitleString, X + 145, 10, X - 15, 30, "")
  SetGadgetFont(#TitleString, FontID(#Font)) 
  
  TextGadget(#LabelLabel, 10, 55, 60, 30, "Label", #PB_Text_Right)
  SetGadgetFont(#LabelLabel, FontID(#Font))     
  StringGadget(#LabelString, 80, 50,  X - 10, 30, "")
  SetGadgetFont(#LabelString, FontID(#Font))     
 
  TextGadget(#LabelCatNo, X + 75, 55, 60, 30, "Cat.no.", #PB_Text_Right)
  SetGadgetFont(#LabelCatNo, FontID(#Font))     
  StringGadget(#CatNoString, X + 145, 50, X - 15, 30, "")
  SetGadgetFont(#CatNoString, FontID(#Font))     
  
  TextGadget(#LabelCountry, 10, 95, 60, 30, "Country", #PB_Text_Right)
  SetGadgetFont(#LabelCountry, FontID(#Font))     
  StringGadget(#CountryString, 80, 90,  X - 10, 30, "")
  SetGadgetFont(#CountryString, FontID(#Font))     
   
  TextGadget(#LabelYear, X + 75, 95, 60, 30, "Year", #PB_Text_Right)
  SetGadgetFont(#LabelYear, FontID(#Font))     
  StringGadget(#YearString, X + 145, 90, X - 15, 30, "", #PB_String_Numeric)  
  SetGadgetFont(#YearString, FontID(#Font))     
 
  TextGadget(#LabelGenre, 10, 135, 60, 30, "Genre", #PB_Text_Right)
  SetGadgetFont(#LabelGenre, FontID(#Font))     
  StringGadget(#GenreString, 80, 130,  X - 10, 30, "")  
  SetGadgetFont(#GenreString, FontID(#Font)) 
   
  TextGadget(#LabelBPM, 10, 175, 60, 30, "BPM", #PB_Text_Right)
  SetGadgetFont(#LabelBPM, FontID(#Font))     
  StringGadget(#BPMString, 80, 170,  X - 10, 30, "")
  SetGadgetFont(#BPMString, FontID(#Font))     
   
  TextGadget(#LabelSleeve, 10, 215, 60, 30, "Sleeve", #PB_Text_Right)
  SetGadgetFont(#LabelSleeve, FontID(#Font))      
  StringGadget(#SleeveString, 80, 210,  X - 10, 30, "", #PB_String_ReadOnly)
  SetGadgetFont(#SleeveString, FontID(#Font))     
  CustomButton(#ButtonSleeveString, X + 80, 210, 16, 16, ?openblack, ?openwhite, "Choose folder", 30, 30) 
  
  GadgetNumber\SleeveDatabase = ImageGadget(#PB_Any, X + 145, 130, 100, 100, ImageID(CreateImage(#PB_Any,  110, 110, 32, #Gray)))    
    
  Label = TextGadget(#PB_Any, 20, 255, 60, 25, "Intro:")
  SetGadgetFont(Label, FontID(Bold))       
   
  Label = TextGadget(#PB_Any, 20, 285, 60, 25, "Break:")  
  SetGadgetFont(Label, FontID(Bold))  
   
  CheckBoxGadget(#IntroFadeIn, 90, 250, 70, 30, "Fade in")
  SetGadgetFont(#IntroFadeIn, FontID(#Font))       
  
  CheckBoxGadget(#IntroHasBass, 190, 250, 70, 30, "Bass")
  SetGadgetFont(#IntroHasBass, FontID(#Font))       

  CheckBoxGadget(#IntroHasMelody, 270, 250, 70, 30, "Melody")
  SetGadgetFont(#IntroHasMelody, FontID(#Font))       
  
  CheckBoxGadget(#IntroHasVocal, 360, 250, 70, 30, "Vocal")
  SetGadgetFont(#IntroHasVocal, FontID(#Font))       
  
  CheckBoxGadget(#IntroHasBeats, 440, 250, 70, 30, "Beat")
  SetGadgetFont(#IntroHasBeats, FontID(#Font))       
   
  CheckBoxGadget(#BreakFadeOut, 90, 280, 70, 30, "Fade out")
  SetGadgetFont(#BreakFadeOut, FontID(#Font))       
  
  CheckBoxGadget(#BreakHasBass, 190, 280, 70, 30, "Bass")
  SetGadgetFont(#BreakHasBass, FontID(#Font))       
  
  CheckBoxGadget(#BreakHasMelody, 270, 280, 70, 30, "Melody")
  SetGadgetFont(#BreakHasMelody, FontID(#Font))       
  
  CheckBoxGadget(#BreakHasVocal, 360, 280, 70, 30, "Vocal")
  SetGadgetFont(#BreakHasVocal, FontID(#Font))       
  
  CheckBoxGadget(#BreakHasBeats, 440, 280, 70, 30, "Beat")
  SetGadgetFont(#BreakHasBeats, FontID(#Font))       
  
  CanvasGadget(#CanvasWaveform, 170, 320, 350, 150, #PB_Canvas_Keyboard)
  SetGadgetColor(#CanvasWaveform, #PB_Gadget_BackColor, #Black)
  
  If GadgetHeight(#CanvasWaveform) < 200
    ResizeGadget(#CanvasWaveform, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord) - 200, WindowHeight(#WindowDatabaseAddRecord) - 195)  
  Else
    ResizeGadget(#CanvasWaveform, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord) - 200, #PB_Ignore)              
  EndIf
  
  If GadgetHeight(#CanvasWaveform) > 200
    ResizeGadget(#CanvasWaveform, #PB_Ignore, #PB_Ignore, WindowWidth(#WindowDatabaseAddRecord) - 200, 200)            
  EndIf  
  
  Y = GadgetY(#CanvasWaveform) + GadgetHeight(#CanvasWaveform)    
        
  Label = FrameGadget(#PB_Any, 5, 320, 150, 100, "Marker")
  SetGadgetFont(Label, FontID(Bold)) 
  
  ComboBoxGadget(#Combo_Marker, 10, 340, 140, 30)
  AddGadgetItem(#Combo_Marker, -1, "Intro begin")
  AddGadgetItem(#Combo_Marker, -1, "Intro end")
  AddGadgetItem(#Combo_Marker, -1, "Intro prestart")
  AddGadgetItem(#Combo_Marker, -1, "Intro loop begin")
  AddGadgetItem(#Combo_Marker, -1, "Intro loop end")
  AddGadgetItem(#Combo_Marker, -1, "Intro beat")
  AddGadgetItem(#Combo_Marker, -1, "Break begin")
  AddGadgetItem(#Combo_Marker, -1, "Break end")
  AddGadgetItem(#Combo_Marker, -1, "Break continue")
  AddGadgetItem(#Combo_Marker, -1, "Break mute")
  AddGadgetItem(#Combo_Marker, -1, "Break loop begin")
  AddGadgetItem(#Combo_Marker, -1, "Break loop end")
  AddGadgetItem(#Combo_Marker, -1, "Break beat")
  AddGadgetItem(#Combo_Marker, -1, "Skip begin")
  AddGadgetItem(#Combo_Marker, -1, "Skip end")
  SetGadgetFont(#Combo_Marker, FontID(#Font))  
  SetGadgetText(#Combo_Marker, "Intro begin")
  
  ButtonGadget(#ButtonAddMarker, 10, 380, 60, 30, "Add")
  SetGadgetFont(#ButtonAddMarker, FontID(#Font))   
  
  ButtonGadget(#ButtonDeleteMarker,  80, 380, 70, 30, "Delete")
  SetGadgetFont(#ButtonDeleteMarker, FontID(#Font))   
         
  Label = TextGadget(#PB_Any, 10, 450, 140, 30, "Waveform scale")  
  SetGadgetFont(Label, FontID(Bold))  
  
  TrackBarGadget(#TrackbarScale, 10, 480, 140, 20, 32, 128)
  SetGadgetState(#TrackbarScale, CalcScale())       
  
  CustomButton(#ButtonPlaySong, 10, Y + 15, 14, 14, ?playblack,?playwhite, "Play", 30, 30)  
  CustomButton(#ButtonStopSong, 55, Y + 15, 16, 16, ?stopblack,?stopwhite, "Stop", 30, 30)  
  
  CustomButton(#ButtonZoomToSelection, 170, Y + 15, 20, 20, ?zoomselectionblack,?zoomselectionwhite, "Zoom to selection", 40, 30)
  CustomButton(#ButtonZoomIn, 250, Y + 15, 20, 20, ?zoominblack,?zoominwhite, "Zoom  in", 40, 30) 
  CustomButton(#ButtonZoomOut, 330, Y + 15, 20, 20, ?zoomoutblack,?zoomoutwhite, "Zoom out", 40, 30) 
  CustomButton(#ButtonZoomFull, 410, Y + 15, 20, 20, ?zoomfullblack,?zoomfullwhite, "Zoom full", 40, 30)   
   
  GadgetToolTip(#ButtonZoomToSelection, "Zoom to selection")
  GadgetToolTip(#ButtonZoomIn, "Zoom in")
  GadgetToolTip(#ButtonZoomOut, "Zoom out")
  GadgetToolTip(#ButtonZoomFull, "Zoom full")
  
  Y + 40

  SetGadgetAttribute(#ScrollAreaDatabaseAddRecord, #PB_ScrollArea3D_InnerHeight + 2, Y + 80)
  
  If WindowWidth(#WindowDatabaseAddRecord) < 710  
    TextGadget(#LabelCursor, WindowWidth(#WindowDatabaseAddRecord) - 540, Y + 15, 70, 20, "Cursor")        
    TextGadget(#CursorPosString, WindowWidth(#WindowDatabaseAddRecord) - 540, Y + 35, 120, 30, "00:00.000")
  Else
    TextGadget(#LabelCursor, GadgetX(#CanvasWaveform), Y + 15, 70, 20, "Cursor") 
    TextGadget(#CursorPosString, GadgetX(#CanvasWaveform), Y + 35, 120, 30, "00:00.000")    
  EndIf
  SetGadgetFont(#LabelCursor, FontID(Bold))      
  SetGadgetFont(#CursorPosString, FontID(Big))     

  TextGadget(#LabelBegin, WindowWidth(#WindowDatabaseAddRecord) - 300, Y + 15, 70, 20, "Begin")
  SetGadgetFont(#LabelBegin, FontID(Bold))     
  
  TextGadget(#LabelEnd, WindowWidth(#WindowDatabaseAddRecord) - 200, Y + 15, 70, 20, "End")
  SetGadgetFont(#LabelEnd, FontID(Bold))     
  
  TextGadget(#LabelLength, WindowWidth(#WindowDatabaseAddRecord) - 100, Y + 15, 70, 20, "Length")
  SetGadgetFont(#LabelLength, FontID(Bold))     
   
  TextGadget(#LabelSelection, WindowWidth(#WindowDatabaseAddRecord) - 380, Y + 35, 70, 20, "Selection", #PB_Text_Right)
  SetGadgetFont(#LabelSelection, FontID(Bold))
  
  TextGadget(#LabelView, WindowWidth(#WindowDatabaseAddRecord) - 380, Y + 55, 70, 20, "View", #PB_Text_Right)
  SetGadgetFont(#LabelView, FontID(Bold))     
   
  TextGadget(#SelBeginString, WindowWidth(#WindowDatabaseAddRecord) - 300, Y + 35, 80, 20, "00:00.000")
  SetGadgetFont(#SelBeginString, FontID(#Font))     
    
  TextGadget(#SelEndString, WindowWidth(#WindowDatabaseAddRecord) - 200, Y + 35, 80, 20, "00:00.000")
  SetGadgetFont(#SelEndString, FontID(#Font))  
  
  TextGadget(#SelLengthString, WindowWidth(#WindowDatabaseAddRecord) - 100, Y + 35, 80, 20, "00:00.000")
  SetGadgetFont(#SelLengthString, FontID(#Font))    
    
  TextGadget(#ViewBeginString, WindowWidth(#WindowDatabaseAddRecord) - 300, Y + 55, 80, 20, "00:00.000")
  SetGadgetFont(#ViewBeginString, FontID(#Font))   
       
  TextGadget(#ViewEndString, WindowWidth(#WindowDatabaseAddRecord) - 200, Y + 55, 80, 20, "00:00.000")
  SetGadgetFont(#ViewEndString, FontID(#Font))      
     
  TextGadget(#ViewLengthString, WindowWidth(#WindowDatabaseAddRecord) - 100, Y + 55, 80, 20, "00:00.000")
  SetGadgetFont(#ViewLengthString, FontID(#Font))   
   
  CreateFieldPopup("artist", #ContainerArtist, #ArtistString, #ListviewArtist) 
  CreateFieldPopup("label", #ContainerLabel, #LabelString, #ListviewLabel) 
  CreateFieldPopup("country", #ContainerCountry, #CountryString, #ListviewCountry) 
  CreateFieldPopup("year", #ContainerYear, #YearString, #ListviewYear) 
  CreateFieldPopup("genre", #ContainerGenre, #GenreString, #ListviewGenre)  
  
  CloseGadgetList()  ;Close scrollarea gadget

  SetActiveGadget(#ArtistString)      

  BindGadgetEvent(#ButtonCancelDatabaseAddRecord, @ButtonCancelDatabaseAddRecord())
  BindGadgetEvent(#ButtonSaveDatabaseAddRecord, @ButtonSaveDatabaseAddRecord())
  BindGadgetEvent(#BPMString, @BPMString())
  BindGadgetEvent(#ButtonSleeveString, @ButtonSleeveString()) 
  BindGadgetEvent(#ButtonAddMarker, @ButtonAddMarker())
  BindGadgetEvent(#ButtonDeleteMarker, @ButtonDeleteMarker())
  BindGadgetEvent(#ButtonZoomFull, @ButtonZoomFull())
  BindGadgetEvent(#ButtonZoomToSelection, @ButtonZoomToSelection())
  BindGadgetEvent(#ButtonZoomIn, @ButtonZoomIn())
  BindGadgetEvent(#ButtonZoomOut, @ButtonZoomOut()) 
  BindGadgetEvent(#ButtonPlaySong, @ButtonPlayDatabaseAddRecordSong()) 
  BindGadgetEvent(#ButtonStopSong, @ButtonStopDatabaseAddRecordSong())   
  BindGadgetEvent(#TrackbarScale, @TrackbarScale())
  BindGadgetEvent(#ButtonTestBeatSync, @ButtonTestBeatSync())
  BindGadgetEvent(#IntroFadeIn, @CheckBoxIntroFadeIn())  
  BindGadgetEvent(#BreakFadeOut, @CheckboxBreakFadeout())  
  
  BindEvent(#PB_Event_SizeWindow, @ResizeWindowsTimer()) 
  BindEvent(#PB_Event_Timer, @ResizeWindowsTimer())
     
  ;Create keyboard shortcuts 
  AddKeyboardShortcut(#WindowDatabaseAddRecord, #PB_Shortcut_Escape, #EscKey)
  AddKeyboardShortcut(#WindowDatabaseAddRecord, #PB_Shortcut_Return, #EnterKey)  
  AddKeyboardShortcut(#WindowDatabaseAddRecord, #PB_Shortcut_Up, #UpKey)  
  AddKeyboardShortcut(#WindowDatabaseAddRecord, #PB_Shortcut_Down, #DownKey) 
EndProcedure

Procedure CreateWindowExportToAudioFile()  
  If CountGadgetItems(#ListiconPlaylist) = 0
    MessageRequester("Action not allowed", "Can't export because the playlist is empty.")
    ProcedureReturn
  EndIf

  OpenWindow(#WindowExportToAudioFile, 0, 0, 600, 160, #AppName + " - Export mix to audiofile", #PB_Window_TitleBar | #PB_Window_MinimizeGadget | #PB_Window_WindowCentered, WindowID(#WindowMain)) 
  WindowBounds(#WindowExportToAudioFile, 600, 160, 600, 160)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux  
    CreateAppIcon(#WindowExportToAudioFile)   
  CompilerEndIf
  
  TextGadget(#LabelExport, 10, 20, 580, 40, "")

  SetGadgetFont(#LabelExport, FontID(#Font))
  
  ProgressBarGadget(#ProgressBarExport, 10, 70, 530, 20, 0, 100)     
  TextGadget(#LabelExportPercent, 550, 72, 50, 20, "")  
  SetGadgetFont(#LabelExport, FontID(#Font)) 
  
  ButtonGadget(#ButtonCancelExport, 490, 110, 100, 30, "Cancel")  
  SetGadgetFont(#ButtonCancelExport, FontID(#Font))
  
  BindGadgetEvent(#ButtonCancelExport, @ButtonCancelExport())    
EndProcedure

Procedure CreateWindowCustomPlaylist()      
  Protected.i Row, Frame, Image
  Protected.i WinWidth = WindowWidth(#WindowMain), WinHeight = WindowHeight(#WindowMain)
  Protected.i Bold = LoadFont(#PB_Any, "Bebas-Regular", 10, #PB_Font_Bold)    
  
  If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING
    PlayerPausedByProgram = #True
    ButtonPause(#PB_EventType_LeftClick)    
  EndIf
  
  If WinWidth < 1000
    WinWidth = 1000
  EndIf
  
  If WinHeight < 500
    WinHeight = 500
  EndIf
  
  If DesktopWidth(0) > 1200
    WinWidth = 1200
  EndIf
  
  OpenWindow(#WindowCustomPlaylist, WindowX(#WindowMain) + 10, WindowY(#WindowMain) + 10, WinWidth, WinHeight, #AppName + " - Create custom playlist",  #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | 
                                 #PB_Window_SizeGadget | #PB_Window_TitleBar | #PB_Window_Invisible, WindowID(#WindowMain))  
  WindowBounds(#WindowCustomPlaylist, 500, 300, DesktopWidth(0), DesktopHeight(0)) 
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    CreateAppIcon(#WindowCustomPlaylist)     
  CompilerEndIf
  
  ButtonGadget(#ButtonLoadCustomPlaylist,  10, 10, 100, 30, "Load")    
  SetGadgetFont(#ButtonLoadCustomPlaylist, FontID(#Font)) 
      
  ButtonGadget(#ButtonSaveCustomPlaylist,  130, 10, 100, 30, "Save")    
  SetGadgetFont(#ButtonSaveCustomPlaylist, FontID(#Font))   
  
  ButtonGadget(#ButtonApplyCustomPlaylist,  WindowWidth(#WindowCustomPlaylist) - 230, 10, 100, 30, "Apply")
  SetGadgetFont(#ButtonApplyCustomPlaylist, FontID(#Font)) 
  
  ButtonGadget(#ButtonCancelCustomPlaylist,  WindowWidth(#WindowCustomPlaylist) - 110, 10, 100, 30, "Cancel")    
  SetGadgetFont(#ButtonCancelCustomPlaylist, FontID(#Font)) 
    
  
  ;***************************
  ;Create gadgets for picklist
  ;***************************
  
  FrameGadget(#FramePicklist, 5, 55, (WindowWidth(#WindowCustomPlaylist) / 2) - 10, WindowHeight(#WindowCustomPlaylist) - 65, "Picklist")
  
  ListIconGadget(#ListiconPicklist, 10, 75, (WindowWidth(#WindowCustomPlaylist) / 2) - 20, WindowHeight(#WindowCustomPlaylist) - 180, "BPM", 60, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  ListIconGadget(#ListiconPicklistSearch, 10, 75, (WindowWidth(#WindowCustomPlaylist) / 2) - 20, WindowHeight(#WindowCustomPlaylist) - 180, "BPM", 60, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  
  AddGadgetColumn(#ListiconPicklist, 1, "Song", GadgetWidth(#ListiconPicklist) - 60)
  AddGadgetColumn(#ListiconPicklistSearch, 1, "Song", GadgetWidth(#ListiconPicklistSearch) - 60)
  
  AddGadgetColumn(#ListiconPicklist, 2, "", 0) ;Hidden column for ID's
  AddGadgetColumn(#ListiconPicklistSearch, 2, "", 0) ;Hidden column for ID's
  
  SetGadgetFont(#FramePicklist, FontID(Bold))   
  SetGadgetFont(#ListiconPicklist, FontID(#Font)) 
  SetGadgetFont(#ListiconPicklistSearch, FontID(#Font)) 
  
  HideGadget(#ListIconPicklistSearch, #True)    
  Visible\ListiconPicklistSearch = #False  
      
  ;Combobox gadget for sorting by column
  ComboBoxGadget(#ComboboxSortPicklist, 15, WindowHeight(#WindowCustomPlaylist) - 95, 75, 30)
  AddGadgetItem(#ComboboxSortPicklist, 0, "Sort")    
  AddGadgetItem(#ComboboxSortPicklist, 1, "BPM")  
  AddGadgetItem(#ComboboxSortPicklist, 2, "Artist")
  AddGadgetItem(#ComboboxSortPicklist, 3, "Year")  
  AddGadgetItem(#ComboboxSortPicklist, 4, "Label")  
  AddGadgetItem(#ComboboxSortPicklist, 5, "Country")    
  SetGadgetText(#ComboboxSortPicklist, "Sort")  
  SetGadgetFont(#ComboboxSortPicklist, FontID(#Font))   
  
  ;String gadget for searching
  StringGadget(#StringSearchPicklist, 110, WindowHeight(#WindowCustomPlaylist) - 95, GadgetWidth(#ListiconPicklist) - 190, 30, "Search...")
  SetGadgetFont(#StringSearchPicklist, FontID(#Font))   
      
  ;Add button
  ButtonGadget(#ButtonAddSong, GadgetX(#StringSearchPicklist) + GadgetWidth(#StringSearchPicklist) + 10, WindowHeight(#WindowCustomPlaylist) - 95, 75, 30, "Add >>")
  SetGadgetFont(#ButtonAddSong, FontID(#Font))   
  
  ;Player gadgets
  CustomButton(#ButtonPlayPicklistSong, 15, WindowHeight(#WindowCustomPlaylist) - 55, 14, 14, ?playblack, ?playwhite, "Play", 30, 30)   
  CustomButton(#ButtonStopPicklistSong,  55, WindowHeight(#WindowCustomPlaylist) - 55, 16, 16, ?stopblack, ?stopwhite, "Stop", 30, 30)   
  TrackBarGadget(#TrackbarPicklist, 95, WindowHeight(#WindowCustomPlaylist) - 55, GadgetWidth(#ListiconPicklist) - 90, 30, 0, 0)  
  DisableGadget(#TrackbarPicklist, #True)       
   
  ;****************************
  ;Create gadgets for tracklist
  ;****************************
  
  FrameGadget(#FrameTracklist, 5 + (WindowWidth(#WindowCustomPlaylist) / 2), 55, (WindowWidth(#WindowCustomPlaylist) / 2) - 10, WindowHeight(#WindowCustomPlaylist) - 65, "Custom playlist")
  SetGadgetFont(#FrameTracklist, FontID(Bold))  
  
  ListIconGadget(#ListiconCustomPlaylist, 10 + (WindowWidth(#WindowCustomPlaylist) / 2), 75, (WindowWidth(#WindowCustomPlaylist) / 2) - 20, WindowHeight(#WindowCustomPlaylist) - 180, "Track", 50, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  
  If GadgetWidth(#ListiconCustomPlaylist) > 570  
    AddGadgetColumn(#ListiconCustomPlaylist, 1, "Song", GadgetWidth(#ListiconCustomPlaylist) - 475)
  Else
    AddGadgetColumn(#ListiconCustomPlaylist, 1, "Song", 110)    
  EndIf
  AddGadgetColumn(#ListiconCustomPlaylist, 2, "Play time", 80)
  AddGadgetColumn(#ListiconCustomPlaylist, 3, "Incr. time", 80)  
  AddGadgetColumn(#ListiconCustomPlaylist, 4, "Original BPM", 110)
  AddGadgetColumn(#ListiconCustomPlaylist, 5, "Playback BPM", 110)  
  AddGadgetColumn(#ListiconCustomPlaylist, 6, "Pitch", 80)    
  AddGadgetColumn(#ListiconCustomPlaylist, 7, "", 80) ;Hidden column for ID's  
  AddGadgetColumn(#ListiconCustomPlaylist, 8, "", 80) ;Hidden column for playtime in seconds (float type)  
  AddGadgetColumn(#ListiconCustomPlaylist, 9, "", 80) ;Hidden column for samplerate
  AddGadgetColumn(#ListiconCustomPlaylist, 10, "", 80);Hidden column for shortened songs  
 
  SetGadgetFont(#ListiconCustomPlaylist, FontID(#Font))    
    
  ButtonGadget(#ButtonRemoveSong, 15 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 95, 140, 30, "Remove last song") 
  SetGadgetFont(#ButtonRemoveSong, FontID(#Font))     
  
  ;Player gadgets (for transition)
  CustomButton(#ButtonPlayCustomTransition, 15 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 55, 14, 14, ?playblack, ?playwhite, "Play", 30, 30)   
  CustomButton(#ButtonStopCustomTransition,  55 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 55, 16, 16, ?stopblack, ?stopwhite, "Stop", 30, 30)     
  TrackBarGadget(#TrackbarCustomTransition, 95 + (WindowWidth(#WindowCustomPlaylist) / 2), WindowHeight(#WindowCustomPlaylist) - 55, GadgetWidth(#ListiconCustomPlaylist) - 90, 30, 0, 0)  
  DisableGadget(#TrackbarCustomTransition, #True)  

  ;Create bindings 
  BindGadgetEvent(#ButtonPlayPicklistSong, @ButtonPlayPicklistsong())  
  BindGadgetEvent(#ButtonStopPicklistSong, @ButtonStopPicklistSong())    
  BindGadgetEvent(#ButtonApplyCustomPlaylist, @ButtonApplyCustomPlaylist())  
  BindGadgetEvent(#ButtonCancelCustomPlaylist, @ButtonCancelCustomPlaylist())   
  BindGadgetEvent(#ButtonAddSong, @ButtonAddSongToCustomPlaylist())      
  BindGadgetEvent(#ButtonRemoveSong, @ButtonRemoveSongFromCustomPlaylist())        
  BindGadgetEvent(#ComboboxSortPicklist, @ComboboxSortPicklist())     
  BindGadgetEvent(#TrackbarPicklist, @TrackbarPicklist())
  BindGadgetEvent(#ListiconPicklist, @ButtonStopPicklistSong())
  BindGadgetEvent(#ListiconPicklistSearch, @ButtonStopCustomTransition())  
  BindGadgetEvent(#ListiconCustomPlaylist, @ButtonStopCustomTransition())    
  BindGadgetEvent(#ButtonPlayCustomTransition, @ButtonPlayCustomTransition())
  BindGadgetEvent(#ButtonStopCustomTransition, @ButtonStopCustomTransition())  
  BindGadgetEvent(#ButtonLoadCustomPlaylist, @ButtonLoadCustomPlaylist())  
  BindGadgetEvent(#ButtonSaveCustomPlaylist, @ButtonSaveCustomPlaylist())    
EndProcedure

Procedure CreateWindowBeatSyncTest()
  Protected.s Action, Song
  Protected.s DBAdd = #AppName + " - Database - "
  Protected.i Label
  Protected.i Bold = LoadFont(#PB_Any, "Bebas-Regular", 10, #PB_Font_Bold)  
  Protected.i DBAddLen = Len(DBAdd)
  
  If Left(GetWindowTitle(#WindowDatabaseAddRecord), DBAddLen + 3) = DBadd + "Add"
    Action = "Add"
  Else
    Action = "Edit"
  EndIf
  
  DBAdd + Action + " record ["
  
  If Trim(GetGadgetText(#ArtistString)) <> "" And Trim(GetGadgetText(#TitleString)) <> "" 
    Song = UCase(GetGadgetText(#ArtistString)) + " - " + UCase(GetGadgetText(#TitleString))
  Else
    ;Extract filename from window title
    Song = ReplaceString(GetWindowTitle(#WindowDatabaseAddRecord), DBAdd, "")
    
    ;Remove ] at end of window title
    Song = Left(Song, Len(Song) - 1)
  EndIf
  
  OpenWindow(#WindowBeatSyncTest, 0, 0, 550, 230, #AppName + " - Database - " + Action + " record - Beat sync test", #PB_Window_TitleBar | #PB_Window_MinimizeGadget | #PB_Window_WindowCentered, WindowID(#WindowDatabaseAddRecord)) 
  WindowBounds(#WindowBeatSyncTest, 550, 230, 550, 230)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux  
    CreateAppIcon(#WindowBeatSyncTest)
  CompilerEndIf
  
  ButtonGadget(#ButtonCancelBeatSyncTest, 440, 10, 100, 30, "Close")
  SetGadgetFont(#ButtonCancelBeatSyncTest, FontID(#Font))   
        
  Label = TextGadget(#PB_Any, 10, 10, 300, 30, "Volume of overlapping test-beats")
  SetGadgetFont(Label, FontID(Bold))   
  
  TrackBarGadget(#TrackbarBeatTestVolume, 320, 15, 100, 30, 0, 150)  
  SetGadgetState(#TrackbarBeatTestVolume, 75)
  TrackbarBeatTestVolume()
      
  Label = TextGadget(#PB_Any, 10, 60, 530, 30, Song)
  SetGadgetFont(Label, FontID(#Font))      
  
  CustomButton(#ButtonPlayIntroBeatSyncTest, 20, 140, 14, 14, ?playblack, ?playwhite, "Play", 30, 30)  
  CustomButton(#ButtonStopIntroBeatSyncTest, 60, 140, 16, 16, ?stopblack, ?stopwhite, "Stop", 30, 30)
      
  CustomButton(#ButtonPlayBreakBeatSyncTest, 293, 140, 14, 14, ?playblack, ?playwhite, "Play", 30, 30)    
  CustomButton(#ButtonStopBreakBeatSyncTest, 333, 140, 16, 16, ?stopblack, ?stopwhite, "Stop", 30, 30)
 
  TrackBarGadget(#TrackbarIntroBeatSyncTest, 30, 190, 225, 30, 0, Round(DatabaseSong\IntroPrefix + TransitionLength(DatabaseSong\IntroStart, DatabaseSong\IntroEnd, DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd, DatabaseSong\IntroLoopRepeat), #PB_Round_Nearest) * 1000)
  TrackBarGadget(#TrackbarBreakBeatSyncTest, 303, 190, 225, 30, 0, Round(DatabaseSong\BreakContinue + TransitionLength(DatabaseSong\BreakStart, DatabaseSong\BreakEnd, DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd, DatabaseSong\BreakLoopRepeat), #PB_Round_Nearest) * 1000)
  
  TextGadget(#LabelTestIntroTime, 165, 140, 80, 30, "-" + Seconds2Time(GetGadgetAttribute(#TrackbarIntroBeatSyncTest, #PB_TrackBar_Maximum) / 1000, #False), #PB_Text_Right) 
  SetGadgetFont(#LabelTestIntroTime, FontID(#Font))  
  
  TextGadget(#LabelTestBreakTime, 438, 140, 80, 30, "-" + Seconds2Time(GetGadgetAttribute(#TrackbarBreakBeatSyncTest, #PB_TrackBar_Maximum) / 1000, #False), #PB_Text_Right)  
  SetGadgetFont(#LabelTestBreakTime, FontID(#Font))  
  
  DisableGadget(#TrackbarIntroBeatSyncTest, #True)
  DisableGadget(#TrackbarBreakBeatSyncTest, #True)
             
  Label = FrameGadget(#PB_Any, 10, 110, 255, 110, "Intro beat sync test")
  SetGadgetFont(Label, FontID(Bold))    
  
  Label = FrameGadget(#PB_Any, 283, 110, 255, 110, "Break beat sync test")
  SetGadgetFont(Label, FontID(Bold))
  
  BindGadgetEvent(#ButtonCancelBeatSyncTest, @ButtonCancelBeatSyncTest())  
  BindGadgetEvent(#ButtonPlayIntroBeatSyncTest, @ButtonPlayIntroBeatSyncTest())
  BindGadgetEvent(#ButtonStopIntroBeatSyncTest, @ButtonStopIntroBeatSyncTest())
  BindGadgetEvent(#ButtonPlayBreakBeatSyncTest, @ButtonPlayBreakBeatSyncTest())
  BindGadgetEvent(#ButtonStopBreakBeatSyncTest, @ButtonStopBreakBeatSyncTest())    
  BindGadgetEvent(#TrackbarBeatTestVolume, @TrackbarBeatTestVolume())
EndProcedure

Procedure CreateWindowFilesProgress()
  OpenWindow(#WindowMusicLibraryProgress, 0, 0, 600, 190, #AppName + " - Files - Add folder", #PB_Window_TitleBar | #PB_Window_MinimizeGadget | #PB_Window_WindowCentered, WindowID(#WindowMain)) 
  WindowBounds(#WindowMusicLibraryProgress, 600, 190, 600, 190)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    CreateAppIcon(#WindowMusicLibraryProgress)  
  CompilerEndIf
  
  TextGadget(#LabelFile, 10, 20, 580, 80, "Collecting files...")
  SetGadgetFont(#LabelFile, FontID(#Font))     
  
  ButtonGadget(#ButtonCancelAddFolder, 480, 140, 100, 30, "Cancel")  
  SetGadgetFont(#ButtonCancelAddFolder, FontID(#Font))   
  
  BindGadgetEvent(#ButtonCancelAddFolder, @ButtonCancelAddFolder())    
EndProcedure 


;------------------------------------ Create panel items

Procedure CreatePanelItemPlayer()
  Protected.i Bold = LoadFont(#PB_Any, "Bebas-Regular", 14, #PB_Font_Bold)     
  Protected.i Image, i, Y, Extra, Y1, Y3
  
  ContainerGadget(#C1, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
    SetGadgetColor(#C1, #PB_Gadget_BackColor, SystemBackgroundColor)  
  CompilerEndIf
  
  ;Create icon-buttons on the left side
  CustomButton(#ButtonPrevious,  10, 15, 25, 25, ?previousblack, ?previouswhite, "Previous") 
  CustomButton(#ButtonPlay,      45, 17, 25, 21, ?playblack, ?playwhite, "Play")
  CustomButton(#ButtonPause,     45, 15, 25, 25, ?pauseblack, ?pausewhite, "Pause")  
  CustomButton(#ButtonStop,      80, 15, 25, 25, ?stopblack, ?stopwhite, "Stop")
  CustomButton(#ButtonNext,      120, 15, 25, 25, ?nextblack, ?nextwhite, "Next") 
  CustomButton(#ButtonDynAmpOn,  165, 15, 25, 22, ?dynamponblack, ?dynamponwhite, "Enable dynamic amplitude") 
  CustomButton(#ButtonDynAmpOff, 165, 15, 25, 25, ?dynampoffblack, ?dynampoffwhite, "Disable dynamic amplitude")
  CustomButton(#ButtonVolume,    205, 15, 23, 23, ?volumeblack, ?volumewhite, "Volume") 
  
  CustomButton(#ButtonLoadPlaylist1, WindowWidth(#WindowMain) - 260, 15, 20, 20, ?openblack, ?openwhite, "Load playlist")
  CustomButton(#ButtonSavePlaylist1, WindowWidth(#WindowMain) - 220, 15, 20, 20, ?saveblack, ?savewhite, "Save playlist")   
  CustomButton(#ButtonCreateRandomPlaylist1, WindowWidth(#WindowMain) - 185 , 15, 20, 20, ?shuffleblack, ?shufflewhite, "Create random playlist")     
  CustomButton(#ButtonCreateCustomPlaylist1, WindowWidth(#WindowMain) - 150, 17, 18, 18, ?customblack, ?customwhite, "Create custom playlist") 
  CustomButton(#ButtonExportTXT, WindowWidth(#WindowMain) - 115, 15, 20, 20, ?txtblack, ?txtwhite, "Export playlist to text-file")      
  CustomButton(#ButtonExportMP3, WindowWidth(#WindowMain) - 80, 15, 20, 20, ?mp3black, ?mp3white, "Export playlist to mp3-file")      
  CustomButton(#ButtonAlternativeSong,  WindowWidth(#WindowMain) - 40, 15, 20, 20, ?replaceblack, ?replacewhite, "Replace song")      
   
  HideGadget(#ButtonDynAmpOff, #True)
  HideGadget(#ButtonPause, #True)
   
  ;Create trackbar gadget for volume 
  TrackBarGadget(#TrackbarVolume, 240, 15, 80, 20, 0, 150)  
  SetGadgetState(#TrackbarVolume, 75) 
  HideGadget(#TrackbarVolume, #True)
  
  Protected w = WindowWidth(#WindowMain) - 680
  If w < 0
    w = 0
  EndIf
   
  TrackBarGadget(#Trackbar,           320, 15, w, 20, 0, 0)
  TrackBarGadget(#TrackbarTransition, 320, 15, w, 20, 0, 0)
  
  HideGadget(#TrackbarTransition, #True)
  DisableGadget(#TrackbarTransition, #True)
  
  ;Create time labels   
  TextGadget(#LabelTime, 260, 15, 40, 20, "00:00", #PB_Text_Right)  
  TextGadget(#LabelMix, 260, 35, WindowWidth(#WindowMain) - 300, 20, "")  
  SetGadgetFont(#LabelMix, FontID(#Font))   
  
  TextGadget(#LabelRemainingTime, WindowWidth(#WindowMain) - 350, 15, 40, 20, "-00:00")     
  SetGadgetFont(#LabelTime, FontID(#Font))     
  SetGadgetFont(#LabelRemainingTime, FontID(#Font))   
     
  ;Create listicon for playlist
  ListIconGadget(#ListiconPlaylist, 0, 60, WindowWidth(#WindowMain), WindowHeight(#WindowMain) - 255, "Track", 50, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection|#PB_ListIcon_MultiSelect) 
  ;SetGadgetColor(#ListiconPlaylist,#PB_Gadget_BackColor, SystemBackgroundColor)
  
  If GadgetWidth(#ListiconPlaylist) > 850
    AddGadgetColumn(#ListiconPlaylist, 1, "Song", GadgetWidth(#ListiconPlaylist) - 520)       
  Else
    AddGadgetColumn(#ListiconPlaylist, 1, "Song", GadgetWidth(#ListiconPlaylist) - 380)         
  EndIf 
  
  AddGadgetColumn(#ListiconPlaylist, 2, "Play time", 80)
  AddGadgetColumn(#ListiconPlaylist, 3, "Incr. time", 80)  
  AddGadgetColumn(#ListiconPlaylist, 4, "Original BPM", 110)
  AddGadgetColumn(#ListiconPlaylist, 5, "Playback BPM", 110)  
  AddGadgetColumn(#ListiconPlaylist, 6, "Pitch", 80)
  SetGadgetFont(#ListiconPlaylist, FontID(#Font))     
  
  ContainerGadget(#ContainerSongInfo, 0, GadgetY(#ListiconPlaylist) + GadgetHeight(#ListiconPlaylist) + 20, 400, 120, #PB_Container_BorderLess)
  ScrollAreaGadget(#ScrollAreaSongInfo, 20, 0, 400, 120, 400, 260, 1, #PB_ScrollArea_BorderLess)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux   
    Y1 = 5
    Y3 = 75
  CompilerElse
    Y1 = 10
    Y3 = 70    
  CompilerEndIf
  
  ;Create gadgets for song info
  For i = 0 To 1
    LabelSongInfo(0, i) = StringGadget(#PB_Any, 130, 5 + Y1, 400, 25, "", #PB_String_ReadOnly|#PB_String_UpperCase|#PB_String_BorderLess)
    LabelSongInfo(1, i) = StringGadget(#PB_Any, 130, 40 + Y, 400, 25, "", #PB_String_ReadOnly|#PB_String_UpperCase|#PB_String_BorderLess)
    LabelSongInfo(2, i) = StringGadget(#PB_Any, 130, 75 + Y3, 400, 25, "", #PB_String_ReadOnly|#PB_String_UpperCase|#PB_String_BorderLess)
    SleeveGadget(i) = ImageGadget(#PB_Any, 20, WindowHeight(#WindowMain) - 150  + Y, 70, 70, ImageID(CreateImage(#PB_Any, 1, 1, 32)))    
    ImageFlag(i) = ImageGadget(#PB_Any, 130, 75 + Y3, 40, 40, ImageID(CreateImage(#PB_Any, 1, 1, 32)))  
   
    SetGadgetFont(LabelSongInfo(0, i), FontID(Bold))
    SetGadgetFont(LabelSongInfo(1, i), FontID(Bold))
    SetGadgetFont(LabelSongInfo(2, i), FontID(Bold)) 
    
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
      SetGadgetColor(LabelSongInfo(0, i), #PB_Gadget_BackColor, SystemBackgroundColor)
      SetGadgetColor(LabelSongInfo(1, i), #PB_Gadget_BackColor, SystemBackgroundColor)
      SetGadgetColor(LabelSongInfo(2, i), #PB_Gadget_BackColor, SystemBackgroundColor)      
    CompilerElse
      If Preferences\WindowsTheme = "Fancy dark" 
        SetGadgetColor(LabelSongInfo(0, i), #PB_Gadget_BackColor, RGB(36, 36, 36))       
        SetGadgetColor(LabelSongInfo(1, i), #PB_Gadget_BackColor, RGB(36, 36, 36))        
        SetGadgetColor(LabelSongInfo(2, i), #PB_Gadget_BackColor, RGB(36, 36, 36))   
      Else 
        SetGadgetColor(LabelSongInfo(0, i), #PB_Gadget_BackColor, SystemBackgroundColor)   
        SetGadgetColor(LabelSongInfo(1, i), #PB_Gadget_BackColor, SystemBackgroundColor)         
        SetGadgetColor(LabelSongInfo(2, i), #PB_Gadget_BackColor, SystemBackgroundColor)            
      EndIf      
    CompilerEndIf
    
    HideGadget(ImageFlag(i), #True)  
    Y + 120
  Next 
  
  ;Close scrollarea gadget #ScrollareaSongInfo
  CloseGadgetList()   
 
  ;Close container gadget #ContainerSongInfo
  CloseGadgetList()    
  
  ;Create spectrum canvas
  CanvasGadget(#CanvasSpectrum, WindowWidth(#WindowMain) - 130, WindowHeight(#WindowMain) - 140, 100, 100)
  HideGadget(#CanvasSpectrum, #True)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
    SetGadgetColor(#CanvasSpectrum, #PB_Gadget_BackColor, SystemBackgroundColor)
  CompilerElse
    If Preferences\WindowsTheme = "Fancy dark" 
      SetGadgetColor(#CanvasSpectrum, #PB_Gadget_BackColor, RGB(36, 36, 36))   
    Else 
      SetGadgetColor(#CanvasSpectrum, #PB_Gadget_BackColor, SystemBackgroundColor)    
    EndIf      
  CompilerEndIf  
   
  ;Close container gadget #C1
  CloseGadgetList()
  
  ;Create gadget bindings
  BindGadgetEvent(#Trackbar, @Trackbar())  
  BindGadgetEvent(#TrackbarVolume, @TrackbarVolume()) 
  BindGadgetEvent(#ButtonCreateRandomPlaylist1, @ButtonCreateRandomPlaylist())   
  BindGadgetEvent(#ButtonCreateCustomPlaylist1, @ButtonCreateCustomPlaylist())   
  BindGadgetEvent(#ButtonLoadPlaylist1, @ButtonLoadPlaylist())   
  BindGadgetEvent(#ButtonSavePlaylist1, @ButtonSavePlaylist())   
  BindGadgetEvent(#ButtonExportMP3, @ButtonExportToAudioFile())    
  BindGadgetEvent(#ButtonExportTXT, @ButtonExportToTextFile())    
  BindGadgetEvent(#ButtonAlternativeSong, @ButtonAlternativeSong())      
EndProcedure

 
Procedure CreatePanelItemFiles()
  Protected.s BPM    
  
  ContainerGadget(#C3, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux      
    SetGadgetColor(#C3, #PB_Gadget_BackColor, SystemBackgroundColor)  
  CompilerEndIf
  
  ButtonGadget(#ButtonAddFolder, 15, 10, 110, 30, "Add folder")
  SetGadgetFont(#ButtonAddFolder, FontID(#Font)) 
  
  ButtonGadget(#ButtonClearList, 135, 10, 110, 30, "Clear list")
  SetGadgetFont(#ButtonClearList, FontID(#Font)) 
    
  ListIconGadget(#ListiconMusicLibrary, 10, 50, WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 165, "Added", 60, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  ListIconGadget(#ListiconMusicLibrarySearch, 10, 50, WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 165, "Added", 60, #PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
  
  AddGadgetColumn(#ListiconMusicLibrary, 1, "BPM", 60)    
  AddGadgetColumn(#ListiconMusicLibrarySearch, 1, "BPM", 60)    

  AddGadgetColumn(#ListiconMusicLibrary, 2, "File", (GadgetWidth(#ListiconMusicLibrary) - 120) / 2)  
  AddGadgetColumn(#ListiconMusicLibrarySearch, 2, "File", (GadgetWidth(#ListiconMusicLibrary) - 120) / 2)    
  
  AddGadgetColumn(#ListiconMusicLibrary, 3, "Folder", (GadgetWidth(#ListiconMusicLibrary) - 120) / 2)   
  AddGadgetColumn(#ListiconMusicLibrarySearch, 3, "Folder", (GadgetWidth(#ListiconMusicLibrary) - 120) / 2)   
  
  SetGadgetFont(#ListiconMusicLibrary, FontID(#Font))   
  SetGadgetFont(#ListiconMusicLibrarySearch, FontID(#Font))   
  
  HideGadget(#ListiconMusicLibrarySearch, #True)
  Visible\ListiconMusicLibrarySearch = #False
    
  ButtonGadget(#ButtonRemoveFile, 15,  WindowHeight(#WindowMain) - 105, 130, 30, "Delete from list") 
  SetGadgetFont(#ButtonRemoveFile, FontID(#Font))     
  
  ComboBoxGadget(#ComboboxSortFiles, 155,  WindowHeight(#WindowMain) - 105, 110, 30) 
  AddGadgetItem(#ComboboxSortFiles, 0, "Sort")    
  AddGadgetItem(#ComboboxSortFiles, 1, "Added")    
  AddGadgetItem(#ComboboxSortFiles, 2, "BPM")  
  AddGadgetItem(#ComboboxSortFiles, 3, "File")
  AddGadgetItem(#ComboboxSortFiles, 4, "Folder")   
  SetGadgetText(#ComboboxSortFiles, "Sort")  
  SetGadgetFont(#ComboboxSortFiles, FontID(#Font))     
  
  ButtonGadget(#ButtonAddFiletoDatabase, 275,  WindowHeight(#WindowMain) - 105, 130, 30, "Add to database")   
  SetGadgetFont(#ButtonAddFiletoDatabase, FontID(#Font))     
  
  StringGadget(#StringSearchFiles, 415, WindowHeight(#WindowMain) - 105, WindowWidth(#WindowMain) - 425, 30, "Search...")   
  SetGadgetFont(#StringSearchFiles, FontID(#Font))     
  
  CustomButton(#ButtonPlayFile, 15, WindowHeight(#WindowMain) - 65, 14, 14, ?playblack, ?playwhite, "Play", 30, 30)  
  CustomButton(#ButtonStopMusicLibrarySong,  55, WindowHeight(#WindowMain) - 65, 16, 16, ?stopblack, ?stopwhite, "Stop", 30, 30)
    
  TrackBarGadget(#TrackbarMusicLibrary, 115, WindowHeight(#WindowMain) - 60, WindowWidth(#WindowMain) - 145, 30, 0, 0)  
  DisableGadget(#TrackbarMusicLibrary, #False)
  
  ;Close container gadget #C3  
  CloseGadgetList()   
 
  BindGadgetEvent(#ButtonAddFolder, @ButtonAddFolder())    
  BindGadgetEvent(#ButtonRemoveFile, @ButtonRemoveFile())     
  BindGadgetEvent(#ComboboxSortFiles, @ComboboxOrderFiles())     
  BindGadgetEvent(#ButtonAddFiletoDatabase, @ButtonAddFileToDatabase())     
  BindGadgetEvent(#ButtonPlayFile, @ButtonPlayFile())     
  BindGadgetEvent(#ButtonStopMusicLibrarySong, @ButtonStopMusicLibrarySong())     
  BindGadgetEvent(#TrackbarMusicLibrary, @TrackbarMusicLibrary())    
  BindGadgetEvent(#ListiconMusicLibrary, @ButtonStopMusicLibrarySong())  
  BindGadgetEvent(#ListiconMusicLibrarySearch, @ButtonStopMusicLibrarySong())    
  BindGadgetEvent(#ButtonClearList, @ButtonClearlist())  
  
  ;Fill the listicon with files and bpm's
  DatabaseQuery(#DBFiles, "SELECT id, bpm, file, folder, added FROM files ORDER BY id")  
  While NextDatabaseRow(#DBFiles)
    BPM = GetDatabaseString(#DBFiles, 1)
    If BPM <> ""
      BPM = RSet(FormatNumber(ValF(BPM)), 6, "0")
    EndIf
    
    AddGadgetItem(#ListiconMusicLibrary, -1, GetDatabaseString(#DBFiles, 4) + Chr(10)+ BPM + Chr(10) + 
                                             GetDatabaseString(#DBFiles, 2) + Chr(10) + 
                                             GetDatabaseString(#DBFiles, 3))      
  Wend
  FinishDatabaseQuery(#DBFiles)     
EndProcedure

Procedure CreatePanelItemDatabase()
  ContainerGadget(#C2, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux      
    SetGadgetColor(#C2, #PB_Gadget_BackColor, SystemBackgroundColor)
  CompilerEndIf
  
  TextGadget(#LabelTotalRecords, WindowWidth(#WindowMain) - 240, 15, 230, 30, "0 Records", #PB_Text_Right) 
  SetGadgetFont(#LabelTotalRecords, FontID(#Font))     
 
  ListIconGadget(#ListiconDatabase, 10, 50,  WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 165, "ID", 6, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
  ListIconGadget(#ListiconDatabaseSearch, 10, 50,  WindowWidth(#WindowMain) - 20, WindowHeight(#WindowMain) - 165, "ID", 0, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect | #PB_ListIcon_AlwaysShowSelection)
 
  If GadgetWidth(#ListiconDatabase) > 1220
    AddGadgetColumn(#ListiconDatabase, 1, "Song", GadgetWidth(#ListiconDatabase) - 990)
    AddGadgetColumn(#ListiconDatabaseSearch, 1, "Song", GadgetWidth(#ListiconDatabaseSearch) - 990)    
  Else
    AddGadgetColumn(#ListiconDatabase, 1, "Song", 350)    
    AddGadgetColumn(#ListiconDatabaseSearch, 1, "Song", 350)        
  EndIf
   
  AddGadgetColumn(#ListiconDatabase, 2, "Label", 200)
  AddGadgetColumn(#ListiconDatabaseSearch, 2, "Label", 200)
  
  AddGadgetColumn(#ListiconDatabase, 3, "Cat.no.", 100)
  AddGadgetColumn(#ListiconDatabaseSearch, 3, "Cat.no.", 100)
  
  AddGadgetColumn(#ListiconDatabase, 4, "Country", 100)
  AddGadgetColumn(#ListiconDatabaseSearch, 4, "Country", 100)
  
  AddGadgetColumn(#ListiconDatabase, 5, "Year", 60)
  AddGadgetColumn(#ListiconDatabaseSearch, 5, "Year", 60)
  
  AddGadgetColumn(#ListiconDatabase, 6, "Genre", 250)
  AddGadgetColumn(#ListiconDatabaseSearch, 6, "Genre", 250)
  
  AddGadgetColumn(#ListiconDatabase, 7, "BPM", 60)
  AddGadgetColumn(#ListiconDatabaseSearch, 7, "BPM", 60)
  
  SetGadgetFont(#ListiconDatabase, FontID(#Font))     
  SetGadgetFont(#ListiconDatabaseSearch, FontID(#Font))     
  
  HideGadget(#listIconDatabaseSearch, #True) 
  Visible\ListiconDatabaseSearch = #False
   
  ButtonGadget(#ButtonAddRecord, 10, 10, 100, 30, "Add record")  
  SetGadgetFont(#ButtonAddRecord, FontID(#Font))     
  
  ButtonGadget(#ButtonEditRecord, 10, WindowHeight(#WindowMain) - 110, 80, 30, "Edit")    
  SetGadgetFont(#ButtonEditRecord, FontID(#Font))     
  
  ButtonGadget(#ButtonDeleteRecord, 100, WindowHeight(#WindowMain) - 110, 80, 30, "Delete")
  SetGadgetFont(#ButtonDeleteRecord, FontID(#Font))     
  
  ComboBoxGadget(#ComboboxSortDatabase, 190, WindowHeight(#WindowMain) - 110, 100, 30)
  AddGadgetItem(#ComboboxSortDatabase, -1, "Sort")  
  AddGadgetItem(#ComboboxSortDatabase, -1, "Artist")
  AddGadgetItem(#ComboboxSortDatabase, -1, "Title")
  AddGadgetItem(#ComboboxSortDatabase, -1, "Label")
  AddGadgetItem(#ComboboxSortDatabase, -1, "Cat.no.")
  AddGadgetItem(#ComboboxSortDatabase, -1, "Country")
  AddGadgetItem(#ComboboxSortDatabase, -1, "Year")
  AddGadgetItem(#ComboboxSortDatabase, -1, "Genre")
  AddGadgetItem(#ComboboxSortDatabase, -1, "BPM")
  SetGadgetText(#ComboboxSortDatabase, "Sort")
  SetGadgetFont(#ComboboxSortDatabase, FontID(#Font))     
  
  StringGadget(#StringSearchDatabase, 300, WindowHeight(#WindowMain) - 110, WindowWidth(#WindowMain) - 310, 30, "Search...")
  SetGadgetFont(#StringSearchDatabase, FontID(#Font))     
    
  CustomButton(#ButtonPlayDatabaseSong, 15, WindowHeight(#WindowMain) - 70, 14, 14, ?playblack,?playwhite, "Play", 30, 30)  
  CustomButton(#ButtonStopDatabaseSong,  55, WindowHeight(#WindowMain) - 70, 16, 16, ?stopblack,?stopwhite, "Stop", 30, 30)  
   
  TrackBarGadget(#TrackbarDatabase, 115, WindowHeight(#WindowMain) - 65, WindowWidth(#WindowMain) - 145, 30, 0, 0)  
  DisableGadget(#TrackbarDatabase, #True)
  
  ;Close container gadget #C2
  CloseGadgetList()  
  
  ;BindGadgetEvent(#ListiconDatabase, @ButtonStopDatabaseSong())
  BindGadgetEvent(#ButtonAddRecord, @ButtonAddRecord())
  BindGadgetEvent(#ButtonDeleteRecord, @ButtonDeleteRecord())
  BindGadgetEvent(#ButtonEditRecord, @ButtonEditRecord())
  BindGadgetEvent(#ComboboxSortDatabase, @ComboboxSortDatabase())
  BindGadgetEvent(#ButtonPlayDatabaseSong, @ButtonPlayDatabaseSong())
  BindGadgetEvent(#ButtonStopDatabaseSong, @ButtonStopDatabaseSong())  
  BindGadgetEvent(#TrackbarDatabase, @TrackbarDatabase())   
  BindGadgetEvent(#ListiconDatabase, @ButtonStopDatabaseSong())  
  BindGadgetEvent(#ListiconDatabaseSearch, @ButtonStopDatabaseSong())  
  
  FillListiconDatabase()
  
  PreferencesFile()
  PreferenceGroup("Database")
  SelectRow(#ListiconDatabase, ReadPreferenceInteger("Row", 0))
  ClosePreferences()    
EndProcedure  

Procedure CreatePanelItemSettings() 
  Protected.i Bold = LoadFont(#PB_Any, "Bebas-Regular", 10, #PB_Font_Bold)    
  Protected.i Y = 20, OptionHeight = 45, FrameMarginBottom = 30, Frame = 100, DummyHeight = 80
  Protected.i Label, Gadget, Choice, Choices, FrameHeight, Sections, ScrollAreaHeight, ListviewGadgets, OtherGadgets 
  Protected.i ValueItems, V, ListviewItem, ListviewItems, Needle, Button    
  Protected.s Value, ValueItem, Key, Group  
  Protected.b Added, DatabaseEmpty = #False
 
  ContainerGadget(#C4, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain))
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
    SetGadgetColor(#C4, #PB_Gadget_BackColor, SystemBackgroundColor)    
  CompilerEndIf   
  
  
  ;***************************
  ;Create gadgets for settings
  ;***************************
  
  ;Create buttons
  ButtonGadget(#ButtonDefaultSettings,  10, 10, 100, 30, "Default")
  SetGadgetFont(#ButtonDefaultSettings, FontID(#Font))    
    
  ;Create bindings for buttons
  BindGadgetEvent(#ButtonDefaultSettings, @ButtonDefaultSettings())          
   
  ;Calculate height of the scrollarea
  ForEach SettingsPanel()
    If SettingsPanel()\Section <> "" 
      Sections + 1
    EndIf
    
    If SettingsPanel()\Gadget = #SettingListview
      ListviewGadgets + 1
    Else
      OtherGadgets + 1
    EndIf
  Next
  
  ;Calculate height of the scrollarea 
  ;note: change the value of DummyHeight if the scrollarea doesn't fit
  ScrollAreaHeight = DummyHeight + 
                     ((OptionHeight * OtherGadgets) + 
                      (135 * ListviewGadgets)) + 
                     (Sections * FrameMarginBottom) 
  
  ;Create scrollarea
  ScrollAreaGadget(#ScrollArea, 0, 50, 
                   WindowWidth(#WindowMain), 
                   WindowHeight(#WindowMain) - 50, 
                   WindowWidth(#WindowMain) - 22, 
                   ScrollAreaHeight)
   
  
  ;Walkthrough Settings() and build gadgets
  ForEach SettingsPanel()
    ;Build new frame if a new section is found
    If SettingsPanel()\Section <> ""  
      Frame + 1  
      FrameHeight = 60  
      
      ;Increasy Y to create vertical space below the frame
      If Y > 20 
        Y + FrameMarginBottom
      EndIf
      
      ;Create the frame with the height of one option
      FrameGadget(Frame, 10, Y - 10,  WindowWidth(#WindowMain) - 40, FrameHeight, SettingsPanel()\Section)     
      SetGadgetFont(Frame, FontID(Bold))
      
      ;Increase Y to create vertical space between frame border and the first option
      Y + 10
    EndIf      
 
    Gadget = 51 + ListIndex(SettingsPanel()) ;51 is added to prevent conflicts with other gadgets
  
    TextGadget(Gadget + 400, 20, Y + 5, 230, 30, SettingsPanel()\Description, #PB_Text_Right)   
    SetGadgetFont(Gadget + 400, FontID(#Font)) 

    Select SettingsPanel()\Gadget      
      Case #SettingPathRequester            
        StringGadget(Gadget, 260, Y, WindowWidth(#WindowMain) - 340, 30, SettingsPanel()\DefaultValue,  #PB_String_ReadOnly)
        SetGadgetFont(Gadget, FontID(#Font))    
    
        If Gadget = 51
          CustomButton(#ButtonOpenFolderAudio, WindowWidth(#WindowMain) - 70, Y, 16, 16, ?openblack, ?openwhite, "Choose folder", 30, 30)   
          BindGadgetEvent(#ButtonOpenFolderAudio, @ButtonOpenFolderAudio())                   
        Else
          CustomButton(#ButtonOpenFolderSleeves, WindowWidth(#WindowMain) - 70, Y, 16, 16, ?openblack, ?openwhite, "Choose folder", 30, 30)      
          BindGadgetEvent(#ButtonOpenFolderSleeves, @ButtonOpenFolderSleeves())       
        EndIf
                
        ;Increase Y for position of the next option
        Y + OptionHeight        
      Case #SettingListview
        ListViewGadget(Gadget, 260, Y, WindowWidth(#WindowMain) - 300, 120, #PB_ListView_MultiSelect)  
        SetGadgetFont(Gadget, FontID(#Font))    
       
        Choices = 1 + CountString(SettingsPanel()\Options, ",")   
        For Choice = 1 To Choices    
          Added = #True
          If SettingsPanel()\Description = "Years" And StringField(SettingsPanel()\Options, Choice, ",") = "0"
            ;Do not allow 0 in the listview with years            
            Added = #False
          EndIf
          
          If Added
            AddGadgetItem(Gadget, -1, StringField(SettingsPanel()\Options, Choice, ","))
          EndIf
        Next     
        
        Select SettingsPanel()\Description
          Case "Years"
            Button = #ButtonResetYears
          Case "Countries"
            Button = #ButtonResetCountries            
          Case "Artists"
            Button = #ButtonResetArtists             
          Case "Genres"
            Button = #ButtonResetGenres           
          Case "Record labels"
            Button = #ButtonResetLabels  
        EndSelect

        ButtonGadget(Button, 120, Y + 70, 120, 30, "Deselect all")
        SetGadgetFont(Button, FontID(#Font))          
        
        ;Increase Y for position of the next option
        Y + 135           
        
        ;Create binding to track selected items
        BindGadgetEvent(Gadget, @ListviewSettings())          
      Case #SettingCombobox  
        ComboBoxGadget(Gadget, 260, Y, WindowWidth(#WindowMain) - 300, 30)
        SetGadgetFont(Gadget, FontID(#Font))         
        
        If SettingsPanel()\Description = "Color" 
          BindGadgetEvent(Gadget, @ChangeWindowsTheme())                 
        EndIf
                 
        Choices = 1 + CountString(SettingsPanel()\Options, ",")   
        For Choice = 1 To Choices        
          AddGadgetItem(Gadget, -1, StringField(SettingsPanel()\Options, Choice, ","))
        Next           

        SetGadgetText(Gadget, SettingsPanel()\DefaultValue)       
       
        ;Increase Y for position of the next option
        Y + OptionHeight              
    EndSelect   
 
    ;Create info tooltip for each option 
    GadgetToolTip(Gadget, SettingsPanel()\Tooltip)
 
    ;Increase the height of the frame
    ResizeGadget(Frame, 10, #PB_Ignore, #PB_Ignore, FrameHeight)            
        
    ;Increase FrameHeight with the vertical size of one option
    If SettingsPanel()\Gadget = #SettingListview
      FrameHeight + 160
    Else      
      FrameHeight + OptionHeight 
    EndIf
  Next
  
  ;Close scrollAreaGadget
  CloseGadgetList() 
  
  ;Close container gadget #C4
  CloseGadgetList() 
 
  ;Load playlist settings if available
  If OpenPreferences(OSPath("assets/data/mixperfect.ini"))  
    Gadget = 51
    
    ;Walkthrough SettingsPanel()
    ForEach SettingsPanel()  
      
      If SettingsPanel()\Section <> ""
        If Left(SettingsPanel()\Section, 6) = "Filter"
          Group = "Filter"
        ElseIf SettingsPanel()\Section = "Directories"
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            Group = "Directories Linux"
          CompilerElse
            Group = "Directories Windows"
          CompilerEndIf        
        ElseIf SettingsPanel()\Section = "Session"
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            Group = "Session Linux"
          CompilerElse
            Group = "Session Windows"
          CompilerEndIf              
        Else
          Group = SettingsPanel()\Section
        EndIf
      EndIf
      
      PreferenceGroup(Group)
      
      ;Read preference-key and preference-value
      Key = ReplaceString(SettingsPanel()\Description, " ", "_")
      Value = ReadPreferenceString(Key, SettingsPanel()\DefaultValue)      
      ValueItems = 0
      
      If SettingsPanel()\Gadget <> #SettingListview
        ;Set the playlist setting
        If Gadget < 53
          Value = AbsoluteDir(Value)
        EndIf 
        SetGadgetText(Gadget, Value)
      Else   
        ;Get and set the saved selected listview items       
        If Trim(Value) <> ""
          ValueItems = CountString(Value, "|") + 1
          
          ;Use a needle to prevent repeated searching from beginning of listview
          Needle = 1
          
          ;Walkthrough the saved selected listview items
          For V = 1 To ValueItems  
            ValueItem = StringField(Value, V, "|")       
            ListviewItems = CountGadgetItems(Gadget)
            
            ;Walkthrough the listview to find the saved selected listview item
            For ListviewItem = Needle To ListviewItems
              ;Select the found item in the listview
              If GetGadgetItemText(Gadget, ListviewItem - 1) = ValueItem                
                SetGadgetItemState(Gadget, ListviewItem - 1, 1)
                Break
              EndIf
            Next            
            Needle = ListviewItem - 1 
          Next
        EndIf
        SetGadgetText(Gadget + 400, SettingsPanel()\Description + Chr(13) + "(" + Str(ValueItems) + " items selected)")
      EndIf

      Gadget + 1
    Next
    ClosePreferences()
  EndIf    
  
  BindGadgetEvent(GadgetNumber\MinSongs , @CheckSettingMinMaxSongs())    
  BindGadgetEvent(GadgetNumber\MaxSongs, @CheckSettingMinMaxSongs())    
  BindGadgetEvent(GadgetNumber\MinPlaybackTime, @CheckSettingMinMaxPlaybackTime())    
  BindGadgetEvent(GadgetNumber\MinPlaybackTime, @CheckSettingMinMaxPlaybackTime())    
  BindGadgetEvent(#ButtonResetArtists, @ButtonResetArtists())
  BindGadgetEvent(#ButtonResetLabels, @ButtonResetLabels())
  BindGadgetEvent(#ButtonResetGenres, @ButtonResetGenres())
  BindGadgetEvent(#ButtonResetCountries, @ButtonResetCountries())
  BindGadgetEvent(#ButtonResetYears, @ButtonResetYears())  
EndProcedure

Procedure CreatePanelItemHelp()
  Protected.i DocFont = LoadFont(#PB_Any, "Bebas-Regular", 12)     

  ContainerGadget(#C5, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain) - 20)
  SetGadgetColor(#C5, #PB_Gadget_BackColor, RGB(245, 245, 245))   
  
  HyperLinkGadget(#HyperlinkAbout, 10, 10, 50, 30, "About", #Blue)  
  SetGadgetFont(#HyperlinkAbout, FontID(#Font))        
  BindGadgetEvent(#HyperlinkAbout, @HyperlinkAbout())   
  
  HyperLinkGadget(#HyperlinkPlayer, 100, 10, 50, 30, "Player", #Blue)  
  SetGadgetFont(#HyperlinkPlayer, FontID(#Font))      
  BindGadgetEvent(#HyperlinkPlayer, @HyperlinkPlayer())        
  
  HyperLinkGadget(#HyperlinkDatabase, 190, 10, 100, 30, "Database", #Blue)  
  SetGadgetFont(#HyperlinkDatabase, FontID(#Font))      
  BindGadgetEvent(#HyperlinkDatabase, @HyperlinkDatabase())    
  
  HyperLinkGadget(#HyperlinkFiles, 310, 10, 50, 30, "Files", #Blue)
  SetGadgetFont(#HyperlinkFiles, FontID(#Font))      
  BindGadgetEvent(#HyperlinkFiles, @HyperlinkFiles())     
  
  HyperLinkGadget(#HyperlinkSettings, 380, 10, 100, 30, "Settings", #Blue)
  SetGadgetFont(#HyperlinkSettings, FontID(#Font))      
  BindGadgetEvent(#HyperlinkSettings, @HyperlinkSettings())     
  
  HyperLinkGadget(#HyperlinkUpgrade, 480, 10, 100, 30, "Upgrade", #Blue)
  SetGadgetFont(#HyperlinkUpgrade, FontID(#Font))      
  BindGadgetEvent(#HyperlinkUpgrade, @HyperlinkUpgrade())   
  
  ContainerGadget(#EditorContainer, 20, 50, WindowWidth(#WindowMain) - 40, WindowHeight(#WindowMain) - 100) 
  EditorGadget(#EditorHelp, -2, -2, WindowWidth(#WindowMain) - 36, WindowHeight(#WindowMain) - 96, #PB_Editor_ReadOnly|#PB_Editor_WordWrap) 
  AddGadgetItem(#EditorHelp, -1, "")    
  SetGadgetFont(#EditorHelp, FontID(DocFont))   
  SetGadgetColor(#EditorHelp, #PB_Gadget_BackColor, RGB(245, 245, 245))
  SetGadgetColor(#EditorHelp, #PB_Gadget_FrontColor, RGB(51, 51, 51))
  
  CloseGadgetList() ;Close container gadget #EditorContainer
   
  CloseGadgetList() ;Close container gadget #C5   
  
  HyperlinkAbout()  
EndProcedure  

Procedure CreatePanelItemUpgrade()  
  ContainerGadget(#C6, 0, 0, WindowWidth(#WindowMain), WindowHeight(#WindowMain) - 20)
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
    SetGadgetColor(#C6, #PB_Gadget_BackColor, SystemBackgroundColor)    
  CompilerEndIf     
  
  TextGadget(#CurrentVersion, 10, 30, 400, 30, "Current version: " + #Version)
  SetGadgetFont(#CurrentVersion, FontID(#Font))      
  
  TextGadget(#VersionCheck, 10, 70, 400, 30, "Checking for updates, please wait...")
  SetGadgetFont(#VersionCheck, FontID(#Font))      
  
  ButtonGadget(#ButtonUpgrade, 10, 110, 190, 30, "")
  SetGadgetFont(#ButtonUpgrade, FontID(#Font)) 
  HideGadget(#ButtonUpgrade, #True)
  
  TextGadget(#DownloadProgress, 10, 170, 400, 30, "")
  SetGadgetFont(#DownloadProgress, FontID(#Font)) 
  
  ButtonGadget(#ButtonCancelDownload, 10, 230, 190, 30, "Cancel")
  SetGadgetFont(#ButtonCancelDownload, FontID(#Font)) 
  HideGadget(#ButtonCancelDownload, #True)
  
  CloseGadgetList()
EndProcedure  
  
;----------------------------------- Panel help events

Procedure HyperlinkAbout()
  SetHyperlinkFonts(#HyperlinkAbout)  
  Restore HelpAbout 
  SetGadgetText(#EditorHelp, RestoredData())  
EndProcedure

Procedure HyperlinkSettings()
  SetHyperlinkFonts(#HyperlinkSettings)
  Restore HelpSettings 
  SetGadgetText(#EditorHelp, RestoredData())
EndProcedure 

Procedure HyperlinkPlayer()   
  SetHyperlinkFonts(#HyperlinkPlayer)
  Restore HelpPlayer  
  SetGadgetText(#EditorHelp, RestoredData())  
EndProcedure 

Procedure HyperlinkDatabase()    
  SetHyperlinkFonts(#HyperlinkDatabase)      
  Restore HelpDatabase   
  SetGadgetText(#EditorHelp, RestoredData()) 
EndProcedure 

Procedure HyperlinkFiles()     
  SetHyperlinkFonts(#HyperlinkFiles)   
  Restore HelpFiles
  SetGadgetText(#EditorHelp, RestoredData())  
EndProcedure 

Procedure HyperlinkUpgrade()     
  SetHyperlinkFonts(#HyperlinkUpgrade)   
  Restore HelpUpgrade
  SetGadgetText(#EditorHelp, RestoredData())  
EndProcedure 

;------------------------------------ Panel player events
 
Procedure ButtonAlternativeSong()
  Protected.i Index, SongType, FileSamplerate
  Protected.i Row = GetGadgetState(#ListiconPlaylist)
  Protected.s IDs, FilterQuery, PlaylistString, Year 
  Protected.f lowBPM, highBPM, OriginalBPM
  Protected.f IntroPrefix, IntroStart, IntroEnd, IntroLoopstart, IntroLoopEnd, IntroLoopRepeat  
  Protected.f BreakStart, BreakEnd, BreakLoopstart, BreakLoopEnd, BreakLoopRepeat, Breakcontinue
  Protected.f SkipStart, SkipEnd, PlayLength   
  Protected.f DBLowestBPM = DBLowestBPM(), DBHighestBPM = DBHighestBPM()
  
  If Row = 0 
    MessageRequester("Action not allowd", "The first song can't be replaced", #PB_MessageRequester_Warning)    
    ProcedureReturn
  EndIf    
  
  ButtonStop(#PB_EventType_LeftClick)
  LoadPreferences()
        
  Index = ListIndex(Songs())
  
  SelectElement(Songs(), Mix(CurrentSong)\Number - 1) 
  PreviousElement(Songs()) 
  
  OriginalBPM = Songs()\PlaybackBPM   
  lowBPM = OriginalBPM - Preferences\MaximumBPMdistance
  highBPM = OriginalBPM + Preferences\MaximumBPMdistance
   
  NextElement(Songs())
   
  IDs = ""
  ForEach Songs()
    IDs + Songs()\ID + ","
  Next            
  IDs = RTrim(IDS, ",")
             
  FilterQuery = GenerateFilterQuery()   
  If FilterQuery <> ""
    FilterQuery = " AND " + FilterQuery
    FilterQuery = RemoveString(FilterQuery, "AND", #PB_String_NoCase, Len(FilterQuery) - 4)
  EndIf
  
  If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite" 
    Year = "year='" + Mix(CurrentSong)\Year + "' AND "
  EndIf
   
  DatabaseQuery(#DBMusic, "SELECT id, bpm, filename, introprefix, introstart, introend, introloopstart, introloopend, introlooprepeat, " + 
                          "breakstart, breakend, breakloopstart, breakloopend, breaklooprepeat, breakcontinue, skipstart, skipend, " +
                          "breakbass, breakvocal, breakmelody, breakbeats, samplerate FROM music WHERE " + Year + "bpm BETWEEN " + StrF(lowBPM)  + " AND " + StrF(highBPM) + " AND id NOT IN (" + IDs + ") " + FilterQuery + " ORDER BY RANDOM() LIMIT 1") 
  NextDatabaseRow(#DBMusic)    
   
  If GetDatabaseString(#DBMusic, 0) = ""
    MessageRequester("No alternative song found", "This song can not be replaced", #PB_MessageRequester_Warning)    
    SelectElement(Songs(), Index)
    ProcedureReturn
  EndIf   
  
  SelectElement(Songs(), Mix(CurrentSong)\Number - 1)
    
  IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 3))   
  IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 4))   
  IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 5))      
  IntroLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 6))
  IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 7))    
  IntroLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 8))  
  BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 9))  
  BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 10))  
  BreakLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 11))  
  BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 12))  
  BreakLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 13))  
  BreakContinue = Time2Seconds(GetDatabaseString(#DBMusic, 14))    
  SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 15))   
  SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 16))   
  FileSamplerate = GetDatabaseLong(#DBMusic, 21)
  
  If Row = 0
    SongType = #FirstSong
  Else
    Songtype = #InBetweenSong
  EndIf

  PlayLength = PlayLength(SongType, IntroPrefix, IntroStart, Introend, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat, BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat, BreakContinue)            
  
  If Preferences\ShortenSongs = "Always" Or (Preferences\ShortenSongs = "Random" And Random(1))
    PlayLength - (SkipEnd - SkipStart)
    Songs()\Shorten = #True
  Else
    Songs()\Shorten = #False
  EndIf         
  
  Songs()\Pitch = ""
  If Abs(GetDatabaseFloat(#DBMusic, 1) - OriginalBPM) <= Preferences\PitchRange
    OriginalBPM = GetDatabaseFloat(#DBMusic, 1)  
    Songs()\Pitch = "  0.00%" 
  EndIf           
    
  Songs()\ID = GetDatabaseString(#DBMusic, 0) 
  Songs()\Playtime = PlayLength 
  
  ;Bug fix --------------------------------
  Songs()\IntroPrefix = IntroPrefix  
  Songs()\IntroStart = IntroStart  
  Songs()\IntroEnd = IntroEnd
  Songs()\IntroLoopstart = IntroLoopstart
  Songs()\IntroLoopEnd = IntroLoopEnd    
  Songs()\IntroLoopRepeat = IntroLoopRepeat
  Songs()\BreakStart = BreakStart
  Songs()\BreakEnd = BreakEnd 
  Songs()\BreakLoopstart = BreakLoopstart
  Songs()\BreakLoopEnd = BreakLoopEnd
  Songs()\BreakLoopRepeat = BreakLoopRepeat
  Songs()\BreakContinue = BreakContinue   
  Songs()\SkipStart = SkipStart
  Songs()\SkipEnd = SkipEnd
  Songs()\Samplerate = FileSamplerate
  ;-----------------------------------------
  
  PlaylistString = GeneratePlaylistIDsString()
  FillListiconPlaylist(PlaylistString)

  SelectRow(#ListiconPlaylist, Row)
  ListiconPlaylist(#PB_EventType_Change)   
                
  ;Save the playlist to preferences file
  If PreferencesFile()          
    PreferenceGroup("Session")      
    WritePreferenceString("Type", Preferences\PlaylistType)                
    WritePreferenceString("IDs", PlaylistString)           
    ClosePreferences()
  EndIf              
EndProcedure

Procedure ButtonSavePlaylist()
  Protected.s File
  Protected.b Save, TryAgain = #True
  Protected.s StandardFile = OSPath("playlists/playlist.mix")  
  Protected.s Pattern = "Mix playlist (*.mix)|*.mix"   
  Protected.i Index
  
  If CountGadgetItems(#ListiconPlaylist) = 0
    MessageRequester("Action not allowed", "An empty playlist can't be saved.")
    ProcedureReturn
  EndIf  
  
  While TryAgain
    Save = #False
    
    If FileSize("playlists") <> -2  
      CreateDirectory("playlists")
    EndIf  
      
    File = OSPath(SaveFileRequester("Save playlist as...", StandardFile, Pattern, 0))
    
    If File
      If GetExtensionPart(File) = ""
        File + ".mix" 
      EndIf
      
      If LCase(GetExtensionPart(File)) <> "mix"
        MessageRequester("Playlist saving error", "Playlist file must have mix-extension.", #PB_MessageRequester_Error)
      ElseIf FileSize(File) <> -1
        Select MessageRequester("Save playlist warning", "File " + GetFilePart(File) + " already exists." + Chr(13) + Chr(13) + "Do you want to overwrite this file?", #PB_MessageRequester_Warning|#PB_MessageRequester_YesNoCancel)
          Case #PB_MessageRequester_Yes 
            TryAgain = #False
            Save = #True
          Case #PB_MessageRequester_Cancel 
            TryAgain = #False              
        EndSelect
      Else
        TryAgain = #False 
        Save = #True
      EndIf
        
      If Save
        Index = ListIndex(Songs())
        
        CreateFile(#File, File)
        WriteStringN(#File, GeneratePlaylistIDsString())
        WriteStringN(#File, "Type = " + Preferences\PlaylistType)     
        CloseFile(#File)
        
        SelectElement(Songs(), Index)         
      EndIf
    Else
      TryAgain = #False
    EndIf
  Wend
EndProcedure

Procedure ButtonLoadPlaylist() 
  Protected.s File, PlaylistString, PlaylistType
  Protected.b IsPlaylist
  Protected.s StandardFile = OSPath("playlists/playlist.mix")  
  Protected.s Pattern = "Mix playlist (*.mix)|*.mix|All files (*.*)|*.*" 
   
  If FileSize("playlists") <> -2  
    CreateDirectory("playlists")
  EndIf  
   
  File = OSPath(OpenFileRequester("Choose playlist file to load", StandardFile, Pattern, 0))
  
  If File
    ;Check if the choosen file is really a mixperfect-playlist
    If LCase(GetExtensionPart(File)) = "mix"  
      OpenFile(#File, File)

      If Not Eof(#File)
        PlaylistString = ReadString(#File)
        If Not Eof(#File) And FindString(PlaylistString, "|") And FindString(PlaylistString, ",") And FindString(StringField(PlaylistString, 1, ","), "R")
          PlaylistType = ReadString(#File)

          If (FindString(PlaylistType, "Type = Random") Or FindString(PlaylistType, "Type = Custom"))   
            IsPlaylist = #True   
          EndIf
        EndIf
      EndIf
      CloseFile(#File)
    EndIf
    
    If Not IsPlaylist
      MessageRequester("Playlist loading error", "File is not a " + #AppName + " playlist-file.", #PB_MessageRequester_Error)      
    Else 
      FillListiconPlaylist(PlaylistString)
     
      ;Save the playlist to preferences file
      If PreferencesFile()          
        PreferenceGroup("Session")      
        WritePreferenceString("Type", Right(PlaylistType, 6) ) 
        WritePreferenceString("IDs", PlaylistString)           
        ClosePreferences()
      EndIf 
      
      SetGadgetState(#Panel, 0)      
    EndIf
  EndIf
EndProcedure

Procedure.s ChangeFileExtension(FileName.s, NewExt.s)  
  Protected DotPos = FindString(FileName, ".", -1)  
  
  If DotPos > 0
    ProcedureReturn Left(FileName, DotPos - 1) + "." + NewExt
  Else
    ProcedureReturn FileName + "." + NewExt
  EndIf
EndProcedure

Procedure ButtonExportToAudioFile()
  Protected.s File, Extension, Options
  Protected.b Save, TryAgain = #True  
  Protected.s StandardFile = OSPath("exports/mix.mp3") 
  Protected.s Pattern = "MP3 files (*.mp3)|*.mp3|WAV files (*.wav)|*.wav|FLAC files (*.flac)|*.flac|OGG files (*.ogg)|*.ogg|OPUS files (*.opus)|*.opus"

  While TryAgain
    Save = #False  
    
    If FileSize("exports") <> -2  
      CreateDirectory("exports")
    EndIf  
  
    File = OSPath(SaveFileRequester("Save playlist as...", StandardFile, Pattern, 0))

    If File         
      Extension = LCase(GetExtensionPart(File))  
      If Extension <> "mp3" And Extension <> "wav" And Extension <> "ogg" And Extension <> "flac" And Extension <> "opus"       
        MessageRequester("Saving error", "Audiofile must have .mp3, .wav, .flac, .ogg, .opus extension.", #PB_MessageRequester_Error)
        TryAgain = #True
        Save = #False      
      ElseIf FileSize(File) <> -1
        If MessageRequester("Save playlist warning", "File " + GetFilePart(File) + " already exists." + Chr(13) + Chr(13) + "Do you want to overwrite this file?", #PB_MessageRequester_Warning|#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
          TryAgain = #False
          Save = #True
        Else
          TryAgain = #True 
          Save = #False
        EndIf
      Else
        TryAgain = #False 
        Save = #True
      EndIf
        
      If Save    
        RawFile = ""
        TryAgain = #False 
        TracklistPosition = GetGadgetState(#ListiconPlaylist)
        
        ButtonStop(#PB_EventType_LeftClick)
        DisableWindow(#WindowMain, #True)
        
        BASS_StreamFree(Chan\Mixer)
        Chan\Mixer = BASS_Mixer_StreamCreate(44100, 2, #BASS_STREAM_DECODE|#BASS_MIXER_END|#BASS_UNICODE|#BASS_SAMPLE_FLOAT) 
        
        Select Extension
          Case "wav"
            RawFile = ChangeFileExtension(File, "raw")
            BASS_Encode_Start(Chan\Mixer, @RawFile, #BASS_ENCODE_NOHEAD|#BASS_UNICODE|#BASS_ENCODE_PCM|$40000, #Null, #Null)            
          Case "mp3"
            BASS_Encode_MP3_StartFile(Chan\Mixer, "-b 320 -m s", #BASS_UNICODE|#BASS_ENCODE_PCM|$40000, @File)
          Case "ogg"          
            Options = "--quality=9"
            BASS_Encode_OGG_StartFile(Chan\Mixer, @Options, #BASS_UNICODE|#BASS_ENCODE_PCM|$40000, @File)            
          Case "flac"
            Options = "--best"
            BASS_Encode_FLAC_StartFile(Chan\Mixer, @Options, #BASS_UNICODE|#BASS_ENCODE_PCM|$40000, @File)            
          Case "opus"
             Options = "--bitrate 256"
            BASS_Encode_OPUS_StartFile(Chan\Mixer, @Options, #BASS_UNICODE|#BASS_ENCODE_PCM|$40000, @File)            
        EndSelect
        
        BASS_ChannelSetPosition(Chan\Mixer, 0, #BASS_POS_BYTE)     
        PrepareMix(0, #True)
        CreateWindowExportToAudioFile()     
        
        If RawFile = ""
          SetGadgetText(#LabelExport, "Exporting mix to " + GetFilePart(File) + " ...")
        Else
          SetGadgetText(#LabelExport, "Exporting mix to " + ChangeFileExtension(GetFilePart(RawFile), "wav") +  " ..." + Chr(13) + "Encoding ...")
        EndIf
         
        ;Enable decoding threath in main code
        Decoding = #True
      EndIf
    Else
      TryAgain = #False
    EndIf
  Wend    
EndProcedure

Procedure ButtonExportToTextFile()
  Protected.s File, Line, Line1, Line2, Line3, Time
  Protected.b Save, TryAgain = #True  
  Protected.i Item, Image, Flag
  Protected.s StandardFile = OSPath("exports/mix.txt") 
  Protected.s Pattern = "Text files (*.txt)|*.txt"
  
  NewList TempSongs.SongsStructure()
  
  While TryAgain
    Save = #False  
    
    If FileSize("exports") <> -2  
      CreateDirectory("exports")
    EndIf  
    
    File = OSPath(SaveFileRequester("Save playlist as...", StandardFile, Pattern, 0))
       
    If File 
      If GetExtensionPart(File) = "" 
        File + ".txt" 
      EndIf
      
      If LCase(GetExtensionPart(File)) <> "txt"
        MessageRequester("Saving error", "Text file must have txt-extension.", #PB_MessageRequester_Error)
      ElseIf FileSize(File) <> -1
        Select MessageRequester("Save playlist warning", "File " + GetFilePart(File) + " already exists." + Chr(13) + Chr(13) + "Do you want to overwrite this file?", #PB_MessageRequester_Warning|#PB_MessageRequester_YesNoCancel)
          Case #PB_MessageRequester_Yes 
            TryAgain = #False
            Save = #True
          Case #PB_MessageRequester_Cancel 
            TryAgain = #False              
        EndSelect
      Else
        TryAgain = #False 
        Save = #True
      EndIf
        
      If Save    
        ;Export the playlist to textfile
        If FileSize(File) <> -1
          DeleteFile(File)
        EndIf
         
        CreateFile(0, File)
        
        WriteStringN(0, "TRACKLIST:")
        WriteStringN(0, "")
        
        ;Copy the list to avoid confusing the current playing mix
        CopyList(Songs(), TempSongs())
        
        ForEach(TempSongs())
          Line = ""
          Line1 = ""
          Line2 = ""
          Line3 = ""
          
          If TempSongs()\Artist = "" Or TempSongs()\Title = ""
            Line1 = TempSongs()\AudioFilename     
          Else      
            Line1 = TempSongs()\Artist + " - " + TempSongs()\Title
            
            If Val(TempSongs()\Year) >= 1950 Or TempSongs()\Label <> ""
              If Val(TempSongs()\Year) >= 1950
                Line2 = TempSongs()\Year
                
                If TempSongs()\Label <> ""
                  Line2 + ", "
                EndIf
              EndIf
                
              If TempSongs()\Label <> ""
                Line2 + TempSongs()\Label
                
                If TempSongs()\CatNo <> ""
                  Line2 + " (" + TempSongs()\CatNo + ")"
                EndIf
              Else
                If TempSongs()\CatNo <> ""
                  Line2 + TempSongs()\CatNo
                EndIf          
              EndIf
            EndIf
             
            If TempSongs()\Country <> ""    
              Line3 + TempSongs()\Country 
            EndIf
          EndIf     
 
          Line + RSet(Str(TempSongs()\Number), 3, "0") + ". " + Line1
          
          If Line2 <> ""
            Line + " | " + Line2
          EndIf
          
          If Line3 <> ""
            Line + " | " + Line3
          EndIf          
            
          WriteStringN(0, Line)
        Next
               
        CloseFile(0)                    
      EndIf
    Else
      TryAgain = #False
    EndIf
  Wend    
EndProcedure
 
Procedure ButtonCreateCustomPlaylist() 
  If CheckSettingMinMaxSongs() Or CheckSettingMinMaxPlaybackTime() 
    ProcedureReturn
  EndIf  
  
  ;Check if database is empty
  DatabaseQuery(#DBMusic, "SELECT COUNT(id) FROM music")  
  NextDatabaseRow(#DBMusic)
  If GetDatabaseLong(#DBMusic, 0) = 0
    MessageRequester("Action not allowed", "A custom playlist cannot be created because the database is empty." +  
                                               "First add some songs to the database and try again.", #PB_MessageRequester_Warning)
    FinishDatabaseQuery(#DBMusic) 
    ProcedureReturn   
  EndIf
  FinishDatabaseQuery(#DBMusic)   
  
  CustomPlaylistPreviousIDs = ""
  ButtonStop(#PB_EventType_LeftClick)
  DisableWindow(#WindowMain, #True)
  CreateWindowCustomPlaylist()
  LoadPreferences()
  FillListiconPicklist() 
  
  ;Save the playlist to preferences file
  If PreferencesFile()          
    PreferenceGroup("Session")      
    WritePreferenceString("Type", "Custom")               
    WritePreferenceString("IDs", GeneratePlaylistIDsString())           
    ClosePreferences()
  EndIf
  
;   If Not RefreshPlaylist
;     SetGadgetState(#Panel, 0)
;   EndIf  

  HideWindow(#WindowCustomPlaylist, #False)   
EndProcedure

Procedure ButtonCreateRandomPlaylist()
  Protected.s PlaylistString
  Protected.i Result, I, Highest, Tracks, StringNr
  Protected.i StartTime = ElapsedMilliseconds()  
  
  Dim String.s(999)
  
  If CheckSettingMinMaxSongs() Or CheckSettingMinMaxPlaybackTime()  
    ProcedureReturn
  EndIf
  
  LoadPreferences()
  
  ;Check if database is empty
  DatabaseQuery(#DBMusic, "SELECT COUNT(id) FROM music")  
  NextDatabaseRow(#DBMusic)
  If GetDatabaseLong(#DBMusic, 0) = 0
    MessageRequester("Playlist loading error", "Playlist cannot be created because the database is empty." +  
                                               "First add some songs to the database and try again.", #PB_MessageRequester_Warning)
    FinishDatabaseQuery(#DBMusic) 
    ProcedureReturn   
  EndIf
  FinishDatabaseQuery(#DBMusic) 
   
  ;Check if a music direcory is choosen
  If Preferences\PathAudio = ""
    MessageRequester("Playlist loading error", "No music directory selected in settings.", #PB_MessageRequester_Warning)      
    ProcedureReturn     
  EndIf 
  
  While ElapsedMilliseconds() - StartTime < 1000
    PlaylistString = GenerateRandomPlaylist()
  Wend

  If PlaylistString = ""
    MessageRequester("Playlist loading error", "Playlist could not be generated. Try again, or update your settings before retrying.", #PB_MessageRequester_Warning)    
    ProcedureReturn  
  EndIf       
    
  FillListiconPlaylist(PlaylistString, #False)  
 
  ;Save the playlist to preferences file
  If PreferencesFile()          
    PreferenceGroup("Session")      
    WritePreferenceString("Type", "Random")               
    WritePreferenceString("IDs", PlaylistString)           
    ClosePreferences()
  EndIf
  
  If Not RefreshPlaylist
    SetGadgetState(#Panel, 0)
  EndIf
EndProcedure

Procedure ListiconPlaylist(EventType)  
  Protected.i Row = GetGadgetState(#ListiconPlaylist)  
 
  If Row <> - 1 And InitializationReady1 And Row = CountGadgetItems(#ListiconPlaylist) - 1 And Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random" 
    SelectRow(#ListiconPlaylist, Mix(CurrentSong)\Number - 1)
    MessageRequester("Action not allowed", "It's not possible to select the last song in infinite mode.", #PB_MessageRequester_Warning|#PB_MessageRequester_Ok)    
    ProcedureReturn
  EndIf   
  
  If EventType = #PB_EventType_Change And CountGadgetItems(#ListiconPlaylist) > 0 And Row <> -1 And InitializationReady    
    PrepareMix(Row)       
  ElseIf EventType = #PB_EventType_LeftDoubleClick 
    If BASS_ChannelIsActive(Chan\Mixer) <> #BASS_ACTIVE_PLAYING
      ButtonPlay(#PB_EventType_LeftClick)  
    Else
      ButtonPause(#PB_EventType_LeftClick) 
    EndIf
  ElseIf EventType = #PB_EventType_RightClick
    EditSong()       
  EndIf
EndProcedure
  
Procedure Trackbar()
  If Busy
    ProcedureReturn
  EndIf

  If GetGadgetState(#Trackbar) > GetGadgetAttribute(#Trackbar, #PB_TrackBar_Maximum) - 2000
    SetGadgetState(#Trackbar, GetGadgetAttribute(#Trackbar, #PB_TrackBar_Maximum) - 2000)
  EndIf
  
  Protected.f RealTime = (GetGadgetState(#Trackbar) / 1000) / (Mix(CurrentSong)\OrigFreq / Mix(CurrentSong)\Samplerate)

  If Mix(CurrentSong)\Number > 1
    RealTime + Mix(CurrentSong)\IntroEnd
  EndIf

  If Mix(CurrentSong)\Shorten And RealTime > Mix(CurrentSong)\SkipStart
    RealTime + (Mix(CurrentSong)\SkipEnd - Mix(CurrentSong)\SkipStart)
  EndIf

  BASS_ChannelSetPosition(Mix(CurrentSong)\Channel, BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, RealTime), #BASS_POS_BYTE)
  UpdateTimeLabels()
EndProcedure
 
Procedure TrackbarVolume()
  Protected.f Volume
  
  Volume = GetGadgetState(#TrackbarVolume) / 100
  BASS_ChannelSetAttribute(Chan\Mixer, #BASS_ATTRIB_VOL, Volume)  
EndProcedure

Procedure ButtonPrevious(EventType)
  Protected.i Row = GetGadgetState(#ListiconPlaylist) - 1
  
  If EventType <> #PB_EventType_LeftClick  
    ProcedureReturn
  EndIf  
  
  If ListSize(Songs()) = 0
    ProcedureReturn    
  EndIf
  
  If Row => 0
    SelectRow(#ListiconPlaylist, Row)
    ListiconPlaylist(#PB_EventType_Change)    
  EndIf  
EndProcedure
  
Procedure ButtonNext(EventType) 
  Protected.i Row = GetGadgetState(#ListiconPlaylist) + 1
  
  If EventType <> #PB_EventType_LeftClick Or ListSize(Songs()) = 0
    ProcedureReturn    
  EndIf  
  
  If Row < ListSize(Songs()) 
    SelectRow(#ListiconPlaylist, Row)
    ListiconPlaylist(#PB_EventType_Change)    
  EndIf
EndProcedure

Procedure ButtonPause(EventType)
  If EventType <> #PB_EventType_LeftClick  
    ProcedureReturn
  EndIf  

  If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING
    BASS_ChannelPause(Chan\Mixer)
    HideGadget(#ButtonPause, #True)
    HideGadget(#ButtonPlay, #False) 
    PausedCurrentSongPos = BASS_ChannelGetPosition(Mix(CurrentSong)\Channel, #BASS_POS_BYTE)
    
    If Mix(CurrentSong)\Mixing 
      PausedNextSongPos = BASS_ChannelGetPosition(Mix(NextSong)\Channel, #BASS_POS_BYTE)      
    EndIf
  EndIf
  
  If Mix(CurrentSong)\Mixing Or Mix(CurrentSong)\Fading    
    isPaused = #True    
  EndIf
EndProcedure

Procedure ButtonPlay(EventType)
  Protected.s FileFullPath
  Static.q Pos 
 
  If EventType <> #PB_EventType_LeftClick Or ListSize(Songs()) = 0
    ProcedureReturn    
  EndIf
 
  PlayerPausedByProgram = #False
  
  FileFullPath = Preferences\PathAudio + OSPath(Mix(CurrentSong)\AudioFilename) 
    
  If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PAUSED   
    If FileSize(FileFullPath) = -1
      ButtonStop(#PB_EventType_LeftClick)
      MessageRequester("Playing error", "File does not exist: " + FileFullPath, #PB_MessageRequester_Error) 
      ProcedureReturn
    EndIf    
    
    If BASS_ChannelIsActive(Chan\Database) = #BASS_ACTIVE_PLAYING
      ButtonStopDatabaseSong()
      ButtonStopMusicLibrarySong()      
    EndIf
    
    BASS_ChannelPlay(Chan\Mixer, #True) ; to avoid playing the stored buffer, #true is used instead of #false
    BASS_ChannelSetPosition(Mix(CurrentSong)\Channel, PausedCurrentSongPos, #BASS_POS_BYTE)
    
    If Mix(CurrentSong)\Mixing
      BASS_ChannelSetPosition(Mix(NextSong)\Channel, PausedNextSongPos, #BASS_POS_BYTE)
    EndIf
    
    HideGadget(#ButtonPause, #False)
    HideGadget(#ButtonPlay, #True) 
  Else 
    ;Start playing
    If FileSize(FileFullPath) = -1    
      MessageRequester("Playing error", "File does not exist: " + FileFullPath, #PB_MessageRequester_Error) 
      ProcedureReturn
    EndIf

    ButtonStopDatabaseSong()

    BASS_ChannelPlay(Chan\Mixer, #True)
       
    HideGadget(#ButtonPause, #False)
    HideGadget(#ButtonPlay, #True)     
    
    ;Update spectrum to avoid white background
    UpdateSpectrum()
    HideGadget(#CanvasSpectrum, #False)    
    
    ;Set timer for updating trackbar and spectrum
    AddWindowTimer(#WindowMain, #PlayingMixTimer, 100)     
    
    ;Enable trackbar
    DisableGadget(#Trackbar, #False)
  EndIf  
  
  If Mix(CurrentSong)\Mixing Or Mix(CurrentSong)\Fading
    isPaused = #False 
    startTime = ElapsedMilliseconds() - elapsedTime
  EndIf  
EndProcedure
 
Procedure ButtonStop(EventType) 
  If EventType <> #PB_EventType_LeftClick Or ListSize(Songs()) = 0
    ProcedureReturn
  EndIf  
   
  isPaused = #False
  PlayerPausedByProgram = #False
 
  RemoveWindowTimer(#WindowMain, #PlayingMixTimer)   
  BASS_ChannelStop(Chan\Mixer)
  
  If ListSize(Songs()) > 0
    SelectElement(Songs(), GetGadgetState(#ListiconPlaylist))
    SetTrackBarMaximum()
    SetGadgetText(#LabelRemainingTime, Seconds2Time(GetGadgetAttribute(#Trackbar, #PB_TrackBar_Maximum), #False))
  EndIf 
  
  HideGadget(#TrackbarTransition, #True) 
  HideGadget(#Trackbar, #False)   
  HideGadget(#CanvasSpectrum, #True)  
  HideGadget(#ButtonPause, #True)
  HideGadget(#ButtonPlay, #False)    
  
  SelectRow(#ListiconPlaylist, Mix(CurrentSong)\Number - 1)
  
  ListiconPlaylist(#PB_EventType_Change)
EndProcedure

Procedure ButtonDynAmpOn(EventType)
  If EventType <> #PB_EventType_LeftClick  
    ProcedureReturn
  EndIf    
   
  Dim param.BASS_BFX_DAMP(0)
  
  param(0)\fTarget = 0.44
  param(0)\fQuiet = 0.03
  param(0)\fRate = 0.01 
  param(0)\fGain = 1.0
  param(0)\fDelay = 0.035    
  param(0)\lChannel = #BASS_BFX_CHANALL           
    
  DynAmp = BASS_ChannelSetFX(Chan\Mixer, #BASS_FX_BFX_DAMP, 1) 
  BASS_FXSetParameters(DynAmp, @param(0))     
  
  HideGadget(#ButtonDynAmpOff, #False)
  HideGadget(#ButtonDynAmpOn, #True)   
EndProcedure

Procedure ButtonDynAmpOff(EventType)
  If EventType <> #PB_EventType_LeftClick  
    ProcedureReturn
  EndIf    
   
  BASS_ChannelRemoveFX(Chan\Mixer, DynAmp) 
  DynAmp = #False  
  
  HideGadget(#ButtonDynAmpOff, #True)
  HideGadget(#ButtonDynAmpOn, #False)    
  
  DynAmp = 0
EndProcedure

Procedure ButtonVolume(EventType) 
  If EventType <> #PB_EventType_LeftClick  
    ProcedureReturn
  EndIf  
   
  If Visible\Volume 
    HideGadget(#TrackbarVolume, #True)    
    Visible\Volume = #False
    
    ResizeGadget(#Trackbar,           320, #PB_Ignore, WindowWidth(#WindowMain) - 680,  #PB_Ignore)
    ResizeGadget(#TrackbarTransition, 320, #PB_Ignore, WindowWidth(#WindowMain) - 680, #PB_Ignore)
    ResizeGadget(#LabelTime, 260, #PB_Ignore, #PB_Ignore, #PB_Ignore)      
    ResizeGadget(#LabelMix, 260, #PB_Ignore, WindowWidth(#WindowMain) - 300, #PB_Ignore)          
  Else
    HideGadget(#TrackbarVolume, #False)
    SetActiveGadget(#TrackbarVolume)
    Visible\Volume = #True
    
    ResizeGadget(#Trackbar,           450, #PB_Ignore, WindowWidth(#WindowMain) - 810,  #PB_Ignore)
    ResizeGadget(#TrackbarTransition, 450, #PB_Ignore, WindowWidth(#WindowMain) - 810, #PB_Ignore)
    ResizeGadget(#LabelTime, 385, #PB_Ignore, #PB_Ignore, #PB_Ignore)  
    ResizeGadget(#LabelMix, 385, #PB_Ignore, WindowWidth(#WindowMain) - 400, #PB_Ignore)          
  EndIf
EndProcedure

;------------------------------------ Panel files events

Procedure ButtonClearList()
  If CountGadgetItems(#ListiconMusicLibrary) = 0
    MessageRequester("Action not allowed", "Music library is empty.", #PB_MessageRequester_Error)      
    ProcedureReturn    
  EndIf
  
  If MessageRequester("Warning", "Are you sure you want to clear the music library?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes      
    DatabaseUpdate(#DBFiles, "DELETE FROM files") 
    ClearGadgetItems(#ListiconMusicLibrary)
    SetGadgetText(#StringSearchFiles, "")
    HideGadget(#ListiconMusicLibrarySearch, #True)
    Visible\ListiconMusicLibrarySearch = #False    
  EndIf
EndProcedure
 
Procedure ButtonAddFolder() 
  If Preferences\PathAudio = ""
    MessageRequester("Add folder error", "No music directory selected in settings.", #PB_MessageRequester_Error)      
    ProcedureReturn    
  EndIf
    
  CollectingFilesPath = PathRequester("Choose a folder", Preferences\PathAudio)  
  
  If CollectingFilesPath <> ""
    If Left(CollectingFilesPath, Len(Preferences\PathAudio)) <> Preferences\PathAudio
      MessageRequester("Add folder error", "The choosen folder is not a subfolder of " + Preferences\PathAudio, #PB_MessageRequester_Error)      
      ProcedureReturn        
    EndIf
    
    ButtonStopMusicLibrarySong()
    
    CreateWindowFilesProgress()
 
    StopCollectingFiles = #False
    CollectingFiles = CreateThread(@ThreadCollectFiles(), 0)        
  EndIf    
EndProcedure

Procedure ButtonRemoveFile()
  Protected.i ListIcon
  
  If Visible\ListiconMusicLibrarySearch 
    ListIcon = #ListiconMusicLibrarySearch
  Else
    ListIcon = #ListiconMusicLibrary
  EndIf
  
  Protected.i Items = CountGadgetItems(#ListiconMusicLibrary) - 1
  Protected.i Row = GetGadgetState(ListIcon)
  Protected.i i
  Protected.s File = ReplaceString(GetGadgetItemText(ListIcon, Row, 2), "'", "''")
  Protected.s Folder = ReplaceString(GetGadgetItemText(ListIcon, Row, 3) , "'", "''")  
  
  If Row = -1 Or CountGadgetItems(ListIcon) = 0
    MessageRequester("Action not allowed", "Nothing selected", #PB_MessageRequester_Warning)
    ProcedureReturn
  EndIf
 
  If MessageRequester("Delete file", "Are you sure you want to delete " + GetGadgetItemText(ListIcon, Row, 2) + " from the music library?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes  
    ButtonStopMusicLibrarySong()  
     
    DatabaseUpdate(#DBFiles, "DELETE FROM files WHERE file='" + File + "' AND folder='" + Folder + "'")
    
    If Visible\ListiconMusicLibrarySearch
      For i = 0 To Items  
        If GetGadgetItemText(#ListiconMusicLibrarySearch, Row, 2) = GetGadgetItemText(#ListiconMusicLibrary, i, 2) And GetGadgetItemText(#ListiconMusicLibrarySearch, Row, 3) = GetGadgetItemText(#ListiconMusicLibrary, i, 3) 
          RemoveGadgetItem(#ListiconMusicLibrary, i) 
          Break        
        EndIf
      Next
    EndIf      
     
    RemoveGadgetItem(ListIcon, Row)    
  EndIf
EndProcedure
  
Procedure ComboboxOrderFiles() 
  If GetGadgetText(#ComboboxSortFiles) <> "Sort"   
    ButtonStopMusicLibrarySong()  
    
    If Visible\ListiconMusicLibrarySearch
      FillListiconMusicLibrary(#ListiconMusicLibrarySearch)
    Else
      FillListiconMusicLibrary()
    EndIf
  EndIf  
EndProcedure

Procedure ButtonAddFileToDatabase()   
  Protected.i Row = GetGadgetState(#ListiconMusicLibrary)
  
  If Row = -1 Or CountGadgetItems(#ListiconMusicLibrary) = 0
    MessageRequester("Action not allowed", "Nothing selected.", #PB_MessageRequester_Warning)
    ProcedureReturn
  ElseIf GetGadgetItemText(#ListiconMusicLibrary, Row, 0) = "Yes"
    MessageRequester("Action not allowed", "Record does already exists in database.", #PB_MessageRequester_Warning)
    ProcedureReturn    
  EndIf
  
  ButtonStopMusicLibrarySong()  
  CreateWindowDatabaseAddRecord(GetGadgetItemText(#ListiconMusicLibrary, Row, 2))
  DisableWindow(#WindowMain, #True)
  LoadDatabaseFile(OSPath(GetGadgetItemText(#ListiconMusicLibrary, Row, 3) + GetGadgetItemText(#ListiconMusicLibrary, Row, 2)), GetGadgetItemText(#ListiconMusicLibrary, Row, 1))
EndProcedure

Procedure StringSearchFiles(EventType)  
  If EventType = #PB_EventType_Focus 
    If GetGadgetText(#StringSearchFiles) = "Search..."    
      SetGadgetText(#StringSearchFiles, "")  
    EndIf  
  ElseIf EventType = #PB_EventType_LostFocus 
    If Trim(GetGadgetText(#StringSearchFiles)) = ""
      SetGadgetText(#StringSearchFiles, "Search...")
      HideGadget(#ListiconMusicLibrarySearch, #True)  
      Visible\ListiconMusicLibrarySearch = #False   
    EndIf
  ElseIf EventType = #PB_EventType_Change    
    If GetGadgetText(#StringSearchFiles) <> "Search..."  
      If Trim(GetGadgetText(#StringSearchFiles)) <> ""      
        FillListiconMusicLibrary(#ListiconMusicLibrarySearch)    
      
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetActiveGadget(#StringSearchFiles)
        CompilerEndIf      
      Else
        HideGadget(#ListiconMusicLibrarySearch, #True)     
        Visible\ListiconMusicLibrarySearch = #False        
      EndIf
    EndIf    
  EndIf      
EndProcedure
 
Procedure ButtonPlayFile()
  Protected.i ListIcon

  If Visible\ListiconMusicLibrarySearch 
    ListIcon = #ListiconMusicLibrarySearch
  Else
    ListIcon = #ListiconMusicLibrary
  EndIf
  
  Protected.i Row = GetGadgetState(ListIcon) 
  Protected.s FileFullPath = OSPath(GetGadgetItemText(ListIcon, Row, 3) + GetGadgetItemText(ListIcon, Row, 2))
  
  If CountGadgetItems(ListIcon) = 0
    MessageRequester("Action not allowed", "The music library is empty.", #PB_MessageRequester_Error)
    ProcedureReturn
 ElseIf Row = -1  
    MessageRequester("Action not allowed", "Nothing selected", #PB_MessageRequester_Warning)
    ProcedureReturn
 ElseIf FileSize(FileFullPath) = -1
    MessageRequester("File loading error", "The file " + GetFilePart(FileFullPath) + " does not exist.", #PB_MessageRequester_Error)  
    ProcedureReturn
  EndIf
  
  ButtonStopMusicLibrarySong()  
  
  If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING   
    PlayerPausedByProgram = #True
    ButtonPause(#PB_EventType_LeftClick)   
  EndIf

  Chan\Database = CreateChannel(FileFullPath)           
   
  SetGadgetAttribute(#TrackbarMusicLibrary, #PB_TrackBar_Maximum, BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE))
  BASS_Mixer_ChannelSetSync(Chan\Database, #BASS_SYNC_END|#BASS_SYNC_MIXTIME, 2, @ButtonStopMusicLibrarySong(), 0)  
  AddWindowTimer(#WindowMain, #TrackbarMusicLibraryTimer, 500)    
  DisableGadget(#TrackbarMusicLibrary, #False)
   
  BASS_ChannelPlay(Chan\Database, #True)
EndProcedure

Procedure ButtonStopMusicLibrarySong()
  RemoveWindowTimer(#WindowMain, #TrackbarMusicLibraryTimer)     
  BASS_ChannelStop(Chan\Database)
  BASS_StreamFree(Chan\Database)
  SetGadgetAttribute(#TrackbarMusicLibrary, #PB_TrackBar_Maximum, 0)
  DisableGadget(#TrackbarMusicLibrary, #True)
  
  If PlayerPausedByProgram 
    ButtonPlay(#PB_EventType_LeftClick)
  EndIf  
EndProcedure

Procedure TrackbarMusicLibrary()
  Protected.i TrackbarPosition = GetGadgetState(#TrackbarMusicLibrary)
  Protected.s PositionSeconds = Seconds2Time(BASS_ChannelBytes2Seconds(Chan\Database, TrackbarPosition), #False)
  Protected.s LengthSeconds = Seconds2Time(BASS_ChannelBytes2Seconds(Chan\Database, BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE)), #False)
  
  BASS_ChannelSetPosition(Chan\Database, TrackbarPosition, #BASS_POS_BYTE)    
  GadgetToolTip(#TrackbarMusicLibrary, PositionSeconds + " / " + LengthSeconds)    
EndProcedure

;------------------------------------ Panel database events

Procedure ButtonAddRecord()
  Protected.s File, DBFilename, Extension  
  Protected.s LastDBFile = Preferences\PathAudio
  Protected.s Pattern   
  Protected.b Found
  Protected.i Channel
  Protected Info.BASS_CHANNELINFO  
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Pattern = "All audio files|*.mp1;*.mp2;*.mp3;*.ogg;*.wav;*.aiff;*.aac;*.adts;*.m4a;*.mp4;*.flac;*.opus;*.wma" +
              "MP1 files (*.mp1)|*.mp1|" + 
               "MP2 files (*.mp2)|*.mp2|" +
               "MP3 files (*.mp3)|*.mp3|" +
               "OGG files (*.ogg)|*.ogg|" +
               "WAV files (*.wav)|*.wav|" +
               "AIFF files (*.aiff)|*.aiff|" +
               "AAC files (*.aac)|*.aac|" +
               "ADTS files (*.adts)|*.adts|" +
               "M4A files (*.m4a)|*.m4a|" +
               "MP4 files (*.mp4)|*.mp4|" +
               "FLAC files (*.flac)|*.flac|" +
               "OPUS files (*.opus)|*.opus|" +
               "WMA files (*.wma)|*.wma|"  
               
  CompilerElse
    Pattern = "All audio files|*.mp1;*.mp2;*.mp3;*.ogg;*.wav;*.aiff;*.aac;*.adts;*.m4a;*.mp4;*.flac;*.opus;" +
              "MP1 files (*.mp1)|*.mp1|" + 
               "MP2 files (*.mp2)|*.mp2|" +
               "MP3 files (*.mp3)|*.mp3|" +
               "OGG files (*.ogg)|*.ogg|" +
               "WAV files (*.wav)|*.wav|" +
               "AIFF files (*.aiff)|*.aiff|" +
               "AAC files (*.aac)|*.aac|" +
               "ADTS files (*.adts)|*.adts|" +
               "M4A files (*.m4a)|*.m4a|" +
               "MP4 files (*.mp4)|*.mp4|" +
               "FLAC files (*.flac)|*.flac|" +
               "OPUS files (*.opus)|*.opus|"  
               
  CompilerEndIf
   
  ;Check if a music direcory is choosen
  If Preferences\PathAudio = ""
    MessageRequester("Action not allowed", "No music directory selected in settings.", #PB_MessageRequester_Warning)      
    ProcedureReturn     
  EndIf   
  
  DatabaseQuery(#DBMusic, "SELECT filename FROM music ORDER BY id DESC LIMIT 1")
  NextDatabaseRow(#DBMusic)
  If GetDatabaseString(#DBMusic, 0) <> "" And FileSize(Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 0))) <> -1 
    LastDBFile = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 0))
  EndIf
  FinishDatabaseQuery(#DBMusic)  
 
  File = OSPath(OpenFileRequester("Choose audiofile to add", LastDBFile, Pattern, 0))
  
  If File
    ;Check if file already exists in music database    
    DBFilename = GetFilePart(ReplaceString(File, Preferences\PathAudio, ""))
    DBFilename = ReplaceString(DBFilename, "'", "''")
    DatabaseQuery(#DBMusic, "SELECT id FROM music WHERE filename LIKE '%/" + DBFilename + "' OR filename LIKE '%\" + DBFilename + "'  LIMIT 1")
    NextDatabaseRow(#DBMusic)
    If GetDatabaseString(#DBMusic, 0) <> ""
      Found = #True
    EndIf
    FinishDatabaseQuery(#DBMusic)
    
    If Found
      MessageRequester("Action not allowed", GetFilePart(File) + " does already exists in database.", #PB_MessageRequester_Warning) 
      ProcedureReturn  
    EndIf
    
    Extension = LCase(GetExtensionPart(File))      
    
    If Extension <> "mp3" And Extension <> "mp2" And Extension <> "mp1" And
       Extension <> "ogg" And Extension <> "wav" And Extension <> "aiff" And
       Extension <> "aac" And Extension <> "adts" And Extension <> "m4a" And
       Extension <> "mp4" And Extension <> "flac" And Extension <> "opus"
    
      ; Alleen op Windows mag .wma
      CompilerIf #PB_Compiler_OS = #PB_OS_Windows
        If Extension <> "wma"
          MessageRequester("Action not allowed", GetFilePart(File) + " does not have a supported audio format (.mp1, .mp2, .mp3, .ogg, .wav, .aiff, .aac, .adts, .m4a, .mp4, .flac, .opus, .wma)", #PB_MessageRequester_Warning)
          ProcedureReturn
        EndIf
      CompilerElse
        MessageRequester("Action not allowed", GetFilePart(File) + " does not have a supported audio format (.mp1, .mp2, .mp3, .ogg, .wav, .aiff, .aac, .adts, .m4a, .mp4, .flac, .opus)", #PB_MessageRequester_Warning)
        ProcedureReturn
      CompilerEndIf
    EndIf
    
    ButtonStopDatabaseSong()      
    ButtonPause(#PB_EventType_LeftClick)

    DisableWindow(#WindowMain, #True) 
    CreateWindowDatabaseAddRecord(GetFilePart(File))
    LoadDatabaseFile(OSPath(File), CalculateEstimatedBPM(File))
  EndIf
EndProcedure

Procedure ButtonEditRecord()
  Protected.i ListIcon
  
  If Visible\ListiconDatabaseSearch
    ListIcon = #ListiconDatabaseSearch
  Else
    ListIcon = #ListiconDatabase    
  EndIf
  
  Protected.i Index
  Protected.i Row = GetGadgetState(ListIcon)
  Protected.s Path
  Protected.s ID = GetGadgetItemText(ListIcon, Row, 0)
  Protected.b SongInPlaylist
  
  If Row = -1 Or CountGadgetItems(ListIcon) = 0
    MessageRequester("Action not allowed", "Nothing selected", #PB_MessageRequester_Warning)
    ProcedureReturn
;   ElseIf SongInPlaylist(ID)
;     If MessageRequester("Warning", "This song is in the current playlist. Adjustments can cause errors in the current mix." + Chr(13) +
;                                    "Do you want to continue?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
;       ProcedureReturn  
;     EndIf
  EndIf
  
  DatabaseSong\ID = ID
  DatabaseQuery(#DBMusic, "SELECT filename FROM music WHERE id='" + DatabaseSong\ID + "' LIMIT 1")
  NextDatabaseRow(#DBMusic)
  Path = OSPath(GetDatabaseString(#DBMusic, 0))
  FinishDatabaseQuery(#DBMusic)
  
  ButtonStopDatabaseSong()      
  DisableWindow(#WindowMain, #True) 
  CreateWindowDatabaseAddRecord(GetFilePart(Path), "Edit")
  LoadDatabaseFile(Preferences\PathAudio + Path) 
EndProcedure

Procedure ButtonDeleteRecord()
  Protected.i ListIcon
  
  If Visible\ListiconDatabaseSearch
    ListIcon = #ListiconDatabaseSearch
  Else
    ListIcon = #ListiconDatabase    
  EndIf
  
  Protected.i Index, i
  Protected.i Items = CountGadgetItems(#ListiconDatabase) - 1
  Protected.i Row = GetGadgetState(ListIcon)
  Protected.s ID = GetGadgetItemText(ListIcon, Row, 0)
  Protected.s File, Folder
  Protected.b SongInPlaylist
  
  If Row = -1 Or CountGadgetItems(ListIcon) = 0
    MessageRequester("Action not allowed", "Nothing selected", #PB_MessageRequester_Warning)
    ProcedureReturn
  ElseIf SongInPlayList(ID)
    If MessageRequester("Warning", "This song is in the current playlist. Deleting will cause an error in the current mix." + Chr(13) +
                                   "Do you want to continue?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
      ProcedureReturn  
    EndIf
  EndIf
    
  If MessageRequester("Delete record", "Are you sure you want to delete " + 
                                       UCase(GetGadgetItemText(ListIcon, Row, 1)) + " - " +
                                       UCase(GetGadgetItemText(ListIcon, Row, 2)) +
                                       " from the database?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      
    ButtonStopDatabaseSong()  
    
    DatabaseQuery(#DBMusic, "SELECT filename FROM music WHERE id='" + ID + "' LIMIT 1")
    NextDatabaseRow(#DBMusic)   
    File = OSPath(GetFilePart(GetDatabaseString(#DBMusic, 0)))
    Folder = Preferences\PathAudio + OSPath(GetPathPart(GetDatabaseString(#DBMusic, 0)))
    FinishDatabaseQuery(#DBMusic)
    
    DatabaseUpdate(#DBMusic, "DELETE FROM music WHERE id='" + ID + "'")
    DatabaseUpdate(#DBFiles, "UPDATE files SET added='No' WHERE file='" + File + "' AND folder='" + Folder + "'")
    
    If Visible\ListiconDatabaseSearch
      For i = 0 To Items
        If GetGadgetItemText(#ListiconDatabase, i, 0) = ID  
          RemoveGadgetItem(#ListiconDatabase, i) 
          Break
        EndIf
      Next
    EndIf
    
    RemoveGadgetItem(ListIcon, Row)  
     
    DatabaseQuery(#DBMusic, "SELECT COUNT(id) FROM music")  
    NextDatabaseRow(#DBMusic)
    SetGadgetText(#LabelTotalRecords, Str(GetDatabaseLong(#DBMusic, 0)) +  " Records")
    FinishDatabaseQuery(#DBMusic)  
  EndIf
EndProcedure

Procedure ComboboxSortDatabase()
  If GetGadgetText(#ComboboxSortDatabase) <> "Sort"   
    ButtonStopDatabaseSong() 
    
    If Visible\ListiconDatabaseSearch
      FillListiconDatabase(#ListiconDatabaseSearch)
    Else
      FillListiconDatabase()      
    EndIf
  EndIf    
EndProcedure

Procedure StringSearchDatabase(EventType)
  If EventType = #PB_EventType_Focus 
    If GetGadgetText(#StringSearchDatabase) = "Search..."
      SetGadgetText(#StringSearchDatabase, "")    
    EndIf  
  ElseIf EventType = #PB_EventType_LostFocus 
    If Trim(GetGadgetText(#StringSearchDatabase)) = ""
      SetGadgetText(#StringSearchDatabase, "Search...") 
      HideGadget(#ListiconDatabaseSearch, #True)  
      Visible\ListiconDatabaseSearch = #False  
      SetGadgetText(#LabelTotalRecords, Str(CountGadgetItems(#ListiconDatabase)) +  " Records")       
    EndIf
  ElseIf EventType = #PB_EventType_Change
    If GetGadgetText(#StringSearchDatabase) <> "Search..." 
      If Trim(GetGadgetText(#StringSearchDatabase)) <> ""
        FillListiconDatabase(#ListiconDatabaseSearch)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetActiveGadget(#StringSearchDatabase)
        CompilerEndIf 
      Else      
        HideGadget(#ListIconDatabaseSearch, #True)     
        Visible\ListiconDatabaseSearch = #False     
        SetGadgetText(#LabelTotalRecords, Str(CountGadgetItems(#ListiconDatabase)) +  " Records") 
      EndIf      
    EndIf    
  EndIf    
EndProcedure

Procedure ButtonPlayDatabaseSong()
  Protected.i ListIcon
  
  If Visible\ListiconDatabaseSearch
    ListIcon = #ListiconDatabaseSearch
  Else
    ListIcon = #ListiconDatabase    
  EndIf
  
  Protected.i Row = GetGadgetState(ListIcon)
  Protected.s FileFullPath, ID = GetGadgetItemText(Listicon, Row, 0)  
  
  If CountGadgetItems(ListIcon) = 0
    MessageRequester("Action not allowed", "The database is empty.", #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
   
  DatabaseQuery(#DBMusic, "SELECT filename FROM music WHERE id='" + ID +  "' LIMIT 1")    
  NextDatabaseRow(#DBMusic)
  FileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 0))

  If FileSize(FileFullPath) = -1
    MessageRequester("Action not allowed", "The file does not exist.", #PB_MessageRequester_Error)  
    ProcedureReturn
  EndIf
  
  ButtonStopDatabaseSong()
  
  If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING   
    PlayerPausedByProgram = #True
    ButtonPause(#PB_EventType_LeftClick)
  EndIf
  
  Chan\Database = CreateChannel(FileFullPath)           

  SetGadgetAttribute(#TrackbarDatabase, #PB_TrackBar_Maximum, BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE))
  BASS_Mixer_ChannelSetSync(Chan\Database, #BASS_SYNC_END|#BASS_SYNC_MIXTIME, 2, @ButtonStopDatabaseSong(), 0)  
  AddWindowTimer(#WindowMain, #TrackbarDatabaseTimer, 500)    
  DisableGadget(#TrackbarDatabase, #False)

  BASS_ChannelPlay(Chan\Database, #True)  
EndProcedure

Procedure ButtonStopDatabaseSong()
  RemoveWindowTimer(#WindowMain, #TrackbarDatabaseTimer)     
  BASS_ChannelStop(Chan\Database)
  BASS_StreamFree(Chan\Database)
  SetGadgetAttribute(#TrackbarDatabase, #PB_TrackBar_Maximum, 0)
  DisableGadget(#TrackbarDatabase, #True) 
  
  If PlayerPausedByProgram     
    ButtonPlay(#PB_EventType_LeftClick)
  EndIf
EndProcedure

Procedure TrackbarDatabase()
  Protected.i TrackbarPosition = GetGadgetState(#TrackbarDatabase)
  Protected.s PositionSeconds = Seconds2Time(BASS_ChannelBytes2Seconds(Chan\Database, TrackbarPosition), #False)
  Protected.s LengthSeconds = Seconds2Time(BASS_ChannelBytes2Seconds(Chan\Database, BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE)), #False)
  
  BASS_ChannelSetPosition(Chan\Database, TrackbarPosition, #BASS_POS_BYTE)    
  GadgetToolTip(#TrackbarDatabase, PositionSeconds + " / " + LengthSeconds)    
EndProcedure

;------------------------------------ Panel settings events

Procedure ButtonOpenFolderAudio()  
  Protected.s Path = PathRequester("Choose the path where audio files are stored", GetGadgetText(51))  
  
  If Path <> ""
    ;Show choosen folder in StringGadget
    SetGadgetText(51, Path)      
  EndIf  
EndProcedure

Procedure ButtonOpenFolderSleeves()  
  Protected.s Path = PathRequester("Choose the path where sleeve files are stored", GetGadgetText(52))  
  If Path <> ""
    ;Show choosen folder in StringGadget
    SetGadgetText(52, Path)    
  EndIf
EndProcedure
 
Procedure ButtonDefaultSettings()
  Protected.i Row
  Protected.i Gadget = 51
  Protected.s Description
 
  ForEach SettingsPanel()
    If Gadget > 52
      SetGadgetText(Gadget, SettingsPanel()\DefaultValue)
       
      ;Unselect the first item in a listview 
      If SettingsPanel()\Gadget = #SettingListview
        SetGadgetItemState(Gadget, 0, 0)
      EndIf
           
      If SettingsPanel()\Gadget = #SettingListview And (SettingsPanel()\Description = "Genres" Or SettingsPanel()\Description = "Countries" Or 
                                                        SettingsPanel()\Description = "Years" Or SettingsPanel()\Description = "Record labels" Or SettingsPanel()\Description = "Artists")
        For Row = 0 To CountGadgetItems(Gadget)
          SetGadgetItemState(Gadget, Row, 0)
        Next Row        
        
        Description = Left(GetGadgetText(Gadget + 400), FindString(GetGadgetText(Gadget + 400), Chr(13)))
        SetGadgetText(Gadget + 400, Description + "(0 items selected)")        
      EndIf     
    EndIf
    
    Gadget + 1
  Next
EndProcedure

Procedure ListviewSettings()
  Protected.i Items, Row, Selected, Gadget = GetActiveGadget()
  Protected.s Description 
  
  If GadgetType(Gadget) <> #PB_GadgetType_ListView 
    ProcedureReturn
  EndIf
  
  Items = CountGadgetItems(Gadget)
  Description = Left(GetGadgetText(Gadget + 400), FindString(GetGadgetText(Gadget + 400), Chr(13)))
  
  For Row = 0 To Items - 1
    If GetGadgetItemState(Gadget, Row) = 1
      Selected + 1
    EndIf
  Next
  
  SetGadgetText(Gadget + 400, Description + "(" + Str(Selected) + " items selected)")
EndProcedure

Procedure ChangeWindowsTheme()
  If Preferences\WindowsTheme <> GetGadgetText(GetActiveGadget())
    If MessageRequester("Restart required", "MixPerfect Player must be restarted to apply the " + LCase(GetGadgetText(GetActiveGadget())) + " theme." + Chr(13) + Chr(13) + "Do you want to restart now?", #PB_MessageRequester_Info|#PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      ExitProgram(#True)
      RunProgram(ProgramFilename())
      End
    EndIf
  EndIf
EndProcedure
 
Procedure ButtonResetCountries()
  DeselectListviewItems(70, "Countries")
EndProcedure

Procedure ButtonResetGenres()
  DeselectListviewItems(71, "Genres")
EndProcedure

Procedure ButtonResetYears()  
  DeselectListviewItems(72, "Years")
EndProcedure

Procedure ButtonResetLabels()
  DeselectListviewItems(74, "Record labels")
EndProcedure

Procedure ButtonResetArtists()
  DeselectListviewItems(75, "Artists")
EndProcedure

;------------------------------------ Panel custom playlist events

Procedure ButtonLoadCustomPlaylist()
  Protected.s File, PlaylistString, PlaylistType
  Protected.b IsPlaylist
  Protected.s StandardFile = OSPath("playlists/custom_playlist.cmx")  
  Protected.s Pattern = "Mix playlist (*.cmx)|*.cmx|All files (*.*)|*.*" 
  Protected.s Item
   
  If FileSize("playlists") <> -2  
    CreateDirectory("playlists")
  EndIf  
   
  File = OSPath(OpenFileRequester("Choose playlist file to load", StandardFile, Pattern, 0))
  
  If File
    ;Check if the choosen file is really a custom-playlist
    If LCase(GetExtensionPart(File)) = "cmx"  
      OpenFile(#File, File)

      If Not Eof(#File)
        PlaylistString = ReadString(#File)
        If CountString(PlaylistString, Chr(9)) = 10
          IsPlaylist = #True   
        EndIf
      EndIf
      CloseFile(#File)
    EndIf
    
    If Not IsPlaylist
      MessageRequester("Custom playlist loading error", "File is not a " + #AppName + " custom playlist file.", #PB_MessageRequester_Error)      
      ProcedureReturn
    EndIf
    
    ClearGadgetItems(#ListiconCustomPlaylist)
    
    CustomPlaylistPreviousIDs = ""
    OpenFile(#File, File)
    While Not Eof(#File)
      Item = ReadString(#File)
      CustomPlaylistPreviousIDs + StringField(Item, 8, Chr(9)) + ","
      AddGadgetItem(#ListiconCustomPlaylist, -1, ReplaceString(Item, Chr(9), Chr(10)))      
    Wend
    CloseFile(#File)   
    CustomPlaylistPreviousIDs = RTrim(CustomPlaylistPreviousIDs, ",")

    SetGadgetText(#StringSearchPicklist, "")            
    SelectRow(#ListiconCustomPlaylist, CountGadgetItems(#ListiconCustomPlaylist) - 1)  
    FillListiconPicklist(#ListiconPicklist, #True)
  EndIf
EndProcedure

Procedure ButtonSaveCustomPlaylist()
  Protected.s File
  Protected.b Save, TryAgain = #True
  Protected.s StandardFile = OSPath("playlists/custom_playlist.cmx")  
  Protected.s Pattern = "Custom playlist (*.cmx)|*.cmx"   
  Protected.s RowString
  Protected.i Rows = CountGadgetItems(#ListiconCustomPlaylist)
  Protected.i Row, Column
 
  If Rows = 0
    MessageRequester("Action not allowed", "An empty custom playlist can't be saved.")
    ProcedureReturn
  EndIf  
  
  While TryAgain
    Save = #False
    
    If FileSize("playlists") <> -2  
      CreateDirectory("playlists")
    EndIf  
      
    File = OSPath(SaveFileRequester("Save custom playlist as...", StandardFile, Pattern, 0))
    
    If File
      If GetExtensionPart(File) = ""
        File + ".cmx" 
      EndIf
      
      If LCase(GetExtensionPart(File)) <> "cmx"
        MessageRequester("Playlist saving error", "Playlist file must have cmx-extension.", #PB_MessageRequester_Error)
      ElseIf FileSize(File) <> -1
        Select MessageRequester("Save custom playlist warning", "File " + GetFilePart(File) + " already exists." + Chr(13) + Chr(13) + "Do you want to overwrite this file?", #PB_MessageRequester_Warning|#PB_MessageRequester_YesNoCancel)
          Case #PB_MessageRequester_Yes 
            TryAgain = #False
            Save = #True
          Case #PB_MessageRequester_Cancel 
            TryAgain = #False              
        EndSelect
      Else
        TryAgain = #False 
        Save = #True
      EndIf
        
      If Save         
        CreateFile(#File, File)
        
        For Row = 0 To Rows - 1
          RowString = ""
          For Column = 0 To 11
            RowString + GetGadgetItemText(#ListiconCustomPlaylist, Row, Column) + Chr(9)
          Next
          WriteStringN(#File, RTrim(RowString, Chr(9)))          
        Next 
  
        CloseFile(#File)     
      EndIf
    Else
      TryAgain = #False
    EndIf
  Wend
EndProcedure

Procedure TrackbarPicklist()   
  Protected.i TrackbarPosition = GetGadgetState(#TrackbarPicklist)
  Protected.s PositionSeconds = Seconds2Time(BASS_ChannelBytes2Seconds(Chan\Database, TrackbarPosition), #False)
  Protected.s LengthSeconds = Seconds2Time(BASS_ChannelBytes2Seconds(Chan\Database, BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE)), #False)
  
  BASS_ChannelSetPosition(Chan\Database, TrackbarPosition, #BASS_POS_BYTE)    
  GadgetToolTip(#TrackbarPicklist, PositionSeconds + " / " + LengthSeconds)  
EndProcedure

Procedure StringSearchPicklist(EventType) 
  If EventType = #PB_EventType_Focus  
    If GetGadgetText(#StringSearchPicklist) = "Search..."  
      SetGadgetText(#StringSearchPicklist, "")  
    EndIf  
  ElseIf EventType = #PB_EventType_LostFocus 
    If Trim(GetGadgetText(#StringSearchPicklist)) = ""
      SetGadgetText(#StringSearchPicklist, "Search...")
      HideGadget(#ListiconPicklistSearch, #True)  
      Visible\ListiconPicklistSearch = #False
      SetGadgetText(#FramePicklist, "Picklist (" + Str(CountGadgetItems(#ListiconPicklist)) + " matches)")   
    EndIf
  ElseIf EventType = #PB_EventType_Change
    If GetGadgetText(#StringSearchPicklist) <> "Search..."  
      If Trim(GetGadgetText(#StringSearchPicklist)) <> ""
        FillListiconPicklist(#ListiconPicklistSearch)
        
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          SetActiveGadget(#StringSearchPicklist)
        CompilerEndIf
      Else
        HideGadget(#ListiconPicklistSearch, #True)     
        Visible\ListiconPicklistSearch = #False  
        SetGadgetText(#FramePicklist, "Picklist (" + Str(CountGadgetItems(#ListiconPicklist)) + " matches)")     
        FillListiconPicklist(#ListiconPicklistSearch)
      EndIf
    EndIf    
  EndIf
EndProcedure
 
Procedure ComboboxSortPicklist()
  If GetGadgetText(#ComboboxSortPicklist) <> "Sort"   
    If Visible\ListiconPicklistSearch
      FillListiconPicklist(#ListiconPicklistSearch)
    Else
      FillListiconPicklist()     
    EndIf
  EndIf
EndProcedure
 
Procedure ButtonPlayPicklistSong()
  Protected.i ListIcon
  
  If Visible\ListiconPicklistSearch
    ListIcon = #ListiconPicklistSearch
  Else
    ListIcon = #ListiconPicklist
  EndIf
  
  Protected.i PicklistRow = GetGadgetState(ListIcon)
  Protected.s FileFullPath, ID = GetGadgetItemText(ListIcon, PicklistRow, 2)  
  
  If CountGadgetItems(ListIcon) = 0
    MessageRequester("Action not allowed", "The picklist is empty.", #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
  
  ButtonStopPicklistsong()
  ButtonStopCustomTransition()  
  
  
  ;*********************
  ;Prepare selected song
  ;*********************
  
  DatabaseQuery(#DBMusic, "SELECT filename FROM music WHERE id='" + ID +  "' LIMIT 1")    
  NextDatabaseRow(#DBMusic)
  FileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 0))
  
  If FileSize(FileFullPath) = -1
    MessageRequester("Action not allowed", "The file does not exist.", #PB_MessageRequester_Error)  
    ProcedureReturn
  EndIf
  
  Chan\Database = CreateChannel(FileFullPath)           
  BASS_Mixer_ChannelSetSync(Chan\Database, #BASS_SYNC_END|#BASS_SYNC_MIXTIME, 2, @ButtonStopPicklistSong(), 0)  
   
  SetGadgetAttribute(#TrackbarPicklist, #PB_TrackBar_Maximum, BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE))
  AddWindowTimer(#WindowCustomPlaylist, #TrackbarPicklistTimer, 500)    
  DisableGadget(#TrackbarPicklist, #False)

  BASS_ChannelPlay(Chan\Database, #True)
EndProcedure

Procedure ButtonStopPicklistSong()
  RemoveWindowTimer(#WindowCustomPlaylist, #TrackbarPicklistTimer)     
  BASS_ChannelStop(Chan\Database)
  BASS_StreamFree(Chan\Database)
  SetGadgetAttribute(#TrackbarPicklist, #PB_TrackBar_Maximum, 0)
  DisableGadget(#TrackbarPicklist, #True)
EndProcedure

Procedure ButtonPlayCustomTransition()   
  Protected.s Query = "SELECT id, bpm, filename, introstart, introend, introloopstart, introloopend, introlooprepeat, " + 
                      "breakstart, breakend, breakloopstart, breakloopend, breaklooprepeat, introbeatlist, breakbeatlist,  " + 
                      "introfade, breakfade, introprefix, breakcontinue, breakmute, skipstart, skipend, samplerate, introbeats, breakbeats FROM music"
  Protected.s IntroFileFullPath, BreakFileFullPath
  Protected.i Row = GetGadgetState(#ListiconCustomPlaylist) 
  Protected.i IntroID = Val(GetGadgetItemText(#ListiconCustomPlaylist, Row + 1, 7))
  Protected.i BreakID = Val(GetGadgetItemText(#ListiconCustomPlaylist, Row, 7))
  Protected.i IntroFileSamplerate, BreakFileSamplerate
  Protected.f MaxVol = GetGadgetState(#TrackbarVolume) / 100 
  Protected.f IntroBPM, BreakBPM, IntroLength, BreakLength
  Protected.q StartTime2Bytes, EndTime2Bytes

  If Row = -1  
    MessageRequester("Action not allowed", "Nothing selected", #PB_MessageRequester_Warning)
    ProcedureReturn
  EndIf  
 
  If CountGadgetItems(#ListiconCustomPlaylist) < 2
    MessageRequester("Action not allowed", "The tracklist must contain at least 2 songs.", #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
  
  If Row = CountGadgetItems(#ListiconCustomPlaylist) - 1
    MessageRequester("Action not allowed", "Last song never can play a transition.", #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf  
  
  ButtonStopPicklistSong()
  ButtonStopCustomTransition()  
  
  BASS_ChannelRemoveFX(Chan\CustomTransitionBreak, Chan\FX1) 
  BASS_ChannelRemoveFX(Chan\CustomTransitionIntro, Chan\FX2) 
  
  ;********************************
  ;Fetch intro record from database
  ;********************************
  
  DatabaseQuery(#DBMusic, Query + " WHERE id='" + IntroID +  "' LIMIT 1")    
  NextDatabaseRow(#DBMusic)
  
  CustomTransition\IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 3))   
  CustomTransition\IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 4))      
  CustomTransition\IntroLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 5))
  CustomTransition\IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 6))   
  CustomTransition\IntroLoopCounter = 0  
  CustomTransition\IntroLoopRepeat = GetDatabaseLong(#DBMusic, 7) 
  CustomTransition\IntroBeatList = GetDatabaseString(#DBMusic, 13)    
  CustomTransition\IntroFade = GetDatabaseLong(#DBMusic, 15)  
  CustomTransition\IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 17))  
  CustomTransition\SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 20))  
  CustomTransition\SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 21))    
  CustomTransition\IntroBeats = GetDatabaseLong(#DBMusic, 23)
  IntroBPM = GetDatabaseFloat(#DBMusic, 1)
  IntroFileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 2))
  IntroFileSamplerate = GetDatabaseLong(#DBMusic, 22)    
  IntroLength = TransitionLength(CustomTransition\IntroStart, CustomTransition\IntroEnd, CustomTransition\IntroLoopStart, CustomTransition\IntroLoopEnd, CustomTransition\IntroLoopRepeat)  

  If FileSize(IntroFileFullPath) = -1
    MessageRequester("Action not allowed", "File does not exist.", #PB_MessageRequester_Error)    
    ProcedureReturn -1
  EndIf
  
  ;********************************
  ;Fetch break record from database
  ;********************************
  
  DatabaseQuery(#DBMusic, Query + " WHERE id='" + BreakID +  "' LIMIT 1")    
  NextDatabaseRow(#DBMusic)  
  
  CustomTransition\BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 8))  
  CustomTransition\BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 9))  
  CustomTransition\BreakLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 10))  
  CustomTransition\BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 11))  
  CustomTransition\BreakLoopCounter = 0    
  CustomTransition\BreakLoopRepeat = GetDatabaseLong(#DBMusic, 12) 
  CustomTransition\BreakBeatList = GetDatabaseString(#DBMusic, 14)
  CustomTransition\BreakFade = GetDatabaseLong(#DBMusic, 16)
  CustomTransition\BreakContinue = Time2Seconds(GetDatabaseString(#DBMusic, 18))  
  CustomTransition\BreakMute = Time2Seconds(GetDatabaseString(#DBMusic, 19))  
  CustomTransition\BreakBeats = GetDatabaseLong(#DBMusic, 24)  
  BreakBPM = GetDatabaseFloat(#DBMusic, 1)  
  BreakFileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 2)) 
  BreakFileSamplerate = GetDatabaseLong(#DBMusic, 22)    
  BreakLength = TransitionLength(CustomTransition\BreakStart, CustomTransition\BreakEnd, CustomTransition\BreakLoopStart, CustomTransition\BreakLoopEnd, CustomTransition\BreakLoopRepeat) 
    
  If FileSize(BreakFileFullPath) = -1
    MessageRequester("Action not allowed", "File does not exist.", #PB_MessageRequester_Error)    
    ProcedureReturn -1
  EndIf
  
  ;**************************
  ; Prepare custom transition
  ;**************************
  
  Chan\CustomTransitionBreak = CreateChannel(BreakFileFullPath, #BASS_ASYNCFILE|#BASS_STREAM_DECODE|#BASS_SAMPLE_FLOAT)        
  Chan\CustomTransitionIntro = CreateChannel(IntroFileFullPath, #BASS_ASYNCFILE|#BASS_STREAM_DECODE|#BASS_SAMPLE_FLOAT)    
  
  BASS_Mixer_StreamAddChannel(Chan\MixerCustomTransition, Chan\CustomTransitionIntro, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN)              
  BASS_ChannelSetPosition(Chan\CustomTransitionIntro, BASS_ChannelSeconds2Bytes(Chan\CustomTransitionIntro, CustomTransition\IntroStart - CustomTransition\IntroPrefix - 0.005), #BASS_POS_BYTE)            

  If CustomTransition\IntroLoopStart > 0 And CustomTransition\IntroLoopEnd > 0 And CustomTransition\IntroLoopRepeat > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionIntro, CustomTransition\IntroLoopStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionIntro, CustomTransition\IntroLoopEnd)
    BASS_Mixer_ChannelSetSync(Chan\CustomTransitionIntro, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTime2Bytes, @CustomTransitionIntroLoop(), StartTime2Bytes)
  EndIf      

  If CustomTransition\IntroFade
    Volume(Chan\CustomTransitionIntro, MaxVol, 0.0, IntroLength + CustomTransition\IntroPrefix) 
  EndIf   
 
  BASS_ChannelSetAttribute(Chan\CustomTransitionBreak, #BASS_ATTRIB_FREQ, BreakFileSamplerate * (IntroBPM / BreakBPM))      
  BASS_Mixer_StreamAddChannel(Chan\MixerCustomTransition, Chan\CustomTransitionBreak, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN)            
  BASS_ChannelSetPosition(Chan\CustomTransitionBreak, BASS_ChannelSeconds2Bytes(Chan\CustomTransitionBreak, CustomTransition\BreakStart - CustomTransition\IntroPrefix - 0.025), #BASS_POS_BYTE)             

  SetGadgetAttribute(#TrackbarCustomTransition, #PB_TrackBar_Maximum, Int(BreakLength + CustomTransition\BreakContinue + CustomTransition\IntroPrefix) * 1000)
  SetGadgetState(#TrackbarCustomTransition, 0) 

  If CustomTransition\BreakLoopStart > 0 And CustomTransition\BreakLoopEnd > 0 And CustomTransition\BreakLoopRepeat > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionBreak, CustomTransition\BreakLoopStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionBreak, CustomTransition\BreakLoopEnd)
    BASS_Mixer_ChannelSetSync(Chan\CustomTransitionBreak, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTime2Bytes, @CustomTransitionBreakLoop(), StartTime2Bytes)
  EndIf     
 
  StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionBreak, CustomTransition\BreakStart)     
  BASS_Mixer_ChannelSetSync(Chan\CustomTransitionIntro, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @BeatCustomTransitionSynchronizer(), BreakFileSamplerate)     
 
  If CustomTransition\BreakMute > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionBreak, CustomTransition\BreakEnd - CustomTransition\BreakMute)     
    BASS_Mixer_ChannelSetSync(Chan\CustomTransitionBreak, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @Mute(), 0)      
  EndIf
  
  If CustomTransition\BreakFade
    Volume(Chan\CustomTransitionBreak, 0.0, MaxVol, BreakLength + CustomTransition\BreakContinue + CustomTransition\IntroPrefix) 
  EndIf     
  
  If GetGadgetItemText(#ListiconCustomPlaylist, Row, 10) = "S" And CustomTransition\SkipStart > 0 And CustomTransition\SkipEnd > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionIntro, CustomTransition\SkipStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionIntro, CustomTransition\SkipEnd)
    BASS_ChannelSetSync(Chan\CustomTransitionIntro, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @Skip(), EndTime2Bytes)
  EndIf     
  
  If CustomTransition\BreakBeats And CustomTransition\IntroBeats  
    Dim Param.BASS_BFX_BQF(0)  
      
    Param(0)\lFilter = #BASS_BFX_BQF_HIGHPASS
    Param(0)\fCenter = 250
    Param(0)\fBandwidth = 0
    Param(0)\fQ = 0.7   
    Param(0)\lChannel = #BASS_BFX_CHANALL 
    Volume(Chan\CustomTransitionIntro, 1.0)     

    If Preferences\FilterOverlappedBeats = "Current song" Or Preferences\FilterOverlappedBeats = "Both songs"
      Chan\FX1 = BASS_ChannelSetFX(Chan\CustomTransitionBreak, #BASS_FX_BFX_BQF, 0)      
      BASS_FXSetParameters(Chan\FX1, @param(0))    
      Volume(Chan\CustomTransitionBreak, 0.9)
    EndIf

    If Preferences\FilterOverlappedBeats = "Next song" Or Preferences\FilterOverlappedBeats = "Both songs" 
      Chan\FX2 = BASS_ChannelSetFX(Chan\CustomTransitionIntro, #BASS_FX_BFX_BQF, 0)     
      BASS_FXSetParameters(Chan\FX2, @param(0))      
      Volume(Chan\CustomTransitionIntro, 0.9)     
    EndIf             
  EndIf    

  AddWindowTimer(#WindowCustomPlaylist, #TrackbarCustomTransitionTimer, 500)  
  
  BASS_ChannelPlay(Chan\MixerCustomTransition, #True)
EndProcedure

Procedure ButtonStopCustomTransition()
  RemoveWindowTimer(#WindowCustomPlaylist, #TrackbarCustomTransitionTimer)   
  
  BASS_ChannelStop(Chan\MixerCustomTransition)
  BASS_Mixer_ChannelRemove(Chan\CustomTransitionBreak) 
  BASS_Mixer_ChannelRemove(Chan\CustomTransitionIntro)   

  SetGadgetAttribute(#TrackbarCustomTransition, #PB_TrackBar_Maximum, 0)
EndProcedure

Procedure ButtonAddSongToCustomPlaylist()
  Protected.i ListIcon
  
  If Visible\ListiconPicklistSearch
    ListIcon = #ListiconPicklistSearch
  Else
    ListIcon = #ListiconPicklist
  EndIf
  
  Protected.i PicklistRow = GetGadgetState(ListIcon)
  Protected.i TracklistRow = GetGadgetState(#ListiconCustomPlaylist)  
  Protected.i TracklistItems = CountGadgetItems(#ListiconCustomPlaylist) 
  Protected.i MaxSongs = MaxSongs(Preferences\MaximumNumberOfSongs)
  Protected.i SongType, Seconds, Samplerate, FileSamplerate
  Protected.f IntroLength, BreakLength
  Protected.f PitchChange, PlayTime, PlayTimeLastSong, IncreasingTime, IncreasingTimeLastSong
  Protected.f MaxPlaybackTime = MaxPlaybackTime(Preferences\MaximumPlaybackTime)
  Protected.f IntroPrefix, IntroStart, IntroEnd, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat
  Protected.f BreakStart, BreakEnd, BreakLoopstart, BreakLoopEnd, BreakLoopRepeat, Breakcontinue, SkipStart, SkipEnd  
  Protected.f PlaybackBPM, OriginalBPM = ValF(GetGadgetItemText(ListIcon, PicklistRow, 0))
  Protected.s FileFullPath, Pitch, Shorten, LastSongShorten, Columns, String
  Protected.s ID = GetGadgetItemText(ListIcon, PicklistRow, 2) 

  Protected.s Query = "id, filename, introprefix, introstart, introend, introloopstart, introloopend, introlooprepeat, " + 
                      "breakstart, breakend, breakloopstart, breakloopend, breaklooprepeat, breakcontinue, skipstart, skipend, samplerate"
  
  If CountGadgetItems(ListIcon) = 0
    If Visible\ListiconPicklistSearch  
      String = " Remove search text to refill the list"
    EndIf
    MessageRequester("Action not allowed", "The picklist is empty." + String, #PB_MessageRequester_Error)  
    ProcedureReturn
  EndIf       
  
  If CountString(CustomPlaylistPreviousIDs, ",") + 1 > Preferences\UniqueSongsBeforeRepeating
    CustomPlaylistPreviousIDs = ""
  Else  
    ;Build a string with collected database-ID's to prevent duplicate tracks      
    CustomPlaylistPreviousIDs + "," + ID
  EndIf
  
  
  ;******************************************************
  ;Calculate playtime of the last song (the song to add), 
  ;using the id of selected row in picklist
  ;******************************************************

  DatabaseQuery(#DBMusic, "SELECT " + Query + " FROM music WHERE id='" + ID + "' LIMIT 1")  
  NextDatabaseRow(#DBMusic)
 
  FileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 1))
  IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 2))   
  IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 3))   
  IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 4))      
  IntroLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 5))
  IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 6))    
  IntroLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 7))  
  BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 8))  
  BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 9))  
  BreakLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 10))  
  BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 11))  
  BreakLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 12))  
  Breakcontinue = Time2Seconds(GetDatabaseString(#DBMusic, 13))    
  SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 14))   
  SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 15))     
  FileSamplerate = GetDatabaseLong(#DBMusic, 16)      

  FinishDatabaseQuery(#DBMusic)
  
  PlayTimeLastSong = PlayLength(#LastSong, IntroPrefix, IntroStart, IntroEnd, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat,
                              BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat, BreakContinue, 
                              FileFullPath)   
 
  If Preferences\ShortenSongs = "Always" Or (Preferences\ShortenSongs = "Random" And Random(1)) 
    PlayTimeLastSong = (BreakEnd - IntroEnd) - (SkipEnd - SkipStart)  
    If BreakLoopStart > 0 And BreakLoopEnd And BreakLoopRepeat > 0
      PlayTimeLastSong + ((BreakLoopEnd - BreakLoopStart) * BreakLoopRepeat)
    EndIf
    LastSongShorten = "S"
  EndIf      
 
  IntroLength = TransitionLength(IntroStart, IntroEnd, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat)      
    
  
    
  ;**************************************************************
  ;Recalculate playtime and increasing time of the previous song, 
  ;using the id of the last row in tracklist
  ;**************************************************************
  
  If TracklistItems > 0
    DatabaseQuery(#DBMusic,  "SELECT " + Query + " FROM music WHERE id='" + GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 7) + "' LIMIT 1")  
    NextDatabaseRow(#DBMusic)

    FileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 1))
    IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 2))   
    IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 3))   
    IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 4))      
    IntroLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 5))
    IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 6))    
    IntroLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 7))  
    BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 8))  
    BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 9))  
    BreakLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 10))  
    BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 11))  
    BreakLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 12))  
    Breakcontinue = Time2Seconds(GetDatabaseString(#DBMusic, 13))    
    SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 14))   
    SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 15))      
    FileSamplerate = GetDatabaseLong(#DBMusic, 16)       
    
    If TracklistItems - 1 = 0
      SongType = #FirstSong
    Else
      SongType = #InBetweenSong
    EndIf  
    
    PlayTime = PlayLength(SongType, IntroPrefix, IntroStart, IntroEnd, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat,
                          BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat, BreakContinue,
                          FileFullPath)  
    
    If Preferences\ShortenSongs = "Always" Or (Preferences\ShortenSongs = "Random" And Random(1))
      PlayTime - (SkipEnd - SkipStart)
      Shorten = "S"
    EndIf    
      
    IncreasingTime = PlayTime
    
    If TracklistItems > 1 
      Seconds = (Time2Seconds(Mid(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 2, 3), 4, 5))) + 
                (60 * 60 * Val(Left(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 2, 3), 2)))  
      IncreasingTime + Seconds
    EndIf  
    
    BreakLength = TransitionLength(BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat)      
  EndIf 
  
  
  ;**************************************
  ;Calculate increasing time of last song
  ;**************************************
  
  IncreasingTimeLastSong = IncreasingTime + PlayTimeLastSong
   
  ;************************************************
  ;Calculate the playback BPM, pitch and samplerate
  ;************************************************
  
  PlaybackBPM = ValF(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 5))

  If TracklistItems = 0 Or Abs(OriginalBPM - PlaybackBPM) <= Preferences\PitchRange
    PlayBackBPM = OriginalBPM
    Pitch.s = "  0.00%" 
    Samplerate = FileSamplerate
  Else
    PitchChange = Abs(100 * ((PlaybackBPM / OriginalBPM) - 1))  
  
    If OriginalBPM > PlaybackBPM
      Pitch = " -" + FormatNumber(PitchChange) + "%"
    Else 
      Pitch = "+" + FormatNumber(PitchChange) + "%" 
    EndIf             
    
    Samplerate = Val(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 9))
    Samplerate * (IntroLength / BreakLength)       
  EndIf
  
  
  ;***************************************
  ;Check if custom playlist meets settings
  ;***************************************
  
  If TracklistItems > MaxSongs And Preferences\MaximumNumberOfSongs <> "Infinite"  
    MessageRequester("Action not allowed", 
                     "According to the settings, the custom playlist may not contain more than " + MaxSongs + " songs",
                     #PB_MessageRequester_Error)
    ProcedureReturn
  ElseIf IncreasingTime > MaxPlaybackTime And Preferences\MaximumPlaybackTime <> "Infinite"
    MessageRequester("Action not allowed", 
                     "The song that you want to add exceeds the maximum duration of the playlist." + 
                     " According to the settings, the custom playlist may not last longer than " + Preferences\MaximumPlaybackTime,
                     #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
   
  ButtonStopPicklistsong()
  
  
  ;********************************************
  ;Add selected song from picklist to tracklist  
  ;********************************************

  TracklistItems + 1
  
  Columns = RSet(Str(TracklistItems), 3, "0") + Chr(10) +  
            GetGadgetItemText(ListIcon, PicklistRow, 1) + Chr(10) + 
            Seconds2Time(PlayTimeLastSong, #False) + Chr(10) + 
            Seconds2Time(IncreasingTimeLastSong, #True) + Chr(10) + 
            RSet(FormatNumber(OriginalBPM), 6, "0") + Chr(10) + 
            RSet(FormatNumber(PlaybackBPM), 6, "0") + Chr(10) + 
            Pitch + Chr(10) + 
            ID + Chr(10) + 
            StrF(PlayTimeLastSong) + Chr(10) +
            Str(Samplerate) + Chr(10) +
            LastSongShorten
  
  AddGadgetItem(#ListiconCustomPlaylist, TracklistItems + 1, Columns)
                                                             
  
  ;********************************************************
  ;Change playbacktime and increasing time of previous song 
  ;********************************************************  
  
  If TracklistItems > 1  
    SetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 2, Seconds2Time(PlayTime, #False), 2)
    SetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 2, Seconds2Time(IncreasingTime, #True), 3) 
    SetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 2, StrF(PlayTime), 8)
    SetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 2, Shorten, 10)    
  EndIf 
  
  
  ;************************************* 
  ;Jump to the last row of the tracklist
  ;************************************* 
  SelectRow(#ListiconCustomPlaylist, TracklistItems - 1)  
  SelectRow(#ListiconCustomPlaylist, -1)  
    
  ;*******************
  ;Refill the picklist
  ;*******************
  
  FillListiconPicklist()
  
  If Visible\ListiconPicklistSearch  
    FillListiconPicklist(#ListiconPicklistSearch)    
  EndIf
  
  SelectRow(#ListiconCustomPlaylist, TracklistRow)
EndProcedure

Procedure ButtonRemoveSongFromCustomPlaylist()
  Protected.i TracklistItems = CountGadgetItems(#ListiconCustomPlaylist)  
  Protected.i Last, Position
 
  If TracklistItems > 0
    RemoveGadgetItem(#ListiconCustomPlaylist, TracklistItems - 1) 
  EndIf
  
  ;Remove last ID from string
  If CustomPlaylistPreviousIDs <> "" 
    Repeat
      Last = Position
      Position = FindString(CustomPlaylistPreviousIDs, ",", Position + 1)
    Until Not Position

    CustomPlaylistPreviousIDs = Left(CustomPlaylistPreviousIDs, Last - 1)
  EndIf
  
  ButtonStopPicklistSong()
  ButtonStopCustomTransition()

  ;Refill the picklist
  FillListiconPicklist()  
EndProcedure

Procedure ButtonApplyCustomPlaylist()
  Protected.i TracklistItems = CountGadgetItems(#ListiconCustomPlaylist)
  Protected.i Seconds = (Time2Seconds(Mid(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 3), 4, 5))) + 
                        (60 * 60 * Val(Left(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 3), 2)))   
  Protected.i Row
  Protected.s PlaylistIDs, PlaylistDurations, PlaylistString

  If CountGadgetItems(#ListiconCustomPlaylist) < Val(Preferences\MinimumNumberOfSongs)
    MessageRequester("Custom playlist error", 
                     "According to the settings, the tracklist must have at least " + Preferences\MinimumNumberOfSongs + " songs",
                     #PB_MessageRequester_Error)
    ProcedureReturn
  ElseIf Seconds < MinPlaybackTime(Preferences\MinimumPlaybackTime) 
    MessageRequester("Custom playlist error", 
                     "According to the settings, the custom playlist duration must be at least " + Preferences\MinimumPlaybackTime,  
                     #PB_MessageRequester_Error)
    ProcedureReturn
  EndIf
  
  If TracklistItems > 0
    For Row = 0 To TracklistItems - 1
      PlaylistIDs + RemoveString(GetGadgetItemText(#ListiconCustomPlaylist, Row, 7), Chr(13)) 
      
      If GetGadgetItemText(#ListiconCustomPlaylist, Row, 6) = "  0.00%"
        PlaylistIDs + "R"      
      EndIf
      
      PlaylistIDs + ","
      
      PlaylistDurations + FormatNumber(ValF(GetGadgetItemText(#ListiconCustomPlaylist, Row, 8)), 2) +
                          GetGadgetItemText(#ListiconCustomPlaylist, Row, 10) + ","
    Next

    PlaylistString = RTrim(PlaylistIDs, ",") + "|" + RTrim(PlaylistDurations, ",")
  
    FillListiconPlaylist(PlaylistString)  

    ;Stop playing
    ButtonStopPicklistSong()    
    ButtonStopCustomTransition()
    
    ;Save the playlist to preferences file
    If PreferencesFile()          
      PreferenceGroup("Session")      
      WritePreferenceString("Type", "Custom") 
      WritePreferenceString("IDs", PlaylistString)           
      ClosePreferences()
    EndIf
  EndIf
  
  HideGadget(#ListIconPicklistSearch, #True)   
  Visible\ListiconPicklistSearch = #False 
  
  CloseWindow(#WindowCustomPlaylist)
  DisableWindow(#WindowMain, #False)
  ;WindowBounds(#WindowMain, WindowWidth(#WindowMain), WindowHeight(#WindowMain), DesktopWidth(0), DesktopHeight(0))  
  SetGadgetState(#Panel, 0)
EndProcedure
 
Procedure ButtonCancelCustomPlaylist() 
  ButtonStopPicklistSong()
  ButtonStopCustomTransition()  
  
  HideGadget(#ListIconPicklistSearch, #True)   
  Visible\ListiconPicklistSearch = #False   
  
  ;Return to main window
  CloseWindow(#WindowCustomPlaylist)
  DisableWindow(#WindowMain, #False)
 ; WindowBounds(#WindowMain, WindowWidth(#WindowMain), WindowHeight(#WindowMain), DesktopWidth(0), DesktopHeight(0))  
  
  If PlayerPausedByProgram
    ButtonPlay(#PB_EventType_LeftClick)             
  EndIf     
EndProcedure
  
;------------------------------------ Window database add record events

Procedure CheckBoxIntroFadeIn()  
  DrawMarkers()
EndProcedure

Procedure CheckboxBreakFadeout()
  DrawMarkers()  
EndProcedure

Procedure ButtonTestBeatSync()
  If DatabaseSongErrors() <> ""
    ProcedureReturn
  EndIf
 
  ButtonStopDatabaseAddRecordSong()    
  DisableWindow(#WindowDatabaseAddRecord, #True) 
  CreateWindowBeatSyncTest()  
EndProcedure

Procedure ButtonPlayDatabaseAddRecordSong()
  Protected.q StartTimeBytes, EndTimeBytes  
  
  RealTimeFX\Mute = #False
  RealTimeFX\FadeIn = #False
  RealTimeFX\FadeOut = #False  
  DatabaseSong\IntroLoopCounter = 0
  DatabaseSong\BreakLoopCounter = 0

  If BASS_ChannelIsActive(Chan\Database) = #BASS_ACTIVE_PLAYING 
    ButtonStopDatabaseAddRecordSong()
  Else  
    If DatabaseSong\SkipStart > 0 And DatabaseSong\SkipEnd > 0 
      StartTimeBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\SkipStart)
      EndTimeBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\SkipEnd)      
      Sync(0) = BASS_ChannelSetSync(Chan\Database, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTimeBytes, @Skip(), EndTimeBytes)
    EndIf
    
    If DatabaseSong\IntroLoopStart > 0  And DatabaseSong\IntroLoopEnd > 0 And DatabaseSong\IntroLoopRepeat > 0
      StartTimeBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\IntroLoopStart) 
      EndTimeBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\IntroLoopEnd)     
      DatabaseSong\IntroLoopCounter = 0             
      Sync(1) = BASS_ChannelSetSync(Chan\Database, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTimeBytes, @IntroTestLoop(), StartTimeBytes)
    EndIf   
    
    If DatabaseSong\BreakLoopStart > 0  And DatabaseSong\BreakLoopEnd > 0 And DatabaseSong\BreakLoopRepeat > 0
      StartTimeBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\BreakLoopStart)
      EndTimeBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\BreakLoopEnd)       
      DatabaseSong\BreakLoopCounter = 0             
      Sync(2) = BASS_ChannelSetSync(Chan\Database, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTimeBytes, @BreakTestLoop(), StartTimeBytes)
    EndIf         
    
    BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, GetGadgetState(#TrackbarVolume) / 100)       
    BASS_ChannelSetPosition(Chan\Database, BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\CursorSec), #BASS_POS_BYTE)       
    
    RealTimeSyncs(DatabaseSong\CursorSec)
    
    BASS_ChannelPlay(Chan\Database, #False)   
 
    AddWindowTimer(#WindowDatabaseAddRecord, #DatabaseAddRecordTimer, 50)       
  EndIf
EndProcedure

Procedure ButtonStopDatabaseAddRecordSong()
  Protected.q BeginBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewBegin)
  Protected.f Pos = BASS_ChannelBytes2Seconds(Chan\Database, BeginBytes + (DatabaseSong\BytesPerPixel * DatabaseSong\CursorX)) 
 
  If BASS_ChannelIsActive(Chan\Database) <> #BASS_ACTIVE_PLAYING
    ProcedureReturn
  EndIf
    
  BASS_ChannelStop(Chan\Database)
  
  BASS_ChannelRemoveSync(Chan\Database, Sync(0)) 
  BASS_ChannelRemoveSync(Chan\Database, Sync(1)) 
  BASS_ChannelRemoveSync(Chan\Database, Sync(2)) 
   
  RemoveWindowTimer(#WindowDatabaseAddRecord, #DatabaseAddRecordTimer)
  
  StartDrawing(CanvasOutput(#CanvasWaveform)) 
  If DatabaseSong\SelectionLength > 0 
    DrawImage(ImageID(#SelectionWaveImage), 0, 0)    
    SetGadgetText(#CursorPosString, GetGadgetText(#SelBeginString))     
    DatabaseSong\CursorSec = DatabaseSong\SelectionBegin
  Else
    DrawImage(ImageID(#CursorWaveImage), 0, 0)  
    SetGadgetText(#CursorPosString, Seconds2TimeMS(Pos))  
    DatabaseSong\CursorSec = Pos
  EndIf
  StopDrawing()  
EndProcedure

Procedure ButtonZoomIn()
  Protected.q FullLength = BASS_ChannelGetLength(Chan\DecodedDatabase, #BASS_POS_BYTE) 
  Protected.f FullLengthSec = BASS_ChannelBytes2Seconds(Chan\DecodedDatabase, FullLength)   
  Protected.f Extra  
  Protected.q PosBytes, NumSamples, Length  
  Protected.i SamplesPerElement 
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)  
  Protected.f CursorSec = DatabaseSong\CursorSec
  Protected *WaveData   
  
  If DatabaseSong\SelectionLength > 0
    CursorSec + DatabaseSong\SelectionLength / 2
  EndIf   
  DatabaseSong\ViewBegin = CursorSec - (CursorSec - DatabaseSong\ViewBegin) / 2
  DatabaseSong\ViewEnd = CursorSec + (DatabaseSong\ViewEnd - CursorSec) / 2
 
  If DatabaseSong\ViewBegin < 0 
    DatabaseSong\ViewBegin = 0
  EndIf
    
  If DatabaseSong\ViewEnd > FullLengthSec 
    DatabaseSong\ViewEnd = FullLengthSec
  EndIf
  
  While NumSamples < WaveformWidth
    DatabaseSong\ViewBegin + ((CursorSec - DatabaseSong\ViewBegin) / 2) - Extra
    DatabaseSong\ViewEnd - ((DatabaseSong\ViewEnd - CursorSec) / 2) + Extra
    
    If DatabaseSong\ViewBegin < 0 
      DatabaseSong\ViewBegin = 0
    EndIf
    
    If DatabaseSong\ViewEnd > FullLengthSec
      DatabaseSong\ViewEnd = FullLengthSec
    EndIf    
    
    PosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin) 
    NumSamples = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewEnd - DatabaseSong\ViewBegin) >> 2
    
    Extra + 0.005   
  Wend    
  
  If DatabaseSong\ViewEnd - DatabaseSong\ViewBegin > DatabaseSong\ViewLength Or DatabaseSong\ViewEnd - DatabaseSong\ViewBegin < 0.03
    ProcedureReturn
  EndIf
  
  NumSamples = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewEnd - DatabaseSong\ViewBegin) >> 2
  Length = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewEnd - DatabaseSong\ViewBegin)
  
  DatabaseSong\ViewLength = DatabaseSong\ViewEnd - DatabaseSong\ViewBegin
  
  SetGadgetText(#ViewBeginString, Seconds2TimeMS(DatabaseSong\ViewBegin))
  SetGadgetText(#ViewEndString, Seconds2TimeMS(DatabaseSong\ViewEnd))
  SetGadgetText(#ViewLengthString, Seconds2TimeMS(DatabaseSong\ViewLength))

  If BASS_ChannelIsActive(Chan\Database) = #BASS_ACTIVE_PLAYING
    BASS_ChannelStop(Chan\Database)
    BASS_ChannelRemoveSync(Chan\Database, Sync(0)) 
    RemoveWindowTimer(#WindowDatabaseAddRecord, #DatabaseAddRecordTimer)
  EndIf
  
  SamplesPerElement = NumSamples / WaveformWidth
  DatabaseSong\BytesPerPixel = SamplesPerElement << 2
  *WaveData = AllocateMemory(Length)
  
  BASS_ChannelSetPosition(Chan\DecodedDatabase, PosBytes, #BASS_POS_BYTE)    
  BASS_ChannelGetData(Chan\DecodedDatabase, *WaveData, Length)
  ReDim MM.MinMax(NumSamples / SamplesPerElement)
  MinMaxScaled(@MM(), SamplesPerElement, *WaveData, NumSamples)
  UpdateCanvas()     
  
  DrawMarkers()  
  CalcCursorPos(DatabaseSong\ViewBegin)       
  
  If DatabaseSong\SelectionLength > 0   
    RedrawSelection() 
  Else
    DrawCursor()    
  EndIf
   
  SetActiveGadget(#CanvasWaveform)      
EndProcedure

Procedure ButtonZoomOut()
  Protected.f CursorSec 
  Protected.q PosBytes, NumSamples, Length
  Protected.i SamplesPerElement 
  Protected.q FullLength = BASS_ChannelGetLength(Chan\DecodedDatabase, #BASS_POS_BYTE) 
  Protected.f FullLengthSec = BASS_ChannelBytes2Seconds(Chan\DecodedDatabase, FullLength)   
  Protected *WaveData
  
  If DatabaseSong\SelectionLength > 0
    CursorSec = DatabaseSong\SelectionBegin + DatabaseSong\SelectionLength / 2
  Else
    CursorSec = DatabaseSong\CursorSec
  EndIf  
  
  DatabaseSong\ViewBegin = CursorSec - ((CursorSec - DatabaseSong\ViewBegin) * 2)
  DatabaseSong\ViewEnd = CursorSec + ((DatabaseSong\ViewEnd - CursorSec) * 2)  
   
  If DatabaseSong\ViewBegin < 0 
    DatabaseSong\ViewBegin = 0
  EndIf
  
  If DatabaseSong\ViewEnd <= DatabaseSong\ViewBegin
    Swap DatabaseSong\ViewEnd, DatabaseSong\ViewBegin
  EndIf
  
  If DatabaseSong\ViewEnd > FullLengthSec
    DatabaseSong\ViewEnd= FullLengthSec
  EndIf
  
  DatabaseSong\ViewLength = DatabaseSong\ViewEnd - DatabaseSong\ViewBegin
  
  SetGadgetText(#ViewBeginString, Seconds2TimeMS(DatabaseSong\ViewBegin))
  SetGadgetText(#ViewEndString, Seconds2TimeMS(DatabaseSong\ViewEnd))
  SetGadgetText(#ViewLengthString, Seconds2TimeMS(DatabaseSong\ViewLength))
   
  PosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin) 
  Length = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewEnd - DatabaseSong\ViewBegin)  
  
  If Length < 0
    ProcedureReturn
  EndIf
  
  If BASS_ChannelIsActive(Chan\Database) = #BASS_ACTIVE_PLAYING
    BASS_ChannelStop(Chan\Database)
    BASS_ChannelRemoveSync(Chan\Database, Sync(0)) 
    RemoveWindowTimer(#WindowDatabaseAddRecord, #DatabaseAddRecordTimer)
  EndIf
  
  
  NumSamples = Length >> 2
  SamplesPerElement = (NumSamples / GadgetWidth(#CanvasWaveform))
  DatabaseSong\BytesPerPixel = SamplesPerElement << 2
  *WaveData = AllocateMemory(Length)
  
  BASS_ChannelSetPosition(Chan\DecodedDatabase, PosBytes, #BASS_POS_BYTE)    
  BASS_ChannelGetData(Chan\DecodedDatabase, *WaveData, Length)
  
  ReDim MM.MinMax(NumSamples / SamplesPerElement)
  MinMaxScaled(@MM(), SamplesPerElement, *WaveData, NumSamples)
  UpdateCanvas()    
  
  CalcCursorPos(DatabaseSong\ViewBegin)
  DrawMarkers()    
  
  If DatabaseSong\SelectionLength > 0
    RedrawSelection() 
  Else           
    DrawCursor()
  EndIf  
   
  SetActiveGadget(#CanvasWaveform)  
EndProcedure

Procedure ButtonZoomFull()
  Protected.q Length = BASS_ChannelGetLength(Chan\DecodedDatabase, #BASS_POS_BYTE)     
  Protected.q NumSamples = Length >> 2
  Protected.i SamplesPerElement = NumSamples / GadgetWidth(#CanvasWaveform)
  Protected.f EndSec = BASS_ChannelBytes2Seconds(Chan\DecodedDatabase, Length)
  
  ReDim MM.MinMax(NumSamples / SamplesPerElement)
    
  DatabaseSong\BytesPerPixel = SamplesPerElement << 2
  
  MinMaxScaled(@MM(), SamplesPerElement, *FullWaveData, NumSamples)
  UpdateCanvas()  
  
  DatabaseSong\ViewBegin = 0
  DatabaseSong\ViewEnd = EndSec
  DatabaseSong\ViewLength = EndSec
  
  SetGadgetText(#ViewBeginString, Seconds2TimeMS(DatabaseSong\ViewBegin))
  SetGadgetText(#ViewEndString, Seconds2TimeMS(DatabaseSong\ViewEnd))
  SetGadgetText(#ViewLengthString, Seconds2TimeMS(DatabaseSong\ViewLength))
  
  If BASS_ChannelIsActive(Chan\Database) = #BASS_ACTIVE_PLAYING
    BASS_ChannelStop(Chan\Database)
    BASS_ChannelRemoveSync(Chan\Database, Sync(0)) 
    RemoveWindowTimer(#WindowDatabaseAddRecord, #DatabaseAddRecordTimer)
  EndIf    

  If DatabaseSong\SelectionLength > 0 
    CalcCursorPos(0)  
    DrawMarkers()
    RedrawSelection()    
  Else         
    DrawMarkers() 
    CalcCursorPos(0)
    DrawCursor()
  EndIf
   
  SetActiveGadget(#CanvasWaveform)  
EndProcedure

Procedure ButtonZoomToSelection()
  If DatabaseSong\SelectionLength = 0
    ProcedureReturn
  EndIf
  
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)  
  Protected.f PosSec = DatabaseSong\SelectionBegin
  Protected.q PosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, PosSec) 
  Protected.f FullLengthSec = BASS_ChannelGetLength(Chan\DecodedDatabase, #BASS_POS_BYTE) 
  Protected.q Length = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\SelectionLength)  
  Protected.q NumSamples = Length >> 2
  Protected.i SamplesPerElement = NumSamples / WaveformWidth
  Protected *WaveData = AllocateMemory(Length)  
 
  If NumSamples <= 0 Or SamplesPerElement <= 0
    ButtonZoomIn()
    ProcedureReturn
  EndIf
   
  DatabaseSong\ViewBegin = DatabaseSong\SelectionBegin
  DatabaseSong\ViewEnd = DatabaseSong\SelectionEnd
  DatabaseSong\ViewLength = DatabaseSong\SelectionLength

  SetGadgetText(#ViewBeginString, Seconds2TimeMS(DatabaseSong\SelectionBegin))
  SetGadgetText(#ViewEndString, Seconds2TimeMS(DatabaseSong\SelectionEnd))
  SetGadgetText(#ViewLengthString, Seconds2TimeMS(DatabaseSong\SelectionLength))       
  
  If BASS_ChannelIsActive(Chan\Database) = #BASS_ACTIVE_PLAYING
    BASS_ChannelStop(Chan\Database)
    BASS_ChannelRemoveSync(Chan\Database, Sync(0)) 
    RemoveWindowTimer(#WindowDatabaseAddRecord, #DatabaseAddRecordTimer)
  EndIf 

  DatabaseSong\BytesPerPixel = SamplesPerElement << 2
  BASS_ChannelSetPosition(Chan\DecodedDatabase, PosBytes, #BASS_POS_BYTE)    
  BASS_ChannelGetData(Chan\DecodedDatabase, *WaveData, Length)
  
  ReDim MM.MinMax(NumSamples / SamplesPerElement)
  MinMaxScaled(@MM(), SamplesPerElement, *WaveData, NumSamples)
  UpdateCanvas()  
  
  DrawMarkers()

  StartDrawing(CanvasOutput(#CanvasWaveform))  
  DrawImage(ImageID(#OriginalWaveImage), 0, 0)

  DrawingMode(#PB_2DDrawing_XOr)
  Box(0, 0, WaveformWidth , WaveformHeight , RGB(248, 248, 255)) 
  GrabDrawingImage(#SelectionWaveImage, 0, 0, WaveformWidth , WaveformHeight)   
  StopDrawing()
    
  SetActiveGadget(#CanvasWaveform)  
EndProcedure

Procedure ButtonAddMarker()
  Protected.f BPM = ValF(GetGadgetText(#BPMString))
  Protected.f TransitionLength
  Protected.q SongLengthBytes = BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE) 
  Protected.f SongLengthSec = BASS_ChannelBytes2Seconds(Chan\Database, SongLengthBytes)
  Protected.f PosMinSec, PosPlusSec = DatabaseSong\CursorSec + TransitionLength     
  Protected.s Errors
  Protected.s IntroList = ReplaceString(DatabaseSong\IntroBeatList, Chr(13), Chr(10))
  Protected.s BreakList = ReplaceString(DatabaseSong\BreakBeatList, Chr(13), Chr(10))  
  Protected.i LastBeat 
 
  If BPM > 60 And BPM < 170
    TransitionLength = (60 / BPM) * 32
  EndIf
 
  PosMinSec = DatabaseSong\CursorSec - TransitionLength
  PosPlusSec = DatabaseSong\CursorSec + TransitionLength   
  
  Select GetGadgetText(#Combo_Marker)
    Case "Skip begin"
      If DatabaseSong\IntroStart = 0 Or DatabaseSong\IntroEnd = 0 Or DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0
        Errors + "Skip begin marker can only be set after the intro markers and break markers are set."  
      Else        
        If DatabaseSong\SkipEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\SkipEnd 
          Errors + "Skip begin marker must be set before the skip end marker." + Chr(13)     
        EndIf
        
        If DatabaseSong\IntroEnd > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroEnd 
          Errors + "Skip begin marker must be set after the intro end marker." + Chr(13)     
        EndIf
        
        If DatabaseSong\BreakStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakStart
          Errors + "Skip begin marker must be set before the break begin marker." + Chr(13)     
        EndIf      
      EndIf
      
      If Errors = ""
        DatabaseSong\SkipStart = DatabaseSong\CursorSec
      EndIf
    Case "Skip end"
      If DatabaseSong\IntroStart = 0 Or DatabaseSong\IntroEnd = 0 Or DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0
        Errors + "Skip begin marker can only be set after the intro markers and break markers are set."  
      Else       
        If DatabaseSong\SkipStart > 0 And DatabaseSong\CursorSec <= DatabaseSong\SkipStart
          Errors + "Skip end marker must be set after the skip begin marker." + Chr(13)     
        EndIf
        
        If DatabaseSong\IntroEnd > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroEnd 
          Errors + "Skip end marker must be set after the intro end marker." + Chr(13)     
        EndIf
        
        If DatabaseSong\BreakStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakStart
          Errors + "Skip end marker must be set before the break begin marker." + Chr(13)     
        EndIf      
      EndIf
      
      If Errors = ""      
        DatabaseSong\SkipEnd = DatabaseSong\CursorSec
      EndIf
    Case "Intro loop begin"
      If DatabaseSong\IntroStart = 0 Or DatabaseSong\IntroEnd = 0  
        Errors + "Intro loop begin marker can only be set after the intro markers are set."  
      Else 
        If DatabaseSong\IntroLoopEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\IntroLoopEnd 
          Errors + "Intro loop begin marker must be set before the intro loop end marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec <= DatabaseSong\IntroStart
          Errors + "Intro loop begin marker must be set after the intro begin marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\IntroEnd
          Errors + "Intro loop begin marker must be set before the intro end marker." + Chr(13)          
        EndIf                
      EndIf
      
      If Errors = ""      
        If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And MessageRequester("Warning", "Do you really want to replace the intro begin loop marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf            
        DatabaseSong\IntroLoopStart = DatabaseSong\CursorSec    
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Intro loop end"
      If DatabaseSong\IntroStart = 0 Or DatabaseSong\IntroEnd = 0  
        Errors + "Intro loop end marker can only be set after the intro markers are set."  
      Else 
        If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroLoopStart
          Errors + "Intro loop end marker must be set after the intro loop begin marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec <= DatabaseSong\IntroStart
          Errors + "Intro loop end marker must be set after the intro begin marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\IntroEnd
          Errors + "Intro loop end marker must be set before the intro end marker." + Chr(13)          
        EndIf                
      EndIf     
      
      If Errors = ""
        If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the intro end loop marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf       
        DatabaseSong\IntroLoopEnd = DatabaseSong\CursorSec
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf  
    Case "Break loop begin"
      If DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0  
        Errors + "Break loop begin marker can only be set after the break markers are set."  
      Else 
        If DatabaseSong\BreakLoopEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakLoopEnd 
          Errors + "Break loop begin marker must be set before the break loop end marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec <= DatabaseSong\BreakStart
          Errors + "Break loop begin marker must be set after the break begin marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\BreakEnd
          Errors + "Break loop begin marker must be set before the break end marker." + Chr(13)          
        EndIf                
      EndIf
      
      If Errors = ""      
        If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the break loop begin marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf       
        DatabaseSong\BreakLoopStart = DatabaseSong\CursorSec
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Break loop end"     
      If DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0  
        Errors + "Break loop end marker can only be set after the break markers are set."  
      Else 
        If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\CursorSec <= DatabaseSong\BreakLoopStart
          Errors + "Break loop end marker must be set after the break loop begin marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec <= DatabaseSong\BreakStart
          Errors + "Break loop end marker must be set after the break begin marker." + Chr(13)          
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\BreakEnd
          Errors + "Break loop end marker must be set before the break end marker." + Chr(13)          
        EndIf                
      EndIf    
      
      If Errors = ""            
        If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the break loop end marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf        
        DatabaseSong\BreakLoopEnd = DatabaseSong\CursorSec
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Intro begin"    
      If (DatabaseSong\BreakStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakStart) Or (DatabaseSong\BreakEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakEnd)
        Errors + "Intro begin marker must be set before the break markers." + Chr(13)          
      EndIf
   
      If (DatabaseSong\SkipStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\SkipStart) Or (DatabaseSong\SkipEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\SkipEnd)
        Errors + "Intro begin marker must be set before the skip markers." + Chr(13)          
      EndIf        
      
      If DatabaseSong\IntroEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\IntroEnd
        Errors + "Intro begin marker must be set before the intro end marker." + Chr(13)          
      EndIf
      
      If Errors = ""
        If DatabaseSong\IntroStart > 0 And DatabaseSong\IntroEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the intro begin marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf
        
        DatabaseSong\IntroStart = DatabaseSong\CursorSec
        If BPM >= 60 And DatabaseSong\IntroEnd = 0 And PosPlusSec < SongLengthSec             
          DatabaseSong\IntroEnd = PosPlusSec
        EndIf
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Intro end"
      If (DatabaseSong\BreakStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakStart) Or (DatabaseSong\BreakEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakEnd)      
        Errors + "Intro end marker must be set before the break markers." + Chr(13)                  
      EndIf
      
      If (DatabaseSong\SkipStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\SkipStart) Or (DatabaseSong\SkipEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\SkipEnd)
        Errors + "Intro end marker must be set before the skip markers." + Chr(13)          
      EndIf       
      
      If DatabaseSong\IntroStart > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroStart
        Errors + "Intro end marker must be set after the intro begin marker." + Chr(13)          
      EndIf      
      
      If Errors = ""      
        If DatabaseSong\IntroStart > 0 And DatabaseSong\IntroEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the intro end marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf  
        
        DatabaseSong\IntroEnd = DatabaseSong\CursorSec 
        If BPM >= 60 And DatabaseSong\IntroStart = 0 And PosMinSec >= 0
          DatabaseSong\IntroStart =  PosMinSec
        EndIf               
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Intro prestart" 
      If DatabaseSong\IntroStart = 0
        Errors + "Intro prestart marker can only be set after the intro begin marker is set."
      ElseIf DatabaseSong\IntroStart > 0 And DatabaseSong\CursorSec >= DatabaseSong\IntroStart
        Errors + "Intro prestart marker must be set before the intro begin marker." + Chr(13)          
      EndIf      
      
      If Errors = ""
        DatabaseSong\IntroPrefix = DatabaseSong\IntroStart - DatabaseSong\CursorSec
      EndIf
    Case "Break begin"
      If DatabaseSong\IntroEnd > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroEnd
        Errors + "Break begin marker must be set after the introend marker." + Chr(13)   
      EndIf
      
      If DatabaseSong\SkipEnd > 0 And DatabaseSong\CursorSec <= DatabaseSong\SkipEnd
        Errors + "Break begin marker must be set after the skip end marker." + Chr(13)          
      EndIf         
      
      If DatabaseSong\BreakEnd > 0 And DatabaseSong\CursorSec >= DatabaseSong\BreakEnd
        Errors + "Break begin marker must be set before the break end marker." + Chr(13)          
      EndIf         
      
      If Errors = ""      
        If DatabaseSong\BreakStart > 0 And DatabaseSong\BreakEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the break begin marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf      
        
        DatabaseSong\BreakStart = DatabaseSong\CursorSec   
        If BPM >= 60 And DatabaseSong\BreakEnd = 0 And PosPlusSec < SongLengthSec       
          DatabaseSong\BreakEnd = PosPlusSec
        EndIf            
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Break end"
      If (DatabaseSong\IntroStart > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroStart) Or (DatabaseSong\IntroEnd > 0 And DatabaseSong\CursorSec <= DatabaseSong\IntroEnd)
        Errors + "Break end marker must be set after the intro markers." + Chr(13)          
      EndIf
       
      If DatabaseSong\SkipEnd > 0 And DatabaseSong\CursorSec <= DatabaseSong\SkipEnd
        Errors + "break end marker must be set after the skip end marker." + Chr(13)          
      EndIf   
      
      If DatabaseSong\BreakStart > 0 And DatabaseSong\CursorSec <= DatabaseSong\BreakStart
        Errors + "Break end marker must be set after the break begin marker." + Chr(13)          
      EndIf      
      
      If Errors = ""        
        If DatabaseSong\BreakStart > 0 And DatabaseSong\BreakEnd > 0 And MessageRequester("Warning", "Are you sure you want to replace the break end marker?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
          ProcedureReturn
        EndIf 
        
        DatabaseSong\BreakEnd = DatabaseSong\CursorSec
        If BPM >= 60 And DatabaseSong\BreakStart = 0 And PosMinSec >= 0
          DatabaseSong\BreakStart = PosMinSec
        EndIf               
        DatabaseSong\BPM = CalculateExactBPM()        
        SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))
      EndIf
    Case "Break mute" 
      If DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0
        Errors + "Break mute marker can only be set after the break markers are set."       
      Else       
        If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And (DatabaseSong\CursorSec => DatabaseSong\BreakLoopStart Or DatabaseSong\CursorSec <= DatabaseSong\BreakLoopEnd)
          Errors + "Break mute marker can not be set between break loop markers." + Chr(13)                          
        EndIf        
        If DatabaseSong\BreakContinue > 0
          Errors + "Break mute marker can not be combined with a break continue marker." + Chr(13)                          
        EndIf
        
        If DatabaseSong\CursorSec <= DatabaseSong\BreakStart
          Errors + "Break mute marker must be set after the break begin marker." + Chr(13)                          
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\BreakEnd
          Errors + "Break mute marker must be set before the break end marker." + Chr(13)                          
        EndIf        
      EndIf
      
      If Errors = ""        
        DatabaseSong\BreakMute = DatabaseSong\BreakEnd - DatabaseSong\CursorSec
      EndIf
    Case "Break continue"
      If DatabaseSong\BreakMute > 0
        Errors + "Break continue marker can not be combined with a break mute marker." + Chr(13)                          
      EndIf
        
      If DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0
        Errors + "Break continue marker can only be set after the break markers are set."  
      ElseIf DatabaseSong\CursorSec <= DatabaseSong\BreakEnd
        Errors + "Break continue marker must be set after the break end marker." + Chr(13)                  
      EndIf
      
      If Errors = ""
        DatabaseSong\BreakContinue = DatabaseSong\CursorSec - DatabaseSong\BreakEnd
      EndIf
    Case "Intro beat"  
      If DatabaseSong\IntroStart = 0 Or DatabaseSong\IntroEnd = 0  
        Errors + "Intro beat marker can only be set after the intro markers are set." 
      Else
        If DatabaseSong\CursorSec <= DatabaseSong\IntroStart  
          Errors + "Intro beat marker must be set after the intro begin marker." + Chr(13)
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\IntroEnd
          Errors + "Intro beat marker must be set before the intro end marker." + Chr(13)
        EndIf        
      EndIf
      
      If Errors = ""        
        LastBeat = CountString(IntroList, Chr(10))
        DatabaseSong\IntroBeatList = IntroList + GetGadgetText(#CursorPosString) + Chr(10) 
      EndIf
    Case "Break beat"       
      If DatabaseSong\BreakStart = 0 Or DatabaseSong\BreakEnd = 0
        Errors + "Break beat marker can only be set after the break markers are set."  
      Else
        If DatabaseSong\CursorSec <= DatabaseSong\BreakStart  
          Errors + "Break beat marker must be set after the break begin marker." + Chr(13)
        EndIf
        
        If DatabaseSong\CursorSec >= DatabaseSong\BreakEnd
          Errors + "Break beat marker must be set before the break end marker." + Chr(13)
        EndIf        
      EndIf
      
      If Errors = ""        
        LastBeat = CountString(BreakList, Chr(10))
        DatabaseSong\BreakBeatList = BreakList + GetGadgetText(#CursorPosString) + Chr(10)
      EndIf
  EndSelect
  
  If Errors <> ""
    MessageRequester("Action not allowed", Errors, #PB_MessageRequester_Warning)  
  Else
    DrawMarkers(#FirstWaveImage)
    DrawCursor()    
  EndIf
  
  SetActiveGadget(#CanvasWaveform)  
EndProcedure

Procedure ButtonDeleteMarker()
  Protected.s IntroList = ReplaceString(DatabaseSong\IntroBeatList, Chr(13), Chr(10))
  Protected.s BreakList = ReplaceString(DatabaseSong\BreakBeatList, Chr(13), Chr(10))  
  Protected.i LastBeat
  
  Select GetGadgetText(#Combo_Marker)
    Case "Skip begin"
      DatabaseSong\SkipStart = 0     
    Case "Skip end"
      DatabaseSong\SkipEnd = 0
    Case "Intro begin"
      DatabaseSong\IntroStart = 0
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))
    Case "Intro end"
      DatabaseSong\IntroEnd = 0         
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))
    Case "Intro loop begin"
      DatabaseSong\IntroLoopStart = 0    
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))        
    Case "Intro loop end"
      DatabaseSong\IntroLoopEnd = 0        
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))        
    Case "Intro prestart"
      DatabaseSong\IntroPrefix = 0      
    Case "Break begin"
      DatabaseSong\BreakStart = 0           
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))      
    Case "Break end"
      DatabaseSong\BreakEnd = 0             
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))  
    Case "Intro loop begin"
      DatabaseSong\IntroLoopStart = 0
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))        
    Case "Intro loop end"
      DatabaseSong\IntroLoopEnd = 0      
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))    
    Case "Break loop begin"
      DatabaseSong\BreakLoopStart = 0 
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))        
    Case "Break loop end"
      DatabaseSong\BreakLoopEnd = 0      
      SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))         
    Case "Break mute"  
      DatabaseSong\BreakMute = 0    
    Case "Break continue"
      DatabaseSong\BreakContinue = 0    
    Case "Intro beat"   
      LastBeat = CountString(IntroList, Chr(10))
      If LastBeat > 0
        DatabaseSong\IntroBeatList = Left(IntroList, Len(IntroList) - 11)
      Else 
         DatabaseSong\IntroBeatList = ""
      EndIf     
    Case "Break beat"    
      LastBeat = CountString(BreakList, Chr(10))
      If LastBeat > 0
         DatabaseSong\BreakBeatList = Left(BreakList, Len(BreakList) - 11)
      Else 
         DatabaseSong\BreakBeatList = ""
      EndIf          
  EndSelect  

  DrawMarkers(#FirstWaveImage)
  DrawCursor()
  SetActiveGadget(#CanvasWaveform)  
EndProcedure

Procedure ButtonCancelDatabaseAddRecord()
  If GetGadgetText(#SleeveString) <> "" Or Trim(GetGadgetText(#ArtistString)) <> "" Or Trim(GetGadgetText(#TitleString)) <> "" Or Trim(GetGadgetText(#YearString)) <> "" Or 
     Trim(GetGadgetText(#LabelString)) <> "" Or Trim(GetGadgetText(#CatNoString)) <> "" Or Trim(GetGadgetText(#CountryString)) <> "" Or 
     GetGadgetState(#IntroFadeIn) Or DatabaseSong\IntroPrefix > 0 Or DatabaseSong\IntroStart > 0 Or DatabaseSong\IntroEnd > 0 Or DatabaseSong\IntroLoopStart > 0 Or DatabaseSong\IntroLoopEnd > 0 Or 
     GetGadgetState(#BreakFadeOut) Or DatabaseSong\BreakStart > 0 Or DatabaseSong\BreakEnd > 0 Or DatabaseSong\BreakContinue > 0 Or DatabaseSong\BreakLoopStart > 0 Or DatabaseSong\BreakLoopEnd > 0 Or DatabaseSong\BreakMute > 0 Or 
     DatabaseSong\SkipStart > 0 Or DatabaseSong\SkipEnd > 0 Or GetGadgetState(#IntroHasBass) Or GetGadgetState(#IntroHasBeats) Or GetGadgetState(#IntroHasMelody) Or GetGadgetState(#IntroHasVocal) Or
     GetGadgetState(#BreakHasBass) Or GetGadgetState(#BreakHasBeats) Or GetGadgetState(#BreakHasMelody) Or GetGadgetState(#BreakHasVocal) 
    
    If AllGadgetsData() <> DatabaseRecordData
      If MessageRequester("Warning", "Changes are not saved. Do you really want to cancel?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
        ProcedureReturn
      EndIf
    EndIf
  EndIf
  
  ButtonStopDatabaseAddRecordSong()
  ReDim MM(0)
  
  If IsImage(#OriginalWaveImage)
    FreeImage(#OriginalWaveImage)
  EndIf
  
  If IsImage(#CursorWaveImage)
    FreeImage(#CursorWaveImage)  
  EndIf
  
  If IsImage(#FirstWaveImage)
    FreeImage(#FirstWaveImage)    
  EndIf
  
  If IsImage(#SelectionWaveImage)
    FreeImage(#SelectionWaveImage)    
  EndIf
   
  RemoveWindowTimer(#WindowDatabaseAddRecord, #TimerSizeWindow) 
  
  CloseWindow(#WindowDatabaseAddRecord)
  
  DisableWindow(#WindowMain, #False)
  ;WindowBounds(#WindowMain, WindowWidth(#WindowMain), WindowHeight(#WindowMain), DesktopWidth(0), DesktopHeight(0))  
  
  If PlayerPausedByProgram
    ButtonPlay(#PB_EventType_LeftClick)             
  EndIf     
EndProcedure

Procedure ButtonSaveDatabaseAddRecord()
  Protected.s File, Folder, ID, Song
  Protected.s DBAdd = #AppName + " - Database - Add"
  Protected.s SleeveFilename = ReplaceString(GetGadgetText(#SleeveString), Preferences\PathSleeves, "")
  Protected.s AudioFilename = ReplaceString(DatabaseSong\AudioFilename, Preferences\PathAudio, "")
  Protected.i Row, i, j
  Protected.i DBAddLen = Len(DBAdd) 
        
  If DatabaseSongErrors() <> ""
    ProcedureReturn
  EndIf         
  
  If (GetGadgetState(#IntroHasBass) = 0 And GetGadgetState(#IntroHasBeats) = 0 And GetGadgetState(#IntroHasMelody) = 0 And GetGadgetState(#IntroHasVocal) = 0) Or 
     (GetGadgetState(#BreakHasBass) = 0 And GetGadgetState(#BreakHasBeats) = 0 And GetGadgetState(#BreakHasMelody) = 0 And GetGadgetState(#BreakHasVocal) = 0)
    If MessageRequester("Warning","Intro- and/or break-checkboxes for bass, melody, vocals and beats are empty. Do you want to make changes?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      ProcedureReturn      
    EndIf
  EndIf 

  If Left(GetWindowTitle(#WindowDatabaseAddRecord), DBAddLen) = DBAdd
    ;**************
    ; INSERT RECORD
    ;**************
    
    File = ReplaceString(GetFilePart(DatabaseSong\AudioFilename), "'", "''")    
    Folder = Preferences\PathAudio + ReplaceString(GetPathPart(DatabaseSong\AudioFilename), Preferences\PathAudio, "")
    Folder = ReplaceString(Folder, "'", "''")
    
    If DatabaseUpdate(#DBMusic, "INSERT INTO music (artist, title, bpm, introprefix, introfade, introstart, introend, " + 
                             "introbeatlist, introbeats, introbass, introvocal, intromelody, breakfade, breakstart, " + 
                             "breakend, breakbeatlist, breakbeats, breakbass, breakvocal, breakmelody, genre, " +  
                             "filename, sleeve, `year`, label, catno, country, breakmute, breakcontinue, " +  
                             "introloopstart, introloopend, breakloopstart, breakloopend, introlooprepeat, " +  
                             "breaklooprepeat, skipstart, skipend, samplerate) VALUES ('" + 
                             ReplaceString(GetGadgetText(#ArtistString), "'", "''") + "', '" + 
                             ReplaceString(GetGadgetText(#TitleString), "'", "''") + "', " + 
                             CalculateExactBPM() + ", '" + 
                             Seconds2TimeMS(DatabaseSong\IntroPrefix, 4) + "', " + 
                             GetGadgetState(#IntroFadeIn) + ", '" + 
                             Seconds2TimeMs(DatabaseSong\IntroStart, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\IntroEnd, 4) + "', '" + 
                             DatabaseSong\IntroBeatList + "', " + 
                             GetGadgetState(#IntroHasBeats) + ", " + 
                             GetGadgetState(#IntroHasBass) + ", " + 
                             GetGadgetState(#IntroHasVocal) + ", " + 
                             GetGadgetState(#IntroHasMelody) + ", " + 
                             GetGadgetState(#BreakFadeOut) + ", '" + 
                             Seconds2TimeMS(DatabaseSong\BreakStart, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\BreakEnd, 4) + "', '" + 
                             DatabaseSong\BreakBeatList + "', " + 
                             GetGadgetState(#BreakHasBeats) + ", " + 
                             GetGadgetState(#BreakHasBass) + ", " + 
                             GetGadgetState(#BreakHasVocal) + ", " + 
                             GetGadgetState(#BreakHasMelody) + ", '" + 
                             ReplaceString(GetGadgetText(#GenreString), "'", "''") + "', '" + 
                             ReplaceString(AudioFilename, "'", "''") + "', '" + 
                             ReplaceString(SleeveFilename, "'", "''") + "', " + 
                             Val(GetGadgetText(#YearString)) + ", " + "'" + 
                             ReplaceString(GetGadgetText(#LabelString), "'", "''") + "', '" + 
                             ReplaceString(GetGadgetText(#CatNoString), "'", "''") + "', '" + 
                             ReplaceString(GetGadgetText(#CountryString), "'", "''") + "', '" + 
                             Seconds2TimeMS(DatabaseSong\BreakMute, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\BreakContinue, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\IntroLoopStart, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\IntroLoopEnd, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\BreakLoopStart, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\BreakLoopEnd, 4) + "', " +  
                             DatabaseSong\IntroLoopRepeat + ", " +  
                             DatabaseSong\BreakLoopRepeat + ", '" + 
                             Seconds2TimeMS(DatabaseSong\SkipStart, 4) + "', '" + 
                             Seconds2TimeMS(DatabaseSong\SkipEnd, 4) + "', " +         
                             DatabaseSong\OrigFreq + ")")         

      DatabaseUpdate(#DBFiles, "UPDATE files SET added='Yes' WHERE file='" + File + "' AND folder='" + Folder + "'")          
      
      If GetGadgetState(#Panel) = 2
        Row = GetGadgetState(#ListiconMusicLibrary)        
        SetGadgetItemText(#ListiconMusicLibrary, Row, "Yes", 0)  
        DisableWindow(#WindowMain, #False)   
      ElseIf GetGadgetState(#Panel) = 1   
        DatabaseQuery(#DBMusic, "SELECT id, artist, title, label, catno, country, year, genre, bpm, filename FROM music ORDER BY id DESC LIMIT 1")
        NextDatabaseRow(#DBMusic)       
        
        If Trim(GetDatabaseString(#DBMusic, 1)) = "" And Trim(GetDatabaseString(#DBMusic, 2)) = ""
          Song = OSPath(GetFilePart(GetDatabaseString(#DBMusic, 9))) 
        Else
          Song = GetDatabaseString(#DBMusic, 1) + " - " + GetDatabaseString(#DBMusic, 2)  
        EndIf
    
        AddGadgetItem(#ListiconDatabase, -1, UCase(GetDatabaseString(#DBMusic, 0) + Chr(10) + 
                                             Song + Chr(10) +
                                             GetDatabaseString(#DBMusic, 3) + Chr(10) +
                                             GetDatabaseString(#DBMusic, 4) + Chr(10) +
                                             GetDatabaseString(#DBMusic, 5) + Chr(10) +
                                             GetDatabaseString(#DBMusic, 6) + Chr(10) +
                                             GetDatabaseString(#DBMusic, 7) + Chr(10) +
                                             RSet(FormatNumber(GetDatabaseFloat(#DBMusic, 8)), 6, "0") + Chr(10)))
        FinishDatabaseQuery(#DBMusic)
        SelectRow(#ListiconDatabase, CountGadgetItems(#ListiconDatabase) - 1)
        DisableWindow(#WindowMain, #False)   
      EndIf
    EndIf    
  Else 
    ;**************
    ; UPDATE RECORD
    ;**************     
 
    If DatabaseUpdate(#DBMusic, "UPDATE music SET artist='" + ReplaceString(GetGadgetText(#ArtistString), "'", "''") + "', " +
                                "title='" + ReplaceString(GetGadgetText(#TitleString), "'", "''") + "', " + 
                                "bpm=" + CalculateExactBPM() + ", " +  
                                "introprefix='" + Seconds2TimeMS(DatabaseSong\IntroPrefix, 4) + "', " +
                                "introfade=" + GetGadgetState(#IntroFadeIn) + ", " +
                                "introstart='" + Seconds2TimeMS(DatabaseSong\IntroStart, 4) + "', " +
                                "introend='" + Seconds2TimeMS(DatabaseSong\IntroEnd, 4) + "', " + 
                                "introbeatlist='" + DatabaseSong\IntroBeatList + "', " +
                                "introbeats=" + GetGadgetState(#IntroHasBeats) + ", " +
                                "introbass=" + GetGadgetState(#IntroHasBass) + ", " +
                                "introvocal=" + GetGadgetState(#IntroHasVocal) + ", " +
                                "intromelody=" + GetGadgetState(#IntroHasMelody) + ", " +
                                "breakfade=" + GetGadgetState(#BreakFadeOut) + ", " +
                                "breakstart='" + Seconds2TimeMS(DatabaseSong\BreakStart, 4) + "', " + 
                                "breakend='" + Seconds2TimeMS(DatabaseSong\BreakEnd, 4) + "', " + 
                                "breakbeatlist='" + DatabaseSong\BreakBeatList + "'," +
                                "breakbeats=" + GetGadgetState(#BreakHasBeats) + ", " +
                                "breakbass=" + GetGadgetState(#BreakHasBass) + ", " +
                                "breakvocal=" + GetGadgetState(#BreakHasVocal) + ", " +
                                "breakmelody=" + GetGadgetState(#BreakHasMelody) + ", " +
                                "genre='" + ReplaceString(GetGadgetText(#GenreString), "'", "''") + "', " +
                                "filename='" + ReplaceString(AudioFilename, "'", "''") + "', " + 
                                "sleeve='" + ReplaceString(SleeveFilename, "'", "''") + "', " +  
                                "`year`=" + Val(GetGadgetText(#YearString)) + ", " + 
                                "label=" + "'" + ReplaceString(GetGadgetText(#LabelString), "'", "''") + "', " + 
                                "catno='" + ReplaceString(GetGadgetText(#CatNoString), "'", "''") + "', " + 
                                "country='" + ReplaceString(GetGadgetText(#CountryString), "'", "''") + "', " +  
                                "breakmute='" + Seconds2TimeMS(DatabaseSong\BreakMute, 4) + "', " +  
                                "breakcontinue='" + Seconds2TimeMS(DatabaseSong\BreakContinue, 4) + "', " +  
                                "introloopstart='" + Seconds2TimeMS(DatabaseSong\IntroLoopStart, 4) + "', " +  
                                "introloopend='" + Seconds2TimeMS(DatabaseSong\IntroLoopEnd, 4) + "', " +  
                                "breakloopstart='" + Seconds2TimeMS(DatabaseSong\BreakLoopStart, 4) + "', " +  
                                "breakloopend='" + Seconds2TimeMS(DatabaseSong\BreakLoopEnd, 4) + "', " +  
                                "introlooprepeat=" + DatabaseSong\IntroLoopRepeat + ", " + 
                                "breaklooprepeat=" + DatabaseSong\BreakLoopRepeat + ", " +
                                "skipstart='" + Seconds2TimeMS(DatabaseSong\SkipStart, 4) + "', " +  
                                "skipend='" + Seconds2TimeMS(DatabaseSong\SkipEnd, 4) + "', " +       
                                "samplerate=" +  DatabaseSong\OrigFreq +                                    
                                " WHERE ID='" + DatabaseSong\ID + "'")   
      
      ;if songs in playlist, update song in playlist with markers and duration  
      If Mix(CurrentSong)\ID = DatabaseSong\ID
        UpdateSongInPlaylist()
      EndIf
    EndIf
    DisableWindow(#WindowMain, #False)      
  EndIf     
  
  ButtonStopDatabaseAddRecordSong()
  RemoveWindowTimer(#WindowDatabaseAddRecord, #TimerSizeWindow) 

  If GetGadgetState(#Panel) = 1  
    DisableWindow(#WindowMain, #False) 
    Row = GetGadgetState(#ListiconDatabase) 
    
    If Trim(GetGadgetText(#ArtistString)) = "" And Trim(GetGadgetText(#TitleString)) = ""
      Song = GetFilePart(DatabaseSong\AudioFilename) 
    Else
      Song = GetGadgetText(#ArtistString) + " - " + GetGadgetText(#TitleString)  
    EndIf      
    
    If Left(GetWindowTitle(#WindowDatabaseAddRecord), DBAddLen) = DBAdd Or 
       (Left(GetWindowTitle(#WindowDatabaseAddRecord), DBAddLen) <> DBAdd And DatabaseSong\ID = GetGadgetItemText(#ListiconDatabase, Row, 0))
      SetGadgetItemText(#ListiconDatabase, Row, UCase(GetGadgetText(#LabelString)), 2)
      SetGadgetItemText(#ListiconDatabase, Row, UCase(GetGadgetText(#CatNoString)), 3)
      SetGadgetItemText(#ListiconDatabase, Row, UCase(GetGadgetText(#CountryString)), 4)
      SetGadgetItemText(#ListiconDatabase, Row, GetGadgetText(#YearString), 5)
      SetGadgetItemText(#ListiconDatabase, Row, UCase(GetGadgetText(#GenreString)), 6)
      SetGadgetItemText(#ListiconDatabase, Row, RSet(FormatNumber(CalculateExactBPM()), 6, "0"), 7) 
      SetGadgetItemText(#ListiconDatabase, Row, UCase(Song), 1) 
    EndIf
  
    If Visible\ListiconDatabaseSearch
      Row = GetGadgetState(#ListiconDatabaseSearch)    
      
      SetGadgetItemText(#ListiconDatabaseSearch, Row, UCase(GetGadgetText(#LabelString)), 2)
      SetGadgetItemText(#ListiconDatabaseSearch, Row, UCase(GetGadgetText(#CatNoString)), 3)
      SetGadgetItemText(#ListiconDatabaseSearch, Row, UCase(GetGadgetText(#CountryString)), 4)
      SetGadgetItemText(#ListiconDatabaseSearch, Row, UCase(GetGadgetText(#YearString)), 5)
      SetGadgetItemText(#ListiconDatabaseSearch, Row, UCase(GetGadgetText(#GenreString)), 6)
      SetGadgetItemText(#ListiconDatabaseSearch, Row, RSet(FormatNumber(CalculateExactBPM()), 6, "0"), 7) 
      SetGadgetItemText(#ListiconDatabaseSearch, Row, UCase(Song), 1)     
    EndIf
  EndIf
  
  CloseWindow(#WindowDatabaseAddRecord)  
 ; WindowBounds(#WindowMain, WindowWidth(#WindowMain), WindowHeight(#WindowMain), DesktopWidth(0), DesktopHeight(0))  

  ReDim MM(0)
  
  If PlayerPausedByProgram
    ButtonPlay(#PB_EventType_LeftClick)             
  EndIf     
EndProcedure

Procedure BPMString()
  Protected.s String = GetGadgetText(#BPMString)
  Protected.s NewString
  Protected.i i, Character
  Protected.i Length = Len(String)   
  
  ;Allow only numbers and dot
  For i = 1 To Length
    Character = Asc(Mid(String, i, 1))
    If (Character >= 48 And Character <= 57) Or Character = 46
      NewString + Chr(Character)
    EndIf
  Next
  
  ;Allow string length of 6 characters
  If Len(NewString) > 6
    NewString = Left(NewString, 6)
  EndIf
  
  SetGadgetText(#BPMString, NewString)
EndProcedure

Procedure ButtonSleeveString()
  Protected.i Image
  Protected.s Path, File, Extension  
  Protected.s Pattern = "All image files (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.bmp|" + 
          "JPG files (*.jpg)|*.jpg|" +
          "JPEG files (*.jpeg)|*.jpeg|" +
          "PNG files (*.png)|*.png|" +
          "BMP files (*.bmp)|*.bmp"
  
  If GetGadgetText(#SleeveString) <> ""
    Path = GetGadgetText(#SleeveString)
  Else
    Path = Preferences\PathSleeves
  EndIf
  
  File = OSPath(OpenFileRequester("Choose image file", Path, Pattern, 0))
  
  If File 
    If FindString(File, Preferences\PathSleeves) = 0 
      MessageRequester("File open error", "Please choose a file from your sleeves path " + Preferences\PathSleeves, #PB_MessageRequester_Error)        
    Else      
      Extension = LCase(GetExtensionPart(File))
      Select Extension
        Case "jpg"
          Image = LoadImage(#PB_Any, File, UseJPEGImageDecoder())          
        Case "png"
          Image = LoadImage(#PB_Any, File, UsePNGImageDecoder())                    
        Case "bmp"
          Image = LoadImage(#PB_Any, File)                    
      EndSelect

      If Not Image
        Image = CreateImage(#PB_Any,  110, 110, 32, #Gray)
      Else
        ResizeImage(Image, 110, 110)        
        SetGadgetState(GadgetNumber\SleeveDatabase, ImageID(Image))
        SetGadgetText(#SleeveString, File)
      EndIf
    EndIf
  EndIf  
EndProcedure 

Procedure CanvasWaveform(EventType)   
  Protected.i xpos = WindowMouseX(#WindowDatabaseAddRecord) - GadgetX(#CanvasWaveform)
  Protected.i ypos = WindowMouseY(#WindowDatabaseAddRecord) - GadgetY(#CanvasWaveform) + 200
  Protected.i Modifiers, Key
  Protected.q BeginBytes, Pos2Bytes
  Protected.f Pos2Sec
  Protected.b PlaySong
    
  If xpos >= 0 And xpos <= GadgetWidth(#CanvasWaveform)  
    BeginBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewBegin)
    Pos2Bytes = BeginBytes + (DatabaseSong\BytesPerPixel * xpos)
    Pos2Sec = BASS_ChannelBytes2Seconds(Chan\Database, Pos2Bytes)
       
    If (DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And xpos >= SectionX(DatabaseSong\IntroLoopStart) And xpos <= SectionX(DatabaseSong\IntroLoopEnd)) Or (DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And xpos >= SectionX(DatabaseSong\BreakLoopStart) And xpos <= SectionX(DatabaseSong\BreakLoopEnd))
      GadgetToolTip(#CanvasWaveform, Seconds2TimeMS(Pos2Sec) + " - Right-click to set how many times the loop should repeat.")      
    Else
      GadgetToolTip(#CanvasWaveform, Seconds2TimeMS(Pos2Sec))    
    EndIf
    
    Select EventType
      Case #PB_EventType_LeftDoubleClick     
        DoubleClickSelection(#True)        
      Case #PB_EventType_RightDoubleClick     
        DatabaseSong\CursorX = xpos
        DrawCursor()               
        DrawSelection(xpos)   
        DoubleClickSelection(#False)   
      Case #PB_EventType_RightClick
        If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And xpos >= SectionX(DatabaseSong\IntroLoopStart) And xpos <= SectionX(DatabaseSong\IntroLoopEnd)
          AskRepeatQuestion("intro", DatabaseSong\IntroLoopRepeat)
        ElseIf DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And xpos >= SectionX(DatabaseSong\BreakLoopStart) And xpos <= SectionX(DatabaseSong\BreakLoopEnd)
          AskRepeatQuestion("break", DatabaseSong\BreakLoopRepeat)         
        EndIf        
      Case #PB_EventType_KeyDown    
        Key = GetGadgetAttribute(#CanvasWaveform, #PB_Canvas_Key) 
        Modifiers = GetGadgetAttribute(#CanvasWaveform, #PB_Canvas_Modifiers)
        
        Select Key
          Case #PB_Shortcut_Space
            If BASS_ChannelIsActive(Chan\Database) <> #BASS_ACTIVE_PLAYING
              ButtonPlayDatabaseAddRecordSong()
            Else
              ButtonStopDatabaseAddRecordSong()          
            EndIf     
          Case #PB_Shortcut_I
            If modifiers & #PB_Canvas_Shift
              SetGadgetText(#Combo_Marker, "Intro end")
            Else
              SetGadgetText(#Combo_Marker, "Intro begin")
            EndIf    
            ButtonAddMarker()
          Case #PB_Shortcut_B
            If modifiers & #PB_Canvas_Shift
              SetGadgetText(#Combo_Marker, "Break end")
            Else
              SetGadgetText(#Combo_Marker, "Break begin")
            EndIf    
            ButtonAddMarker() 
          Case #PB_Shortcut_S
            If modifiers & #PB_Canvas_Shift
              SetGadgetText(#Combo_Marker, "Skip end")
            Else
              SetGadgetText(#Combo_Marker, "Skip begin")
            EndIf    
            ButtonAddMarker() 
          Case #PB_Shortcut_M
            SetGadgetText(#Combo_Marker, "Break mute")  
            ButtonAddMarker() 
          Case #PB_Shortcut_C
            SetGadgetText(#Combo_Marker, "Break continue")  
            ButtonAddMarker()  
          Case #PB_Shortcut_P
            SetGadgetText(#Combo_Marker, "Intro prestart")  
            ButtonAddMarker()                    
        EndSelect
      Case #PB_EventType_LeftButtonUp   
        ButtonDown = #False
      Case #PB_EventType_LeftButtonDown        
        ButtonDown = #True
        DatabaseSong\CursorX = xpos
        DrawCursor()               
        DrawSelection(xpos)  
      Case #PB_EventType_MouseMove 
        If ButtonDown
          DrawSelection(xpos)
        EndIf
      Case #PB_EventType_MouseWheel 
        If GetGadgetAttribute(#CanvasWaveform, #PB_Canvas_WheelDelta) = -1     
          ButtonZoomOut()  
        Else
          ButtonZoomIn()  
        EndIf    
    EndSelect   
  EndIf
EndProcedure


Procedure ArtistString(EventType)
  FieldPopup(EventType, #ListviewArtist, #ArtistString, #ContainerArtist)
EndProcedure

Procedure ListviewArtist(EventType)
  FieldPopupSelect(EventType, #ListviewArtist, #ArtistString)
EndProcedure

Procedure LabelString(EventType)
  FieldPopup(EventType, #ListviewLabel, #LabelString, #ContainerLabel)
EndProcedure

Procedure ListviewLabel(EventType)  
  FieldPopupSelect(EventType, #ListviewLabel, #LabelString)
EndProcedure

Procedure CountryString(EventType)
  FieldPopup(EventType, #ListviewCountry, #CountryString, #ContainerCountry)
EndProcedure

Procedure ListviewCountry(EventType)
  FieldPopupSelect(EventType, #ListviewCountry, #CountryString)
EndProcedure

Procedure YearString(EventType)
  FieldPopup(EventType, #ListviewYear, #YearString, #ContainerYear)
EndProcedure

Procedure ListviewYear(EventType)
  FieldPopupSelect(EventType, #ListviewYear, #YearString)
EndProcedure
  
Procedure GenreString(EventType)
  FieldPopup(EventType, #ListviewGenre, #GenreString, #ContainerGenre)
EndProcedure

Procedure ListviewGenre(EventType)
  FieldPopupSelect(EventType, #ListviewGenre, #GenreString)
EndProcedure

Procedure TrackbarScale()
  Protected.q PosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)  
  Protected.q Length = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewEnd - DatabaseSong\ViewBegin)
  Protected.q NumSamples = Length >> 2
  Protected.i SamplesPerElement = NumSamples / GadgetWidth(#CanvasWaveform)
  Protected *WaveData = AllocateMemory(Length)
  
  ReDim MM.MinMax(NumSamples / SamplesPerElement)
  
  BASS_ChannelSetPosition(Chan\DecodedDatabase, PosBytes, #BASS_POS_BYTE)      
  BASS_ChannelGetData(Chan\DecodedDatabase, *WaveData, Length)
  
  DatabaseSong\BytesPerPixel = SamplesPerElement << 2  
   
  MinMaxScaled(@MM(), SamplesPerElement, *WaveData, NumSamples, GetGadgetState(#TrackbarScale))
  UpdateCanvas()  
  
  DrawMarkers() 
  CalcCursorPos(DatabaseSong\ViewBegin)

  If DatabaseSong\SelectionLength > 0 
    RedrawSelection()
  Else
    DrawCursor()
  EndIf    
EndProcedure

;------------------------------------ Window database beat sync test events

Procedure ButtonCancelBeatSyncTest()
  ButtonStopIntroBeatSyncTest()
  ButtonStopBreakBeatSyncTest()
  
  CloseWindow(#WindowBeatSyncTest)
  DisableWindow(#WindowDatabaseAddRecord, #False) 
EndProcedure

Procedure ButtonPlayIntroBeatSyncTest()
  Protected.q StartTime2Bytes, EndTime2Bytes 
  Protected.s BeatFilename = OSPath("assets/beats.wav")
  Protected.s SongFilename = DatabaseSong\AudioFilename
  Protected.f IntroLength = TransitionLength(DatabaseSong\IntroStart, DatabaseSong\IntroEnd, DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd, DatabaseSong\IntroLoopRepeat)  
  Protected.f MaxVol = GetGadgetState(#TrackbarVolume) / 100
 
  If BreakSyncTestPlaying  
    RemoveWindowTimer(#WindowBeatSyncTest, #TrackbarBreakBeatSyncTestTimer)
    SetGadgetState(#TrackbarBreakBeatSyncTest, 0)  
    SetGadgetText(#LabelTestBreakTime, "-" + Seconds2Time(GetGadgetAttribute(#TrackbarBreakBeatSyncTest, #PB_TrackBar_Maximum) / 1000, #False))    
  EndIf  
  
  DatabaseSong\BeatCounter = 0
  DatabaseSong\IntroLoopCounter = 0  
  IntroSyncTestPlaying = #True
  BreakSyncTestPlaying = #False
  
  ButtonStopIntroBeatSyncTest()  
  ;ButtonStopBreakBeatSyncTest() 
  
  AddWindowTimer(#WindowBeatSyncTest, #TrackbarIntroBeatSyncTestTimer, 100)
  
  Chan\Beat = CreateChannel(BeatFilename, #BASS_ASYNCFILE|#BASS_STREAM_DECODE|#BASS_SAMPLE_FLOAT)              
  Chan\Song = CreateChannel(SongFilename, #BASS_ASYNCFILE|#BASS_STREAM_DECODE|#BASS_SAMPLE_FLOAT)              
                 
  BASS_ChannelSetPosition(Chan\Song, BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\IntroStart - DatabaseSong\IntroPrefix - 0.005), #BASS_POS_BYTE)
 
  BASS_Mixer_StreamAddChannel(Chan\MixerBeatTest, Chan\Song, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN)    
  
  StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\IntroStart)         
  BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @StartBeatSyncLoop(), 1)    
  
  StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\IntroStart)         
  BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @BeatTestSynchronizer(), 1)          
   
  StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\IntroEnd)       
  BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @ButtonStopIntroBeatSyncTest(), 0)  
  
  If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And DatabaseSong\IntroLoopRepeat > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\IntroLoopStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\IntroLoopEnd)
    BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTime2Bytes, @IntroTestLoop(), StartTime2Bytes)
  EndIf  
 
  If GetGadgetState(#IntroFadeIn) 
    Volume(Chan\Song, MaxVol, 0.0, IntroLength + DatabaseSong\IntroPrefix) 
  EndIf
        
  BASS_ChannelSetAttribute(Chan\Beat, #BASS_ATTRIB_VOL, GetGadgetState(#TrackbarBeatTestVolume) / 100)      
  BASS_ChannelPlay(Chan\MixerBeatTest, #True)
EndProcedure  

Procedure ButtonStopIntroBeatSyncTest()  
  If Not IntroSyncTestPlaying
    ProcedureReturn
  EndIf
    
  BASS_ChannelStop(Chan\MixerBeatTest)
  BASS_Mixer_ChannelRemove(Chan\Song) 
  BASS_Mixer_ChannelRemove(Chan\Beat)   

  RemoveWindowTimer(#WindowBeatSyncTest, #TrackbarIntroBeatSyncTestTimer)    
  
  SetGadgetState(#TrackbarIntroBeatSyncTest, 0)  
  SetGadgetText(#LabelTestIntroTime, "-" + Seconds2Time(GetGadgetAttribute(#TrackbarIntroBeatSyncTest, #PB_TrackBar_Maximum) / 1000, #False))
EndProcedure  

Procedure ButtonPlayBreakBeatSyncTest()
  Protected.q StartTime2Bytes, EndTime2Bytes
  Protected.s BeatFilename = OSPath("assets/beats.wav")
  Protected.s SongFilename = DatabaseSong\AudioFilename
  Protected.f BreakLength = TransitionLength(DatabaseSong\BreakStart, DatabaseSong\BreakEnd, DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd, DatabaseSong\BreakLoopRepeat)  
  Protected.f MaxVol = GetGadgetState(#TrackbarVolume) / 100  
  Protected.i BreakCont
  
  FileSamplerateIntro = DatabaseSong\OrigFreq  
  
  If DatabaseSong\BreakContinue > 0 
    BreakCont = 1
  EndIf
  
  If IntroSyncTestPlaying  
    RemoveWindowTimer(#WindowBeatSyncTest, #TrackbarIntroBeatSyncTestTimer)
    SetGadgetState(#TrackbarIntroBeatSyncTest, 0)  
    SetGadgetText(#LabelTestIntroTime, "-" + Seconds2Time(GetGadgetAttribute(#TrackbarIntroBeatSyncTest, #PB_TrackBar_Maximum) / 1000, #False))    
  EndIf
  
  DatabaseSong\BeatCounter = 0  
  DatabaseSong\BreakLoopCounter = 0
  BreakSyncTestPlaying = #True
  IntroSyncTestPlaying = #False
  
  ;ButtonStopIntroBeatSyncTest()  
  ButtonStopBreakBeatSyncTest()  
    
  AddWindowTimer(#WindowBeatSyncTest, #TrackbarBreakBeatSyncTestTimer, 100)   
 
  Chan\Beat = CreateChannel(BeatFilename, #BASS_ASYNCFILE|#BASS_STREAM_DECODE|#BASS_SAMPLE_FLOAT)              
  Chan\Song = CreateChannel(SongFilename, #BASS_ASYNCFILE|#BASS_STREAM_DECODE|#BASS_SAMPLE_FLOAT)              
 
  BASS_ChannelSetPosition(Chan\Song, BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakStart - 0.005), #BASS_POS_BYTE)
 
  BASS_Mixer_StreamAddChannel(Chan\MixerBeatTest, Chan\Song, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN)             
  BASS_Mixer_StreamAddChannel(Chan\MixerBeatTest, Chan\Beat, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN)             
  
  StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakStart)         
  BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @BeatTestSynchronizer(), 0)          
   
  StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakEnd)      
  BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @BtnStopBreakBeatSyncTest(), BreakCont)     
  
  If BreakCont
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakEnd + DatabaseSong\BreakContinue)       
    BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @StopBreakBeatSyncTest(), 0)     
  EndIf
  
  If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And DatabaseSong\BreakLoopRepeat > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakLoopStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakLoopEnd)
    BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTime2Bytes, @BreakTestLoop(), StartTime2Bytes)
  EndIf      
  
  If DatabaseSong\BreakMute > 0 
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Chan\Song, DatabaseSong\BreakEnd - DatabaseSong\BreakMute)
    BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @Mute(), 0)    
  EndIf     
  
  If GetGadgetState(#BreakFadeOut)   
    Volume(Chan\Song, 0.0, MaxVol, BreakLength + DatabaseSong\BreakContinue) 
  EndIf 
  
  BASS_ChannelSetAttribute(Chan\Beat, #BASS_ATTRIB_VOL, GetGadgetState(#TrackbarBeatTestVolume) / 100)      
  BASS_ChannelPlay(Chan\MixerBeatTest, #True) 
EndProcedure  

Procedure BtnStopBreakBeatSyncTest(Stream.i, Channel.i, BassData.i, BreakCont.i) 
  If Not BreakCont  
    BASS_ChannelStop(Chan\MixerBeatTest) 
    BASS_Mixer_ChannelRemove(Chan\Song) 
    RemoveWindowTimer(#WindowBeatSyncTest, #TrackbarBreakBeatSyncTestTimer)  
    SetGadgetState(#TrackbarBreakBeatSyncTest, 0)    
    SetGadgetText(#LabelTestBreakTime, "-" + Seconds2Time(GetGadgetAttribute(#TrackbarBreakBeatSyncTest, #PB_TrackBar_Maximum) / 1000, #False))   
  EndIf

  BASS_Mixer_ChannelRemove(Chan\Beat)     
EndProcedure 

Procedure StopBreakBeatSyncTest() 
  BtnStopBreakBeatSyncTest(0, 0, 0, 0)
EndProcedure 

Procedure ButtonStopBreakBeatSyncTest() 
  If Not BreakSyncTestPlaying 
    ProcedureReturn
  EndIf  
  
  BtnStopBreakBeatSyncTest(0, 0, 0, 0)   
EndProcedure  
 
Procedure TrackbarBeatTestVolume()
  Protected.f Volume
  
  Volume = GetGadgetState(#TrackbarBeatTestVolume) / 100
  BASS_ChannelSetAttribute(Chan\Beat, #BASS_ATTRIB_VOL, Volume)    
EndProcedure

;------------------------------------ Window files progress events

Procedure ButtonCancelAddFolder()
  StopCollectingFiles = #True
EndProcedure

;------------------------------------ Window export to audiofile events

Procedure ButtonCancelExport()
  If RawFile <> "" And FileSize(RawFile) <> -1
    DeleteFile(RawFile)
  EndIf
  
  StopDecoding = #True 
EndProcedure
 
;------------------------------------ Functions

Procedure.i WriteWAVHeaderStream(File, DataSize.q, SampleRate, NumChannels, BitsPerSample)
  Protected ChunkSize.q = DataSize + 36
  Protected ByteRate = SampleRate * NumChannels * BitsPerSample / 8
  Protected BlockAlign.w = NumChannels * BitsPerSample / 8

  FileSeek(File, 0)
  
  WriteString(File, "RIFF", #PB_Ascii)
  WriteLong(File, ChunkSize)
  WriteString(File, "WAVE", #PB_Ascii)
  
  ; fmt chunk
  WriteString(File, "fmt ", #PB_Ascii)
  WriteLong(File, 16) ; PCM chunk size
  WriteWord(File, 1)  ; PCM format
  WriteWord(File, NumChannels)
  WriteLong(File, SampleRate)
  WriteLong(File, ByteRate)
  WriteWord(File, BlockAlign)
  WriteWord(File, BitsPerSample)
  
  ; data chunk
  WriteString(File, "data", #PB_Ascii)
  WriteLong(File, DataSize)

  ProcedureReturn Loc(File)
EndProcedure
 
Procedure.b ConvertRawToWav_Stream(RawFile.s, WavFile.s, SampleRate, NumChannels, BitsPerSample)
  Protected BufferSize = 65536 ; 64 KB
  Protected *Buffer = AllocateMemory(BufferSize)
  Protected.q DataSize = 0
  Protected.f Percent
  Protected.i Event, BytesRead, i
  Protected.i FileSize = FileSize(RawFile)
  Protected.i LastUpdateTime = ElapsedMilliseconds()
  Protected.b StopExport = #False  ; <-- Voeg een stop-flag toe

  If *Buffer = 0
    ProcedureReturn #False
  EndIf
  
  If ReadFile(0, RawFile)
    If CreateFile(1, WavFile)
      For i = 1 To 44
        WriteByte(1, 0)
      Next

      Repeat
        BytesRead = ReadData(0, *Buffer, BufferSize)
        
        If BytesRead > 0
          WriteData(1, *Buffer, BytesRead)
          DataSize + BytesRead
          
          If ElapsedMilliseconds() - LastUpdateTime >= 1000
            LastUpdateTime = ElapsedMilliseconds()
            Percent = (DataSize * 100.0) / FileSize 
            SetGadgetState(#ProgressbarExport, Int(Percent))   
            SetGadgetText(#LabelExportPercent, Str(Int(Percent)) + "%")  
            
            Repeat 
              Event = WindowEvent()
              Select Event
                Case #PB_Event_CloseWindow
                  StopExport = #True
                Case #PB_Event_Gadget
                  Select EventGadget()
                    Case #ButtonCancelExport
                      StopExport = #True
                  EndSelect
              EndSelect
            Until Event = 0            
          EndIf
        EndIf       

        Delay(5)
 
        If StopExport
          Break
        EndIf

      Until BytesRead = 0 Or StopExport
      
      If Not StopExport
        FileSeek(1, 0)
        WriteWAVHeaderStream(1, DataSize, SampleRate, NumChannels, BitsPerSample)
      EndIf
      
      CloseFile(0)
      CloseFile(1)
      FreeMemory(*Buffer)
      
      If StopExport
        ButtonCancelExport()
        ProcedureReturn #False
      Else
        ProcedureReturn #True
      EndIf
    EndIf
  EndIf
  
  If IsFile(0)
    CloseFile(0)
  EndIf
  
  If IsFile(1)
    CloseFile(1) 
  EndIf
  
  If *Buffer
    FreeMemory(*Buffer)
  EndIf
  
  ProcedureReturn #False
EndProcedure 

Procedure.s AllGadgetsData()
  ProcedureReturn GetGadgetText(#GenreString) +
    GetGadgetText(#ArtistString) +
    GetGadgetText(#TitleString) +
    GetGadgetText(#YearString) +
    GetGadgetText(#LabelString) +
    GetGadgetText(#CatNoString) +
    GetGadgetText(#CountryString) +
    GetGadgetText(#BPMString) +
    GetGadgetText(#SleeveString)  +
    Str(GetGadgetState(#IntroFadeIn)) +
    Str(GetGadgetState(#IntroHasBass)) +
    Str(GetGadgetState(#IntroHasMelody)) +
    Str(GetGadgetState(#IntroHasVocal)) +
    Str(GetGadgetState(#IntroHasBeats)) +
    Str(GetGadgetState(#BreakFadeOut)) +
    Str(GetGadgetState(#BreakHasBass)) +
    Str(GetGadgetState(#BreakHasMelody)) +
    Str(GetGadgetState(#BreakHasVocal)) +
    Str(GetGadgetState(#BreakHasBeats))  
EndProcedure

Procedure.s AbsoluteDir(Path.s)  
  Protected.b DriveLetter = #False
  Protected.i Char
  
  Path = Trim(Path)
  
  CompilerIf #PB_OS_Windows
    If Len(Path) >= 2
      Char = Asc(Left(Path, 1))
      If (Char => 65  And Char <= 90) Or (Char >= 97  And Char <= 122) 
        If Mid(Path, 2, 1) = ":"
          DriveLetter = #True
        EndIf
      EndIf
    EndIf
  CompilerEndIf
  
  If Left(Path, 1) = "/" Or Left(Path, 1) = "\" Or DriveLetter 
    ProcedureReturn Path
  EndIf

  ProcedureReturn GetPathPart(ProgramFilename()) + OSPath(Path)
EndProcedure 
    
Procedure.b LightMode()
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows      
    ProcedureReturn      
  CompilerEndIf
  
  If SystemBackgroundColor < 4000000
    ProcedureReturn #True
  EndIf
EndProcedure
  
Procedure.b SongInPlaylist(ID.s)
  Protected.i Index = ListIndex(Songs())
  Protected.b IDFound
  
  ForEach Songs()
    If Songs()\ID = ID
      IDFound = #True      
      Break
    EndIf
  Next
  SelectElement(Songs(), Index)    
  
  ProcedureReturn IDFound
EndProcedure  

Procedure.s RestoredData()
  Protected.s Text, DataString
  
  Repeat
    Read.s DataString
    If DataString = ""
      Break
    EndIf
    
    Text + DataString    
  ForEver  
  
  ProcedureReturn Text
EndProcedure

Procedure.i SectionX(Pos.f)
  Protected.q PosBytes = BASS_ChannelSeconds2Bytes(Chan\Database, Pos)    
  Protected.q BeforePosBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewBegin)
  
  ProcedureReturn (PosBytes - BeforePosBytes) / DatabaseSong\BytesPerPixel     
EndProcedure

Procedure.i CalcScale()
  Protected.f Percent = (GadgetHeight(#CanvasWaveform) / GadgetWidth(#CanvasWaveform)) * 100
  
  ProcedureReturn 100 - Int(percent)  
EndProcedure

Procedure.s CleanUpQuery(Query.s)
  Query = Trim(Query)
  
  If Query <> "" And Right(Query, 4) <> " AND"
    Query + " AND "
  EndIf
  
  While FindString(Query, "  ")
    Query = ReplaceString(Query, "  ", " ")
    While FindString(Query, "AND AND")
      Query = ReplaceString(Query, "AND AND", "AND ")
    Wend   
  Wend
  
  If Left(Trim(Query), 3) = "AND"
    Query = Mid(Query, 4)
  EndIf  
      
  ProcedureReturn Query
EndProcedure

Procedure.s CleanString(String.s)  
  While FindString(String, "  ")
    String = ReplaceString(String, "  ", " ")
  Wend
  
  While FindString(String, ", ")
    String = ReplaceString(String, ", ", ",")
  Wend
  
  While FindString(String, ", ")  
    String = ReplaceString(String, ", ", ",")  
  Wend
  
  While FindString(String, ",,")  
    String = ReplaceString(String, ",,", ",")  
  Wend    
  
  String = Trim(String)
  String = Trim(String, ",")
    
  ProcedureReturn String
EndProcedure

Procedure.s RemoveDuplicates(String.s)
  Protected.s Genre
  Protected.i Items = CountString(String, ",")
  Protected.i Item, U, UniqueTel
  Protected.b Found
  
  Dim Unique.s(0)
    
  If Items > 0
    If Items > 1 
      Items + 1
    EndIf 
    
    ;Walkthrough all items in String
    For Item = 1 To Items  
      Genre = StringField(String, Item, ",") 
      Found = #False
      
      ;Check if the item exists in array Unique()
      For U = 0 To UniqueTel - 1 
        If Unique(U) = Genre
          Found = #True
          Break
        EndIf
      Next  
      
      If Not Found
        ;Add the item to array Unique()      
        ReDim Unique(UniqueTel)
        Unique(UniqueTel) = Genre
        UniqueTel + 1
      EndIf
    Next 
    SortArray(Unique(), #PB_Sort_Ascending)
    
    ;Create new string with all items from array Unique()  
    String = ""
    For U = 0 To UniqueTel - 1
      String + Unique(U) 
      If U < UniqueTel -1
        String + ","
      EndIf
    Next
  EndIf
  
  ProcedureReturn String  
EndProcedure
 
Procedure.f DBLowestBPM()
  Protected.f LowestBPM
  
  DatabaseQuery(#DBMusic, "SELECT bpm FROM music ORDER BY bpm ASC LIMIT 1")  
  NextDatabaseRow(#DBMusic)
  LowestBPM = GetDatabaseFloat(#DBMusic, 0)      
  FinishDatabaseQuery(#DBMusic)
  
  ProcedureReturn LowestBPM
EndProcedure

Procedure.f DBHighestBPM()
  Protected.f HighestBPM
  
  DatabaseQuery(#DBMusic, "SELECT bpm FROM music ORDER BY bpm DESC LIMIT 1")  
  NextDatabaseRow(#DBMusic)
  HighestBPM = GetDatabaseFloat(#DBMusic, 0)   
  FinishDatabaseQuery(#DBMusic)  
  
  ProcedureReturn HighestBPM  
EndProcedure

Procedure.s Seconds2LongTime(Seconds.f)
  Protected.i TotalSeconds = Int(Seconds)
  Protected.i Hours = TotalSeconds / 3600
  Protected.i Minutes = (TotalSeconds % 3600) / 60
  Protected.i RemainingSeconds = TotalSeconds % 60
  
  ProcedureReturn RSet(Str(hours), 2, "0") + ":" + RSet(Str(Minutes), 2, "0") + ":" + RSet(Str(RemainingSeconds), 2, "0")
EndProcedure

Procedure.s Seconds2Time(Seconds.f, DisplayHours.b)
  If DisplayHours
    ProcedureReturn FormatDate("%hh:%ii.%ss", Seconds)   
  Else
     ProcedureReturn FormatDate("%ii.%ss", Seconds)
  EndIf
EndProcedure 

Procedure.s Seconds2TimeMS(Sec.f, Digits = 3)
  Protected.i Minutes, Seconds
  Protected.f Milliseconds
  Protected.s M, S, MS

  Minutes = Int(Sec / 60)
  Seconds = Int(Mod(Sec, 60))
  Milliseconds = (Sec - Int(Sec)) * Pow(10, Digits)

  M = RSet(Str(Minutes), 2, "0")
  S = RSet(Str(Seconds), 2, "0")
  MS = RSet(Str(Int(Milliseconds)), Digits, "0")

  ProcedureReturn M + ":" + S + "." + MS
EndProcedure

Procedure.f Time2Seconds(Time.s)
  Protected.i Pos
  Protected.f Part1, Part2
   
  Time = Trim(ReplaceString(Time, ":", "."))  
  
  Pos = FindString(Time, ".")
  Part1 = ValD(Left(Time, Pos - 1)) 
  Part2 = ValD(Mid(Time, Pos + 1))

  ProcedureReturn (Part1 * 60) + Part2
EndProcedure

Procedure.s GetDistinct(Field.s)
  Protected.s String
  
  If field = "filename"
    String = OSPath(String)
  EndIf
  
  DatabaseQuery(#DBMusic, "SELECT DISTINCT " + Trim(Field) + " FROM music ORDER BY " + Field + " ASC")  
  
  While NextDatabaseRow(#DBMusic)
    If Trim(GetDatabaseString(#DBMusic, 0)) <> ""
      String + Trim(GetDatabaseString(#DBMusic, 0)) + ","
    EndIf
  Wend
  FinishDatabaseQuery(#DBMusic)  
  
  ;remove possible comma at the end of the string
  String = RTrim(String, ",")
  
  ProcedureReturn LCase(String)
EndProcedure

Procedure.f PlayLength(SongType.i, IntroPrefix.f, 
                       IntroStart, IntroEnd.f, IntroLoopStart.f, IntroLoopEnd.f, IntroLoopRepeat.i,
                       BreakStart.f, BreakEnd.f, BreakLoopStart.f, BreakLoopend.f, BreakLoopRepeat.i, BreakContinue.f,
                       FileFullPath.s = "")
  Protected.f PlayLength, SongLength
  Protected.i Channel
  
  FileFullPath = OSPath(FileFullPath)
  
  Select SongType
    Case #Firstsong 
      PlayLength = BreakEnd 
      If BreakLoopstart + BreakLoopEnd > 0
        PlayLength + (BreakLoopRepeat * (BreakLoopEnd - BreakLoopStart))
      EndIf
    Case #InBetweenSong
      PlayLength = BreakEnd - IntroEnd 
      If BreakLoopstart + BreakLoopEnd > 0
        PlayLength + (BreakLoopRepeat * (BreakLoopEnd - BreakLoopStart))
      EndIf      
    Case #LastSong
      Channel = CreateChannel(FileFullPath)           
      SongLength = BASS_ChannelBytes2Seconds(Channel, BASS_ChannelGetLength(Channel, #BASS_POS_BYTE))    
      BASS_StreamFree(Channel)      
      PlayLength = SongLength - IntroEnd  
  EndSelect     
  
  ProcedureReturn PlayLength
EndProcedure

Procedure.i MaxSongs(Text.s)  
  ProcedureReturn Val(Text) 
EndProcedure

Procedure.i MinPlaybackTime(Text.s)
  If FindString(Text, "hour") 
    ProcedureReturn 60 * 60 * Val(Text)
  EndIf 
  
  ProcedureReturn  60 * Val(Text)      
EndProcedure

Procedure.i MaxPlaybackTime(Text.s)
  If Text = "Infinite"
    ProcedureReturn 86400 ;24 hours
  ElseIf FindString(Text, "hour") 
    ProcedureReturn 60 * 60 * Val(Text)
  EndIf 
  
  ProcedureReturn 60 * Val(Text)      
EndProcedure
 
Procedure.s GetDefaultSetting(SettingDescription.s)
  Protected.s Result
  
  ForEach SettingsPanel()
    If SettingsPanel()\Description = SettingDescription
      Result = SettingsPanel()\DefaultValue
      Break
    EndIf
  Next  
  
  ProcedureReturn Result
EndProcedure

Procedure.s GeneratePlaylistIDsString()
  Protected.s PlaylistDurations, PlaylistIDs
  
  ForEach Songs()
    PlaylistIDs + Songs()\ID 
    
    If Songs()\Pitch = "  0.00%" 
      PlaylistIDs + "R"
    EndIf
    
    If Songs()\NoMatch
      PlaylistIDs + "!"  
    EndIf
    
    PlaylistIDs + ","
    
    PlaylistDurations + FormatNumber(Songs()\Playtime) 
    
    If Songs()\Shorten
      PlaylistDurations + "S"
    EndIf
    
    PlaylistDurations + ","
  Next       
  
  ProcedureReturn RTrim(PlaylistIDs, ",") + "|" + RTrim(PlaylistDurations, ",")
EndProcedure

Procedure.s GenerateBeatList(Beats.s, PosBegin.f, PosEnd.f, Intro.i, LoopStart.f, LoopEnd.f, LoopRepeat.i)
  Protected.i Beat, DbBeats, i, ClosestIndex
  Protected.s Item, Output, BeatPos
  Protected.d Beatlength, Diff, ClosestDiff
  
  Dim BeatArray.d(32)
  
  ;calculate the beat length
  If LoopRepeat > 0 And LoopStart > 0 And LoopEnd > 0
    Beatlength = ((PosEnd - PosBegin) + (LoopRepeat * (LoopEnd - LoopStart))) / 32     
  Else
    Beatlength = (PosEnd - PosBegin) / 32
  EndIf
  
  ;normalise Beat string
  Beats = ReplaceString(Beats, Chr(13), Chr(10))
  Beats = ReplaceString(Beats, "\r", Chr(10))
  Beats = ReplaceString(Beats, "\n", Chr(10))  
  
  DbBeats = CountString(Beats, Chr(10))
  
  ; Initieel array vullen met berekende beatposities
  For Beat = 1 To 32
    BeatArray(Beat) = PosBegin + (Beatlength * (Beat - 1))
  Next Beat
  
  ;replace closed position in BeatArray
  For Beat = 1 To DbBeats
    Item = StringField(Beats, Beat, Chr(10))
    If Item <> ""
      Protected.d RealBeat = Time2Seconds(Item)
      
      ClosestDiff = 9999999
      ClosestIndex = -1
      
      For i = 1 To 32
        Diff = Abs(RealBeat - BeatArray(i))
        If Diff < ClosestDiff
          ClosestDiff = Diff
          ClosestIndex = i
        EndIf
      Next i
      
      If ClosestIndex > 0
        BeatArray(ClosestIndex) = RealBeat
      EndIf
    EndIf
  Next Beat
  
  ;build output string
  For Beat = 1 To 32
    Output + StrF(BeatArray(Beat)) + Chr(10)
  Next Beat
  
  ProcedureReturn Output
EndProcedure

Procedure.s GenerateListviewQuery(PreferenceName.s, PreferenceString.s, DBFieldName.s, Wildcard = #False)
  Protected.i PreferenceItem, PreferenceItems = CountString(PreferenceString, "|") + 1
  Protected.s Query, String
 
  For PreferenceItem = 1 To PreferenceItems 
    String = StringField(PreferenceString, PreferenceItem, "|")
    
    ;Escape single quotes
    String = ReplaceString(String, "'", "''")
        
    If Wildcard      
      Query + DBFieldName + " LIKE '%" + String + "%' OR "
    Else
      Query + "'" + String + "',"
    EndIf
  Next
  
 
  If Query = "''," Or Query = DBFieldName + " LIKE '%%' OR "
    Query = ""
  Else 
    If Wildcard
      Query = RemoveString(Query, " OR ", #PB_String_CaseSensitive, Len(Query) - 5)      
      Query = "(" + Query + ") AND"
    Else      
      Query = Trim(Query, ",")
      Query = DBFieldName +" IN (" + Query + ") AND "
    EndIf   
  EndIf  
  
  ProcedureReturn Query
EndProcedure

Procedure.s GenerateFilterQuery()
  Protected.s FilterQuery = GenerateListviewQuery("Artists", Preferences\Artists, "artist") 
  
  If Preferences\EvolutionMode = "Off" Or (Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime = "Infinite")
    FilterQuery + GenerateListviewQuery("Years", Preferences\Years, "year") 
  EndIf
  
  FilterQuery + GenerateListviewQuery("Record labels", Preferences\RecordLabels, "label") 
  FilterQuery + GenerateListviewQuery("Countries", Preferences\Countries, "country")   
  FilterQuery + GenerateListviewQuery("Genres", Preferences\Genres, "genre", #True)   
  FilterQuery = RemoveString(FilterQuery, " AND ", #PB_String_CaseSensitive, Len(FilterQuery) - 6)
  
  ProcedureReturn Trim(FilterQuery)
EndProcedure

Procedure.s GenerateRandomPlaylist()
  Protected.b NoMatch 
  Protected.f IntroPrefix, IntroStart, IntroEnd, IntroLoopStart,IntroLoopEnd, IntroLoopRepeat
  Protected.f BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat, BreakContinue
  Protected.f SkipStart, SkipEnd, PlayLength, PlaylistSeconds
  Protected.f OriginalBPM, PlaybackBPM, LowestBPM, HighestBPM, DBLowestBPM, DBHighestBPM 
  Protected.s Artist, Title, PlaylistIDs, PlaylistDurations, Shorten, Query, CombineQuery, ID
  Protected.s DateTime = Str(Day(Date())) + "-" + Str(Month(Date())) + "-" + Str(Year(Date())) + "_" + Str(Hour(Date())) + "u" + Str(Minute(Date())) + "m" + Str(Second(Date())) + "s"
  Protected.s PreviousID, PreviousIDs, FileFullPath, FilterQuery, PreviousIDsQuery, LastString 
  Protected.s QueryPrefix = "SELECT id, bpm, filename, introprefix, introstart, introend, introloopstart, introloopend, introlooprepeat, " + 
                            "breakstart, breakend, breakloopstart, breakloopend, breaklooprepeat, breakcontinue, skipstart, skipend, " +
                            "breakbass, breakvocal, breakmelody, breakbeats, samplerate FROM music WHERE "
  Protected.s LastItem
  Protected.b EndOfPlaylist, PlaylistMeetsSettings 
  Protected.i SongType, Songs, MaxSongs, Position, MinSeconds, MaxSeconds, X, FileSamplerate, Item, Last
  Protected.i PreviousIDsTel, ValidCount, StartTime = ElapsedMilliseconds()
  Protected.i ListviewYearGadget = 72
  Protected.i ValidNumber = 4
  Protected.i ListviewYearItems = CountGadgetItems(ListviewYearGadget)
  Protected.i AverageSongsPerYear = 9999
  Protected.i SelectedYears, Count, LeftYears, YearCounter, RemainingSongs, YearSongs
  Protected.i AverageSongDuration, AverageAmountOfSongs, AverageAmountOfSongsByTime, RemainingByTime, RemainingByCount 
  
  ;In infinity mode, check if an updated database file is present  
  If RefreshPlaylist And FileSize(OSPath("assets/data/update.db1")) <> -1
    ;While playing, replace the database file with the new version
    CloseDatabase(#DBMusic)
    RenameFile(OSPath("assets/data/mixperfect.db1"), OSPath("assets/data/mixperfect_old_") + DateTime + ".db1")
    RenameFile(OSPath("assets/data/update.db1"), OSPath("assets/data/mixperfect.db1"))
    OpenDatabase(#DBMusic, OSPath("assets/data/mixperfect.db1"), "", "", #PB_Database_SQLite)
  EndIf
  
  LoadPreferences()
  
  If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite" 
    Dim Years.s(ListviewYearItems)
    
    ;add selected years in listview items to array
    For Item = 0 To ListviewYearItems - 1
      If GetGadgetItemState(ListviewYearGadget, Item) = 1
        Years(SelectedYears) = GetGadgetItemText(ListviewYearGadget, Item)
        SelectedYears + 1
      EndIf
    Next
    
    ;add all years to array if no years are selected 
    If SelectedYears = 0
      For Item = 0 To ListviewYearItems - 1
        Years(SelectedYears) = GetGadgetItemText(ListviewYearGadget, Item)
        SelectedYears + 1
      Next
    EndIf
    
    ;sort array and remove duplicates
    SortArray(Years(), #PB_Sort_Ascending)
    
    Dim UniqueYears.s(ArraySize(Years()))
     
    For Item = 0 To ArraySize(Years()) 
      If Years(Item) <> "" And Years(Item) <> LastItem
        UniqueYears(Count) = Years(Item)
        LastItem = Years(Item)
        Count + 1
      EndIf
    Next
    
    ReDim UniqueYears(Count - 1)    
  EndIf
  
  ;Convert strings to values
  MaxSongs = MaxSongs(Preferences\MaximumNumberOfSongs) 
  MinSeconds = MinPlaybackTime(Preferences\MinimumPlaybackTime)
  MaxSeconds = MaxPlaybackTime(Preferences\MaximumPlaybackTime) 
    
  ;Find lowest and highest BPM in database
  DBLowestBPM = DBLowestBPM() 
  DBHighestBPM = DBHighestBPM()

  ;Create a filter query
  FilterQuery = GenerateFilterQuery() 
   
  ;Set initial BPM range for the first song         
  If Preferences\BPMOfFirstSong = "Random"
    LowestBPM = DBLowestBPM
    HighestBPM = DBHighestBPM
  Else
    LowestBPM = ValF(Preferences\BPMOfFirstSong)
    HighestBPM = ValF(Preferences\BPMOfFirstSong) + 0.99
  EndIf          
          
  While Not EndOfPlaylist  
    ;*******************************************************************
    ;This loop does select songs from the database with subsequent BPM's
    ;*******************************************************************             
    
    PreviousIDsTel + 1
    
    If PreviousID <> ""
      ;Build a string with collected database-ID's to prevent duplicate tracks           
      PreviousIDs + PreviousID + ","
      PreviousIDsQuery = "id NOT IN (" + Trim(PreviousIDs, ",") + ") AND "          

      If FilterQuery <> ""
        If PreviousIDsQuery <> ""
          FilterQuery = " AND " + FilterQuery + " "
        Else
          FilterQuery + " " 
        EndIf
      EndIf               
    EndIf     
    
    Query = CleanUpQuery(PreviousIDsQuery + FilterQuery + CombineQuery)
    If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite"         
      Query + " year=" + UniqueYears(YearCounter) + " AND "
    EndIf
 
    NoMatch = #False
    
    If FirstSongID <> ""
      ;Select the last song from the current playlist (infinity mode)
      DatabaseQuery(#DBMusic, QueryPrefix + " id=' " + FirstSongID + "'")  
      NextDatabaseRow(#DBMusic)         
      FirstSongID = ""         
    Else
      ;Select a random song that meets the BPM range and prefered combine-settings for bass, beats, vocals, melodies
      DatabaseQuery(#DBMusic, QueryPrefix + Query +  " bpm BETWEEN " + StrF(LowestBPM) + " AND " + StrF(HighestBPM) + " ORDER BY RANDOM() LIMIT 1")     
      NextDatabaseRow(#DBMusic) 
      If GetDatabaseString(#DBMusic, 0) = "" And FirstSongID = "" And Preferences\IgnoreCombine = "Yes"
        NoMatch = #True
        ;No match found: select a random song that meets the BPM range but does not match prefered combine-settings for bass, beats, vocals, melodies
        FinishDatabaseQuery(#DBMusic)    

        Query = CleanUpQuery(PreviousIDsQuery + FilterQuery)
        If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite"         
          Query + " year=" + UniqueYears(YearCounter) + " AND "
        EndIf
        DatabaseQuery(#DBMusic, QueryPrefix + Query + " bpm BETWEEN " + StrF(LowestBPM) + " AND " + StrF(HighestBPM) + " ORDER BY RANDOM() LIMIT 1") 
        NextDatabaseRow(#DBMusic)
        If GetDatabaseString(#DBMusic, 0) = "" And PreviousIDsTel > Preferences\UniqueSongsBeforeRepeating 
          ;No match found: select a random song that meets the BPM range (this might be a song that already is in the playlist)          
          FinishDatabaseQuery(#DBMusic)      
          
          Query = CleanUpQuery(FilterQuery)  
          If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite"         
            Query + " year=" + UniqueYears(YearCounter) + " AND "
          EndIf            
          DatabaseQuery(#DBMusic, QueryPrefix + Query + " bpm BETWEEN " + StrF(LowestBPM) + " AND " + StrF(HighestBPM) + " AND id<>'" + PreviousID + "' ORDER BY RANDOM() LIMIT 1")       
          NextDatabaseRow(#DBMusic)  
          If GetDatabaseString(#DBMusic, 0) <> ""
             PreviousIDsTel = 1
          EndIf
        EndIf  
      EndIf
    EndIf 
    
    If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite" And GetDatabaseString(#DBMusic, 0) = "" And YearSongs > 1
      YearSongs = 1
      YearCounter + 1
      Continue
    EndIf
    
    If Songs >= MaxSongs Or GetDatabaseString(#DBMusic, 0) = ""
      EndOfPlayList = #True 
      FinishDatabaseQuery(#DBMusic) 
      Break
    EndIf          
     
    Songs + 1 ;Important: do not move this line up      
    
    PreviousID = GetDatabaseString(#DBMusic, 0) 
    
    IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 3))   
    IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 4))   
    IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 5))      
    IntroLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 6))
    IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 7))    
    IntroLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 8))  
    BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 9))  
    BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 10))  
    BreakLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 11))  
    BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 12))  
    BreakLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 13))  
    Breakcontinue = Time2Seconds(GetDatabaseString(#DBMusic, 14))    
    SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 15))   
    SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 16))      
    FileSamplerate = GetDatabaseLong(#DBMusic, 21)    

    ;Create subquery for next query
    CombineQuery = ""
    If Preferences\CombineBasses = "No" And GetDatabaseLong(#DBMusic, 17) = 1
      CombineQuery + " AND introbass=0" 
    EndIf
    
    If Preferences\CombineVocals = "No" And GetDatabaseLong(#DBMusic, 18) = 1
      CombineQuery + " AND introvocal=0" 
    EndIf
    
    If Preferences\CombineMelodies = "No" And GetDatabaseLong(#DBMusic, 19) = 1
      CombineQuery + " AND intromelody=0" 
    EndIf
    
    If Preferences\CombineBeats = "No" And GetDatabaseLong(#DBMusic, 20) = 1
      CombineQuery + " AND introbeats=0" 
    EndIf
    
    If Preferences\KeepBeatsGoing = "Yes" And GetDatabaseLong(#DBMusic, 20) = 0
      CombineQuery + " AND introbeats=1" 
    EndIf
   
    If Songs = 1
      SongType = #FirstSong
    Else
      Songtype = #InBetweenSong
    EndIf
    
    PlayLength = PlayLength(SongType, IntroPrefix, 
                            IntroStart, Introend, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat, 
                            BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat, BreakContinue)
    
    Shorten = ""
    If Preferences\ShortenSongs = "Always" Or (Preferences\ShortenSongs = "Random" And Random(1))
      PlayLength - (SkipEnd - SkipStart)
      Shorten = "S"
    EndIf             
 
    If PlaylistSeconds + PlayLength >= MaxSeconds 
      EndOfPlayList = #True 
      FinishDatabaseQuery(#DBMusic) 
      Break
    EndIf  
    
    PlaylistSeconds + PlayLength     

    ;Collect ID's and playback durations in strings 
    PlaylistIDs + GetDatabaseString(#DBMusic, 0)         
    PlaylistDurations + FormatNumber(PlayLength, 10) + Shorten + ","    
         
    ;Reset the pitch for the first song or if playback BPM is close to original BPM
    OriginalBPM = GetDatabaseFloat(#DBMusic, 1)       
    If Songs = 1 Or Abs(OriginalBPM - PlaybackBPM) <= Preferences\PitchRange
      PlaybackBPM = OriginalBPM 
      Select Preferences\BPMOrderOfSongs 
        Case "Random"
          LowestBPM = OriginalBPM - Preferences\MaximumBPMdistance
          HighestBPM = OriginalBPM + Preferences\MaximumBPMdistance         
        Case "Ascending"
          LowestBPM = OriginalBPM 
          HighestBPM = OriginalBPM + Preferences\MaximumBPMdistance              
        Case "Descending" 
          LowestBPM = OriginalBPM - Preferences\MaximumBPMdistance
          HighestBPM = OriginalBPM  
      EndSelect
      
      If HighestBPM > DBHighestBPM
        HighestBPM = DBHighestBPM
      EndIf
      
      If LowestBPM < DBLowestBPM
        LowestBPM = DBLowestBPM
      EndIf  
      
      ;Adding R set the pitch to 0 while filling the Listicon
      PlaylistIDs + "R"
    EndIf
    
    ;Adding ! if no match was found
    If NoMatch
      PlaylistIDs + "!"
    EndIf

    PlaylistIDs + ","      
    FinishDatabaseQuery(#DBMusic)          
          
    If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite" 
      AverageSongDuration = PlaylistSeconds / Songs
      
      If AverageSongDuration > 0
        AverageAmountOfSongsByTime = MaxSeconds / AverageSongDuration
      Else
        AverageAmountOfSongsByTime = MaxSongs  
      EndIf

      RemainingByTime = AverageAmountOfSongsByTime - Songs
      RemainingByCount = MaxSongs - Songs

      If RemainingByTime < RemainingByCount
        RemainingSongs = RemainingByTime
      Else
        RemainingSongs = RemainingByCount
      EndIf
    
      LeftYears = (ArraySize(UniqueYears())) - YearCounter
    
      If LeftYears > 0
        AverageSongsPerYear = RemainingSongs / LeftYears
      Else
        EndOfPlayList = #True 
      EndIf
    
      YearSongs + 1
      If YearSongs > AverageSongsPerYear 
        YearSongs = 1
        YearCounter + 1
      EndIf        
    EndIf 
  Wend    

  ;Remove "," from end of strings
  PlaylistIDs = RTrim(PlaylistIDs, ",")    
  PlaylistDurations = RTrim(PlaylistDurations, ",")    
  
  ;*******************************************
  ;Recalculate the playlength of the last song
  ;*******************************************
  
  Last = CountString(PlaylistIDs, ",") + 1
  ID = ReplaceString(StringField(PlaylistIDs, Last, ","), "R", "") 
  ID = ReplaceString(ID, "!", "") 
  DatabaseQuery(#DBMusic, "SELECT id, filename, introprefix, introstart, introend, introloopstart, introloopend, introlooprepeat, " + 
                             "breakstart, breakend, breakloopstart, breakloopend, breaklooprepeat, breakcontinue, skipstart, skipend, samplerate FROM music WHERE id='" +  ID + " ' LIMIT 1")  
  NextDatabaseRow(#DBMusic)      

  FileFullPath = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 1))     
  IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 2))   
  IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 3))   
  IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 4))      
  IntroLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 5))
  IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 6))    
  IntroLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 7))  
  BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 8))  
  BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 9))  
  BreakLoopStart = Time2Seconds(GetDatabaseString(#DBMusic, 10))  
  BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 11))  
  BreakLoopRepeat = Time2Seconds(GetDatabaseString(#DBMusic, 12))  
  Breakcontinue = Time2Seconds(GetDatabaseString(#DBMusic, 13))    
  SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 14))   
  SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 15))    
  FileSamplerate = GetDatabaseLong(#DBMusic, 16) 
  
  FinishDatabaseQuery(#DBMusic) 

  Last = CountString(PlaylistDurations, ",") + 1
  LastString = StringField(PlaylistDurations, Last, ",") 
  PlaylistSeconds - ValF(Left(LastString, Len(LastString)-1)  )  
  
  PlayLength = PlayLength(#LastSong, IntroPrefix, 
                          IntroStart, Introend, IntroLoopStart, IntroLoopEnd, IntroLoopRepeat, 
                          BreakStart, BreakEnd, BreakLoopStart, BreakLoopEnd, BreakLoopRepeat, BreakContinue,
                          FileFullPath)  
  
  Shorten = ""
  If Preferences\ShortenSongs = "Always" Or (Preferences\ShortenSongs = "Random" And Random(1))
    PlayLength = (BreakEnd - IntroEnd) - (SkipEnd - SkipStart) 
    If BreakLoopStart > 0 And BreakLoopEnd And BreakLoopRepeat > 0
      PlayLength + ((BreakLoopEnd - BreakLoopStart) * BreakLoopRepeat)
    EndIf
    Shorten = "S"
  EndIf       
  
  PlaylistSeconds + PlayLength 
  
  ;********************************
  ;Check if playlist meets settings
  ;********************************

  If Preferences\EvolutionMode = "On" And Preferences\MaximumPlaybackTime <> "Infinite" 
    ValidNumber + 1

    If YearCounter = ArraySize(UniqueYears())
      ValidCount + 1
    EndIf
  EndIf    

  If Songs >= Val(Preferences\MinimumNumberOfSongs)
    ValidCount + 1  
  EndIf 
    
  If Songs <= MaxSongs  
    ValidCount + 1
  EndIf
  
  If PlaylistSeconds >= MinSeconds
    ValidCount + 1  
  EndIf     
  
  If PlaylistSeconds <= MaxSeconds
    ValidCount + 1
  EndIf    
   
  If ValidCount = ValidNumber
    EndOfPlaylist = #True
     
    If PlaylistIDs <> ""    
      ;Replace last playlength in PlaylistDurations with recalculated playlength
      Repeat
        Last = Position
        Position = FindString(PlaylistDurations , ",", Position + 1)
      Until Not Position 

      PlaylistDurations = Left(PlaylistDurations, Last) + FormatNumber(PlayLength, 10) + Shorten
      PlaylistIDs + "|" + PlaylistDurations         
    EndIf      
  Else      
    PlaylistIDs = ""      
  EndIf    
  
  ProcedureReturn PlaylistIDs
EndProcedure

Procedure.s CalculateEstimatedBPM(File.s)
  Protected.i Channel, StartSec, EndSec 
  Protected.i MinBPM = 10, MaxBPM = 200
  Protected.i BPMRange = MinBPM | (MaxBPM << 16)  
  Protected.f BPM, Length
 
  Channel = CreateChannel(File, #BASS_STREAM_DECODE)   
  Length = BASS_ChannelBytes2Seconds(Channel, BASS_ChannelGetLength(Channel, #BASS_POS_BYTE)) 
 
  If Length > 90
    StartSec = 60
    EndSec = 90
  ElseIf Length > 60
    Startsec = 30
    EndSec = 60
  ElseIf Length > 30
    Startsec = 0
    EndSec = 30   
  Else 
    Startsec = 0
    EndSec = Length       
  EndIf

  BPM = BASS_FX_BPM_DecodeGet(Channel, StartSec, EndSec, BPMRange, #BASS_FX_FREESOURCE, #Null, 0) 
  
  If BPM = 0
    BPM = BASS_FX_BPM_DecodeGet(Channel, 0, Length, BPMRange, #BASS_FX_FREESOURCE, #Null, 0)     
  EndIf
  
  If BPM > 160
    BPM / 2
  ElseIf BPM < 70
    BPM * 2
  EndIf
  
  BASS_StreamFree(Channel)
 
  ProcedureReturn RSet(FormatNumber(BPM), 6, "0")
EndProcedure

Procedure.f CalculateExactBPM()
  Protected.f BPMIntro, BPMBreak, BPM, Length
  
  If DatabaseSong\IntroStart > 0 And DatabaseSong\IntroEnd > 0
    Length = DatabaseSong\IntroEnd - DatabaseSong\IntroStart
    
    If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0
      BPMIntro = 60 / ((Length + (DatabaseSong\IntroLoopRepeat * (DatabaseSong\IntroLoopEnd - DatabaseSong\IntroLoopStart))) / 32)
    Else
      BPMIntro = 60 / (Length / 32)      
    EndIf
    
    If BPMIntro < 60 Or BPMIntro > 170
      BPMIntro = 0 
    EndIf
  EndIf
  
  If DatabaseSong\BreakStart > 0 And DatabaseSong\BreakEnd > 0
    Length = DatabaseSong\BreakEnd - DatabaseSong\BreakStart
    
    If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0
      BPMBreak = 60 / ((Length + (DatabaseSong\BreakLoopRepeat * (DatabaseSong\BreakLoopEnd - DatabaseSong\BreakLoopStart))) / 32)
    Else
      BPMBreak = 60 / (Length / 32)      
    EndIf
    
    If BPMBreak < 60 Or BPMBreak > 170
      BPMBreak = 0 
    EndIf
  EndIf

  If BPMIntro = 0 And BPMBreak > 0
    BPM = BPMBreak
  ElseIf BPMIntro > 0 And BPMBreak = 0
    BPM = BPMIntro
  ElseIf BPMIntro = 0 And BPMBreak = 0
    BPM = DatabaseSong\BPM
  Else
    BPM = (BPMIntro + BPMBreak) / 2
  EndIf
 
  If BPM < 60 Or BPM > 170
    BPM = DatabaseSong\BPM
  EndIf

  ProcedureReturn BPM 
EndProcedure

Procedure.s DatabaseSongErrors()
  Protected.s Errors
  Protected.s IntroList = ReplaceString(DatabaseSong\IntroBeatList, Chr(13), Chr(10))  
  Protected.i IntroBeats = CountString(IntroList, Chr(10))  
  Protected.s BreakList = ReplaceString(DatabaseSong\BreakBeatList, Chr(13), Chr(10))  
  Protected.i BreakBeats = CountString(BreakList, Chr(10))    
  Protected.q SongLength = BASS_ChannelGetLength(Chan\Database, #BASS_POS_BYTE)
  Protected.i Beat
  Protected.f Second
  Protected.f Marge = 0.015
  Protected.f IntroLength = TransitionLength(DatabaseSong\IntroStart, DatabaseSong\IntroEnd, DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd, DatabaseSong\IntroLoopRepeat)  
  Protected.f BreakLength = TransitionLength(DatabaseSong\BreakStart, DatabaseSong\BreakEnd, DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd, DatabaseSong\BreakLoopRepeat)  
   
  ;Correct markers without marge
  If DatabaseSong\IntroPrefix > 0 And DatabaseSong\IntroPrefix < Marge
    DatabaseSong\IntroPrefix = Marge
  EndIf 

  If DatabaseSong\BreakContinue > 0 And DatabaseSong\BreakContinue < Marge
    DatabaseSong\BreakContinue = Marge
  EndIf
  
  If DatabaseSong\SkipStart > 0 And DatabaseSong\SkipEnd > 0
    If DatabaseSong\SkipStart - DatabaseSong\IntroEnd <  Marge
      DatabaseSong\SkipStart = DatabaseSong\IntroEnd + Marge  
    EndIf
    
    If DatabaseSong\BreakStart - DatabaseSong\SkipEnd < Marge
       DatabaseSong\SkipEnd = DatabaseSong\BreakStart - Marge
    EndIf        
  EndIf 
  
  ;Correct markers outside song
  If DatabaseSong\IntroStart - DatabaseSong\IntroPrefix < 0
    DatabaseSong\IntroPrefix = 0
  EndIf 
  
  ;Correct markers outside song
  If DatabaseSong\BreakContinue >= BASS_ChannelBytes2Seconds(Chan\Database, SongLength)
    DatabaseSong\IntroPrefix = 0
  EndIf   
 
  ;Error checking
  If DatabaseSong\IntroStart = 0
    Errors + "- Intro begin marker not set" + Chr(13)
  EndIf  
  
  If DatabaseSong\IntroEnd = 0
    Errors + "- Intro end marker not set" + Chr(13) 
  EndIf    
  
  If DatabaseSong\IntroStart > 0 And DatabaseSong\IntroEnd > 0 And DatabaseSong\IntroStart > DatabaseSong\IntroEnd
    Errors + "- Intro end marker must be placed after intro start marker" + Chr(13)        
  EndIf
 
  If DatabaseSong\IntroLoopStart = 0 And DatabaseSong\IntroLoopEnd > 0
    Errors + "- Intro loop begin marker not set" + Chr(13)
  ElseIf DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd = 0
    Errors + "- Intro loop end marker not set" + Chr(13)   
  ElseIf DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And DatabaseSong\IntroLoopRepeat = 0
    Errors + "- Intro loop repeat value can not be 0" + Chr(13)   
  EndIf  
  
  If DatabaseSong\IntroLoopStart = 0 And DatabaseSong\IntroLoopEnd > 0 And DatabaseSong\IntroLoopStart > DatabaseSong\IntroLoopEnd
    Errors + "- Intro loop end marker must be placed after intro loop start marker" + Chr(13)        
  EndIf  
  
  If DatabaseSong\IntroLoopStart > 0 And 
     (DatabaseSong\IntroLoopStart < DatabaseSong\IntroStart Or DatabaseSong\IntroLoopEnd < DatabaseSong\IntroStart Or 
      DatabaseSong\IntroLoopStart > DatabaseSong\IntroEnd Or DatabaseSong\IntroLoopEnd > DatabaseSong\IntroEnd)
    Errors + "- Intro loop markers must be placed between intro markers" + Chr(13)   
  EndIf
      
  If DatabaseSong\BreakStart = 0
    Errors + "- Break begin marker not set" + Chr(13)
  EndIf  
  
  If DatabaseSong\BreakEnd = 0
    Errors + "- Break end marker not set" + Chr(13)
  EndIf       
  
  If DatabaseSong\BreakStart > 0 And DatabaseSong\BreakEnd > 0 And DatabaseSong\BreakStart > DatabaseSong\BreakEnd
    Errors + "- Break end marker must be placed after break start marker" + Chr(13)        
  EndIf
   
  If DatabaseSong\BreakLoopStart = 0 And DatabaseSong\BreakLoopEnd > 0
    Errors + "- Break loop begin marker not set" + Chr(13)
  ElseIf DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd = 0
    Errors + "- Break loop end marker not set" + Chr(13) 
  ElseIf DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And DatabaseSong\BreakLoopRepeat = 0
    Errors + "- Break loop repeat value can not be 0" + Chr(13)      
  EndIf  
  
  If DatabaseSong\BreakLoopStart = 0 And DatabaseSong\BreakLoopEnd > 0 And DatabaseSong\BreakLoopStart > DatabaseSong\BreakLoopEnd
    Errors + "- Break loop end marker must be placed after break loop start marker" + Chr(13)        
  EndIf  
  
  If DatabaseSong\BreakLoopStart > 0 And 
     (DatabaseSong\BreakLoopStart < DatabaseSong\BreakStart Or DatabaseSong\BreakLoopEnd < DatabaseSong\BreakStart Or 
      DatabaseSong\BreakLoopStart > DatabaseSong\BreakEnd Or DatabaseSong\BreakLoopEnd > DatabaseSong\BreakEnd)
    Errors + "- Break loop markers must be placed between break markers" + Chr(13)   
  EndIf  
 
  If DatabaseSong\SkipStart = 0 And DatabaseSong\SkipEnd > 0
    Errors + "- Skip begin marker not set" + Chr(13)
  ElseIf DatabaseSong\SkipStart > 0 And DatabaseSong\SkipEnd = 0
    Errors + "- Skip end marker not set" + Chr(13)   
  EndIf    
  
  If DatabaseSong\SkipStart > 0 And DatabaseSong\SkipEnd > 0 And DatabaseSong\SkipStart > DatabaseSong\SkipEnd
    Errors + "- Skip end marker must be placed after skip start marker" + Chr(13)        
  EndIf  
  
  If Abs(BreakLength - IntroLength) >= 1
    Errors + "- Too much difference between duration of intro and break" + Chr(13)
  EndIf
  
  If Errors = ""
    If DatabaseSong\BreakStart <= DatabaseSong\IntroStart Or
       DatabaseSong\BreakEnd <= DatabaseSong\IntroStart Or
       DatabaseSong\BreakStart <= DatabaseSong\IntroEnd Or 
       DatabaseSong\BreakEnd <= DatabaseSong\IntroEnd
      Errors + "- Break markers must be set after intro markers" + Chr(13)         
    EndIf
    
    If DatabaseSong\SkipStart > 0 And DatabaseSong\SkipEnd > 0
      If (DatabaseSong\SkipStart >= DatabaseSong\IntroStart And DatabaseSong\SkipStart <= DatabaseSong\IntroEnd) Or
         (DatabaseSong\SkipEnd >= DatabaseSong\IntroStart And DatabaseSong\SkipEnd <= DatabaseSong\IntroEnd)
        Errors + "- Skip markers must be set after intro markers" + Chr(13)         
      EndIf    
  
      If (DatabaseSong\SkipStart >= DatabaseSong\BreakStart And DatabaseSong\SkipStart <= DatabaseSong\BreakEnd) Or
         (DatabaseSong\SkipEnd >= DatabaseSong\BreakStart And DatabaseSong\SkipEnd <= DatabaseSong\BreakEnd) 
        Errors + "- Skip markers must be set before break markers" + Chr(13)         
      EndIf 
   EndIf    
        
   If IntroBeats > 0
      For Beat = 1 To IntroBeats
        Second = Time2Seconds(StringField(IntroList, Beat, Chr(10)))
        If Second <= DatabaseSong\IntroStart Or Second >= DatabaseSong\IntroEnd
          Errors + "- Intro beats must be set between intro markers" + Chr(13)                   
          Break
        EndIf
      Next Beat
    EndIf
    
    If BreakBeats > 0
      For Beat = 1 To BreakBeats
        Second = Time2Seconds(StringField(BreakList, Beat, Chr(10)))
        If Second <= DatabaseSong\BreakStart Or Second >= DatabaseSong\BreakEnd
          Errors + "- Break beats must be set between break markers" + Chr(13)                   
          Break
        EndIf
      Next Beat
    EndIf    
  EndIf

  If Errors <> ""
    MessageRequester("Action not allowed", "The following error(s) must be corrected:" + Chr(13) + Chr(13) + Errors, #PB_MessageRequester_Warning)
  EndIf
  
  ProcedureReturn Errors
EndProcedure

Procedure.s WinTitle()
  Protected.s title = #AppName  
   
  If ProgramParameter(0) = "youtube"
    title + " (YouTube session)"    
  EndIf
  
  ProcedureReturn title
EndProcedure


Procedure.s OSPath(path.s)
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    ProcedureReturn ReplaceString(path, "\", "/")     
  CompilerEndIf
 
  ProcedureReturn ReplaceString(path, "/", "\")       
EndProcedure

Procedure GetWindowBackgroundColor(hwnd=0)  
  Protected color
  
  CompilerSelect #PB_Compiler_OS      
    CompilerCase #PB_OS_Windows  
      color = GetSysColor_(#COLOR_WINDOW)
      If color = $FFFFFF Or color = 0
        color = GetSysColor_(#COLOR_BTNFACE)
      EndIf
      ProcedureReturn color     
    CompilerCase #PB_OS_Linux   
      StartDrawing(WindowOutput(hwnd))
      color = Point(0,0)
      StopDrawing()
      ProcedureReturn color
  CompilerEndSelect
EndProcedure  

Procedure.l CreateChannel(File.s, Flags.l = #Null)
  Protected.s Extension = LCase(GetExtensionPart(File))
  
  If Flags = #Null
    Flags = #BASS_UNICODE
  Else
    Flags | #BASS_UNICODE
  EndIf
  
  If Extension = "mp1" Or Extension = "mp2" Or Extension = "mp3" Or Extension = "ogg" Or Extension = "opus"
    Flags | #BASS_STREAM_PRESCAN
  EndIf
  
  If Extension = "ogg"  
    Flags | #BASS_POS_OGG
  EndIf  

  Select Extension
    Case "mp1", "mp2", "mp3", "ogg", "wav", "aiff", "wma"
      ProcedureReturn BASS_StreamCreateFile(0, @File, 0, 0, Flags)
    Case "aac", "adts", "m4a", "mp4"
      ProcedureReturn BASS_AAC_StreamCreateFile(0, @File, 0, 0, Flags)  
    Case "flac"
      ProcedureReturn BASS_FLAC_StreamCreateFile(0, @File, 0, 0, Flags) 
    Case "opus"
      ProcedureReturn BASS_OPUS_StreamCreateFile(0, @File, 0, 0, Flags) 
  EndSelect
EndProcedure

;------------------------------------ Mixing

Procedure PrepareMix(Row.i, DecodingMix.b = #False)
  Protected.s FileFullPath1, FileFullPath2
  Protected.b NextSongLoaded, PlayerActive
  
  If Mix(CurrentSong)\Mixing Or Mix(CurrentSong)\Fading    
    Mix(CurrentSong)\Mixing = #False 
    Mix(CurrentSong)\Fading = #False  
    startTime = -1
    HideGadget(#TrackbarTransition, #True)
    HideGadget(#Trackbar, #False)
  EndIf

  If Not DecodingMix And BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING
    If Not EndOfMix
      ButtonStop(#PB_EventType_LeftClick)
      PlayerActive = #True
    EndIf
  EndIf
  
  BASS_Mixer_ChannelRemove(Mix(CurrentSong)\Channel) 
  BASS_Mixer_ChannelRemove(Mix(NextSong)\Channel)   
  
  SelectElement(Songs(), Row)
  CopySong(CurrentSong)    
  
  If Not DecodingMix
    UpdateSongInfo(CurrentSong)
  EndIf
  
  SetTrackBarMaximum()
  DisableGadget(#Trackbar, #False)
 
  FileFullPath1 = Preferences\PathAudio + OSPath(Mix(CurrentSong)\AudioFilename)
  Mix(CurrentSong)\Channel = CreateChannel(FileFullPath1, #BASS_STREAM_DECODE|#BASS_ASYNCFILE|#BASS_FX_FREESOURCE|#BASS_SAMPLE_FLOAT)
  
  BASS_ChannelSetAttribute(Mix(CurrentSong)\Channel, #BASS_ATTRIB_FREQ, Mix(CurrentSong)\Samplerate) 
  Volume(Mix(CurrentSong)\Channel, 1.0)     

  BASS_Mixer_StreamAddChannel(Chan\Mixer, Mix(CurrentSong)\Channel, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN|#BASS_MIXER_BUFFER|#BASS_MIXER_DOWNMIX)          

  If NextElement(Songs())
    NextSongLoaded = #True
    CopySong(NextSong)    
    FileFullPath2 = Preferences\PathAudio + OSPath(Mix(NextSong)\AudioFilename)     
    Mix(NextSong)\Channel = CreateChannel(FileFullPath2, #BASS_STREAM_DECODE|#BASS_ASYNCFILE|#BASS_FX_FREESOURCE|#BASS_SAMPLE_FLOAT)    
    BASS_ChannelSetAttribute(Mix(NextSong)\Channel, #BASS_ATTRIB_FREQ, Mix(NextSong)\Samplerate)         
  EndIf    
  
  If PlayerActive 
    If FileSize(FileFullPath1) = -1
      ButtonStop(#PB_EventType_LeftClick)
      MessageRequester("Playing error", "File does not exist: " + FileFullPath1, #PB_MessageRequester_Error) 
      ProcedureReturn
    EndIf
    
    If NextSongLoaded And FileSize(FileFullPath2) = -1
      ButtonStop(#PB_EventType_LeftClick)          
      MessageRequester("Playing error", "File does not exist: " + FileFullPath2, #PB_MessageRequester_Error)          
      ProcedureReturn
    EndIf
 
    ButtonPlay(#PB_EventType_LeftClick)
  EndIf 
  SetSynchronizers()
  
  If Row = 0   
    BASS_ChannelSetPosition(Mix(CurrentSong)\Channel, 0, #BASS_POS_BYTE)     
    PausedCurrentSongPos = 0
  Else
    BASS_ChannelSetPosition(Mix(CurrentSong)\Channel, BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\IntroEnd), #BASS_POS_BYTE)          
    PausedCurrentSongPos = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\IntroEnd)
  EndIf   
  
  EndOfMix = #False
 
  UpdateTimeLabels()
EndProcedure

Procedure.f PrestartRestSeconds(Position.f, NoSkip = #True)
  Protected.f SkipSecond
  Protected.f SpaceLeft = Mix(CurrentSong)\BreakStart - Mix(CurrentSong)\SkipEnd
  
  If Mix(CurrentSong)\Shorten
    SkipSecond = Mix(CurrentSong)\SkipEnd - Mix(CurrentSong)\SkipStart
  EndIf     
 
  If SpaceLeft < Mix(NextSong)\IntroPrefix And SkipSecond > 0
    Position = Mix(CurrentSong)\SkipStart - Abs(SpaceLeft - Mix(NextSong)\IntroPrefix) 
    
    If Not NoSkip 
      Position - SkipSecond  
    EndIf
  EndIf
  
  ProcedureReturn Position
EndProcedure

Procedure.f TransitionLength(MixPointStart.f, MixPointEnd.f, MixPointLoopStart.f, MixPointLoopEnd.f, MixPointLoopRepeat.i)
  Protected.f TransitionLength
  
  TransitionLength = MixPointEnd - MixPointStart 
 
  ;If there's a loop between the mixpoints, the playing length must be extended
  If MixPointLoopStart > 0 And MixPointLoopEnd > 0 And MixPointLoopRepeat > 0
   TransitionLength + (MixPointLoopRepeat * (MixPointLoopEnd - MixPointLoopStart))
  EndIf     

  ProcedureReturn TransitionLength 
EndProcedure

Procedure Volume(Channel, Volume.f, InitVolume.f = -1, Seconds.f = 0.0)
  Busy = #True  
  
  VolFX = BASS_ChannelSetFX(Channel, #BASS_FX_VOLUME, 0)   
  Dim param.BASS_FX_VOLUME_PARAM(0) 
  
  Param(0)\fTarget = Volume
  Param(0)\fCurrent = InitVolume  
  Param(0)\fTime = Seconds
  
  BASS_FXSetParameters(VolFX, @Param(0)) 
  Busy = #False  
EndProcedure

Procedure Mute(Stream.i, Channel.i, BassData.i, User.i)
  Volume(Channel, 0)
EndProcedure  

Procedure Skip(Stream.i, Channel.i, BassData.i, EndPosition.q) 
  Busy = #True
 
  BASS_ChannelSetPosition(Channel, EndPosition, #BASS_POS_BYTE)  

  Busy = #False
EndProcedure

Procedure IntroLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  Busy = #True

  If Mix(CurrentSong)\Mixing And Mix(NextSong)\IntroLoopCounter < Mix(NextSong)\IntroLoopRepeat   
    BASS_ChannelSetPosition(Channel, StartPosition, #BASS_POS_BYTE)
    Mix(NextSong)\IntroLoopCounter + 1 
  EndIf
  
  Busy = #False
EndProcedure

Procedure BreakLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  Busy = #True
 
  If (Mix(CurrentSong)\Mixing Or Mix(CurrentSong)\Fading) And Mix(CurrentSong)\BreakLoopCounter < Mix(CurrentSong)\BreakLoopRepeat   
    BASS_ChannelSetPosition(Channel, StartPosition, #BASS_POS_BYTE)
    Mix(CurrentSong)\BreakLoopCounter + 1 
  EndIf
 
  Busy = #False  
EndProcedure

Procedure StartBeatSyncLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  BASS_Mixer_StreamAddChannel(Chan\MixerBeatTest, Chan\Beat, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN)             
EndProcedure

Procedure CustomTransitionIntroLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  Busy = #True

  If CustomTransition\IntroLoopCounter < CustomTransition\IntroLoopRepeat   
    BASS_ChannelSetPosition(Chan\CustomTransitionIntro, StartPosition, #BASS_POS_BYTE)
    CustomTransition\IntroLoopCounter + 1 
  EndIf
  
  Busy = #False
EndProcedure

Procedure CustomTransitionBreakLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  Busy = #True

  If CustomTransition\BreakLoopCounter < CustomTransition\BreakLoopRepeat   
    BASS_ChannelSetPosition(Chan\CustomTransitionBreak, StartPosition, #BASS_POS_BYTE)
    CustomTransition\BreakLoopCounter + 1 
  EndIf
  
  Busy = #False  
EndProcedure 
 
Procedure IntroTestLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  Busy = #True
  
  If DatabaseSong\IntroLoopCounter < DatabaseSong\IntroLoopRepeat   
    BASS_ChannelSetPosition(Channel, StartPosition, #BASS_POS_BYTE)
    DatabaseSong\IntroLoopCounter + 1 
  EndIf
  
  Busy = #False
EndProcedure

Procedure BreakTestLoop(Stream.i, Channel.i, BassData.i, StartPosition) 
  Busy = #True
 
  If DatabaseSong\BreakLoopCounter < DatabaseSong\BreakLoopRepeat   
    BASS_ChannelSetPosition(Channel, StartPosition, #BASS_POS_BYTE)
    DatabaseSong\BreakLoopCounter + 1  
  EndIf
  
  Busy = #False  
EndProcedure

Procedure FadeOutLastSong()  
  Busy = #True  
 
  Protected.f Length = TransitionLength(Mix(CurrentSong)\BreakStart, Mix(CurrentSong)\BreakEnd, Mix(CurrentSong)\BreakLoopStart, Mix(CurrentSong)\BreakLoopEnd, Mix(CurrentSong)\BreakLoopRepeat)

  Volume(Mix(CurrentSong)\Channel, 0, -1, Length - 1)
  
  Mix(CurrentSong)\Fading = #True
  Busy = #False  
EndProcedure
  
Procedure MixPrefix(Stream.i, Channel.i, BassData.i, Samplerate.i)  
  Busy = #True  
  
  Protected.q NextPosBytes = BASS_ChannelSeconds2Bytes(Mix(NextSong)\Channel, Mix(NextSong)\IntroStart - Mix(NextSong)\IntroPrefix)
  Protected.f MaxVol = GetGadgetState(#TrackbarVolume) / 100  
  Protected.f IntroLength = TransitionLength(Mix(NextSong)\IntroStart, Mix(NextSong)\IntroEnd, Mix(NextSong)\IntroLoopStart, Mix(NextSong)\IntroLoopEnd, Mix(NextSong)\IntroLoopRepeat)  
  
  If Mix(NextSong)\IntroFade
    Volume(Mix(NextSong)\Channel, MaxVol, 0.0, IntroLength + Mix(NextSong)\IntroPrefix)  
  EndIf
  
  Dim Param.BASS_BFX_BQF(0)  
  
  Param(0)\lFilter = #BASS_BFX_BQF_HIGHPASS
  Param(0)\fCenter = 250
  Param(0)\fBandwidth = 0
  Param(0)\fQ = 0.7   
  Param(0)\lChannel = #BASS_BFX_CHANALL 
  Volume(Mix(NextSong)\Channel, 1.0)     
 
  BASS_ChannelSetPosition(Mix(NextSong)\Channel, NextPosBytes, #BASS_POS_BYTE)   
   
  If Mix(CurrentSong)\BreakBeats And Mix(NextSong)\IntroBeats  
    If Preferences\FilterOverlappedBeats = "Current song" Or Preferences\FilterOverlappedBeats = "Both songs"
      Mix(CurrentSong)\FX = BASS_ChannelSetFX(Mix(CurrentSong)\Channel, #BASS_FX_BFX_BQF, 0)      
      BASS_FXSetParameters(Mix(CurrentSong)\FX, @param(0))  
      Volume(Mix(CurrentSong), 0.9)
    EndIf
  
    If Preferences\FilterOverlappedBeats = "Next song" Or Preferences\FilterOverlappedBeats = "Both songs" 
      Mix(NextSong)\FX = BASS_ChannelSetFX(Mix(NextSong)\Channel, #BASS_FX_BFX_BQF, 0)     
      BASS_FXSetParameters(Mix(NextSong)\FX, @param(0))   
      Volume(Mix(NextSong), 0.9)      
    EndIf        
  EndIf
 
  BASS_ChannelSetAttribute(Mix(NextSong)\Channel, #BASS_ATTRIB_FREQ, Samplerate)     
  BASS_ChannelSetPosition(Mix(NextSong)\Channel, NextPosBytes, #BASS_POS_BYTE)      
  BASS_Mixer_StreamAddChannel(Chan\Mixer, Mix(NextSong)\Channel, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN|#BASS_MIXER_DOWNMIX|#BASS_MIXER_BUFFER)
  
  Mix(CurrentSong)\Mixing = #True  
  Busy = #False  
EndProcedure
 
Procedure StartTransition(Handle.i, Channel.i, BassData.i, Samplerate.i) 
  Busy = #True  
   
  Protected.f BreakEndSec = Mix(CurrentSong)\BreakEnd + Mix(CurrentSong)\BreakContinue - 0.025 
  Protected.q BreakEndBytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, BreakEndSec)  
  Protected.q IntroLoopStartBytes = BASS_ChannelSeconds2Bytes(Mix(NextSong)\Channel, Mix(NextSong)\IntroLoopStart)
  Protected.q IntroLoopEndBytes = BASS_ChannelSeconds2Bytes(Mix(NextSong)\Channel, Mix(NextSong)\IntroLoopEnd)   
  Protected.q NextPosBytes = BASS_ChannelSeconds2Bytes(Mix(NextSong)\Channel, Mix(NextSong)\IntroStart) 
  Protected.f NextMaxVol = 1.0 , CurrentMaxVol = 1.0
  Protected.f IntroLength = TransitionLength(Mix(NextSong)\IntroStart, Mix(NextSong)\IntroEnd, Mix(NextSong)\IntroLoopStart, Mix(NextSong)\IntroLoopEnd, Mix(NextSong)\IntroLoopRepeat)  
  Protected.f BreakLength = TransitionLength(Mix(CurrentSong)\BreakStart, Mix(CurrentSong)\BreakEnd, Mix(CurrentSong)\BreakLoopStart, Mix(CurrentSong)\BreakLoopEnd, Mix(CurrentSong)\BreakLoopRepeat)
  Protected.f StartTime2Bytes, EndTime2Bytes
  
  Dim Param.BASS_BFX_BQF(0)  
  
  Param(0)\lFilter = #BASS_BFX_BQF_HIGHPASS
  Param(0)\fCenter = 250
  Param(0)\fBandwidth = 0
  Param(0)\fQ = 0.7   
  Param(0)\lChannel = #BASS_BFX_CHANALL 
  Volume(Mix(NextSong)\Channel, 1.0)     
 
  BASS_ChannelSetPosition(Mix(NextSong)\Channel, NextPosBytes, #BASS_POS_BYTE)   
  
  If Mix(NextSong)\IntroPrefix = 0
    If Mix(CurrentSong)\BreakBeats And Mix(NextSong)\IntroBeats  
      If Preferences\FilterOverlappedBeats = "Current song" Or Preferences\FilterOverlappedBeats = "Both songs"
        Mix(CurrentSong)\FX = BASS_ChannelSetFX(Mix(CurrentSong)\Channel, #BASS_FX_BFX_BQF, 0)      
        BASS_FXSetParameters(Mix(CurrentSong)\FX, @param(0))      
        CurrentMaxVol = 0.9      
      EndIf
    
      If Preferences\FilterOverlappedBeats = "Next song" Or Preferences\FilterOverlappedBeats = "Both songs" 
        Mix(NextSong)\FX = BASS_ChannelSetFX(Mix(NextSong)\Channel, #BASS_FX_BFX_BQF, 0)     
        BASS_FXSetParameters(Mix(NextSong)\FX, @param(0)) 
        NextMaxVol = 0.9   
      EndIf        
    EndIf
  EndIf
   
  If Mix(NextSong)\IntroFade
    If Mix(NextSong)\IntroPrefix = 0       
      Volume(Mix(NextSong)\Channel, NextMaxVol, 0.0, IntroLength) 
    EndIf
  Else
    Volume(Mix(CurrentSong)\Channel, CurrentMaxVol)    
    Volume(Mix(NextSong)\Channel, NextMaxVol)
  EndIf
  
  If Mix(CurrentSong)\BreakFade      
    Volume(Mix(CurrentSong)\Channel, 0.0, CurrentMaxVol, BreakLength + Mix(CurrentSong)\BreakContinue) 
  Else
    Volume(Mix(CurrentSong)\Channel, CurrentMaxVol)
  EndIf    
    
  BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, BreakEndBytes, @StopTransition(), 0) 
  
  If Mix(CurrentSong)\Number < ListSize(Songs())   
    If Mix(NextSong)\IntroPrefix = 0 Or (Mix(NextSong)\IntroPrefix > 0 And Mix(NextSong)\IntroFade)  
      BASS_ChannelSetAttribute(Mix(NextSong)\Channel, #BASS_ATTRIB_FREQ, Samplerate)    
      BASS_Mixer_StreamAddChannel(Chan\Mixer, Mix(NextSong)\Channel, #BASS_STREAM_AUTOFREE|#BASS_MIXER_NORAMPIN|#BASS_MIXER_DOWNMIX|#BASS_MIXER_BUFFER)
    EndIf   
  EndIf
  
  BeatSynchronizer(0, 0, 0, Mix(CurrentSong)\Samplerate)   
  
  If Mix(NextSong)\IntroLoopStart + Mix(NextSong)\IntroLoopEnd > 0
    Mix(NextSong)\IntroLoopCounter = 0        
    BASS_Mixer_ChannelSetSync(Mix(NextSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, IntroLoopEndBytes, @IntroLoop(), IntroLoopStartBytes)
  EndIf     
  
  If Mix(CurrentSong)\BreakContinue > 0 And Mix(NextSong)\Shorten And Mix(NextSong)\SkipStart > 0 And Mix(NextSong)\SkipEnd > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(NextSong)\Channel, Mix(NextSong)\SkipStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(NextSong)\Channel, Mix(NextSong)\SkipEnd)
    BASS_Mixer_ChannelSetSync(Mix(NextSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @Skip(), EndTime2Bytes)
  EndIf  
 
  Mix(CurrentSong)\Mixing = #True 
  Busy = #False  
EndProcedure

Procedure StopTransition(Handle.i, Channel.i, BassData.i, FX.i) 
  Busy = #True   
 
  Protected.i Index

  If Mix(CurrentSong)\Mixing And Mix(CurrentSong)\BreakLoopStart > 0 And Mix(CurrentSong)\BreakLoopEnd > 0 And Mix(CurrentSong)\BreakLoopCounter < Mix(CurrentSong)\BreakLoopRepeat 
    ProcedureReturn
  EndIf
 
  If Mix(CurrentSong)\BreakBeats And Mix(NextSong)\IntroBeats  
    BASS_ChannelRemoveFX(Mix(CurrentSong)\Channel, Mix(CurrentSong)\FX)  
    BASS_ChannelRemoveFX(Mix(NextSong)\Channel, Mix(NextSong)\FX)   
  EndIf

  BASS_Mixer_ChannelRemove(Mix(CurrentSong)\Channel) 
  BASS_ChannelSetAttribute(Mix(NextSong)\Channel, #BASS_ATTRIB_FREQ, Mix(NextSong)\Samplerate)

  Volume(Mix(NextSong)\Channel, 1.0)   
  
  Swap CurrentSong, Nextsong  
  
  Mix(CurrentSong)\Mixing = #False
  
  If Mix(NextSong)\Number < ListSize(Songs())
    If Decoding      
      ThreadNextSong(#Null)     
    Else             
      If Mix(NextSong)\Number + 1 = ListSize(Songs()) And Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random" 
        FirstSongID = Mix(CurrentSong)\ID 
      Else        
        CreateThread(@ThreadNextSong(), 0)   
      EndIf
    EndIf
  Else
    ;Stop the mix at end of last song
    Swap CurrentSong, Nextsong     
    EndOfMix = #True
 
    ButtonStop(#PB_EventType_LeftClick)    
  EndIf
  
  ;Mixing = #False
  Busy = #False  
EndProcedure 

Procedure BeatSynchronizer(Stream.i, Channel.i, BassData.i, Samplerate.i) 
  Busy = #True
  
  Protected.s Item1 = StringField(Mix(NextSong)\IntroBeatList, Mix(CurrentSong)\BeatCounter + 1, Chr(10)) 
  Protected.s Item2 = StringField(Mix(NextSong)\IntroBeatList, Mix(CurrentSong)\BeatCounter + 2, Chr(10)) 
  Protected.s Item3 = StringField(Mix(CurrentSong)\BreakBeatList, Mix(CurrentSong)\BeatCounter + 1, Chr(10))
  Protected.s Item4 = StringField(Mix(CurrentSong)\BreakBeatList, Mix(CurrentSong)\BeatCounter + 2, Chr(10))  
  Protected.f BeatLength = ValD(Item4) - ValD(Item3) 
  Protected.f BeatLength1 = ValD(Item2) - ValD(Item1)
  Protected.f FreqRatio = (BeatLength1 / BeatLength) * (Mix(NextSong)\OrigFreq / Mix(CurrentSong)\OrigFreq)
  Protected.f NextSyncSec = Mix(CurrentSong)\BreakStart + (BeatLength * (Mix(CurrentSong)\BeatCounter + 1))
  Protected.q SyncPosBytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, NextSyncSec)

  BASS_ChannelSetAttribute(Mix(NextSong)\Channel, #BASS_ATTRIB_FREQ, Samplerate * FreqRatio) 
 
  If Mix(CurrentSong)\BeatCounter < 30   
    BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, SyncPosBytes, @BeatSynchronizer(), Samplerate)   
    Mix(CurrentSong)\BeatCounter + 1   
  EndIf    
  
  Busy = #False  
EndProcedure

Procedure BeatCustomTransitionSynchronizer(Stream.i, Channel.i, BassData.i, Samplerate.i)   
  Busy = #True
 
  Protected.s IntroBeatList, BreakBeatList, Item1, Item2, Item3, Item4
  Protected.d BeatLength, BeatLength1
  Protected.f NextSyncSec, FreqRatio
  Protected.q SyncPosBytes
 
  IntroBeatList = GenerateBeatList(CustomTransition\IntroBeatList, CustomTransition\IntroStart, CustomTransition\IntroEnd, #True, CustomTransition\IntroLoopStart, CustomTransition\IntroLoopEnd, CustomTransition\IntroLoopRepeat)   
  BreakBeatList = GenerateBeatList(CustomTransition\BreakBeatList, CustomTransition\BreakStart, CustomTransition\BreakEnd, #False, CustomTransition\BreakLoopStart, CustomTransition\BreakLoopEnd, CustomTransition\BreakLoopRepeat)      
 
  Item1 = StringField(IntroBeatList, CustomTransition\BeatCounter + 1, Chr(10)) 
  Item2 = StringField(IntroBeatList, CustomTransition\BeatCounter + 2, Chr(10))    
  Item3 = StringField(BreakBeatList, CustomTransition\BeatCounter + 1, Chr(10))
  Item4 = StringField(BreakBeatList, CustomTransition\BeatCounter + 2, Chr(10))  
 
  BeatLength = ValD(Item4) - ValD(Item3) 
  BeatLength1 = ValD(Item2) - ValD(Item1)
  FreqRatio = (BeatLength1 / BeatLength) * (FileSamplerateIntro / FileSamplerateBreak)
  NextSyncSec = CustomTransition\BreakStart + (BeatLength * (CustomTransition\BeatCounter + 1))
  SyncPosBytes = BASS_ChannelSeconds2Bytes(Chan\CustomTransitionBreak, NextSyncSec)
  
  BASS_ChannelSetAttribute(Chan\CustomTransitionIntro, #BASS_ATTRIB_FREQ, Samplerate * FreqRatio)
 
  If CustomTransition\BeatCounter < 30    
    BASS_Mixer_ChannelSetSync(Chan\CustomTransitionBreak, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, SyncPosBytes, @BeatCustomTransitionSynchronizer(), Samplerate)    
    CustomTransition\BeatCounter + 1    
  EndIf    
 
  Busy = #False  
EndProcedure

Procedure BeatTestSynchronizer(Stream.i, Channel.i, BassData.i, Intro.i)   
  Busy = #True
 
  Protected.s SongBeatList, TestBeatList, Item1, Item2, Item3, Item4
  Protected.d BeatLength, BeatLength1
  Protected.f NextSyncSec, FreqRatio
  Protected.q SyncPosBytes
  
  If Intro = 1
    SongBeatList = GenerateBeatList(DatabaseSong\IntroBeatList, DatabaseSong\IntroStart, DatabaseSong\IntroEnd, #True, DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd, DatabaseSong\IntroLoopRepeat)   
  Else
    SongBeatList = GenerateBeatList(DatabaseSong\BreakBeatList, DatabaseSong\BreakStart, DatabaseSong\BreakEnd, #False, DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd, DatabaseSong\BreakLoopRepeat)       
  EndIf
  
  TestBeatList = GenerateBeatList("", 0, BASS_ChannelBytes2Seconds(Chan\Beat, BASS_ChannelGetLength(Chan\Beat, #BASS_POS_BYTE)), #False, -1, -1, -1)        
  
  Item1 = StringField(TestBeatList, DatabaseSong\BeatCounter + 1, Chr(10)) 
  Item2 = StringField(TestBeatList, DatabaseSong\BeatCounter + 2, Chr(10))    
  Item3 = StringField(SongBeatList, DatabaseSong\BeatCounter + 1, Chr(10))
  Item4 = StringField(SongBeatList, DatabaseSong\BeatCounter + 2, Chr(10))  
 
  BeatLength = ValD(Item4) - ValD(Item3) 
  BeatLength1 = ValD(Item2) - ValD(Item1)
  FreqRatio = (BeatLength1 / BeatLength) * (44100 / DatabaseSong\OrigFreq)

  If Intro = 1
    NextSyncSec = DatabaseSong\IntroStart + (BeatLength * (DatabaseSong\BeatCounter + 1))
  Else
    NextSyncSec = DatabaseSong\BreakStart + (BeatLength * (DatabaseSong\BeatCounter + 1))    
  EndIf  

  SyncPosBytes = BASS_ChannelSeconds2Bytes(Chan\Song, NextSyncSec)
 
  BASS_ChannelSetAttribute(Chan\Beat, #BASS_ATTRIB_FREQ, DatabaseSong\OrigFreq * FreqRatio)

  If DatabaseSong\BeatCounter < 30    
    BASS_Mixer_ChannelSetSync(Chan\Song, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, SyncPosBytes, @BeatTestSynchronizer(), Intro)    
    DatabaseSong\BeatCounter + 1    
  EndIf    
  
  Busy = #False  
EndProcedure

Procedure SetSynchronizers()  
  Protected.q StartTime2Bytes, EndTime2Bytes
  Protected.f SkipEndPosition
  Protected.b InfiniteMode
 
  If Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random" 
    InfiniteMode = #True
  EndIf  

  If Not Mix(CurrentSong)\Mixing And Mix(CurrentSong)\Shorten And Mix(CurrentSong)\SkipStart > 0 And Mix(CurrentSong)\SkipEnd > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\SkipStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\SkipEnd)
    BASS_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @Skip(), EndTime2Bytes)
  EndIf  
 
  If Mix(CurrentSong)\BreakMute > 0 
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\BreakEnd - Mix(CurrentSong)\BreakMute)
    BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @Mute(), 0)    
  EndIf      
  
  If Mix(CurrentSong)\BreakLoopStart > 0 And Mix(CurrentSong)\BreakLoopEnd > 0 And Mix(CurrentSong)\BreakLoopRepeat > 0
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\BreakLoopStart)
    EndTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\BreakLoopEnd)
    Mix(CurrentSong)\BreakLoopCounter = 0
    BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, EndTime2Bytes, @BreakLoop(), StartTime2Bytes)
  EndIf     
  
  If Mix(CurrentSong)\Number < ListSize(Songs())  
    If Mix(NextSong)\IntroPrefix > 0
      StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, PrestartRestSeconds(Mix(CurrentSong)\BreakStart - Mix(NextSong)\IntroPrefix))
      BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @MixPrefix(), Mix(NextSong)\Samplerate)  
    EndIf
 
    Mix(CurrentSong)\BeatCounter = 0        
    StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\BreakStart)  
    BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME|#BASS_SYNC_ONETIME, StartTime2Bytes, @StartTransition(), Mix(NextSong)\Samplerate)   
  ElseIf Not InfiniteMode 
    ;Set syncs for the last song 
    If Mix(CurrentSong)\Shorten    
      StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\BreakStart)        
      BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @FadeOutLastSong(), 0)   
      StartTime2Bytes = BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\BreakEnd)     
      BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_POS|#BASS_SYNC_MIXTIME, StartTime2Bytes, @StopTransition(), 0)        
    Else  
      BASS_Mixer_ChannelSetSync(Mix(CurrentSong)\Channel, #BASS_SYNC_END|#BASS_SYNC_MIXTIME, 2, @StopTransition(), 0)    
    EndIf
  EndIf    
EndProcedure 
 
Procedure RealTimeSyncs(PosSec.f)
  Protected.f FadeStep, FadeVol
  Protected.f CurrentVol = GetGadgetState(#TrackbarVolume) / 100
  Protected.f IntroLength = TransitionLength(DatabaseSong\IntroStart, DatabaseSong\IntroEnd, DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd, DatabaseSong\IntroLoopRepeat)  
  Protected.f BreakLength = TransitionLength(DatabaseSong\BreakStart, DatabaseSong\BreakEnd, DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd, DatabaseSong\BreakLoopRepeat)
  Protected.f Extra, FadeLength
  
  If DatabaseSong\BreakMute > 0 
    If PosSec >= DatabaseSong\BreakStart And PosSec >= DatabaseSong\BreakEnd - DatabaseSong\BreakMute And PosSec < DatabaseSong\BreakEnd
      If Not RealTimeFX\Mute 
        RealTimeFX\Mute = #True
        BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, 0)
      EndIf
    Else
      If RealTimeFX\Mute
        RealTimeFX\Mute = #False
        BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, CurrentVol)                                              
      EndIf
    EndIf 
  Else
    RealTimeFX\Mute = #False
  EndIf  
  
  If GetGadgetState(#IntroFadeIn)  
    If PosSec >= DatabaseSong\IntroStart - DatabaseSong\IntroPrefix And PosSec < DatabaseSong\IntroEnd      
      RealTimeFX\FadeIn = #True
      FadeStep = CurrentVol / (IntroLength + DatabaseSong\IntroPrefix)
      
      If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And DatabaseSong\IntroLoopRepeat > 0 
        Extra = (DatabaseSong\IntroLoopEnd - DatabaseSong\IntroLoopStart) * DatabaseSong\IntroLoopCounter
      EndIf
        
      FadeVol = (PosSec + Extra - DatabaseSong\IntroStart + DatabaseSong\IntroPrefix) * FadeStep
      
      BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, FadeVol)                  
    ElseIf RealTimeFX\FadeIn
      RealTimeFX\FadeIn = #False
      BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, CurrentVol)                                              
    EndIf 
  Else
    If RealTimeFX\FadeIn
      BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, CurrentVol)         
      RealTimeFX\FadeIn = #False    
    EndIf
  EndIf  
  
  If GetGadgetState(#BreakFadeOut) 
    If Not RealTimeFX\Mute
      If PosSec >= DatabaseSong\BreakStart And PosSec < DatabaseSong\BreakEnd + DatabaseSong\BreakContinue  
        RealTimeFX\FadeOut = #True
        FadeStep = CurrentVol / (BreakLength + DatabaseSong\BreakContinue)
        
        If DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And DatabaseSong\BreakLoopRepeat > 0 
          Extra = (DatabaseSong\BreakLoopEnd - DatabaseSong\BreakLoopStart) * DatabaseSong\BreakLoopCounter
        EndIf
        FadeVol = (PosSec + Extra - DatabaseSong\BreakStart) * FadeStep
        
        BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, CurrentVol - FadeVol)                  
      ElseIf RealTimeFX\FadeOut
        RealTimeFX\FadeOut = #False
        BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, CurrentVol)                                              
      EndIf  
    EndIf
  Else
    If RealTimeFX\FadeOut
      BASS_ChannelSetAttribute(Chan\Database, #BASS_ATTRIB_VOL, CurrentVol)     
      RealTimeFX\FadeOut = #False        
    EndIf
  EndIf    
EndProcedure

;------------------------------------ Threads

Procedure ThreadDecoding(Void)
  Dim buf(1024)

  While BASS_ChannelIsActive(Chan\Mixer) And Not StopDecoding 
    BASS_ChannelGetData(Chan\Mixer, @buf(0), 1024)  
  Wend    
EndProcedure

Procedure ThreadCollectFiles(void)
  NewList Files.s() 
   
  ListFilesRecursive(CollectingFilesPath, Files()) 
  
  StopCollectingFiles = #True    
EndProcedure 

Procedure ThreadNextSong(void)
  Protected.s FileFullPath
  Protected.i Row = GetGadgetState(#ListiconPlaylist)
  
  ;Load next song
  NextElement(Songs())
  CopySong(NextSong) 
  FileFullPath = Preferences\PathAudio + OSPath(Mix(NextSong)\AudioFilename)

  ;Check if files exists
  If FileSize(FileFullPath) = -1
    ButtonStop(#PB_EventType_LeftClick)    
    MessageRequester("Playing error", "File does not exist: " + FileFullPath, #PB_MessageRequester_Error)    
    ProcedureReturn      
  EndIf 
 
  Mix(NextSong)\Channel = CreateChannel(FileFullPath, #BASS_STREAM_DECODE|#BASS_ASYNCFILE|#BASS_FX_FREESOURCE|#BASS_SAMPLE_FLOAT)

  BASS_ChannelSetAttribute(Mix(NextSong)\Channel, #BASS_ATTRIB_FREQ, Mix(NextSong)\Samplerate)   
  SetSynchronizers()
EndProcedure

;------------------------------------ Waveform

Procedure DrawCursor()
  Protected.i Y
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)  
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)
  
  StartDrawing(CanvasOutput(#CanvasWaveform))   
  DrawImage(ImageID(#OriginalWaveImage), 0, 0)
   
  For Y = 0 To WaveformHeight Step 3
    Line(DatabaseSong\CursorX, Y, 1, 1, RGB(255, 255, 0))
  Next Y    

  GrabDrawingImage(#CursorWaveImage, 0, 0, WaveformWidth, WaveformHeight)      
  StopDrawing()     
EndProcedure

Procedure CalcCursorPos(Startpos.f)
  Protected.q CursorBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\CursorSec)    
  Protected.q BeforePosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, StartPos)    
  
  DatabaseSong\CursorX = (CursorBytes - BeforePosBytes) / DatabaseSong\BytesPerPixel  
EndProcedure

Procedure.f CalcMarkerPos(Pos.f)
  If Pos > 0
    ProcedureReturn Pos
  Else
    ProcedureReturn 10000
  EndIf  
EndProcedure

Procedure DrawMarker(Text.s, Top.b, Pos.f, Font.i, MovePixels.i, Lbl.i, EndMarker.b = #False)  
  Protected.q PosBytes, BeforePosBytes 
  Protected.i x, y, ypos, LoopRepeat
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)
 
  If Pos > 0     
    Select Text
      Case "Skip begin"       
        Pos = DatabaseSong\SkipStart         
      Case "Skip end"
        Pos = DatabaseSong\SkipEnd                   
      Case "Intro loop begin"        
        Pos = DatabaseSong\IntroLoopStart   
        LoopRepeat = DatabaseSong\IntroLoopRepeat  
      Case "Intro loop end"
        Pos = DatabaseSong\IntroLoopEnd
      Case "Break loop begin"
        Pos = DatabaseSong\BreakLoopStart   
        LoopRepeat = DatabaseSong\BreakLoopRepeat          
      Case "Break loop end"        
        Pos = DatabaseSong\BreakLoopEnd
      Case "Intro prestart"
        Pos = DatabaseSong\IntroStart - Pos
      Case "Break mute"
        Pos = DatabaseSong\BreakEnd - Pos
      Case "Break continue"
        Pos = DatabaseSong\BreakEnd + Pos
    EndSelect  
     
    PosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, Pos)    
    BeforePosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)
    x = (PosBytes - BeforePosBytes) / DatabaseSong\BytesPerPixel    
  
    If Top
      y = MovePixels 
    Else
      y = (WaveformHeight - 14) - MovePixels
    EndIf
    
    If Not Lbl
      For ypos = 0 To WaveformHeight Step 6
        Line(x, ypos, 1, 3, RGB(255, 150, 0))    
      Next ypos                               
    ElseIf Not EndMarker    
      Text = ReplaceString(Text, " begin", "")
      Text = ReplaceString(Text, " end", "")
      Text = ReplaceString(Text, "Intro ", "")
      Text = ReplaceString(Text, "Break ", "")
      Text = ReplaceString(Text, "prestart", "Prestart")
      Text = ReplaceString(Text, "continue", "Cont.")      
      
      If LoopRepeat > 0
        Text + " " + Str(LoopRepeat + 1) + " x"
      EndIf 
      
      Text = Left(Text, 8)
      Text = LSet(Text, 8, " ")        
  
      DrawingFont(FontID(Font))
      DrawText(x, y, " " + Text + "  ", RGB(0, 0, 0), RGB(255, 255, 204))      
    EndIf    
  EndIf  
EndProcedure

Procedure DrawMarkers(Image = #OriginalWaveImage)
  Protected.s IntroList = ReplaceString(DatabaseSong\IntroBeatList, Chr(13), Chr(10)) 
  Protected.s BreakList.s = ReplaceString(DatabaseSong\BreakBeatList, Chr(13), Chr(10)) 
  Protected.i IntroBeats = CountString(IntroList, Chr(10))
  Protected.i BreakBeats = CountString(BreakList, Chr(10))
  Protected.i SmallFont = LoadFont(#PB_Any, "Bebas-Regular", 8)  
  Protected.i Step1 = 0, Step2 = 20
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)
  Protected.i Beat, i, x1, x2 
  Protected.q PosBytes1, PosBytes2, BeforePosBytes1, BeforePosBytes2
 
  UpdateCanvas()  
  
  StartDrawing(CanvasOutput(#CanvasWaveform))  
  DrawImage(ImageID(Image), 0, 0)
  
  For i = 0 To 1
    DrawMarker("Intro prestart", #True, DatabaseSong\IntroPrefix, SmallFont, 20, i)       
    DrawMarker("Intro begin", #True, DatabaseSong\IntroStart, SmallFont, 0, i)    
    DrawMarker("Intro end", #False, DatabaseSong\IntroEnd, SmallFont, 0, i, #True) 
    DrawMarker("Intro loop begin", #True, DatabaseSong\IntroLoopStart, SmallFont, 40, i)
    DrawMarker("Intro loop end", #False, DatabaseSong\IntroLoopEnd, SmallFont, 40, i, #True)        
    DrawMarker("Break begin", #True, DatabaseSong\BreakStart, SmallFont, 0, i)     
    DrawMarker("Break end", #False, DatabaseSong\BreakEnd, SmallFont, 0, i, #True) 
    DrawMarker("Break mute", #True, DatabaseSong\BreakMute, SmallFont, 20, i)  
    DrawMarker("Break continue", #False, DatabaseSong\BreakContinue, SmallFont, 20, i) 
    DrawMarker("Break loop begin", #True, DatabaseSong\BreakLoopStart, SmallFont, 40, i)
    DrawMarker("Break loop end", #False, DatabaseSong\BreakLoopEnd, SmallFont, 40, i, #True)        
    DrawMarker("Skip begin", #True, DatabaseSong\SkipStart, SmallFont, 0, i)
    DrawMarker("Skip end", #False, DatabaseSong\SkipEnd, SmallFont, 0, i, #True)     
        
    If IntroBeats > 0
      For Beat = 1 To IntroBeats
        DrawMarker("Intro beat " + Str(Beat), #True, Time2Seconds(StringField(IntroList, Beat, Chr(10))), SmallFont, ((WaveformHeight / 2) - 6) + Step1, i)  
        Swap Step1, Step2
      Next  
    EndIf
    
    Step1 = 0
    Step2 = 20    
    
    If BreakBeats > 0
      For Beat = 1 To BreakBeats
        DrawMarker("Break beat " + Str(Beat), #True, Time2Seconds(StringField(BreakList, Beat, Chr(10))), SmallFont, ((WaveformHeight / 2) - 6) + Step1, i)  
        Swap Step1, Step2        
      Next  
    EndIf
  Next 

  If GetGadgetState(#IntroFadeIn) And DatabaseSong\IntroStart > 0 And DatabaseSong\IntroEnd > 0 
    PosBytes1 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\IntroStart - DatabaseSong\IntroPrefix)    
    BeforePosBytes1 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)       
    x1 = (PosBytes1 - BeforePosBytes1) / DatabaseSong\BytesPerPixel       
    
    PosBytes2 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\IntroEnd)    
    BeforePosBytes2 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)       
    x2 = (PosBytes2 - BeforePosBytes2) / DatabaseSong\BytesPerPixel  
     
    LineXY(x1, WaveformHeight, x2, 0, RGB(128, 128, 128))   
  EndIf       
  
  If GetGadgetState(#BreakFadeOut) And DatabaseSong\BreakStart > 0 And DatabaseSong\BreakEnd > 0 
    PosBytes1 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\BreakStart)    
    BeforePosBytes1 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)       
    x1 = (PosBytes1 - BeforePosBytes1) / DatabaseSong\BytesPerPixel       
    
    PosBytes2 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\BreakEnd + DatabaseSong\BreakContinue)    
    BeforePosBytes2 = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)       
    x2 = (PosBytes2 - BeforePosBytes2) / DatabaseSong\BytesPerPixel  
     
    LineXY(x1, 0, x2, WaveformHeight, RGB(128, 128, 128))     
  EndIf   
      
  GrabDrawingImage(#OriginalWaveImage, 0, 0, WaveformWidth, WaveformHeight)           
  StopDrawing()
  DrawCursor()
EndProcedure

Procedure.b MarkerSelection(StartPos.f, EndPos.f)     
  Protected.q BeforePosBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewBegin)   
  Protected.q PosStart, PosEnd  
  Protected.f StartSec = StartPos 
  Protected.f EndSec = EndPos  
  
  If StartPos > 0 And EndPos > 0 
    If DatabaseSong\CursorSec >= StartPos And DatabaseSong\CursorSec <= EndPos And StartPos >= DatabaseSong\ViewBegin And StartPos <= DatabaseSong\ViewEnd And EndPos >= DatabaseSong\ViewBegin And EndPos <= DatabaseSong\ViewEnd     
      PosStart = BASS_ChannelSeconds2Bytes(Chan\Database, StartSec)
      PosEnd = BASS_ChannelSeconds2Bytes(Chan\Database, EndSec)
      DatabaseSong\CursorX = (PosStart - BeforePosBytes) / DatabaseSong\BytesPerPixel
      DrawSelection((PosEnd - BeforePosBytes) / DatabaseSong\BytesPerPixel)
      
      DatabaseSong\CursorSec = StartSec
      DatabaseSong\SelectionBegin = StartSec
      DatabaseSong\SelectionEnd = EndSec
      DatabaseSong\SelectionLength = EndSec - StartSec
      
      SetGadgetText(#CursorPosString, Seconds2TimeMS(DatabaseSong\CursorSec))
      SetGadgetText(#SelBeginString, Seconds2TimeMS(DatabaseSong\SelectionBegin))                    
      SetGadgetText(#SelEndString, Seconds2TimeMS(DatabaseSong\SelectionEnd)) 
      SetGadgetText(#SelLengthString, Seconds2TimeMS(DatabaseSong\SelectionLength))
      
      ProcedureReturn #True
    EndIf  
  EndIf  
EndProcedure

Procedure DoubleClickSelection(Left.b)
  Protected.f Distance = 10000
  Protected.f FoundPos
  Protected.i i
  
  Dim Position.f(8)
    
  If Not MarkerSelection(DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd) And Not MarkerSelection(DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd) And Not MarkerSelection(DatabaseSong\IntroStart, DatabaseSong\IntroEnd) And Not MarkerSelection(DatabaseSong\BreakStart, DatabaseSong\BreakEnd)            
    Position(0) = CalcMarkerPos(DatabaseSong\IntroPrefix)       
    Position(1) = CalcMarkerPos(DatabaseSong\IntroStart)
    Position(2) = CalcMarkerPos(DatabaseSong\IntroEnd)
    Position(3) = CalcMarkerPos(DatabaseSong\BreakStart)
    Position(4) = CalcMarkerPos(DatabaseSong\BreakEnd)
    Position(5) = CalcMarkerPos(DatabaseSong\BreakMute)
    Position(6) = CalcMarkerPos(DatabaseSong\BreakContinue)
    Position(7) = CalcMarkerPos(DatabaseSong\SkipStart)
    Position(8) = CalcMarkerPos(DatabaseSong\SkipEnd)   
    
    For i = 0 To 8 
      If Left
        If Position(i) < DatabaseSong\CursorSec And Position(i) < 10000 And Position(i) >= DatabaseSong\ViewBegin
          If DatabaseSong\CursorSec - Position(i) < Distance 
            Distance = DatabaseSong\CursorSec - Position(i) 
            FoundPos = Position(i)
          EndIf
        EndIf
      Else          
        If Position(i) > DatabaseSong\CursorSec And Position(i) < 10000 And Position(i) <= DatabaseSong\ViewEnd
          If Position(i) - DatabaseSong\CursorSec < Distance 
            Distance = Position(i) - DatabaseSong\CursorSec
            FoundPos = Position(i)
          EndIf
        EndIf          
      EndIf
    Next i
    
    If Distance < 10000
      If Left
        MarkerSelection(FoundPos, DatabaseSong\CursorSec)
      Else
        MarkerSelection(DatabaseSong\CursorSec, FoundPos)
      EndIf
    EndIf
  EndIf  
EndProcedure

Procedure DrawSelection(x.i)
  Protected.q BeginBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewBegin) 
  Protected.q Pos1Bytes = BeginBytes + (DatabaseSong\BytesPerPixel * DatabaseSong\CursorX)
  Protected.q Pos2Bytes = BeginBytes + (DatabaseSong\BytesPerPixel * x)
  Protected.f Pos1Sec = BASS_ChannelBytes2Seconds(Chan\Database, Pos1Bytes)    
  Protected.f Pos2Sec = BASS_ChannelBytes2Seconds(Chan\Database, Pos2Bytes)
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)  
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)

  If x <> DatabaseSong\CursorX 
    StartDrawing(CanvasOutput(#CanvasWaveform)) 
    DrawImage(ImageID(#OriginalWaveImage), 0, 0)
    DrawingMode(#PB_2DDrawing_XOr)
    
    If x > DatabaseSong\CursorX
      Box(DatabaseSong\CursorX, 0, x - DatabaseSong\CursorX, WaveformHeight, RGB(248, 248, 255))        
      DatabaseSong\SelectionBegin = Pos1Sec
      DatabaseSong\SelectionEnd = Pos2Sec
      DatabaseSong\SelectionLength = BASS_ChannelBytes2Seconds(Chan\Database, Pos2Bytes - Pos1Bytes)
      
      SetGadgetText(#SelBeginString, Seconds2TimeMS(DatabaseSong\SelectionBegin))
      SetGadgetText(#SelEndString, Seconds2TimeMS(DatabaseSong\SelectionEnd))    
      SetGadgetText(#SelLengthString, Seconds2TimeMS(DatabaseSong\SelectionLength))        
    Else
      Box(x, 0, DatabaseSong\CursorX - x, WaveformHeight, RGB(248, 248, 255))     
      DatabaseSong\SelectionBegin = Pos2Sec
      DatabaseSong\SelectionEnd = Pos1Sec        
      DatabaseSong\SelectionLength = BASS_ChannelBytes2Seconds(Chan\Database, Pos1Bytes - Pos2Bytes)     
      Databasesong\CursorSec = BASS_ChannelBytes2Seconds(Chan\Database, Pos2Bytes)
      
      SetGadgetText(#SelBeginString, Seconds2TimeMS(DatabaseSong\SelectionBegin))
      SetGadgetText(#SelEndString, Seconds2TimeMS( DatabaseSong\SelectionEnd))
      SetGadgetText(#SelLengthString, Seconds2TimeMS(DatabaseSong\SelectionLength))           
      SetGadgetText(#CursorPosString, Seconds2TimeMS(Databasesong\CursorSec))           
    EndIf
    
    GrabDrawingImage(#SelectionWaveImage, 0, 0, WaveformWidth, WaveformHeight)                
    StopDrawing()      
  Else        
    DrawCursor()
    
    DatabaseSong\SelectionBegin = 0
    DatabaseSong\SelectionEnd = 0
    DatabaseSong\SelectionLength = 0    
    Databasesong\CursorSec = BASS_ChannelBytes2Seconds(Chan\Database, Pos2Bytes)

    SetGadgetText(#SelBeginString, Seconds2TimeMS(DatabaseSong\SelectionBegin))                      
    SetGadgetText(#SelEndString, Seconds2TimeMS(DatabaseSong\SelectionEnd))
    SetGadgetText(#SelLengthString, Seconds2TimeMS(DatabaseSong\SelectionLength))
    SetGadgetText(#CursorPosString, Seconds2TimeMS(DatabaseSong\CursorSec))
  EndIf   
EndProcedure

Procedure RedrawSelection()
  Protected.q lb = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\SelectionLength)
  Protected.i x = (DatabaseSong\CursorX + lb) / DatabaseSong\BytesPerPixel
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)
  
  StartDrawing(CanvasOutput(#CanvasWaveform)) 
  DrawImage(ImageID(#OriginalWaveImage), 0, 0)
  DrawingMode(#PB_2DDrawing_XOr)      
  Box(DatabaseSong\CursorX, 0, x, WaveformHeight, RGB(248, 248, 255))     
  GrabDrawingImage(#SelectionWaveImage, 0, 0, WaveformWidth, WaveformHeight)          
  StopDrawing() 
EndProcedure

Procedure.l MinMaxScaled(*MinMaxArray, SamplesPerElement, *SampleData, SampleCount, Scale = 48, Stereo = #True, Cont.l = 0)
  If (*MinMaxArray And SamplesPerElement > 0) And (*SampleData And SampleCount > 0)
   
    Scale = GetGadgetState(#TrackbarScale)
    
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
      !mov [rsp-8], rbx                 
      !movdqu [rsp-24], xmm6            
      !movdqu [rsp-40], xmm7             
      !mov rax, [p.p_SampleData]
      !mov rdx, [p.p_MinMaxArray]
    CompilerElse
      !mov [esp-4], ebx                 
      !mov eax, [p.p_SampleData]
      !mov edx, [p.p_MinMaxArray]
    CompilerEndIf
    !mov ecx, [p.v_SamplesPerElement]
    !mov ebx, 1                          
    !cvtsi2sd xmm6, ebx
    !cvtsi2sd xmm1, ecx
    !divsd xmm6, xmm1                   
    !movlhps xmm6, xmm6
    !mov ebx, [p.v_Scale]               
    !imul ebx, 0x00020002
    !movd xmm7, ebx
    !pshufd xmm7, xmm7, 0
    !movd xmm0, [p.v_Cont]              
    !.l0:
    !movdqa xmm2, xmm0
    !movdqa xmm3, xmm0
    !xorpd xmm4, xmm4
    !xorpd xmm5, xmm5   
    !cmp ecx, [p.v_SampleCount]         
    !jbe .l1
    !mov ebx, 1
    !mov ecx, [p.v_SampleCount]
    !cvtsi2sd xmm6, ebx
    !cvtsi2sd xmm1, ecx
    !divsd xmm6, xmm1
    !movlhps xmm6, xmm6   
    !.l1:
    !cmp dword [p.v_Stereo], 0     
    !jnz .l2

    CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
      !movzx ebx, word [rax]           
      !add rax, 2
    CompilerElse
      !movzx ebx, word [eax]
      !add eax, 2
    CompilerEndIf
    !movd xmm0, ebx
    !punpcklwd xmm0, xmm0
    !jmp .l3
    !.l2:
 
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
      !movd xmm0, [rax]                   
      !add rax, 4
    CompilerElse
      !movd xmm0, [eax]
      !add eax, 4
    CompilerEndIf
    !.l3:
    !movdqa xmm1, xmm0
    !punpcklwd xmm1, xmm1                
    !psrad xmm1, 16
    !cvtdq2pd xmm1, xmm1                
    !pminsw xmm2, xmm0                   
    !pmaxsw xmm3, xmm0                   
    !addpd xmm4, xmm1                    
    !mulpd xmm1, xmm1
    !addpd xmm5, xmm1                   
    !sub ecx, 1
    !jnz .l1
    !mulpd xmm4, xmm6                   
    !mulpd xmm5, xmm6                   
    !sqrtpd xmm5, xmm5                   
    !cvtpd2dq xmm4, xmm4                 
    !cvtpd2dq xmm5, xmm5
    !packssdw xmm4, xmm4                
    !packssdw xmm5, xmm5
    !punpckldq xmm2, xmm3
    !punpckldq xmm4, xmm5
    !punpcklqdq xmm2, xmm4               
    !pmulhw xmm2, xmm7                
    !packsswb xmm2, xmm2        
 
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
      !movq [rdx], xmm2                   
      !add rdx, 8
    CompilerElse
      !movq [edx], xmm2                   
      !add edx, 8
    CompilerEndIf
    !mov ecx, [p.v_SamplesPerElement]
    !sub [p.v_SampleCount], ecx         
    !ja .l0
    CompilerIf #PB_Compiler_Processor = #PB_Processor_x64
      !movdqu xmm7, [rsp-40]            
      !movdqu xmm6, [rsp-24]          
      !mov rbx, [rsp-8]             
    CompilerElse
      !mov ebx, [esp-4]                
    CompilerEndIf
  EndIf
  !movd eax, xmm0                    
  ProcedureReturn
EndProcedure

Procedure UpdateCanvas(Offset = 0)
  Protected.i Color, Width, Height, VOffsetL, VOffsetR, MaxX, X, X_
  Protected.i WaveformWidth = GadgetWidth(#CanvasWaveform)  
  Protected.i WaveformHeight = GadgetHeight(#CanvasWaveform)  
  Protected.q PosBytes, BeforePosBytes
  Protected.f IntroStart = DatabaseSong\IntroStart
  Protected.f BreakEnd = DatabaseSong\BreakEnd
  Protected.f BreakMute = DatabaseSong\BreakEnd - DatabaseSong\BreakMute

  If DatabaseSong\IntroPrefix > 0
    IntroStart = DatabaseSong\IntroStart - DatabaseSong\IntroPrefix
  EndIf
  
  If DatabaseSong\BreakContinue > 0
    BreakEnd = DatabaseSong\BreakEnd + DatabaseSong\BreakContinue
  EndIf
  
  Busy = #True
  
  StartDrawing(CanvasOutput(#CanvasWaveform))
  Width = WaveformWidth : Height = WaveformHeight
  VOffsetL = Height >> 2 : VOffsetR = VOffsetL + Height >> 1
  X_ = Offset : MaxX = ArraySize(MM())
  Box(0, 0, Width, Height, RGB(0, 0, 0))

  While X < Width And X_ <= MaxX
    If DatabaseSong\IntroLoopStart > 0 And DatabaseSong\IntroLoopEnd > 0 And X >= SectionX(DatabaseSong\IntroLoopStart) And X <= SectionX(DatabaseSong\IntroLoopEnd)
      Color = RGB(220, 220, 150)     
    ElseIf IntroStart > 0 And DatabaseSong\IntroEnd > 0 And X >= SectionX(IntroStart) And X <= SectionX(DatabaseSong\IntroEnd)
      Color = RGB(255, 255, 204)
    ElseIf DatabaseSong\BreakLoopStart > 0 And DatabaseSong\BreakLoopEnd > 0 And X >= SectionX(DatabaseSong\BreakLoopStart) And X <= SectionX(DatabaseSong\BreakLoopEnd)
      Color = RGB(137, 255, 255)        
    ElseIf DatabaseSong\BreakMute > 0 And DatabaseSong\BreakEnd > 0 And X >= SectionX(BreakMute) And X <= SectionX(DatabaseSong\BreakEnd)
      Color = RGB(0, 0, 0)         
    ElseIf DatabaseSong\BreakStart > 0 And BreakEnd > 0 And X >= SectionX(DatabaseSong\BreakStart) And X <= SectionX(BreakEnd)
      Color = RGB(204, 255, 255)
    ElseIf DatabaseSong\SkipStart > 0 And DatabaseSong\SkipEnd > 0 And X >= SectionX(DatabaseSong\SkipStart) And X <= SectionX(DatabaseSong\SkipEnd)
      Color = RGB(250, 250, 250)
    Else        
      Color = RGB(75, 243, 167)
    EndIf
    
    LineXY(X, VOffsetL - MM(X_)\min[0], X, VOffsetL - MM(X_)\max[0], Color)
    LineXY(X, VOffsetR - MM(X_)\min[1], X, VOffsetR - MM(X_)\max[1], Color)
    
    If VOffsetL - MM(X_)\avg[0] > 0 And VOffsetL - MM(X_)\avg[0] < Height And X > 0 And X < Width
      Plot(X, VOffsetL - MM(X_)\avg[0], color)
    EndIf

    If VOffsetR - MM(X_)\avg[1] > 0 And VOffsetR - MM(X_)\avg[1] < Height  And X > 0 And X < Width
      Plot(X, VOffsetR - MM(X_)\avg[1], color)
    EndIf
    
    X + 1 : X_ + 1
  Wend
  
  Line(0, VOffsetL, Width, 1, RGB(90, 202, 139))
  Line(0, VOffsetR, Width, 1, RGB(90, 202, 139))
  Line(0, Height / 2, Width, 1, RGB(70, 70, 70))
                  
  GrabDrawingImage(#OriginalWaveImage, 0, 0, WaveformWidth, WaveformHeight)
  GrabDrawingImage(#FirstWaveImage, 0, 0, WaveformWidth, WaveformHeight)    
  
  StopDrawing() 
  
  Busy = #False   
EndProcedure

Procedure UpdatePlayCursor()
  Protected.q PosBeginBytes = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewBegin)
  Protected.q CurrentPosBytes = BASS_ChannelGetPosition(Chan\Database, #BASS_POS_BYTE) 
 
  DatabaseSong\CursorSec = BASS_ChannelBytes2Seconds(Chan\Database, CurrentPosBytes) 
  SetGadgetText(#CursorPosString, Seconds2TimeMS(DatabaseSong\CursorSec))           
  
  StartDrawing(CanvasOutput(#CanvasWaveform))
  If DatabaseSong\SelectionLength > 0      
    DrawImage(ImageID(#SelectionWaveImage), 0, 0)            
  Else
    DrawImage(ImageID(#CursorWaveImage), 0, 0)     
  EndIf
  
  Line((CurrentPosBytes - PosBeginBytes) / DatabaseSong\BytesPerPixel, 0, 1, GadgetHeight(#CanvasWaveform), RGB(192, 192, 192))                      
  StopDrawing()  
EndProcedure

Procedure ResizeWaveform()
  Busy = #True

  Protected.i SamplesPerElement 
  Protected.f Extra  
  Protected.f PosSecBegin = DatabaseSong\ViewBegin, PosSecEnd = DatabaseSong\ViewEnd 
  Protected.q PosBytes = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewBegin)
  Protected.q Length = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, DatabaseSong\ViewLength)  
  Protected.q FullLength = BASS_ChannelGetLength(Chan\DecodedDatabase, #BASS_POS_BYTE)
  Protected.f FullLengthSec = BASS_ChannelBytes2Seconds(Chan\DecodedDatabase, FullLength) 
  Protected.q NumSamples = Length >> 2   
  Protected *WaveData 
  
  While NumSamples < GadgetWidth(#CanvasWaveform)    
    PosSecBegin - Extra
    PosSecEnd + Extra    
    
    If PosSecBegin < 0 
      PosSecBegin = 0
    EndIf
    
    If PosSecEnd > FullLengthSec
      PosSecEnd = FullLengthSec
    EndIf

    Length = BASS_ChannelSeconds2Bytes(Chan\DecodedDatabase, PosSecEnd - PosSecBegin)  
    NumSamples = Length >> 2
    Extra + 0.005
  Wend
  
  DatabaseSong\ViewBegin = PosSecBegin
  DatabaseSong\ViewEnd = PosSecEnd   
  DatabaseSong\ViewLength = PosSecEnd - PosSecBegin   

  SetGadgetText(#ViewBeginString, Seconds2TimeMS(DatabaseSong\ViewBegin))
  SetGadgetText(#ViewEndString, Seconds2TimeMS(DatabaseSong\ViewEnd))
  SetGadgetText(#ViewLengthString, Seconds2TimeMS(DatabaseSong\ViewLength))       
  SetGadgetState(#TrackbarScale, CalcScale())
  
  *WaveData = AllocateMemory(Length)
  SamplesPerElement = NumSamples / GadgetWidth(#CanvasWaveform)
  DatabaseSong\BytesPerPixel = SamplesPerElement << 2
     
  BASS_ChannelSetPosition(Chan\DecodedDatabase, PosBytes, #BASS_POS_BYTE)    
  BASS_ChannelGetData(Chan\DecodedDatabase, *WaveData, Length)    
    
  ReDim MM.MinMax(NumSamples / SamplesPerElement)    
  MinMaxScaled(@MM(), SamplesPerElement, *WaveData, NumSamples)            
  UpdateCanvas()  

  
  DrawMarkers()     
  CalcCursorPos(DatabaseSong\ViewBegin)      
  If DatabaseSong\SelectionLength > 0
    RedrawSelection()
  Else
    DrawCursor()
  EndIf      
  
  Busy = #False
EndProcedure

;------------------------------------ Debug

Procedure FileSearch(key.s)
  Protected.s name, EscFile, dir
  Protected.i id
  
  If key = "filename"
    dir = Preferences\PathAudio
  Else
    dir = Preferences\PathSleeves
  EndIf
  
  id = ExamineDirectory(#PB_Any, dir, "")
  If id
    While NextDirectoryEntry(id)
      name = DirectoryEntryName(id)
      If name = "." Or name = ".."
        Continue
      EndIf
      
      If DirectoryEntryType(id) = #PB_DirectoryEntry_Directory  
        FileSearch(key)  
      Else
        EscFile = OSPath(ReplaceString(DirectoryEntryName(id), dir, ""))
        EscFile = ReplaceString(EscFile, "'", "''")
        DatabaseQuery(#DBMusic, "SELECT " + key + " FROM music WHERE " + key + "='" + EscFile + "' LIMIT 1")    
        NextDatabaseRow(#DBMusic)
        If GetDatabaseString(#DBMusic, 0) = ""
          Debug "delete " + dir + DirectoryEntryName(id)
          ;DeleteFile(dir + DirectoryEntryName(id)) 
        EndIf 
        FinishDatabaseQuery(#DBMusic)  
      EndIf
    Wend
    FinishDirectory(id)
  EndIf
EndProcedure

Procedure CheckMusicAndSleeveFiles()
  Protected.s Filename, DBFile, Folder, File
  Protected.i CounterMusic, CounterSleeves
  Protected.i D = ExamineDirectory(#PB_Any, Preferences\PathAudio, "")
   
  ;Check music files  
  DatabaseQuery(#DBMusic, "SELECT filename FROM music ORDER BY id")    
  While NextDatabaseRow(#DBMusic)
    Filename = Preferences\PathAudio + OSPath(GetDatabaseString(#DBMusic, 0))  
    If FileSize(Filename) = -1
      Debug Filename + " Not found"
      CounterMusic + 1
    EndIf
  Wend
  FinishDatabaseQuery(#DBMusic)   
  
  Debug Chr(13) + Chr(13)
  
  ;Check sleeves  
  DatabaseQuery(#DBMusic, "SELECT sleeve, artist, title FROM music ORDER BY id")    
  While NextDatabaseRow(#DBMusic)
    Filename = Preferences\PathSleeves + OSPath(GetDatabaseString(#DBMusic, 0))  
    If FileSize(Filename) = -1
      Debug Filename + " Not found ==>" + GetDatabaseString(#DBMusic, 1) + " - " + GetDatabaseString(#DBMusic, 2)   
      CounterSleeves + 1
    EndIf
  Wend
  FinishDatabaseQuery(#DBMusic)  
  
  Debug Chr(13) + Chr(13)
  
  ;Check empty sleeves  
  DatabaseQuery(#DBMusic, "SELECT sleeve, artist, title FROM music ORDER BY id")    
  While NextDatabaseRow(#DBMusic)
    If Trim(GetDatabaseString(#DBMusic, 0)) = ""
      Debug Filename + " empty sleeve ==>" + GetDatabaseString(#DBMusic, 1) + " - " + GetDatabaseString(#DBMusic, 2)   
    EndIf
  Wend
  FinishDatabaseQuery(#DBMusic)  
  
  Debug Chr(13) + Chr(13)
  Debug Str(CounterMusic) + " music files not found"
  Debug Str(CounterSleeves) + " sleeve files not found"  
  
  Debug Chr(13) + Chr(13)  
   
  ;Check unnecessary music files  
  ;FileSearch("files")
  FileSearch("sleeve")
  Debug Chr(13) + Chr(13)  
EndProcedure

;------------------------------------ Other

Procedure AddSetting(Section.s, Description.s, Gadget.i, Options.s = "", DefaultValue.s = "", Tooltip.s = "")
  AddElement(SettingsPanel())
  SettingsPanel()\Section      = Section
  SettingsPanel()\Description  = Description
  SettingsPanel()\Gadget       = Gadget
  SettingsPanel()\Options      = Options
  SettingsPanel()\DefaultValue = DefaultValue
  SettingsPanel()\Tooltip      = Tooltip
EndProcedure

Procedure Initialize()  
  Protected.s TooltipCombine = "Choose whether ... from 2 songs can be combined during transitions." + Chr(13) + Chr(13) + 
                               "Default is No, which results in more harmonic transitions but fewer mix combinations are possible." + Chr(13) + Chr(13) +
                               "No is recommended if there are few songs in the database." 
  Protected.s TooltipFilter = "Filter by ...(s). The playlist will only contain songs from the selected ...(s)." + Chr(13) + Chr(13) +
                              "Hold Ctrl-key and click to select multiple ...s"
  Protected.s Options
  Protected.b SamplerateExists
  
  If #PB_Compiler_Debugger = 0 And #DebugMusicAndSleeves
    MessageRequester("Program aborted", "Enable the debugger to proceed debugging.", #PB_MessageRequester_Error)  
    End    
  EndIf 
  
  CompilerIf #PB_Compiler_Thread = 0
    CompilerError "Thread safe must be enabled in compiler options!"
  CompilerEndIf  
  
  ;Check if program running on Linux environment
  CompilerIf #PB_Compiler_OS <> #PB_OS_Linux And #PB_Compiler_OS <> #PB_OS_Windows
    MessageRequester("Program aborted", "Operating system not supported.", #PB_MessageRequester_Error)  
    End
  CompilerEndIf
  
  ;Check if computer has a 64-bit processor
  CompilerIf #PB_Compiler_Processor <> #PB_Processor_x64
    MessageRequester("Program aborted", "Processor not supported.", #PB_MessageRequester_Error)
    End
  CompilerEndIf 
  
  ;Check if computer has minimum required screen resolution 
  ExamineDesktops()
  If DesktopWidth(0) < 1024 Or DesktopHeight(0) < 768
    MessageRequester("Program aborted", "Screen resolution not supported (must be 1024 x 768 or higher).", #PB_MessageRequester_Error)
    End  
  EndIf
  
  ;Change program path if the compiled version is running
  If Not FindString(GetFilePart(ProgramFilename()), "purebasic_compilation")
    SetCurrentDirectory(GetPathPart(ProgramFilename()))
  EndIf  
  
  ;Create data folder if not exists
  If FileSize(OSPath("assets/data")) <> -2  
    CreateDirectory(OSPath("assets/data"))
  EndIf
  
  If FileSize(OSPath("assets/beats.wav")) = -1
    MessageRequester("Program aborted", "Failed to load beats.wav", #PB_MessageRequester_Error)  
    End
  EndIf 
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux   
    If FileSize(OSPath("assets/mixperfect_upgrader")) = -1
      MessageRequester("Program aborted", "Failed to load mixperfect_upgrader", #PB_MessageRequester_Error)  
      End
    EndIf   
  CompilerElse
    If FileSize(OSPath("assets/mixperfect_upgrader.exe")) = -1
      MessageRequester("Program aborted", "Failed to load mixperfect_upgrader.exe", #PB_MessageRequester_Error)  
      End
    EndIf      
  CompilerEndIf
  
  ;***************
  ;Music database 
  ;***************
  
  ;Create music database if not exists
  If FileSize(OSPath("assets/data/mixperfect.db1")) = -1
    CreateFile(#File, OSPath("assets/data/mixperfect.db1"))
    CloseFile(#File)
  EndIf
  
  If OpenDatabase(#DBMusic, OSPath("assets/data/mixperfect.db1"), "", "", #PB_Database_SQLite)
    DatabaseUpdate(#DBMusic, "CREATE TABLE music (" + 
                             "`id`	INTEGER PRIMARY KEY AUTOINCREMENT, " +                            
                             "`artist` TEXT, " + 
                             "`title` TEXT, " + 
                             "`bpm` NUMERIC, " +
                             "`introprefix` TEXT, " + 
                             "`introfade` INTEGER, " +
                             "`introstart`	TEXT, " + 
                             "`introend`	TEXT, " + 
                             "`introbeatlist` TEXT, " + 
                             "`introbass` INTEGER, " + 
                             "`introvocal`	INTEGER, " + 
                             "`intromelody`INTEGER, " + 
                             "`introbeats` INTEGER, " + 
                             "`breakfade` INTEGER, " + 
                             "`breakstart`	TEXT, " +  
                             "`breakend` TEXT, " + 
                             "`breakbeatlist`, " + 
                             "`breakbass` INTEGER, " + 
                             "`breakvocal`	INTEGER, " + 
                             "`breakmelody` INTEGER, " + 
                             "`breakbeats` INTEGER, " + 
                             "`genre` TEXT, " + 
                             "`filename`	TEXT, "  + 
                             "`sleeve` TEXT,	" + 
                             "`year`	INTEGER, " + 
                             "`label` TEXT, " + 
                             "`catno` TEXT, " + 
                             "`country` TEXT, " + 
                             "`breakmute` TEXT, " + 
                             "`breakcontinue` TEXT, " + 
                             "`introloopstart` TEXT, " + 
                             "`introloopend` TEXT, " + 
                             "`breakloopstart` TEXT, " + 
                             "`breakloopend` TEXT, " + 
                             "`introlooprepeat` INTEGER, " + 
                             "`breaklooprepeat` INTEGER, " + 
                             "`skipstart` TEXT, " + 
                             "`skipend` TEXT, " + 
                             "`samplerate` INTEGER)") 
    CloseDatabase(#DBMusic)
  Else
    MessageRequester("Program aborted", "Database mixperfect.db1 cannot be opened", #PB_MessageRequester_Error)
    End      
  EndIf
   
  If OpenDatabase(#DBMusic, OSPath("assets/data/mixperfect.db1"), "", "", #PB_Database_SQLite)     
    If DatabaseQuery(#DBMusic, "PRAGMA table_info(music)")
      While NextDatabaseRow(#DBMusic)
        If GetDatabaseString(#DBMusic, 1) = "samplerate"
          SamplerateExists = #True
          Break
        EndIf
      Wend
      FinishDatabaseQuery(#DBMusic)
    EndIf
    CloseDatabase(#DBMusic)
    
    If Not SamplerateExists
      MessageRequester("Program aborted", "Samplerate-field is missing in database.", #PB_MessageRequester_Error)
      End
    EndIf
  EndIf
 
  ;Create indexes on music database
  If OpenDatabase(#DBMusic, OSPath("assets/data/mixperfect.db1"), "", "", #PB_Database_SQLite)
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_id ON music(id)")      
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_bpm ON music(bpm)")  
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_artist ON music(artist)")
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_title ON music(title)")
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_label ON music(label)")
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_catno ON music(catno)")
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_year ON music(year)")
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_country ON music(country)")
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_introbass ON music(introbass)")    
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_intromelody ON music(intromelody)")    
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_introvocal ON music(introvocal)")        
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_introbeats ON music(introbeats)")    
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_breakbass ON music(breakbass)")    
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_breakmelody ON music(breakmelody)")    
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_breakvocal ON music(breakvocal)")        
    DatabaseUpdate(#DBMusic, "CREATE INDEX index_breakbeats ON music(breakbeats)")        
  Else
    MessageRequester("Program aborted", "Database mixperfect.db1 cannot be opened", #PB_MessageRequester_Error)
    End
  EndIf  
  
  
  ;***************
  ;Files database 
  ;***************
  
  ;Create files database if not exists
  If FileSize(OSPath("assets/data/mixperfect.db2")) = -1
    CreateFile(#File, OSPath("assets/data/mixperfect.db2"))
    CloseFile(#File)
    
    If OpenDatabase(#DBFiles, OSPath("assets/data/mixperfect.db2"), "", "", #PB_Database_SQLite)
      DatabaseUpdate(#DBFiles, "CREATE TABLE files (" + 
                               "`id`	INTEGER PRIMARY KEY AUTOINCREMENT, " + 
                               "`added` TEXT, " +    
                               "`file` TEXT, " + 
                               "`folder` TEXT, " + 
                               "`bpm` TEXT)") 
      CloseDatabase(#DBFiles)
    EndIf
  EndIf        
  
  ;Create indexes on files database
  If OpenDatabase(#DBFiles, OSPath("assets/data/mixperfect.db2"), "", "", #PB_Database_SQLite)
    DatabaseUpdate(#DBFiles, "CREATE INDEX index_id ON files(id)")  
    DatabaseUpdate(#DBFiles, "CREATE INDEX index_added ON files(added)")      
    DatabaseUpdate(#DBFiles, "CREATE INDEX index_file ON files(file)")
    DatabaseUpdate(#DBFiles, "CREATE INDEX index_folder ON files(folder)")    
    DatabaseUpdate(#DBFiles, "CREATE INDEX index_bpm ON files(bpm)")        
  Else
    MessageRequester("Program aborted", "Database mixperfect.db2 cannot be opened", #PB_MessageRequester_Error)
    CloseDatabase(#DBMusic)
    End
  EndIf  
  
  ;Initialize font
  If FileSize(OSPath("assets/Bebas-Regular.ttf")) = -1
    MessageRequester("Program aborted", "Failed to load Bebas-Regular.ttf", #PB_MessageRequester_Error)  
    End
  EndIf    
    
  RegisterFontFile(OSPath("assets/Bebas-Regular.ttf"))
  LoadFont(#Font, "Bebas-Regular", 10)  
    
  ;Initialize BASS audio library
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    If Not BASS_Load_Library(OSPath("assets/bass/windows/bass.dll"))   
      MessageRequester("Program aborted", "Failed to load bass.dll", #PB_MessageRequester_Error)  
      End      
    EndIf
    
    If Not BASS_Tags_Load_Library(OSPath("assets/bass/windows/tags.dll"))    
      MessageRequester("Program aborted", "Failed to load tags.dll", #PB_MessageRequester_Error)    
      End
    EndIf
    
    If Not BASS_FX_Load_Library(OSPath("assets/bass/windows/bass_fx.dll"))
      MessageRequester("Program aborted", "Failed to load bass_fx.dll", #PB_MessageRequester_Error)      
      End
    EndIf
    
    If Not BASS_Mixer_Load_Library(OSPath("assets/bass/windows/bassmix.dll"))
      MessageRequester("Program aborted", "Failed to load bassmix.dll", #PB_MessageRequester_Error)    
      End
    EndIf    
    
    If Not BASS_Encode_Load_Library(OSPath("assets/bass/windows/bassenc.dll"))
      MessageRequester("Program aborted", "Failed to load bassenc.dll", #PB_MessageRequester_Error)  
      End
    EndIf 
    
    If Not BASS_Encode_MP3_Load_Library(OSPath(OSPath("assets/bass/windows/bassenc_mp3.dll")))
      MessageRequester("Program aborted", "Failed to load bassenc_mp3.dll", #PB_MessageRequester_Error)   
      End
    EndIf     
    
    If Not BASS_AAC_Load_Library(OSPath("assets/bass/windows/bass_aac.dll"))
      MessageRequester("Program aborted", "Failed to load bass_aac.dll", #PB_MessageRequester_Error)  
      End
    EndIf     
    
    If Not BASS_FLAC_Load_Library(OSPath("assets/bass/windows/bassflac.dll"))
      MessageRequester("Program aborted", "Failed to load bassflac.dll", #PB_MessageRequester_Error)  
      End
    EndIf  
    
    If Not BASS_OPUS_Load_Library(OSPath("assets/bass/windows/bassopus.dll"))
      MessageRequester("Program aborted", "Failed to load bassopus.dll", #PB_MessageRequester_Error)  
      End
    EndIf     
      
    If Not BASSENC_OGG_Load_Library(OSPath("assets/bass/windows/bassenc_ogg.dll"))
      MessageRequester("Program aborted", "Failed to load bassenc_ogg.dll", #PB_MessageRequester_Error)  
      End
    EndIf     
    
    If Not BASS_Enc_OPUS_Load_Library(OSPath("assets/bass/windows/bassenc_opus.dll"))
      MessageRequester("Program aborted", "Failed to load bassenc_opus.dll", #PB_MessageRequester_Error)  
      End
    EndIf     
    
    If Not BASSENCO_FLAC_Load_Library(OSPath("assets/bass/windows/bassenc_flac.dll"))
      MessageRequester("Program aborted", "Failed to load bassenc_flac.dll", #PB_MessageRequester_Error)  
      End
    EndIf         
  CompilerEndIf   

  If Not BASS_Init(-1, 44100, 0, #Null, #Null)  
    MessageRequester("Program aborted", "BASS audio library cannot be initialized.", #PB_MessageRequester_Error)  
    End
  EndIf
 
  BASS_GetVersion()  
  TAGS_GetVersion()
  BASS_Mixer_GetVersion()
  BASS_FX_GetVersion()    
  BASS_Encode_GetVersion()
  BASS_Encode_FLAC_GetVersion()
  ;BASS_Encode_MP3_GetVersion()
  BASS_Encode_OGG_GetVersion()
  BASS_Encode_OPUS_GetVersion()  
  BASS_SetConfig(#BASS_CONFIG_UPDATEPERIOD, 20) 
  BASS_SetConfig(#BASS_CONFIG_AAC_MP4, 1)
  BASS_SetConfig(#BASS_CONFIG_AAC_PRESCAN, 1)
  Chan\Mixer = BASS_Mixer_StreamCreate(44100, 2, #BASS_MIXER_END|#BASS_UNICODE|#BASS_SAMPLE_FLOAT)    
  BASS_ChannelSetAttribute(Chan\Mixer, #BASS_ATTRIB_VOL, 0.75) 
  Chan\MixerBeatTest = BASS_Mixer_StreamCreate(44100, 2, #BASS_MIXER_END|#BASS_UNICODE|#BASS_SAMPLE_FLOAT)    
  BASS_ChannelSetAttribute(Chan\MixerBeatTest, #BASS_ATTRIB_VOL, 0.75)   
  Chan\MixerCustomTransition = BASS_Mixer_StreamCreate(44100, 2, #BASS_MIXER_END|#BASS_UNICODE|#BASS_SAMPLE_FLOAT)    
  
  LoadPreferences()
   
  ;************************************************************************************* 
  ;Create settings
  ;
  ;IMPORTANT, BE CAREFUL WITH:
  ;1. Changing descriptions, as they are also used as key for preferences
  ;2. Removing settings as some of their gadget numbers are used elsewhere 
  ;3. Changing the order of settings, as some of their gadget numbers are used elsewhere  
  ;************************************************************************************* 
  
  AddSetting("Directories", "Path audiofiles", #SettingPathRequester, "", "", "The main folder where your audio files are stored.")
  AddSetting("", "Path sleevesfiles", #SettingPathRequester, "", "", "The main folder where your sleevefiles are stored.")
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    AddSetting("GUI Theme", "Color", #SettingComboBox, "Light,Fancy light,Fancy dark", "Light", 
               "Sets the theme of the graphical user interface." + Chr(13) + Chr(13) + "Default is light.")
  CompilerEndIf
  
  AddSetting("Playlist length", "Minimum number of songs", #SettingComboBox, 
             "2,5,10,15,20,25,30,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,150,200,250,300,350,400,450,500,600,700,800,900,999", 
             "2", 
             "Minimum number of songs the playlist must contain." + Chr(13) + Chr(13) + "Default is 2.")
  
  AddSetting("", "Maximum number of songs", #SettingComboBox, 
             "2,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,150,200,250,300,350,400,450,500,600,700,800,900,999", 
             "100", 
             "Maximum number of songs the playlist must contain." + Chr(13) + Chr(13) + "Default is 100.")
  
  AddSetting("", "Minimum playback time", #SettingComboBox, 
             "2 minutes,10 minutes,15 minutes,30 minutes,1 hour,2 hours,3 hours,4 hours,5 hours,6 hours,7 hours,8 hours,9 hours,10 hours,15 hours,20 hours,24 hours", 
             "2 minutes", 
             "Minimum playback duration of the playlist." + Chr(13) + Chr(13) + "Default is 2 minutes.")
  
  AddSetting("", "Maximum playback time", #SettingComboBox, 
             "2 minutes,10 minutes,15 minutes,30 minutes,1 hour,2 hours,3 hours,4 hours,5 hours,6 hours,7 hours,8 hours,9 hours,10 hours,15 hours,20 hours,24 hours,Infinite", 
             "6 hours", 
             "Maximum playback duration. If Infinite is selected and a random playlist is loaded, an infinite mix will play." + Chr(13) + Chr(13) + "Default is 6 hours.")
  
  AddSetting("Song length", "Shorten songs", #SettingCombobox, "Random,Always,Never", "Random", 
             "If you have placed skip-markers in songs, these songs can be played in abbreviated form." + Chr(13) + Chr(13) + "Default is Random, which plays songs alternately short and long.")
  
  AddSetting("Repeating", "Unique songs before repeating", #SettingCombobox, 
             "2,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90,95,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,950,999", 
             "100", 
             "Prevents repetition of the same songs. Select how many unique songs should be played before a previously played song is repeated." + Chr(13) + Chr(13) + "Default is 100.")
  
   
  Options = "Random"
  DatabaseQuery(#DBMusic, "SELECT DISTINCT CAST(bpm AS INTEGER) FROM music ORDER BY bpm ASC")
  While NextDatabaseRow(#DBMusic)
    Options + "," + GetDatabaseString(#DBMusic, 0) + " BPM"
  Wend
  FinishDatabaseQuery(#DBMusic)
  
  AddSetting("Speed", "BPM of first song", #SettingCombobox, Options, "Random", 
             "The BPM value of the first song in the playlist." + Chr(13) + Chr(13) + "Default is random, which starts the playlist with a random song.")
  
  AddSetting("", "BPM order of songs", #SettingCombobox, "Random,Ascending,Descending", "Random", 
             "Determine whether the speed of songs in the playlist should change in ascending, descending, or random order." + Chr(13) + Chr(13) +
             "Default is Random." + Chr(13) + Chr(13) +
             "Choose Ascending for a playlist that starts with a low BPM and ends with a high BPM." + Chr(13) + Chr(13) +
             "Choose Descending for a playlist that starts with a high BPM and ends with a low BPM.")
  
  AddSetting("", "Maximum BPM distance", #SettingCombobox, 
             "0.5,1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.6,5.0,7.5,8.0,8.5,9.0,9.5", 
             "2.0", 
             "Determines how much the pitch can be adjusted. The lower the value, the less noticeable that the pitch has been adjusted." + Chr(13) + Chr(13) +
             "Default is 2.0, which adjust the pitch no more than 2 bpm lower or higher." + Chr(13) + Chr(13) +
             "Select a higher value to increase mix combinations.")
  
  AddSetting("", "Pitch reset", #SettingCombobox, "0.5,0.6,0.7,0.8,0.9,1.0", "1.0", 
             "Determines when the pitch will be adjusted to the original speed of a song. This way, the playlist can contain songs with very different BMP values without the pitch being adjusted excessively. The lower the value, the less noticeable that the pitch has been adjusted." + Chr(13) + Chr(13) + "Default is 0.5.")
  
  AddSetting("Transitions", "Filter overlapped beats", #SettingCombobox, "Current song,Next song,Both songs,None", "Current song", 
             "The song(s) whose beats need to be filtered during a transition. During a transition it sounds better if the beats of one song sound less heavy" + Chr(13) + Chr(13) + "Default is Current song.")
  
  AddSetting("", "Keep beats going", #SettingCombobox, "Yes,No", "Yes", 
             "Choose whether transitions always must have beats." + Chr(13) + Chr(13) + "Default is Yes, which prevents that some transitions don't have beats.")
  
  AddSetting("", "Combine beats", #SettingCombobox, "Yes,No", "Yes", 
             "Choose whether beats from 2 songs can be combined during transitions." + Chr(13) + Chr(13) + "Default is Yes, which results in overlapping beats (sounds a little less nice, but makes many more mix combinations possible).")
  
  AddSetting("", "Combine basses", #SettingCombobox, "Yes,No", "No", ReplaceString(TooltipCombine, "...", "basses"))
  AddSetting("", "Combine vocals", #SettingCombobox, "Yes,No", "No", ReplaceString(TooltipCombine, "...", "vocals"))
  AddSetting("", "Combine melodies", #SettingCombobox, "Yes,No", "No", ReplaceString(TooltipCombine, "...", "melodies"))
  AddSetting("", "Always combine if no matches left", #SettingCombobox, "Yes,No", "No", 
             "Generates a longer playlist if set to Yes." + Chr(13) + "Default is No.")
  
  AddSetting("Filter - You may select multiple items (hold Ctrl-key and click left mouse button)", "Countries", #SettingListview, GetDistinct("country"), "", ReplaceString(TooltipFilter, "...", "country"))
  AddSetting("", "Genres", #SettingListview, RemoveDuplicates(GetDistinct("genre")), "", ReplaceString(TooltipFilter, "...", "genre"))
  AddSetting("", "Years", #SettingListview, GetDistinct("year"), "", ReplaceString(TooltipFilter, "...", "year"))
  AddSetting("", "Evolution mode", #SettingCombobox, "On,Off", "Off", 
             "Generate random playlists with songs arranged chronologically by year, with (if possible) approximately the same number of songs per year. Ignored if 'Maximum playback time' is set to 'infinite'." + Chr(13) + "Default is Off.")
  AddSetting("", "Record labels", #SettingListview, GetDistinct("label"), "", ReplaceString(TooltipFilter, "...", "record label"))
  AddSetting("", "Artists", #SettingListview, GetDistinct("artist"), "", ReplaceString(TooltipFilter, "...", "artist"))
EndProcedure

Procedure Upgrade()
  Protected Download, Counter, Progress, Event
  Protected.s Prefix
   
  CancelDownload = #False
 
  DisableGadget(#ButtonUpgrade, #True)  
  HideGadget(#ButtonCancelDownload, #False)  
  SetGadgetText(#DownloadProgress, "Downloading")
  Repeat 
    Event = WindowEvent()           
  Until Event = 0    
  Delay(5)   
                     
  Repeat 
    Event = WindowEvent() 
  Until Event = 0    
  Delay(5) 
  
  Download = ReceiveHTTPFile("https://www.mixperfectplayer.nl/" + #DownloadFile, OSPath(GetPathPart(ProgramFilename()) + "assets/" + #DownloadFile), #PB_HTTP_Asynchronous)
  
  AddWindowTimer(#WindowMain, #TimerDownload, 100)
  
  If Download
    Repeat
      Progress = HTTPProgress(Download)      
      Event = WaitWindowEvent()
      
      Select Event
        Case #PB_Event_CloseWindow
          RemoveWindowTimer(#WindowMain, #TimerDownload)
          AbortHTTP(Download)
          ExitProgram()     
        Case #PB_Event_Gadget
          If EventGadget() = #ButtonCancelDownload
            CancelDownload = #True 
          EndIf
        Case #PB_Event_Timer  
          If EventTimer() = #TimerDownload
            If GetGadgetState(#Panel) <> 5          
              CancelDownload = #True 
            EndIf
          EndIf
      EndSelect
      
      If CancelDownload 
        RemoveWindowTimer(#WindowMain, #TimerDownload)        
        MessageRequester("Warning", "Upgrade has been canceled", #PB_MessageRequester_Ok|#PB_MessageRequester_Warning)            
        AbortHTTP(Download)
        Break
      EndIf
      
      Select Progress
        Case #PB_HTTP_Success
          RemoveWindowTimer(#WindowMain, #TimerDownload)
          SetGadgetText(#DownloadProgress, "Download completed")
          HideGadget(#ButtonCancelDownload, #True)    
          Repeat 
            Event = WindowEvent() 
          Until Event = 0    
          Delay(5)          
          
          If MessageRequester("Restart required", "Restart MixPerfect Player to complete upgrade?", #PB_MessageRequester_YesNo|#PB_MessageRequester_Info) = #PB_MessageRequester_Yes
            ExitProgram(#True)
            RunProgram(ProgramFilename())
            End                           
          EndIf
 
          Break
        Case #PB_HTTP_Failed, #PB_HTTP_Aborted
          MessageRequester("Download error", "Download failed", #PB_MessageRequester_Ok|#PB_MessageRequester_Error)    
          FinishHTTP(Download) 
          RemoveWindowTimer(#WindowMain, #TimerDownload)          
          Break          
        Default
          SetGadgetText(#DownloadProgress, "Downloading" + "." + RSet("", Counter, "."))
          Repeat 
            Event = WindowEvent()           
          Until Event = 0    
          Delay(5) 
      EndSelect
      
      Counter + 1
      If Counter >= 5
        Counter = 0
      EndIf       
      
      Delay(100)  
    ForEver
  EndIf    
  
  SetGadgetText(#DownloadProgress, "")
  DisableGadget(#ButtonUpgrade, #False)  
  HideGadget(#ButtonCancelDownload, #True)    
  Repeat 
    Event = WindowEvent() 
  Until Event = 0    
  Delay(5)
EndProcedure  

Procedure.i VersionToInt(Version.s)
  Protected major.i, minor.i, patch.i

  major = Val(StringField(Version, 1, "."))
  minor = Val(StringField(Version, 2, "."))
  patch = Val(StringField(Version, 3, ".")) ; 0 als niet aanwezig

  ; Maak er één getal van, bv. major * 10000 + minor * 100 + patch
  ProcedureReturn major * 10000 + minor * 100 + patch
EndProcedure

Procedure CheckLatestVersion()
  Protected Event
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    Protected Output.s
    Protected Curl
    
    Curl = RunProgram("curl", "--version", "", #PB_Program_Open | #PB_Program_Read)
    If Curl
      While ProgramRunning(Curl)
        Output + ReadProgramString(Curl) + Chr(10)
      Wend
      CloseProgram(Curl)
    
      If Not FindString(Output, "libcurl")
        SetGadgetText(#VersionCheck, "Can't check for updates, libcurl is not installed.")
        Repeat 
          Event = WindowEvent() 
        Until Event = 0    
        Delay(5)            
        ProcedureReturn        
      EndIf
    Else
      SetGadgetText(#VersionCheck, "Can't check for updates, curl command failed.")
      Repeat 
        Event = WindowEvent() 
      Until Event = 0    
      Delay(5)          
      ProcedureReturn
    EndIf
  CompilerEndIf
  
  Protected *Buffer = ReceiveHTTPMemory("https://www.mixperfectplayer.nl/latest-version.txt")
  Protected Size
  Protected.s LatestVersion
  
  If *Buffer
    Size = MemorySize(*Buffer)
    LatestVersion = PeekS(*Buffer, Size, #PB_UTF8)
    If FindString(LCase(LatestVersion), "<html") Or FindString(LCase(LatestVersion), "<!doctype")
      LatestVersion = ""
    EndIf
    FreeMemory(*Buffer)  
  EndIf
  
  ;Remove unwanted characters
  LatestVersion = Trim(LatestVersion)
  LatestVersion = RemoveString(LatestVersion, Chr(13))
  LatestVersion = RemoveString(LatestVersion, Chr(10))
  LatestVersion = RemoveString(LatestVersion, Chr(0))
  LatestVersion = RemoveString(LatestVersion, Chr($FEFF)) 
 
  If VersionToInt(#Version) >= VersionToInt(LatestVersion)
    SetGadgetText(#VersionCheck, "You are running the latest version.")
    Repeat 
      Event = WindowEvent() 
    Until Event = 0    
    Delay(5)    
    ProcedureReturn
  EndIf
  
  If VersionToInt(#Version) < VersionToInt(LatestVersion)
    SetGadgetText(#VersionCheck, "A new version of MixPerfect Player is available!")
    SetGadgetText(#ButtonUpgrade, "Upgrade to version " + Trim(LatestVersion))
    HideGadget(#ButtonUpgrade, #False)
    Repeat 
      Event = WindowEvent() 
    Until Event = 0    
    Delay(5)  
  EndIf
EndProcedure

Procedure UpdateSongInPlaylist()
  Protected.i SongType, FileSamplerate
  Protected.i Row = GetGadgetState(#ListiconPlaylist)
  Protected.s IDs, FilterQuery, PlaylistString, Year 
  Protected.f lowBPM, highBPM, OriginalBPM
  Protected.f IntroPrefix, IntroStart, IntroEnd, IntroLoopstart, IntroLoopEnd, IntroLoopRepeat  
  Protected.f BreakStart, BreakEnd, BreakLoopstart, BreakLoopEnd, BreakLoopRepeat, Breakcontinue, PlayLength   
  Protected.f DBLowestBPM = DBLowestBPM(), DBHighestBPM = DBHighestBPM()

  SelectElement(Songs(), Mix(CurrentSong)\Number - 1)
  OriginalBPM = Songs()\PlaybackBPM   
  
  If Row = 0
    SongType = #FirstSong
  Else
    Songtype = #InBetweenSong
  EndIf

  PlayLength = PlayLength(SongType, DatabaseSong\IntroPrefix, DatabaseSong\IntroStart, DatabaseSong\Introend, DatabaseSong\IntroLoopStart, DatabaseSong\IntroLoopEnd, DatabaseSong\IntroLoopRepeat, DatabaseSong\BreakStart, DatabaseSong\BreakEnd, DatabaseSong\BreakLoopStart, DatabaseSong\BreakLoopEnd, DatabaseSong\BreakLoopRepeat, DatabaseSong\BreakContinue)            
  If Preferences\ShortenSongs = "Always" Or (Preferences\ShortenSongs = "Random" And Random(1))
    PlayLength - (DatabaseSong\SkipEnd - DatabaseSong\SkipStart)
    Songs()\Shorten = #True
  Else
    Songs()\Shorten = #False
  EndIf         
  
  Songs()\Pitch = ""
  If Abs(Songs()\BPM - OriginalBPM) <= Preferences\PitchRange
    OriginalBPM = Songs()\BPM  
    Songs()\Pitch = "  0.00%" 
  EndIf           
    
  Songs()\ID = DatabaseSong\ID
  Songs()\Playtime = PlayLength 
  
  PlaylistString = GeneratePlaylistIDsString()
  FillListiconPlaylist(PlaylistString)

  SelectRow(#ListiconPlaylist, Row)
  ListiconPlaylist(#PB_EventType_Change)   
                
  ;Save the playlist to preferences file
  If PreferencesFile()          
    PreferenceGroup("Session")      
    WritePreferenceString("Type", Preferences\PlaylistType)               
    WritePreferenceString("IDs", PlaylistString)           
    ClosePreferences()
  EndIf      
EndProcedure

Procedure EditSong()
;   If MessageRequester("Warning", "Adjustments can cause errors in the current mix." + Chr(13) +
;                                  "Do you want to continue?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
;     ProcedureReturn
;   EndIf
  
  DatabaseSong\ID = Mix(CurrentSong)\ID
  ButtonStopDatabaseSong()      
  DisableWindow(#WindowMain, #True) 
  CreateWindowDatabaseAddRecord(Mix(CurrentSong)\AudioFilename, "Edit")
  LoadDatabaseFile(Preferences\PathAudio + Mix(CurrentSong)\AudioFilename) 
EndProcedure
  
Procedure.s ToDisplayInArtist()
  ProcedureReturn RemoveDuplicates(GetDistinct("artist"))  
EndProcedure

Procedure.s ToDisplayInCountry()
  ProcedureReturn RemoveDuplicates(GetDistinct("country"))  
EndProcedure

Procedure.s ToDisplayInGenre()
  ProcedureReturn RemoveDuplicates(GetDistinct("genre"))  
EndProcedure

Procedure.s ToDisplayInLabel()
  ProcedureReturn RemoveDuplicates(GetDistinct("label"))  
EndProcedure

Procedure.s ToDisplayInYear()
  ProcedureReturn RemoveDuplicates(GetDistinct("year"))  
EndProcedure
 
Procedure LoadPreviousPlaylist()
  LoadPreferences()
  FillListiconPlaylist(Preferences\PlaylistString, #True)  
EndProcedure

Procedure ResizeSongInfo(Song.i) 
  Protected.i Y, Y1, Y3
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux   
    Y1 = 5
    Y3 = 75
  CompilerElse
    Y1 = 10
    Y3 = 70    
  CompilerEndIf  
 
  If Song = NextSong 
    Y = 120
  EndIf
  
  ResizeGadget(#ContainerSongInfo, -30, GadgetY(#ListiconPlaylist) + GadgetHeight(#ListiconPlaylist) + 20, WindowWidth(#WindowMain) - 220, #PB_Ignore)
  ResizeGadget(#ScrollAreaSongInfo, #PB_Ignore, -10, GadgetWidth(#ContainerSongInfo), GadgetHeight(#ContainerSongInfo) + 20);hier de bug?
  SetGadgetAttribute(#ScrollAreaSongInfo, #PB_ScrollArea_InnerWidth, WindowWidth(#WindowMain) - 200)  
    
  If SleeveLoaded(Song)
    ResizeGadget(SleeveGadget(Song), #PB_Ignore,  10 + Y, #PB_Ignore, #PB_Ignore)                  
    ResizeGadget(LabelSongInfo(0, Song), 130, Y1 + Y, GadgetWidth(#ScrollAreaSongInfo) - 150, #PB_Ignore)  
    ResizeGadget(LabelSongInfo(1, Song), 130,  40 + Y, GadgetWidth(#ScrollAreaSongInfo) - 150, #PB_Ignore)      
     
    If FlagVisible(Song)
      ResizeGadget(LabelSongInfo(2, Song), 170,  Y3 + Y, GadgetWidth(#ScrollAreaSongInfo) - 190, #PB_Ignore) 
      If IsGadget(ImageFlag(Song))
        ResizeGadget(ImageFlag(Song), 130,  Y3 + Y, #PB_Ignore, #PB_Ignore)
      EndIf
    Else
      ResizeGadget(LabelSongInfo(2, Song), 130, Y3 + Y, GadgetWidth(#ScrollAreaSongInfo) - 150, #PB_Ignore)         
    EndIf      
  Else
    HideGadget(SleeveGadget(Song), #True)
    ResizeGadget(LabelSongInfo(0, Song), 20, Y1 + Y, GadgetWidth(#ScrollAreaSongInfo) - 150, #PB_Ignore) 
    ResizeGadget(LabelSongInfo(1, Song), 20, 40 + Y, GadgetWidth(#ScrollAreaSongInfo) - 150, #PB_Ignore)   
    
    If FlagVisible(Song)    
      ResizeGadget(LabelSongInfo(2, Song), 60,   Y3 + Y, GadgetWidth(#ScrollAreaSongInfo) - 100, #PB_Ignore)  
      ResizeGadget(ImageFlag(Song), 20,  Y3 + Y, #PB_Ignore, #PB_Ignore)     
    Else
      ResizeGadget(LabelSongInfo(2, Song), 20, Y3 + Y, GadgetWidth(#ScrollAreaSongInfo) - 150, #PB_Ignore)          
    EndIf
  EndIf
EndProcedure
 
Procedure SelectRow(gadget, index)  
  Protected.i Row_H 

  SetGadgetState(gadget, index)

  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    Row_H = SendMessage_(GadgetID(gadget), #LVM_GETITEMSPACING, 1, 0) >> 16 
    SendMessage_(GadgetID(gadget), #LVM_ENSUREVISIBLE, index, 0)
    SetGadgetItemState(gadget, index, #PB_ListIcon_Selected)
    SetActiveGadget(gadget)
  CompilerEndIf
EndProcedure

Procedure CreateFieldPopup(DBField.s, ContainerID.i, StringID.i, ListviewID.i)
  Protected.i Item, Items
  Protected.s Fields
  
  ContainerGadget(ContainerId, GadgetX(StringID) + 30, GadgetY(StringID) + 35, GadgetWidth(StringID) - 30, 100)
  ListViewGadget(ListviewID, 0, 0, GadgetWidth(StringID), 100)  
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    SetGadgetFont(ListviewID, FontID(#Font)) 
    Fields = RemoveDuplicates(GetDistinct(DBField))  
  
    Items = CountString(Fields, ",") + 1
    For Item = 1 To Items
      AddGadgetItem(ListviewID, -1, StringField(Fields, Item, ","))
    Next 
  CompilerEndIf
  
  CloseGadgetList()
  HideGadget(ContainerID, #True)  
EndProcedure

Procedure FieldPopUp(EventType.i, ListviewID.i, StringID.i, ContainerID.i)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ProcedureReturn
  CompilerEndIf
  
  Protected.i Last, Position, Item
  Protected.i Items = CountGadgetItems(ListviewID)
  Protected.s String = GetGadgetText(StringID)
  Protected.s Field 
  
  If EventType = #PB_EventType_Focus
    HideGadget(#ContainerGenre, #True) 
    HideGadget(#ContainerArtist, #True) 
    HideGadget(#ContainerYear, #True) 
    HideGadget(#ContainerCountry, #True) 
    HideGadget(#ContainerLabel, #True)      
    
    Visible\Container = 0
    
    If StringID = #GenreString
      SetGadgetText(StringID, CleanString(String))    
    Else
      SetGadgetText(StringID, Trim(String))    
    EndIf  
  ElseIf EventType = #PB_EventType_LostFocus
    If StringID = #GenreString    
      SetGadgetText(StringID, CleanString(String))    
    Else
      SetGadgetText(StringID, Trim(String))    
    EndIf      
    HideGadget(ContainerID, #True)
    Visible\Container = 0
  ElseIf EventType = #PB_EventType_Change 
    If StringID = #GenreString 
      Repeat
        Last = Position
        Position = FindString(String , ",", Position + 1)
      Until Not Position 
         
      Field = Trim(Mid(String, Last + 1)) 
    Else
      Field = Trim(String)     
    EndIf
    
    If Field <> "" 
      If LCase(Trim(GetGadgetItemText(ListviewID, GetGadgetState(ListviewID)))) = LCase(Field)          
        HideGadget(ContainerID, #True) 
        Visible\Container = 0
      Else
        For Item = 1 To Items
          If LCase(Left(Trim(GetGadgetItemText(ListviewID, Item - 1)), Len(Field))) = LCase(Field)        
            SelectRow(ListviewID, Item - 1)
            HideGadget(ContainerID, #False) 
            Visible\Container = ContainerID
            Break
          EndIf
        Next
      EndIf
    EndIf  
  EndIf
EndProcedure

Procedure FieldPopupSelect(EventType.i, ListviewID.i, StringID.i)
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    ProcedureReturn
  CompilerEndIf  
  
  Protected.i Last, Position  
  Protected.i Row = GetGadgetState(ListviewID)
  Protected.s String = GetGadgetText(StringID)
  
  If EventType <> #PB_EventType_LeftClick Or Row = -1
    ProcedureReturn
  EndIf
  
  Repeat
    Last = Position
    Position = FindString(String , ",", Position + 1)
  Until Not Position 
  
  If FindString(LCase(String), LCase(GetGadgetItemText(ListviewID, Row) + ",")) = 0
    SetGadgetText(StringID, Left(String, Last) + GetGadgetItemText(ListviewID, Row))  
  EndIf  
EndProcedure

Procedure AskRepeatQuestion(Part.s, Value.i)
  Protected.i MixLoop, TotalBeats, LoopBeats
  Protected.s Input 
  
  If Value < 1 
    Value = 1
  EndIf
  
  Input = InputRequester(Part + " loop", "Fill in how many times the " + Part + " loop has to be played (a number between 2 and 32). " + Chr(10) + Chr(10) +
                                      "If you don't know how to calculate this value you may also " + Chr(10) + 
                                      "enter the number of beats between the '" + Part + " begin'-marker and '" + Part + " end'-marker" + Chr(10) + 
                                      "and the number of beats between the '" + Part + " loop begin'-marker and '" + Part + " loop end'-marker" + Chr(10) + 
                                      "(separate these values by a comma)", Str(Value + 1)) 
  
  Input = Trim(Input)
  If Input = ""
    ProcedureReturn
  EndIf

  If FindString(Input, ",") = 0
    MixLoop = Val(Input)      
  Else
    TotalBeats = Val(Trim(StringField(Input, 1, ",")))
    LoopBeats = Val(Trim(StringField(Input, 2, ",")))
    MixLoop = 1 + ((32 - TotalBeats) / LoopBeats)
  EndIf
  
  If MixLoop < 2 
    MixLoop = 2
  ElseIf MixLoop > 32
    MixLoop = 32
  EndIf 
  
  MixLoop - 1
 
  If Part = "intro"   
    DatabaseSong\IntroLoopRepeat = MixLoop 
  Else
    DatabaseSong\BreakLoopRepeat =MixLoop 
  EndIf
  
  SetGadgetText(#BPMString, FormatNumber(CalculateExactBPM()))    
  
  DrawMarkers()      
  DrawCursor()    
EndProcedure

Procedure.s FormatBeats(BeatList.s)
  BeatList = ReplaceString(BeatList, ":", ".")
  BeatList = ReplaceString(BeatList, "\n", Chr(13))
  BeatList = ReplaceString(BeatList, "\r", Chr(13))        
  BeatList = ReplaceString(BeatList, Chr(10), Chr(13))
   
  ProcedureReturn BeatList
EndProcedure

Procedure LoadDatabaseFile(FileFullPath.s, BPM.s = "") 
  Protected.q Length, NumSamples   
  Protected.f LengthSecond    
  Protected.i SamplesPerElement, Image
  Protected.s Prefix, Extension, PathLinux, PathWindows
  Protected *tagArtist.Ascii, *tagTitle.Ascii, *tagYear.Ascii, *tagGenre.Ascii
  Protected Info.BASS_CHANNELINFO  
  
  FileFullPath = OSPath(FileFullPath)
 
  ReDim MM.MinMax(0)
   
  BASS_StreamFree(Chan\DecodedDatabase)  
  BASS_StreamFree(Chan\Database) 
  
  If BPM = ""
    If FileSize(FileFullPath) = -1
      MessageRequester("Action not allowed", "File " + FileFullPath + " does not exists", #PB_MessageRequester_Error)
      ProcedureReturn
    EndIf
  EndIf
  
  DatabaseSong\AudioFilename = FileFullPath  
  DatabaseSong\IntroPrefix = 0
  DatabaseSong\IntroFade = 0
  DatabaseSong\IntroStart = 0
  DatabaseSong\IntroEnd = 0       
  DatabaseSong\IntroLoopRepeat = 0
  DatabaseSong\IntroLoopStart = 0
  DatabaseSong\IntroLoopEnd = 0  
  DatabaseSong\IntroBeatList = ""
  DatabaseSong\BreakFade = 0  
  DatabaseSong\BreakStart = 0
  DatabaseSong\BreakEnd = 0
  DatabaseSong\BreakLoopRepeat = 0       
  DatabaseSong\BreakLoopStart = 0
  DatabaseSong\BreakLoopEnd = 0
  DatabaseSong\BreakBeatList = ""
  DatabaseSong\BreakMute = 0
  DatabaseSong\BreakContinue = 0 
  DatabaseSong\SkipStart = 0
  DatabaseSong\SkipEnd = 0       
  DatabaseSong\BPM = ValF(BPM)  
 
  Chan\DecodedDatabase = CreateChannel(FileFullPath, #BASS_STREAM_DECODE)    

  Length = BASS_ChannelGetLength(Chan\DecodedDatabase, #BASS_POS_BYTE)   
  LengthSecond = BASS_ChannelBytes2Seconds(Chan\DecodedDatabase, Length)    
  NumSamples = Length >> 2
  SamplesPerElement = NumSamples / GadgetWidth(#CanvasWaveform)  

  Dim MM.MinMax(NumSamples / SamplesPerElement)

  DatabaseSong\BytesPerPixel = SamplesPerElement << 2
  
  *FullWaveData = AllocateMemory(Length)
  BASS_ChannelGetData(Chan\DecodedDatabase, *FullWaveData, Length)  
  MinMaxScaled(@MM(), SamplesPerElement, *FullWaveData, NumSamples)
 
  Chan\Database = CreateChannel(FileFullPath)
  Bass_ChannelGetInfo(Chan\Database, @Info) 
  DatabaseSong\OrigFreq = Info\freq   
 
  DatabaseSong\ViewLength = LengthSecond
  DatabaseSong\ViewBegin = 0  
  DatabaseSong\ViewEnd = LengthSecond
  DatabaseSong\CursorSec = 0
  DatabaseSong\CursorX = 0  
  DatabaseSong\SelectionBegin = 0
  DatabaseSong\SelectionEnd = 0 
  DatabaseSong\SelectionLength = 0  

  SetGadgetText(#ViewLengthString, Seconds2TimeMS(DatabaseSong\ViewLength))            
  SetGadgetText(#ViewEndString, Seconds2TimeMS(DatabaseSong\ViewEnd))              
  SetGadgetText(#CursorPosString, Seconds2TimeMS(DatabaseSong\CursorSec))
  SetGadgetText(#BPMString, BPM)  

  ;Add song if BPM is not empty 
  If BPM <> "" 
    ;Read ID3-tags  
    TAGS_SetUTF8(#True)
   
    *tagArtist = TAGS_Read(Chan\Database, "%ARTI")
    If *tagArtist
      SetGadgetText(#ArtistString, PeekS(*tagArtist, -1, #PB_UTF8))
    EndIf
    
    *tagTitle = TAGS_Read(Chan\Database, "%TITL")
    If *tagTitle
      SetGadgetText(#TitleString, PeekS(*tagTitle, -1, #PB_UTF8))
    EndIf 
    
    *tagYear = TAGS_Read(Chan\Database, "%YEAR")
    If *tagYear
      SetGadgetText(#YearString, PeekS(*tagYear, -1, #PB_UTF8))
    EndIf 
    
    *tagGenre = TAGS_Read(Chan\Database, "%GNRE")
    If *tagGenre
      SetGadgetText(#GenreString, PeekS(*tagGenre, -1, #PB_UTF8))
    EndIf       
      
    UpdateCanvas()  
    DrawCursor()
    
    HideWindow(#WindowDatabaseAddRecord, #False)
    
    DatabaseRecordData = AllGadgetsData()
    
    ProcedureReturn
  EndIf
  
  ;Otherwise edit song ==> add database values to fields 
  FileFullPath = ReplaceString(FileFullPath, Preferences\PathAudio, "")
  
  PathLinux = ReplaceString(FileFullPath, "\", "/");
  PathWindows = ReplaceString(FileFullPath, "/", "\");
  
  DatabaseQuery(#DBMusic, "SELECT * FROM music WHERE filename='" + ReplaceString(PathLinux, "'", "''") + "' OR filename='" + ReplaceString(PathWindows, "'", "''") + "'LIMIT 1")   
  NextDatabaseRow(#DBMusic)  
 
  DatabaseSong\IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 4))
  DatabaseSong\IntroFade = GetDatabaseLong(#DBMusic, 5)
  DatabaseSong\BreakFade = GetDatabaseLong(#DBMusic, 13)  
  DatabaseSong\IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 6)) 
  DatabaseSong\IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 7))       
  DatabaseSong\IntroLoopRepeat = GetDatabaseLong(#DBMusic, 34)    
  DatabaseSong\IntroLoopStart = Time2Seconds(GetDatabaseString(#DBMusic, 30))
  DatabaseSong\IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 31))  
  DatabaseSong\IntroBeatList = FormatBeats(GetDatabaseString(#DBMusic, 8))
  DatabaseSong\BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 14)) 
  DatabaseSong\BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 15))
  DatabaseSong\BreakLoopRepeat = GetDatabaseLong(#DBMusic, 35)        
  DatabaseSong\BreakLoopStart = Time2Seconds(GetDatabaseString(#DBMusic, 32))
  DatabaseSong\BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 33))
  DatabaseSong\BreakBeatList = FormatBeats(GetDatabaseString(#DBMusic, 16))
  DatabaseSong\BreakMute = Time2Seconds(GetDatabaseString(#DBMusic, 28))
  DatabaseSong\BreakContinue = Time2Seconds(GetDatabaseString(#DBMusic, 29))  
  DatabaseSong\SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 36))
  DatabaseSong\SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 37))        
  DatabaseSong\BPM = GetDatabaseFloat(#DBMusic, 3)    
  DatabaseSong\OrigFreq = GetDatabaseLong(#DBMusic, 38)

  If DatabaseSong\IntroLoopRepeat < 1 
    DatabaseSong\IntroLoopRepeat = 1
  EndIf

  If DatabaseSong\BreakLoopRepeat < 1 
    DatabaseSong\BreakLoopRepeat = 1
  EndIf
      
  SetGadgetText(#ArtistString,  GetDatabaseString(#DBMusic, 1)) 
  SetGadgetText(#TitleString,  GetDatabaseString(#DBMusic, 2))           
  SetGadgetText(#BPMString, FormatNumber(DatabaseSong\BPM))                    
  SetGadgetState(#IntroHasBass, GetDatabaseLong(#DBMusic, 9))
  SetGadgetState(#IntroHasVocal, GetDatabaseLong(#DBMusic, 10))
  SetGadgetState(#IntroHasMelody, GetDatabaseLong(#DBMusic, 11))
  SetGadgetState(#IntroHasBeats, GetDatabaseLong(#DBMusic, 12)) 
  SetGadgetState(#IntroFadeIn, GetDatabaseLong(#DBMusic, 5)) 
  SetGadgetState(#BreakFadeOut, GetDatabaseLong(#DBMusic, 13)) 
  SetGadgetState(#BreakHasBass, GetDatabaseLong(#DBMusic, 17))
  SetGadgetState(#BreakHasVocal, GetDatabaseLong(#DBMusic, 18)) 
  SetGadgetState(#BreakHasMelody, GetDatabaseLong(#DBMusic, 19))
  SetGadgetState(#BreakHasBeats, GetDatabaseLong(#DBMusic, 20))
  SetGadgetText(#GenreString, GetDatabaseString(#DBMusic, 21))  
  SetGadgetText(#YearString, GetDatabaseString(#DBMusic, 24)) 
  SetGadgetText(#LabelString, GetDatabaseString(#DBMusic, 25))
  SetGadgetText(#CatNoString, GetDatabaseString(#DBMusic, 26))
  SetGadgetText(#CountryString, GetDatabaseString(#DBMusic, 27))  
  
  Extension = LCase(GetExtensionPart(GetDatabaseString(#DBMusic, 23)))
  
  If (Extension = "jpg" Or Extension = "png" Or Extension = "bmp") And FileSize(Preferences\PathSleeves + OSPath(GetDatabaseString(#DBMusic, 23))) <> -1
    SetGadgetText(#SleeveString, Preferences\PathSleeves + OSPath(GetDatabaseString(#DBMusic, 23)))          
  EndIf
    
  FinishDatabaseQuery(#DBMusic)      
    
  If GetGadgetText(#SleeveString) <> ""
    Select LCase(GetExtensionPart(GetGadgetText(#SleeveString)))
      Case "jpg"
        Image = LoadImage(#PB_Any, GetGadgetText(#SleeveString), UseJPEGImageDecoder())          
      Case "png"
        Image = LoadImage(#PB_Any, GetGadgetText(#SleeveString), UsePNGImageDecoder())          
      Case "bmp"
        Image = LoadImage(#PB_Any, GetGadgetText(#SleeveString))          
    EndSelect
    ResizeImage(Image, 110, 110)
    SetGadgetState(GadgetNumber\SleeveDatabase, ImageID(Image))            
  EndIf
  
  UpdateCanvas()  
  DrawMarkers()      
  DrawCursor()  

  HideWindow(#WindowDatabaseAddRecord, #False)  
  
  DatabaseRecordData = AllGadgetsData()  
EndProcedure

Procedure ListFilesRecursive(Dir.s, List Files.s())
  Protected.i D, Channel, Event
  Protected.s Extension, File, Folder, DBFile, BPM, Added, FileFullPath, FileSearchString, FolderLinux, FolderWindows
  Protected.b WMA
    
  NewList Directories.s()
  
  If StopCollectingFiles
    ProcedureReturn
  EndIf
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    WMA = #True
  CompilerEndIf  
   
  If Right(Dir, 1) <> "/" And  Right(Dir, 1) <> "\"
    Dir + OSPath("/")
  EndIf
  
  D = ExamineDirectory(#PB_Any, Dir, "")
  While NextDirectoryEntry(D) And Not StopCollectingFiles
    Select DirectoryEntryType(D)
      Case #PB_DirectoryEntry_File
        Extension = LCase(GetExtensionPart(DirectoryEntryName(D)))
        If Extension = "mp3" Or 
           Extension = "mp2" Or 
           Extension = "mp1" Or 
           Extension = "ogg" Or 
           Extension = "wav" Or 
           Extension = "aiff" Or
           Extension = "aac" Or 
           Extension = "adts" Or 
           Extension = "m4a" Or
           Extension = "mp4" Or
           Extension = "flac" Or
           Extension = "opus" Or
           (WMA And Extension = "wma")
          File = ReplaceString(DirectoryEntryName(D), "'", "''")
          Folder = ReplaceString(Dir, "'", "''")
          FolderLinux = ReplaceString(Folder, "\", " /")
          FolderWindows = ReplaceString(Folder,"/", "\")
          
          FileFullPath = Dir + DirectoryEntryName(D) 
        
          ;Check if file exists in files-database
          DatabaseQuery(#DBFiles, "SELECT file FROM files WHERE file='" + File + "' AND (folder='" + FolderLinux + "' OR folder='" + FolderWindows + "') LIMIT 1")   
          NextDatabaseRow(#DBFiles)
          DBFile = OSPath(GetDatabaseString(#DBFiles, 0))   
          FinishDatabaseQuery(#DBFiles)    
          
          If DBFile = ""              
            ;Check if file does exists in music-database
            FileSearchString = ReplaceString(ReplaceString(Dir, Preferences\PathAudio, ""), "'", "''") + File
            DatabaseQuery(#DBMusic, "SELECT filename FROM music WHERE filename='" + ReplaceString(FileSearchString, "\", "/")  + "' OR filename='" + ReplaceString(FileSearchString, "/", "\")  + "' LIMIT 1")   
            NextDatabaseRow(#DBMusic)
            If GetDatabaseString(#DBMusic, 0) <> "" 
              Added = "Yes"
            Else
              Added = "No"              
            EndIf
            FinishDatabaseQuery(#DBMusic)    
            
            SetGadgetText(#LabelFile, "FOLDER: " + Dir + Chr(13) +  Chr(13) + "FILE: " + DirectoryEntryName(D))                             
            
            AddElement(Files())
            Files() = FileFullPath          
          
            BPM = CalculateEstimatedBPM(Files())           
            DatabaseUpdate(#DBFiles, "INSERT INTO files (added, bpm, file, folder) VALUES ('" + Added + "', '" + BPM + "', '" + File + "', '" + Folder + "')")
            AddGadgetItem(#ListiconMusicLibrary, -1, Added + Chr(10) + BPM + Chr(10) + 
                                                     DirectoryEntryName(D) + Chr(10) +
                                                     Dir)   
          EndIf
        EndIf
      Case #PB_DirectoryEntry_Directory
        Select DirectoryEntryName(D)
          Case ".", ".."
            Continue
          Default
            AddElement(Directories())
            Directories() = Dir + DirectoryEntryName(D)
        EndSelect
    EndSelect
    
    Delay(5) 
  Wend
  FinishDirectory(D)
  
  ForEach Directories()
    ListFilesRecursive(Directories(), Files())
  Next
EndProcedure

Procedure SetTrackBarMaximum()
  Busy = #True
  
  Protected.f Length = Mix(CurrentSong)\Playtime 
 
  If Mix(CurrentSong)\Number < ListSize(Songs()) Or (Mix(CurrentSong)\Number = ListSize(Songs()) And Mix(CurrentSong)\Shorten)
    Length - Round(TransitionLength(Mix(CurrentSong)\BreakStart, 
                              Mix(CurrentSong)\BreakEnd, 
                              Mix(CurrentSong)\BreakLoopStart, 
                              Mix(CurrentSong)\BreakLoopEnd, 
                              Mix(CurrentSong)\BreakLoopRepeat), #PB_Round_Nearest) 
  EndIf
  
  If Mix(CurrentSong)\Number < ListSize(Songs())
    Length - Mix(NextSong)\IntroPrefix
  EndIf
  
  Length * (Mix(CurrentSong)\OrigFreq / Mix(CurrentSong)\Samplerate)
  Length * 1000

  If Mix(CurrentSong)\Number < ListSize(Songs()) Or (Mix(CurrentSong)\Number = ListSize(Songs()) And Mix(CurrentSong)\Shorten)
    Length - 100
  EndIf
    
  SetGadgetAttribute(#Trackbar, #PB_TrackBar_Maximum, Int(Length))
  SetGadgetState(#Trackbar, 0)  
  UpdateTimeLabels()
  
  Busy = #False
EndProcedure

Procedure CopySong(DestinationSong.i)
  If ListSize(Songs()) = 0
    ProcedureReturn
  EndIf
 
  Mix(DestinationSong)\ID = Songs()\ID
  Mix(DestinationSong)\Channel = Songs()\Channel
  Mix(DestinationSong)\Number = Songs()\Number
  Mix(DestinationSong)\AudioFilename = Songs()\AudioFilename
  Mix(DestinationSong)\SleeveFilename = Songs()\SleeveFilename
  Mix(DestinationSong)\Artist= Songs()\Artist
  Mix(DestinationSong)\Title = Songs()\Title
  Mix(DestinationSong)\Year = Songs()\Year
  Mix(DestinationSong)\Label = Songs()\Label
  Mix(DestinationSong)\Catno = Songs()\Catno
  Mix(DestinationSong)\Country = Songs()\Country
  Mix(DestinationSong)\Playtime = Songs()\Playtime
  Mix(DestinationSong)\IntroBeatList = Songs()\IntroBeatList
  Mix(DestinationSong)\IntroFade = Songs()\IntroFade
  Mix(DestinationSong)\IntroBeats = Songs()\IntroBeats
  Mix(DestinationSong)\IntroPrefix = Songs()\IntroPrefix
  Mix(DestinationSong)\IntroStart = Songs()\IntroStart
  Mix(DestinationSong)\IntroEnd = Songs()\IntroEnd
  Mix(DestinationSong)\IntroLoopStart = Songs()\IntroLoopStart
  Mix(DestinationSong)\IntroLoopEnd = Songs()\IntroLoopEnd
  Mix(DestinationSong)\IntroLoopRepeat = Songs()\IntroLoopRepeat
  Mix(DestinationSong)\BreakBeatList = Songs()\BreakBeatList
  Mix(DestinationSong)\BreakFade = Songs()\BreakFade 
  Mix(DestinationSong)\BreakBeats = Songs()\BreakBeats
  Mix(DestinationSong)\BreakStart = Songs()\BreakStart
  Mix(DestinationSong)\BreakEnd = Songs()\BreakEnd
  Mix(DestinationSong)\BreakContinue = Songs()\BreakContinue
  Mix(DestinationSong)\BreakLoopStart = Songs()\BreakLoopStart
  Mix(DestinationSong)\BreakLoopEnd = Songs()\BreakLoopEnd
  Mix(DestinationSong)\BreakLoopRepeat = Songs()\BreakLoopRepeat
  Mix(DestinationSong)\BreakMute = Songs()\BreakMute
  Mix(DestinationSong)\SkipStart = Songs()\SkipStart
  Mix(DestinationSong)\SkipEnd = Songs()\SkipEnd 
  Mix(DestinationSong)\Samplerate = Songs()\Samplerate
  Mix(DestinationSong)\Shorten = Songs()\Shorten
  Mix(DestinationSong)\PlaybackBPM = Songs()\PlaybackBPM
  Mix(DestinationSong)\BPM = Songs()\BPM  
  Mix(DestinationSong)\NoMatch = Songs()\NoMatch
  Mix(DestinationSong)\PreviousSamplerate = Songs()\PreviousSamplerate
  Mix(DestinationSong)\Pitch = Songs()\Pitch
  Mix(DestinationSong)\OrigFreq = Songs()\OrigFreq  
  Mix(DestinationSong)\BreakBeatListFromDB = Songs()\BreakBeatListFromDB
  Mix(DestinationSong)\IntroBeatListFromDB = Songs()\IntroBeatListFromDB  
  Mix(DestinationSong)\BeatCounter = Songs()\BeatCounter
  Mix(DestinationSong)\IntroLoopCounter = Songs()\IntroLoopCounter
  Mix(DestinationSong)\BreakLoopCounter = Songs()\BreakLoopCounter
  Mix(DestinationSong)\PlaybackSamplerate = Songs()\PlaybackSamplerate
  Mix(DestinationSong)\Shorten = Songs()\Shorten
EndProcedure

Procedure DecodeMix()
  Protected.i Work, Event
  Protected.f Percent
  
  StopDecoding = #False
  Work = CreateThread(@ThreadDecoding(), 0)
  
  While IsThread(Work)
    Select WaitWindowEvent()  
      Case #PB_Event_CloseWindow 
        StopDecoding = #True  
        Break
    EndSelect
    
    Percent = ((Mix(CurrentSong)\Number) / ListSize(Songs())) * 100    
    SetGadgetState(#ProgressbarExport, Int(Percent))    
    SetGadgetText(#LabelExportPercent, Str(Int(Percent)) + "%")
    
    Repeat 
      Event = WindowEvent() 
    Until Event = 0
    Delay(5)
  Wend  

  BASS_Encode_Stop(Chan\Mixer)
  BASS_StreamFree(Chan\Mixer)
  
  If RawFile <> "" And FileSize(RawFile) <> -1
    SetGadgetState(#ProgressbarExport, 0)  
    SetGadgetText(#LabelExport, "Exporting mix to " + ChangeFileExtension(GetFilePart(RawFile), "wav") + " ..." + Chr(13) + "Converting encoded data to wav ...")
    Repeat 
      Event = WindowEvent() 
    Until Event = 0
    Delay(5)
    
    ConvertRawToWav_Stream(RawFile, ChangeFileExtension(RawFile, "wav"), 44100, 2, 16)
    DeleteFile(RawFile)
  EndIf
  
  LoadPreviousPlaylist()
  SelectRow(#ListiconPlaylist, TracklistPosition)
   
  Chan\Mixer = BASS_Mixer_StreamCreate(44100, 2, #BASS_MIXER_END|#BASS_UNICODE|#BASS_SAMPLE_FLOAT)        
  BASS_ChannelSetPosition(Chan\Mixer, 0, #BASS_POS_BYTE)  
  PrepareMix(GetGadgetState(#ListiconPlaylist))
  CloseWindow(#WindowExportToAudioFile)
  DisableWindow(#WindowMain, #False)
  Decoding = #False
EndProcedure

Procedure UpdateTrackbar()
  Protected.i TransitionSeconds, TempSource, Beat, Item
  Protected.i ScrollHeight = GetGadgetAttribute(#ScrollAreaSongInfo, #PB_ScrollArea_InnerHeight) - GadgetHeight(#ScrollAreaSongInfo) 
  Protected.i BeatsIntro = CountString(Mix(NextSong)\IntroBeatListFromDB, Chr(10))
  Protected.i BeatsBreak = CountString(Mix(CurrentSong)\BreakBeatListFromDB, Chr(10))  
  Protected.f TotalSteps, TrackbarPosition
  Protected.f PosCurrentSong = BASS_ChannelBytes2Seconds(Mix(CurrentSong)\Channel, BASS_ChannelGetPosition(Mix(CurrentSong)\Channel, #BASS_POS_BYTE))
  Protected.f PosNextSong, BeatPos
  Protected.f SkipSec = (Mix(CurrentSong)\SkipEnd - Mix(CurrentSong)\SkipStart)  
  Protected.s MixLabel, Field.s

  Static.b Flag
  Static.f ScrollY, StepSize
  Static.i TransitionMS

  If Busy Or (isPaused And startTime <> -1)
    ProcedureReturn
  EndIf
        
  If Mix(CurrentSong)\Mixing Or Mix(CurrentSong)\Fading
    If Not Flag      
      Flag = #True
      
      startTime = ElapsedMilliseconds()               
      TransitionSeconds = Round(TransitionLength(Mix(CurrentSong)\BreakStart, Mix(CurrentSong)\BreakEnd, Mix(CurrentSong)\BreakLoopStart, Mix(CurrentSong)\BreakLoopEnd, Mix(CurrentSong)\BreakLoopRepeat), #PB_Round_Nearest) * (Mix(CurrentSong)\OrigFreq / Mix(CurrentSong)\Samplerate)
           
      TransitionSeconds + Mix(CurrentSong)\BreakContinue                
      If Not Mix(CurrentSong)\Fading And Not Mix(NextSong)\IntroFade
        TransitionSeconds + Mix(NextSong)\IntroPrefix * (Mix(CurrentSong)\OrigFreq / Mix(NextSong)\Samplerate)
      EndIf
     
      HideGadget(#Trackbar, #True)
      HideGadget(#TrackbarTransition, #False)   
      
      TransitionMS = TransitionSeconds * 1000
      SetGadgetAttribute(#TrackbarTransition, #PB_TrackBar_Maximum, TransitionMS)
       
      If Mix(CurrentSong)\Mixing     
        SetGadgetItemState(#ListiconPlaylist, Mix(CurrentSong)\Number, #PB_ListIcon_Selected)
        SetGadgetItemColor(#ListiconPlaylist, Mix(CurrentSong)\Number, #PB_Gadget_BackColor, #PB_Default)        

        TotalSteps = TransitionMS / 50  
        StepSize = ScrollHeight / TotalSteps        

        SetGadgetText(#LabelTime, "Mixing")              
        UpdateSongInfo(NextSong)             
      Else
        SetGadgetText(#LabelTime, "Fading")   
      EndIf         
    EndIf
    
    PosNextSong = BASS_ChannelBytes2Seconds(Mix(NextSong)\Channel, BASS_ChannelGetPosition(Mix(NextSong)\Channel, #BASS_POS_BYTE))
     
    If Mix(CurrentSong)\Mixing 
      If Mix(CurrentSong)\BreakBeats And Mix(NextSong)\IntroBeats  
        Select Preferences\FilterOverlappedBeats
          Case "Current song" 
            MixLabel + "Attenuate break beats | "      
          Case "Next song"  
            MixLabel + "Attenuate intro beats | "      
          Case "Both songs"    
            MixLabel + "Attenuate break beats | Attenuate intro beats | "            
        EndSelect      
      EndIf  
      
      If Mix(NextSong)\IntroPrefix > 0 And PosNextSong < Mix(NextSong)\IntroStart + 1
        MixLabel + "Prestarting intro | "   
      EndIf     
    
      If Mix(NextSong)\IntroFade  
        MixLabel + "Fading in intro | "   
      EndIf     
      
      If Mix(NextSong)\IntroLoopStart > 0 And Mix(NextSong)\IntroLoopEnd > 0 And Mix(NextSong)\IntroLoopRepeat > 0 And Mix(NextSong)\IntroLoopCounter > 0 And Mix(NextSong)\IntroLoopCounter <= Mix(NextSong)\IntroLoopRepeat And PosNextSong <= Mix(NextSong)\IntroLoopEnd
        MixLabel + "Loop intro (" + Mix(NextSong)\IntroLoopCounter + ") | "        
      EndIf  
      
      If Mix(CurrentSong)\BreakFade  
        MixLabel + "Fading out break | "   
      EndIf   
      
      If Mix(CurrentSong)\BreakLoopStart > 0 And Mix(CurrentSong)\BreakLoopEnd > 0 And Mix(CurrentSong)\BreakLoopRepeat > 0 And Mix(CurrentSong)\BreakLoopCounter > 0 And Mix(CurrentSong)\BreakLoopCounter <= Mix(CurrentSong)\BreakLoopRepeat And PosCurrentSong <= Mix(CurrentSong)\BreakLoopEnd 
        MixLabel + "Loop break (" + Mix(CurrentSong)\BreakLoopCounter + ") | "     
      EndIf  
      
      If Mix(CurrentSong)\BreakMute > 0 And PosCurrentSong >= PosCurrentSong + Mix(CurrentSong)\BreakMute
        MixLabel + "Muting break | "
      EndIf       
    EndIf
    
    If Mix(CurrentSong)\Shorten And PosCurrentSong > Mix(CurrentSong)\SkipStart And PosCurrentSong < Mix(CurrentSong)\SkipEnd + 2 And Mix(CurrentSong)\BreakLoopCounter = 0
      MixLabel + "Cutted " + FormatNumber(SkipSec, 2) + " sec. | "  
    EndIf 
    
    If Mix(CurrentSong)\BreakContinue > 0 And PosCurrentSong >= Mix(CurrentSong)\BreakEnd And PosCurrentSong < PosCurrentSong + Mix(CurrentSong)\BreakContinue
      MixLabel + "Continuing break | "  
    EndIf
 
    If BeatsIntro > 0 Or BeatsBreak > 0
      If BeatsBreak > 0
        For Beat = BeatsBreak To 1 Step -1
          Field = StringField(Mix(CurrentSong)\BreakBeatListFromDB, Beat, Chr(10))
          BeatPos = Time2Seconds(Field)   
          If PosCurrentSong >= BeatPos And PosCurrentSong < BeatPos + 2 
            MixLabel + "Adjusted break beatpos. to " + FormatNumber(BeatPos, 3) + " | "
            Break
          EndIf     
        Next
      EndIf  
      
      If BeatsIntro > 0
        For Beat = BeatsIntro To 1 Step -1
          Field = StringField(Mix(NextSong)\IntroBeatListFromDB, Beat, Chr(10))
          BeatPos = Time2Seconds(Field)     
          If PosNextSong >= BeatPos And PosNextSong < BeatPos + 2
            MixLabel + "Adjusted intro beatpos. to " + FormatNumber(BeatPos, 3)
            Break
          EndIf     
        Next
      EndIf
    EndIf

    If Not isPaused 
      elapsedTime = ElapsedMilliseconds() - startTime
    EndIf      
    
    If Mix(CurrentSong)\Mixing
      ScrollY = (ElapsedTime / TransitionMS) * ScrollHeight

      If ScrollY > ScrollHeight
        ScrollY = ScrollHeight
      EndIf
      
      SetGadgetAttribute(#ScrollAreaSongInfo, #PB_ScrollArea_Y, ScrollY)
    EndIf

    SetGadgetState(#TrackbarTransition, elapsedTime) 
  Else        
    If Flag 
      Flag = #False
      HideGadget(#Trackbar, #False)
      HideGadget(#TrackbarTransition, #True)                  
      
      SetGadgetItemState(#ListiconPlaylist, Mix(CurrentSong)\Number - 1, 0)

      ;Refresh playlist at last song if infinity mode is active  
      If Mix(NextSong)\Number + 1 = ListSize(Songs()) And Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random" 
        RefreshPlaylist = #True     
        TempSource = Mix(CurrentSong)\Channel  
        ButtonCreateRandomPlaylist()
        
        FirstElement(Songs())            
        Mix(CurrentSong)\Channel = TempSource 
        Mix(CurrentSong)\Number = 1 
        CreateThread(@ThreadNextSong(), 0)   
        RefreshPlaylist = #False    
      EndIf        
      
      SetTrackBarMaximum()
      UpdateSongInfo(CurrentSong)   
      UpdateSongInfo(NextSong)  
     
      If Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random" And GetGadgetState(#ListiconPlaylist) = CountGadgetItems(#ListiconPlaylist) - 1
        SelectRow(#ListiconPlaylist, 0)
      EndIf       
    EndIf
    
    TrackbarPosition = PosCurrentSong   
    
    If Mix(CurrentSong)\Shorten And PosCurrentSong  > Mix(CurrentSong)\SkipStart
      TrackbarPosition - (Mix(CurrentSong)\SkipEnd - Mix(CurrentSong)\SkipStart)
    EndIf             
    
    If Mix(CurrentSong)\Number > 1
      TrackbarPosition - Mix(CurrentSong)\IntroEnd 
    EndIf    
    
    TrackbarPosition * (Mix(CurrentSong)\OrigFreq / Mix(CurrentSong)\Samplerate)
    SetGadgetState(#Trackbar, TrackbarPosition * 1000)  
 
    If Mix(CurrentSong)\Shorten And PosCurrentSong > Mix(CurrentSong)\SkipStart And PosCurrentSong < Mix(CurrentSong)\SkipEnd + 2
      MixLabel + "Cutted " + FormatNumber(SkipSec, 2) + " sec. | " 
    EndIf
  
    If Mix(CurrentSong)\Samplerate = Mix(CurrentSong)\OrigFreq And GetGadgetState(#Trackbar) / 1000 < 3 And Mix(CurrentSong)\Number > 1 ;And GetGadgetItemText(#ListiconPlaylist, Mix(CurrentSong)\Number - 2, 6) <> "  0.00%"
      MixLabel + "Pitch resetted" 
    EndIf    
    
    ;Skip if sync for skip is missed
    If Mix(CurrentSong)\Shorten And PosCurrentSong > Mix(CurrentSong)\SkipStart And PosCurrentSong < Mix(CurrentSong)\SkipEnd
      BASS_ChannelSetPosition(Mix(CurrentSong)\Channel, BASS_ChannelSeconds2Bytes(Mix(CurrentSong)\Channel, Mix(CurrentSong)\SkipStart), #BASS_POS_BYTE)
    EndIf
  EndIf
  
  MixLabel = RTrim(MixLabel)
  MixLabel = RTrim(MixLabel, "|")   
  SetGadgetText(#LabelMix, MixLabel)      
      
  UpdateTimeLabels()      
  UpdateSpectrum()          
EndProcedure  

Procedure UpdateTrackbarMusicLibrary()
  Protected.f TrackbarPosition
  
  TrackbarPosition = BASS_ChannelGetPosition(Chan\Database, #BASS_POS_BYTE) 
  SetGadgetState(#TrackbarMusicLibrary, Int(TrackbarPosition))
  If TrackbarPosition = GetGadgetAttribute(#TrackbarMusicLibrary, #PB_TrackBar_Maximum)
    ButtonStopMusicLibrarySong()
  EndIf  
EndProcedure

Procedure UpdateTrackbarPicklist()
  Protected.f TrackbarPosition
  
  TrackbarPosition = BASS_ChannelGetPosition(Chan\Database, #BASS_POS_BYTE) 
  SetGadgetState(#TrackbarPicklist, Int(TrackbarPosition))
  If TrackbarPosition = GetGadgetAttribute(#TrackbarPicklist, #PB_TrackBar_Maximum)
    ButtonStopPicklistSong()
  EndIf  
EndProcedure

Procedure UpdateCustomTransitionTrackbar()
  Protected.i TrackbarPosition
  
  Static.i StartTime            
  
  If GetGadgetState(#TrackbarCustomTransition) = 0
    StartTime = ElapsedMilliseconds()
    SetGadgetState(#TrackbarCustomTransition, 1)
  Else
    TrackbarPosition = ElapsedMilliseconds() - StartTime 
    SetGadgetState(#TrackbarCustomTransition, TrackbarPosition)
                
    If TrackbarPosition >= GetGadgetAttribute(#TrackbarCustomTransition, #PB_TrackBar_Maximum)
      ButtonStopCustomTransition()
    EndIf    
  EndIf
EndProcedure

Procedure UpdateTrackbarDatabase()  
  Protected.f TrackbarPosition
  
  TrackbarPosition = BASS_ChannelGetPosition(Chan\Database, #BASS_POS_BYTE) 
  SetGadgetState(#TrackbarDatabase, Int(TrackbarPosition))
  If TrackbarPosition = GetGadgetAttribute(#TrackbarDatabase, #PB_TrackBar_Maximum)
    ButtonStopDatabaseSong()
  EndIf    
EndProcedure

Procedure UpdateTrackbarIntroBeatSyncTest()
  Protected.i TrackbarPosition
  
  Static.i StartTime

  If GetGadgetState(#TrackbarIntroBeatSyncTest) = 0
    StartTime = ElapsedMilliseconds()
    SetGadgetState(#TrackbarIntroBeatSyncTest, 1)
  Else
    TrackbarPosition = ElapsedMilliseconds() - StartTime 
    SetGadgetState(#TrackbarIntroBeatSyncTest, TrackbarPosition)
    SetGadgetText(#LabelTestIntroTime, "-" + Seconds2Time((GetGadgetAttribute(#TrackbarIntroBeatSyncTest, #PB_TrackBar_Maximum) - TrackbarPosition) / 1000, #False))
                 
;     If TrackbarPosition = GetGadgetAttribute(#TrackbarIntroBeatSyncTest, #PB_TrackBar_Maximum)
;       ButtonStopIntroBeatSyncTest()
;     EndIf    
  EndIf
EndProcedure

Procedure UpdateTrackbarBreakBeatSyncTest()
  Protected.i TrackbarPosition
  
  Static.i StartTime
  
  If GetGadgetState(#TrackbarBreakBeatSyncTest) = 0
    StartTime = ElapsedMilliseconds()
    SetGadgetState(#TrackbarBreakBeatSyncTest, 1)    
  Else  
    TrackbarPosition = ElapsedMilliseconds() - StartTime 
    SetGadgetState(#TrackbarBreakBeatSyncTest, TrackbarPosition)
    SetGadgetText(#LabelTestBreakTime, "-" + Seconds2Time((GetGadgetAttribute(#TrackbarBreakBeatSyncTest, #PB_TrackBar_Maximum) - TrackbarPosition) / 1000, #False))
  
    If TrackbarPosition = GetGadgetAttribute(#TrackbarBreakBeatSyncTest, #PB_TrackBar_Maximum)
      ButtonStopBreakBeatSyncTest()
    EndIf  
  EndIf
EndProcedure

Procedure UpdateSongInfo(Song.i)
  Protected.i Item, Image, Flag, FlagLabel
  Protected.s Line1, Line2, Line3
  Protected.s FileFullPath = Preferences\PathSleeves + OSPath(Mix(Song)\SleeveFilename)
  Protected.s FileExtension = LCase(GetExtensionPart(FileFullPath))
 
  FlagVisible(Song) = #False  
  SleeveLoaded(Song) = #False
  
  If Mix(Song)\Artist = "" Or Mix(Song)\Title = ""
    Line1 = Mix(Song)\AudioFilename     
  Else      
    Line1 = Mix(Song)\Artist + " - " + Mix(Song)\Title
          
    If Val(Mix(Song)\Year) >= 1950 Or Mix(Song)\Label <> ""
      If Val(Mix(Song)\Year) >= 1950
        Line2 = Mix(Song)\Year
        
        If Mix(Song)\Label <> ""
          Line2 + ", "
        EndIf
      EndIf
        
      If Mix(Song)\Label <> ""
        Line2 + Mix(Song)\Label
        
        If Mix(Song)\CatNo <> ""
          Line2 + " (" + Mix(Song)\CatNo + ")"
        EndIf
      Else
        If Mix(Song)\CatNo <> ""
          Line2 + ", " + Mix(Song)\CatNo
        EndIf          
      EndIf
    EndIf
     
    If Mix(Song)\Country <> ""
      Select LCase(Trim(ReplaceString(Mix(Song)\Country, ".", "")))
        Case "africa"
          FlagLabel = ?africa                 
        Case "australia"
          FlagLabel = ?australia
        Case "austria"
          FlagLabel = ?austria
        Case "belgium"
          FlagLabel = ?belgium
        Case "canada"
          FlagLabel = ?canada
        Case "china"
          FlagLabel = ?china
        Case "croatia"
          FlagLabel = ?croatia
        Case "denmark"
          FlagLabel = ?denmark
        Case "finland"
          FlagLabel = ?finland
        Case "europe", "eu"
          FlagLabel = ?europe
        Case "france"
          FlagLabel = ?france
        Case "germany"
          FlagLabel = ?germany
        Case "great britain", "britain", "uk", "united kingdom", "england"
          FlagLabel = ?greatbritain
        Case "greece"
          FlagLabel = ?greece
        Case "hong kong"
          FlagLabel = ?hongkong
        Case "italy"          
          FlagLabel = ?italy
        Case "japan"
          FlagLabel = ?japan
        Case "mexico"
          FlagLabel = ?mexico
        Case "poland"
          FlagLabel = ?poland
        Case "spain"
           FlagLabel = ?spain
        Case "sweden"
          FlagLabel = ?sweden
        Case "switzerland"
          FlagLabel = ?switzerland
        Case "usa", "us", "united states", "united states of america", "america"
          FlagLabel = ?usa
        Case "netherlands", "the netherlands", "holland"
          FlagLabel = ?netherlands
          FlagVisible(Song) = #True       
      EndSelect
      
      If FlagLabel <> 0
        Flag = CatchImage(#PB_Any, FlagLabel)     
        If IsImage(Flag)
          FlagVisible(Song) = #True        
        EndIf
      EndIf
      
      Line3 + Mix(Song)\Country 
    EndIf
  EndIf  
   
  If Trim(Mix(Song)\SleeveFilename) <> "" And FileSize(FileFullPath) <> -1 
    Select FileExtension 
      Case "bmp"
        Image = LoadImage(#PB_Any, FileFullPath)        
      Case "png"
        Image = LoadImage(#PB_Any, FileFullPath, UsePNGImageDecoder())
      Case "jpg"
        Image = LoadImage(#PB_Any, FileFullPath, UseJPEGImageDecoder())        
    EndSelect
  
    If IsImage(Image)
      SleeveLoaded(Song) = #True
      ResizeImage(Image, 100, 100)
      SetGadgetState(SleeveGadget(Song), ImageID(Image)) 
      HideGadget(SleeveGadget(Song), #False) 
    EndIf
    
    ResizeSongInfo(Song)
  EndIf
  
  SetGadgetText(LabelSongInfo(0, Song), UCase(Line1))
  SetGadgetText(LabelSongInfo(1, Song), UCase(Line2)) 
  SetGadgetText(LabelSongInfo(2, Song), UCase(Line3))    
   
  If FlagVisible(Song)
    If IsImage(Flag)
      If IsGadget(ImageFlag(Song))
        HideGadget(ImageFlag(Song), #False)   
        ResizeImage(Flag, 30, 30)
        SetGadgetState(ImageFlag(Song), ImageID(Flag))        
      EndIf
    Else 
      FlagVisible(Song) = #False
      If IsGadget(ImageFlag(Song))
        HideGadget(ImageFlag(Song), #True)         
      EndIf
    EndIf
  Else
    If IsGadget(ImageFlag(Song))
      HideGadget(ImageFlag(Song), #True)  
    EndIf
  EndIf
  
  If Song <> NextSong
    SelectRow(#ListiconPlaylist, Mix(Song)\Number - 1) 
  EndIf
  
  ResizeSongInfo(Song.i) 
  
  SetGadgetAttribute(#ScrollAreaSongInfo, #PB_ScrollArea_Y, 0)               
EndProcedure

Procedure UpdateSpectrum()
  Protected _fft._fft
  Protected.l b0, b1, _lines = 16
  Protected.f peak, mm, ys
  Protected.i wx, b
  Protected.i ww = GadgetWidth(#CanvasSpectrum)
  Protected.i wh = GadgetHeight(#CanvasSpectrum)
  Protected.i bw = ww / _lines
  Protected.i half_wh = wh / 2

  If BASS_ChannelGetData(Chan\Mixer, @_fft, #BASS_DATA_FFT2048) = -1
    ProcedureReturn
  EndIf

  StartDrawing(CanvasOutput(#CanvasSpectrum))

  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    Box(0, 0, ww, wh, SystemBackgroundColor)
  CompilerElse
    If Preferences\WindowsTheme = "Fancy dark"
      Box(0, 0, ww, wh, RGB(36,36,36))
    Else
      Box(0, 0, ww, wh, SystemBackgroundColor)
    EndIf
  CompilerEndIf

  DrawingMode(#PB_2DDrawing_Gradient)
  BackColor(RGB(26,132,184))
  FrontColor(#White)
  LinearGradient(0, 0, ww, half_wh)

  b0 = 0
  For wx = 0 To _lines - 1
    peak = 0
    b1 = Pow(2, wx * 10.0 / (_lines - 1))
    If b1 > 1023
      b1 = 1023
    EndIf
    If b1 <= b0
      b1 = b0 + 1
    EndIf

    For b = b0 To b1 - 1
      mm = _fft\_fft[b + 1]
      If mm > peak
        peak = mm
      EndIf
    Next

    ys = Sqr(peak) * 5 * half_wh - 4
    If ys > half_wh
      ys = half_wh
    ElseIf ys < 0
      ys = 0
    EndIf

    Box(bw * wx + 3, half_wh - ys, bw - 2, ys)
    b0 = b1
  Next

  ;mirror
  DrawingMode(#PB_2DDrawing_Gradient)
  BackColor(RGB(76, 172, 214))
  FrontColor(RGB(36, 36, 36))
  LinearGradient(0, half_wh, ww, wh)

  b0 = 0
  For wx = 0 To _lines - 1
    peak = 0
    b1 = Pow(2, wx * 10.0 / (_lines - 1))
    If b1 > 1023
      b1 = 1023
    EndIf
    If b1 <= b0
      b1 = b0 + 1
    EndIf

    For b = b0 To b1 - 1
      mm = _fft\_fft[b + 1]
      If mm > peak
        peak = mm
      EndIf
    Next

    ys = Sqr(peak) * 2 * half_wh - 3
    If ys > half_wh
      ys = half_wh
    ElseIf ys < 0
      ys = 0
    EndIf

    Box(bw * wx + 3, half_wh, bw - 2, ys)
    b0 = b1
  Next

  StopDrawing()
EndProcedure

Procedure UpdateTimeLabels()
  Protected.q BytePos = BASS_ChannelGetPosition(Mix(CurrentSong)\Channel, #BASS_POS_BYTE)
  Protected.f CurrentTime = BASS_ChannelBytes2Seconds(Mix(CurrentSong)\Channel, BytePos) 
  Protected.i MaxTransition = GetGadgetAttribute(#TrackbarTransition, #PB_TrackBar_Maximum) / 1000  
  Protected.i Max = GetGadgetAttribute(#Trackbar, #PB_TrackBar_Maximum) / 1000
  Protected.i RemainingTime
  
  If Mix(CurrentSong)\Shorten And Mix(CurrentSong)\SkipStart > 0 And Mix(CurrentSong)\SkipEnd > 0 And CurrentTime > Mix(CurrentSong)\SkipEnd
    CurrentTime - (Mix(CurrentSong)\SkipEnd - Mix(CurrentSong)\SkipStart)
  EndIf
        
  If Mix(CurrentSong)\Number > 1
    CurrentTime - Mix(CurrentSong)\IntroEnd 
  EndIf
  
  If Mix(CurrentSong)\Mixing Or Mix(CurrentSong)\Fading
     RemainingTime = MaxTransition - (GetGadgetState(#TrackbarTransition) / 1000)
  Else    
    If CurrentTime <= 0.01
      SetGadgetText(#LabelMix, "")      
    EndIf

    SetGadgetText(#LabelTime, Seconds2Time(CurrentTime * (Mix(CurrentSong)\Samplerate / Mix(CurrentSong)\OrigFreq), #False))
    RemainingTime = Max - (GetGadgetState(#Trackbar) / 1000) 
  EndIf

  SetGadgetText(#LabelRemainingTime, "-" + Seconds2Time(RemainingTime , #False))
EndProcedure

Procedure CustomButton(Gadget.i, X.i, Y.i, Width.i, Height.i, *ImageBlack, *ImageWhite = 0, Tooltip.s = "", ButtonWidth.i = 0, ButtonHeight.i = 0)
  Protected.i Image
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    If LightMode()
      Image = CatchImage(#PB_Any, *ImageWhite) 
    Else
      Image = CatchImage(#PB_Any, *ImageBlack)  
    EndIf
  CompilerElse
    If Preferences\WindowsTheme = "Fancy dark" 
      Image = CatchImage(#PB_Any, *ImageWhite) 
    Else
      Image = CatchImage(#PB_Any, *ImageBlack) 
    EndIf      
  CompilerEndIf
  
  ResizeImage(Image, Width, Height)
  
  If ButtonWidth = 0
    ImageGadget(Gadget, X, Y, Width, Height, ImageID(Image)) 
  Else
    ButtonImageGadget(Gadget, X, Y, ButtonWidth, ButtonHeight, ImageID(Image)) 
  EndIf
  GadgetToolTip(Gadget, Tooltip)  
EndProcedure
 
Procedure LoadPreferences() 
  If OpenPreferences(OSPath("assets/data/mixperfect.ini"))
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      PreferenceGroup("Session Linux")
    CompilerElse
      PreferenceGroup("Session Windows")
    CompilerEndIf      
    
    PreferenceGroup("Session")       
    Preferences\PlaylistString = ReadPreferenceString("IDs", "")
    Preferences\PlaylistPosition = ReadPreferenceLong("Playlist_position", 0)
    
    If GetDefaultSetting("Maximum_playback_time") = "Infinite"
      Preferences\PlaylistType = ReadPreferenceString("Type", "Random")    
    Else
      Preferences\PlaylistType = ReadPreferenceString("Type", "Custom")    
    EndIf      
     
    CompilerIf #PB_Compiler_OS = #PB_OS_Linux
      PreferenceGroup("Directories Linux")
    CompilerElse
      PreferenceGroup("Directories Windows")
    CompilerEndIf      
    
    Preferences\PathAudio = OSPath(AbsoluteDir(ReadPreferenceString("Path_audiofiles", GetDefaultSetting("Path audiofiles"))))  
    Preferences\PathSleeves = OSPath(AbsoluteDir(ReadPreferenceString("Path_sleevesfiles", GetDefaultSetting("Path sleevesfiles"))))
    
    PreferenceGroup("GUI Theme")
    Preferences\WindowsTheme = ReadPreferenceString("Color", GetDefaultSetting("Color"))      
     
    PreferenceGroup("Song length")     
    Preferences\ShortenSongs = ReadPreferenceString("Shorten_songs", GetDefaultSetting("Shorten songs"))  
    
    PreferenceGroup("Playlist length")         
    Preferences\MinimumNumberOfSongs = ReadPreferenceString("Minimum_number_of_songs", GetDefaultSetting("Minimum number of songs"))      
    Preferences\MaximumNumberOfSongs = ReadPreferenceString("Maximum_number_of_songs", GetDefaultSetting("Maximum number of songs"))       
    Preferences\MinimumPlaybackTime = ReadPreferenceString("Minimum_playback_time", GetDefaultSetting("Minimum playback time"))      
    Preferences\MaximumPlaybackTime = ReadPreferenceString("Maximum_playback_time", GetDefaultSetting("Maximum playback time"))       
    
    PreferenceGroup("Speed")         
    Preferences\MaximumBPMDistance = ReadPreferenceFloat("Maximum_BPM_distance", ValF(GetDefaultSetting("Maximum BPM distance")))   
    Preferences\BPMOrderOfSongs = ReadPreferenceString("BPM_order_of_songs", GetDefaultSetting("BPM order of songs"))       
    Preferences\BPMOfFirstSong = ReadPreferenceString("BPM_of_first_song", GetDefaultSetting("BPM of first song"))
    Preferences\PitchRange = ReadPreferenceFloat("Pitch_reset", ValF(GetDefaultSetting("Pitch reset")))    
    
    PreferenceGroup("Repeating")             
    Preferences\UniqueSongsBeforeRepeating = ReadPreferenceLong("Unique_songs_before_repeating", Val(GetDefaultSetting("Unique songs before repeating")))    
    
    PreferenceGroup("Filter")     
    Preferences\Genres = ReadPreferenceString("Genres", GetDefaultSetting("Genres")) 
    Preferences\Artists = ReadPreferenceString("Artists", GetDefaultSetting("Artists")) 
    Preferences\Countries = ReadPreferenceString("Countries", GetDefaultSetting("Countries")) 
    Preferences\RecordLabels = ReadPreferenceString("Record_labels", GetDefaultSetting("Record labels")) 
    Preferences\Years = ReadPreferenceString("Years", GetDefaultSetting("Years"))   
    Preferences\EvolutionMode = ReadPreferenceString("Evolution_mode", GetDefaultSetting("Evolution Mode"))          
    
    PreferenceGroup("Transitions")      
    Preferences\KeepBeatsGoing = ReadPreferenceString("Keep_beats_going", GetDefaultSetting("Keep beats going"))       
    Preferences\FilterOverlappedBeats = ReadPreferenceString("Filter_overlapped_beats", GetDefaultSetting("Filter overlapped beats"))   
    Preferences\CombineBasses = ReadPreferenceString("Combine_basses", GetDefaultSetting("Combine basses"))
    Preferences\CombineVocals = ReadPreferenceString("Combine_vocals", GetDefaultSetting("Combine vocals"))
    Preferences\CombineMelodies = ReadPreferenceString("Combine_melodies", GetDefaultSetting("Combine melodies"))
    Preferences\CombineBeats = ReadPreferenceString("Combine_beats", GetDefaultSetting("Combine beats"))    
    Preferences\IgnoreCombine = ReadPreferenceString("Always_combine_if_no_matches_left", GetDefaultSetting("Always combine if no matches left"))  
     
    ClosePreferences()
  Else
    If GetDefaultSetting("Maximum_playback_time") = "Infinite"
      Preferences\PlaylistType = "Random"    
    Else
      Preferences\PlaylistType = "Custom"
    EndIf      
    
    Preferences\WindowsTheme = GetDefaultSetting("Color")
    Preferences\PlaylistString = ""
    Preferences\PathAudio = OSPath(GetDefaultSetting("Path audiofiles"))
    Preferences\PathSleeves = OSPath(GetDefaultSetting("Path sleevesfiles"))    
    Preferences\ShortenSongs = GetDefaultSetting("Shorten songs")    
    Preferences\MinimumNumberOfSongs = GetDefaultSetting("Minimum number of songs")
    Preferences\MaximumNumberOfSongs = GetDefaultSetting("Maximum number of songs")
    Preferences\MinimumPlaybackTime = GetDefaultSetting("Minimum playback time")
    Preferences\MaximumPlaybackTime = GetDefaultSetting("Maximum playback time")
    Preferences\MaximumBPMDistance = ValF(GetDefaultSetting("Maximum BPM distance"))
    Preferences\BPMOrderOfSongs = GetDefaultSetting("BPM order of songs")
    Preferences\UniqueSongsBeforeRepeating = Val(GetDefaultSetting("Unique songs before repeating"))
    Preferences\BPMOfFirstSong = GetDefaultSetting("BPM of first song")
    Preferences\PitchRange = ValF(GetDefaultSetting("Pitch reset"))    
    Preferences\Genres = ""
    Preferences\Artists = ""
    Preferences\Countries = ""
    Preferences\RecordLabels = ""
    Preferences\Years = ""  
    Preferences\KeepBeatsGoing = GetDefaultSetting("Keep beats going")
    Preferences\CombineBasses = GetDefaultSetting("Combine basses")
    Preferences\CombineVocals = GetDefaultSetting("Combine vocals")
    Preferences\CombineMelodies = GetDefaultSetting("Combine melodies")
    Preferences\CombineBeats = GetDefaultSetting("Combine beats")    
    Preferences\IgnoreCombine = GetDefaultSetting("Always combine if no matches left")
    Preferences\FilterOverlappedBeats = GetDefaultSetting("Filter overlapped beats")
    Preferences\EvolutionMode = GetDefaultSetting("Evolution mode")    
  EndIf  
 
  If Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random" And Preferences\PlaylistPosition = CountString(Preferences\PlaylistString, ",") / 2
    Preferences\PlaylistPosition = 0
  EndIf  
EndProcedure  
 
Procedure.b FillLinkedListSongs(PlaylistString.s, PreviousSession = #False)  
  Protected.f Marge = 0.025
  Protected.f Playlength, MinBPM, MaxBPM, PlaybackBPM, Pitch, LastPlaybackBPM 
  Protected.s LastPitch, SongFullPath, ID, FileFullPath, DurationString
  Protected.s PlaylistIDs = StringField(PlaylistString, 1, "|")
  Protected.s PlaylistDurations = StringField(PlaylistString, 2, "|")
  Protected.s IntroBeatListFromDB, BreakBeatListFromDB
  Protected.i LastSamplerate, PlaybackSamplerate, PrevSamplerate
  Protected.i Song, LastSong = CountString(PlaylistIDs, ",") + 1
  Protected.b ResetPitch, Refresh, NoMatch
  
  If Not RefreshPlaylist
    BASS_Mixer_ChannelRemove(Mix(CurrentSong)\Channel) 
    BASS_Mixer_ChannelRemove(Mix(NextSong)\Channel)    
  Else
    Refresh = #True
    LastPlaybackBPM = Songs()\PlaybackBPM
    LastPitch = Songs()\Pitch
    LastSamplerate = Songs()\Samplerate
  EndIf
 
  ;Remove items from Songs()  
  ClearList(Songs())    

  ;Add database records to linked list Songs()         
  While Song < LastSong    
    NoMatch = #False
    
    Song + 1       
    ResetPitch = #False
    
    ID = StringField(PlaylistIDs, Song, ",")
    If FindString(ID, "R")
      ID = RemoveString(ID, "R")
      ResetPitch = #True
    EndIf
    
    If FindString(ID, "!")
      ID = RemoveString(ID, "!")
      NoMatch = #True
    EndIf
      
    DatabaseQuery(#DBMusic, "SELECT id, artist, title, year, label, catno, country, genre, bpm, " + 
                             "introprefix, introstart, introend, introloopstart, introloopend, introlooprepeat, " + 
                             "breakstart, breakend, breakcontinue, breakloopstart, breakloopend, breaklooprepeat, " +
                             "skipstart, skipend, filename, sleeve, breakmute, introbeats, breakbeats, " +
                             "introfade, breakfade, introbeatlist, breakbeatlist, samplerate FROM music " + 
                             "WHERE id='" + ID + "' LIMIT 1") 
  
    NextDatabaseRow(#DBMusic) 

    If GetDatabaseString(#DBMusic, 0) = ""      
      Break
    EndIf 
 
    AddElement(Songs())
    
    Songs()\PreviousSamplerate = PrevSamplerate  
    Songs()\Number = Song
    Songs()\ID = GetDatabaseString(#DBMusic, 0)    
    Songs()\BPM = GetDatabaseFloat(#DBMusic, 8)
    Songs()\IntroPrefix = Time2Seconds(GetDatabaseString(#DBMusic, 9))
    Songs()\IntroStart = Time2Seconds(GetDatabaseString(#DBMusic, 10))
    Songs()\IntroEnd = Time2Seconds(GetDatabaseString(#DBMusic, 11))
    Songs()\IntroLoopStart = Time2Seconds(GetDatabaseString(#DBMusic, 12))
    Songs()\IntroLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 13))
    Songs()\IntroLoopRepeat = GetDatabaseLong(#DBMusic, 14)          
    Songs()\BreakStart = Time2Seconds(GetDatabaseString(#DBMusic, 15))
    Songs()\BreakEnd = Time2Seconds(GetDatabaseString(#DBMusic, 16))        
    Songs()\BreakContinue = Time2Seconds(GetDatabaseString(#DBMusic, 17)) 
    Songs()\BreakLoopstart = Time2Seconds(GetDatabaseString(#DBMusic, 18))
    Songs()\BreakLoopEnd = Time2Seconds(GetDatabaseString(#DBMusic, 19))    
    Songs()\BreakLoopRepeat = GetDatabaseLong(#DBMusic, 20)
    Songs()\SkipStart = Time2Seconds(GetDatabaseString(#DBMusic, 21))   
    Songs()\SkipEnd = Time2Seconds(GetDatabaseString(#DBMusic, 22))   
    Songs()\AudioFilename = OSPath(GetDatabaseString(#DBMusic, 23))  
    Songs()\SleeveFilename = OSPath(GetDatabaseString(#DBMusic, 24)) 
    Songs()\BreakMute = Time2Seconds(GetDatabaseString(#DBMusic, 25))
    Songs()\IntroBeats = GetDatabaseLong(#DBMusic, 26)     
    Songs()\BreakBeats = GetDatabaseLong(#DBMusic, 27)         
    Songs()\IntroFade = GetDatabaseLong(#DBMusic, 28)     
    Songs()\BreakFade = GetDatabaseLong(#DBMusic, 29)  
    Songs()\IntroBeatList = GenerateBeatList(GetDatabaseString(#DBMusic, 30), Songs()\IntroStart, Songs()\IntroEnd, #False, Songs()\IntroLoopStart, Songs()\IntroLoopEnd, Songs()\IntroLoopRepeat)
    Songs()\BreakBeatList = GenerateBeatList(GetDatabaseString(#DBMusic, 31), Songs()\BreakStart, Songs()\BreakEnd, #False, Songs()\BreakLoopStart, Songs()\BreakLoopEnd, Songs()\BreakLoopRepeat) 
    Songs()\NoMatch = NoMatch
    Songs()\OrigFreq = GetDatabaseLong(#DBMusic, 32)  
    
    If Songs()\IntroStart - Songs()\IntroPrefix < 0
      Songs()\IntroPrefix = 0
    EndIf
    
    IntroBeatListFromDB = GetDatabaseString(#DBMusic, 30)
    BreakBeatListFromDB = GetDatabaseString(#DBMusic, 31)   
    
    IntroBeatListFromDB = ReplaceString(IntroBeatListFromDB, Chr(13), Chr(10))
    IntroBeatListFromDB = ReplaceString(IntroBeatListFromDB, "\r", Chr(10))
    IntroBeatListFromDB = ReplaceString(IntroBeatListFromDB, "\n", Chr(10))
    
    BreakBeatListFromDB = ReplaceString(BreakBeatListFromDB, Chr(13), Chr(10))
    BreakBeatListFromDB = ReplaceString(BreakBeatListFromDB, "\r", Chr(10))
    BreakBeatListFromDB = ReplaceString(BreakBeatListFromDB, "\n", Chr(10))    
    
    Songs()\IntroBeatListFromDB = IntroBeatListFromDB 
    Songs()\BreakBeatListFromDB = BreakBeatListFromDB    
    
    FileFullPath = Preferences\PathAudio + OSPath(Songs()\AudioFilename)  
    
    If Songs()\IntroPrefix > 0 And Songs()\IntroPrefix < Marge 
      Songs()\IntroPrefix = Marge
    EndIf
    
    If Songs()\IntroLoopStart > 0 And Songs()\IntroLoopEnd > 0 
      If Abs(Songs()\IntroLoopStart - Songs()\IntroStart) < Marge
        Songs()\IntroStart = Songs()\IntroLoopStart - Marge
      EndIf
    
      If Abs(Songs()\IntroEnd - Songs()\IntroLoopEnd) < Marge
        Songs()\IntroEnd = Songs()\IntroLoopEnd + Marge
      EndIf    
    EndIf      
    
    If Songs()\BreakContinue > 0 And Songs()\BreakContinue < Marge
      Songs()\BreakContinue = Marge
    EndIf
    
    If Songs()\BreakLoopStart > 0 And Songs()\BreakLoopEnd > 0
      If Abs(Songs()\BreakLoopStart - Songs()\BreakStart) < Marge
        Songs()\BreakStart = Songs()\BreakLoopStart - Marge
      EndIf
        
      If Abs(Songs()\BreakEnd - Songs()\BreakLoopEnd) < Marge
        Songs()\BreakEnd = Songs()\BreakLoopEnd + Marge
      EndIf     
    EndIf
    
    If Songs()\SkipStart > 0 And Songs()\SkipEnd > 0
      If Abs(Songs()\SkipStart - Songs()\IntroEnd) <  Marge
        Songs()\SkipStart = Songs()\IntroEnd + Marge  
      EndIf
      
      If Abs(Songs()\BreakStart - Songs()\SkipEnd) < Marge
        Songs()\SkipEnd = Songs()\BreakStart - Marge
      EndIf        
    EndIf
    
    Songs()\Artist = GetDatabaseString(#DBMusic, 1)
    Songs()\Title = GetDatabaseString(#DBMusic, 2)
    Songs()\Year = GetDatabaseString(#DBMusic, 3)
    Songs()\Label = GetDatabaseString(#DBMusic, 4)
    Songs()\Catno = GetDatabaseString(#DBMusic, 5)
    Songs()\Country = GetDatabaseString(#DBMusic, 6)    
 
    DurationString = StringField(PlaylistDurations, Song, ",")
  
    If Right(DurationString, 1) = "S"
      Songs()\Shorten = #True
    EndIf

    ;Calculate samplerates   
    If Not Refresh And (Song = 1 Or ResetPitch)
      ;set song to original speed
      PlaybackSamplerate = Songs()\OrigFreq
      PlaybackBPM = Songs()\BPM
      Songs()\Pitch = "  0.00%" 
    Else     
      If Refresh
        PlaybackSamplerate = LastSamplerate 
        PlaybackBPM = LastPlaybackBPM
        Songs()\Pitch = LastPitch
      Else 
        PlaybackSamplerate = Songs()\OrigFreq * (PlaybackBPM / Songs()\BPM)
 
        ;Calculate the pitch change 
        Pitch = Abs(100 * ((PlaybackBPM / Songs()\BPM) - 1))  
 
        If Songs()\BPM > PlaybackBPM
          Songs()\Pitch = " -" + FormatNumber(Pitch) + "%"                
        Else 
          Songs()\Pitch = "+" + FormatNumber(Pitch) + "%"  
        EndIf           
      EndIf
    EndIf   
    
    Refresh = #False
      
    Songs()\PlaybackBPM = PlaybackBPM 
    Songs()\Samplerate = PlaybackSamplerate 
    Songs()\Playtime = ValF(RTrim(DurationString, "S"))

    PrevSamplerate = PlaybackSamplerate
  Wend     
 
  If ListSize(Songs()) = 0
    ProcedureReturn #False
  EndIf
 
  ProcedureReturn #True  
EndProcedure
 
Procedure.b FillListiconPlaylist(PlaylistString.s, PreviousSession.b = #False)
  Protected.i ImageLoaded, ImageID
  Protected.s Columns, SongInfo, Signs
  Protected.f IncreasingTime, FreqRate, ConvertedPlaytime   
  
  If PlaylistString = "" Or Not FillLinkedListSongs(PlaylistString, PreviousSession)
    ProcedureReturn   
  EndIf

  ;Preferences are already loaded if the playlist is from a previous session
  If Not PreviousSession And Not RefreshPlaylist
    LoadPreferences()
    Preferences\PlaylistPosition =  0 
  EndIf
  
  If Preferences\PlaylistPosition = -1 Or RefreshPlaylist
    Preferences\PlaylistPosition = 0
  EndIf
 
  ;Clear the Listicon
  ClearGadgetItems(#ListiconPlaylist)    
 
  ;Add Songs() to Listicon gadget
  ForEach Songs()
    If Songs()\Artist = "" Or Songs()\Title = ""
      SongInfo = Songs()\AudioFilename
    Else
      SongInfo = UCase(Songs()\Artist + " - " + Songs()\Title)
    EndIf
  
    ConvertedPlaytime = Songs()\Playtime * (Songs()\OrigFreq / Songs()\Samplerate)
    IncreasingTime + ConvertedPlaytime
  
    Signs = ""
    If Songs()\NoMatch
      Signs + " !"
    EndIf
    
    Columns = RSet(Str(Songs()\Number), 3, "0") + Signs + Chr(10) +
              SongInfo + Chr(10) +
              Seconds2Time(ConvertedPlaytime, #False) + Chr(10) +
              Seconds2LongTime(IncreasingTime) + Chr(10) +
              RSet(FormatNumber(Songs()\BPM), 6, "0") + Chr(10) +
              RSet(FormatNumber(Songs()\PlaybackBPM), 6, "0") + Chr(10) +
              Songs()\Pitch
  
    AddGadgetItem(#ListiconPlaylist, -1, Columns)
  Next
  
  If Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random"
    SetGadgetItemColor(#ListiconPlaylist, CountGadgetItems(#ListiconPlaylist) - 1, #PB_Gadget_FrontColor, #Gray)
   Else
    SetGadgetItemColor(#ListiconPlaylist, CountGadgetItems(#ListiconPlaylist) - 1, #PB_Gadget_FrontColor, GetGadgetItemColor(#ListiconPlaylist, #PB_Gadget_FrontColor, 0))          
  EndIf  
  
  ;Update trackbar and songinfo labels
  FirstElement(Songs())
  CopySong(CurrentSong)  
  SetTrackBarMaximum()  
  
  If Not RefreshPlaylist
    UpdateSongInfo(CurrentSong)  
    
    ButtonStop(#PB_EventType_LeftClick)  
    BASS_ChannelSetPosition(Chan\Mixer, 0, #BASS_POS_BYTE)   
    
    SelectRow(#ListiconPlaylist, Preferences\PlaylistPosition)  
    ListiconPlaylist(#PB_EventType_Change)       
  EndIf  
  
  ProcedureReturn #True
EndProcedure

Procedure FillListiconPicklist(ListIcon.i = #ListiconPicklist, ListLoadedFromFile.b = #False)
  Protected.i TracklistItems = CountGadgetItems(#ListiconCustomPlaylist)  
  Protected.i Row, Words, Word, Records
  Protected.f OriginalBPM, PlaybackBPM
  Protected.f DBLowestBPM = DBLowestBPM(), DBHighestBPM = DBHighestBPM()    
  Protected.s Where, nQuery, Query, OrderQuery, SearchQuery, PreviousIDsQuery, CombineQuery, SongInfo, WordString 
  Protected.s SearchString = Trim(GetGadgetText(#StringSearchPicklist))
  
  Static.f LowestBPM, HighestBPM

  If SearchString = ""
    ListIcon = #ListiconPicklist
    HideGadget(#ListiconPicklistSearch, #True)
    HideGadget(#ListiconPicklist, #False)   
    Visible\ListiconPicklistSearch = #False
  Else
    ListIcon = #ListiconPicklistSearch
    HideGadget(#ListiconPicklistSearch, #False)
    HideGadget(#ListiconPicklist, #True)   
    Visible\ListiconPicklistSearch = #True  
  EndIf
 
  If TracklistItems > 0
    DatabaseQuery(#DBMusic, "SELECT breakbass, breakvocal, breakmelody, breakbeats FROM music WHERE id='" + GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 7) +  "' LIMIT 1")    
    NextDatabaseRow(#DBMusic)    

    If Preferences\CombineBasses = "No" And GetDatabaseLong(#DBMusic, 0) = 1
      CombineQuery + " AND introbass=0" 
    EndIf
    
    If Preferences\CombineVocals = "No" And GetDatabaseLong(#DBMusic, 1) = 1
      CombineQuery + " AND introvocal=0" 
    EndIf
    
    If Preferences\CombineMelodies = "No" And GetDatabaseLong(#DBMusic, 2) = 1
      CombineQuery + " AND intromelody=0" 
    EndIf
    
    If Preferences\CombineBeats = "No" And GetDatabaseLong(#DBMusic, 3) = 1
      CombineQuery + " AND introbeats=0" 
    EndIf
    
    If Preferences\KeepBeatsGoing = "Yes" And GetDatabaseLong(#DBMusic, 3) = 0
      CombineQuery + " AND introbeats=1" 
    EndIf    

    FinishDatabaseQuery(#DBMusic)    
  EndIf
  
  Select GetGadgetText(#ComboboxSortPicklist)
    Case "Country"
      OrderQuery = "country, artist, title"
    Case "Year"
      OrderQuery = "year, artist, title"      
    Case "Label"
      OrderQuery = "label, catno, artist, title"      
    Case "BPM"
      OrderQuery = "bpm, artist, title"
    Default:
      OrderQuery = "artist, title"     
  EndSelect  
  
  If SearchString <> "Search..." And SearchString <> ""
    ;Escape single quotes
    SearchString = ReplaceString(SearchString, "'", "''")
    
    ;remove non-search character
    SearchString = ReplaceString(SearchString, "-", "")     
    
    ;Split string in words
    Words = CountString(SearchString, " ") + 1    
    
    For Word = 1 To Words
      WordString = StringField(SearchString, Word, " ")      
      SearchQuery + "(artist LIKE '%" + WordString + "%' " +
                    "OR title LIKE '%" + WordString + "%' " +
                    "OR year LIKE '%" + WordString + "%' " +
                    "OR (bpm LIKE '%" + WordString + "%') " +
                    "OR country LIKE '%" + WordString + "%' " +
                    "OR genre LIKE '%" + WordString + "%' " +                                        
                    "OR label LIKE '%" + WordString + "%' " +
                    "OR catno LIKE '%" + WordString + "%')"
      If Word < Words
        SearchQuery + " AND "
      EndIf
    Next
  EndIf 
  
  If TracklistItems = 0 
    If Preferences\BPMOfFirstSong <> "Random"
      LowestBPM = ValF(Preferences\BPMOfFirstSong) 
      HighestBPM = ValF(Preferences\BPMOfFirstSong) + 0.99
    Else
      LowestBPM = DBLowestBPM
      HighestBPM = DBHighestBPM
    EndIf    
  Else
    ;Reset the pitch if playback BPM is close to original BPM
    OriginalBPM = ValF(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 4))    
    PlaybackBPM = ValF(GetGadgetItemText(#ListiconCustomPlaylist, TracklistItems - 1, 5))  
    
    If ListLoadedFromFile
      LowestBPM = OriginalBPM - Preferences\MaximumBPMdistance
      HighestBPM = OriginalBPM + Preferences\MaximumBPMdistance        
    EndIf
    
    If Abs(OriginalBPM - PlaybackBPM) <= Preferences\PitchRange      
      PlaybackBPM = OriginalBPM 
      Select Preferences\BPMOrderOfSongs 
        Case "Random"
          LowestBPM = OriginalBPM - Preferences\MaximumBPMdistance
          HighestBPM = OriginalBPM + Preferences\MaximumBPMdistance         
        Case "Ascending"
          LowestBPM = OriginalBPM 
          HighestBPM = OriginalBPM + Preferences\MaximumBPMdistance              
        Case "Descending" 
          LowestBPM = OriginalBPM - Preferences\MaximumBPMdistance
          HighestBPM = OriginalBPM  
      EndSelect
    EndIf 
 
    If HighestBPM > DBHighestBPM
      HighestBPM = DBHighestBPM
    EndIf
    
    If LowestBPM < DBLowestBPM
      LowestBPM = DBLowestBPM
    EndIf     
  EndIf 
  
  Query = GenerateFilterQuery() 
  If Query <> ""
    Query + " AND "
  EndIf
  Query + " (bpm BETWEEN " + StrF(LowestBPM) + " AND " + StrF(HighestBPM) + ") " 
 
  If SearchQuery <> ""
    SearchQuery = " AND " + SearchQuery
  EndIf  

  If CustomPlaylistPreviousIDs <> ""
    PreviousIDsQuery = " (id NOT IN (" + LTrim(CustomPlaylistPreviousIDs, ",") + "))" 
  EndIf
   
  If Query <> "" Or SearchQuery <> "" Or PreviousIDsQuery <> ""
    Where = " WHERE"
  EndIf
  
  If PreviousIDsQuery <> "" And (Query <> "" Or SearchQuery <> "") 
    PreviousIDsQuery = " AND " + PreviousIDsQuery 
  EndIf
  
  If PreviousIDsQuery + SearchQuery + Query = "" And CombineQuery <> ""
    ;Remove AND from begin of string
    CombineQuery = Mid(CombineQuery, 5)
  EndIf
  
  If Where = " WHERE"
    nQuery = Trim(Query + " " + SearchQuery + " " + PreviousIDsQuery + CombineQuery)
  
    ;clean up query (make it valid)
    If nQuery <> "" And Right(nQuery, 4) = " AND"
      nQuery = Left(nQuery, Len(nQuery) - 4)
    EndIf
 
    While FindString(nQuery, "  ")
      nQuery = ReplaceString(nQuery, "  ", " ")
      While FindString(nQuery, "AND AND")
        nQuery = ReplaceString(nQuery, "AND AND", "AND ")
      Wend   
    Wend 
  EndIf
  
  If Left(nQuery, 3) = "AND"
    nQuery = Mid(nQuery, 4)
  EndIf   
      
  ;Select songs from the database with subsequent BPM's and fill the picklist
  DatabaseQuery(#DBMusic, "SELECT id, bpm, filename, introend, " + 
                          "breakstart, breakend, breakloopstart, breakloopend, breaklooprepeat, " + 
                          "skipstart, skipend, artist, title, year, label, catno, country FROM music" + 
                          Where + " " + nQuery + " ORDER BY " + OrderQuery)   

  ButtonStopPicklistSong()    
  ClearGadgetItems(ListIcon)
  While NextDatabaseRow(#DBMusic)      
    Records + 1
    
    If GetDatabaseString(#DBMusic, 11) = "" Or GetDatabaseString(#DBMusic, 12) = ""
      SongInfo = OSPath(GetDatabaseString(#DBMusic, 2))
    Else
      SongInfo = GetDatabaseString(#DBMusic, 11) + " - " + GetDatabaseString(#DBMusic, 12)
             
      If GetDatabaseLong(#DBMusic, 13) >= 1950 Or GetDatabaseString(#DBMusic, 14) <> ""
        If GetDatabaseLong(#DBMusic, 13) >= 1950
          SongInfo + ", " + Str(GetDatabaseLong(#DBMusic, 13))
          
          If Trim(GetDatabaseString(#DBMusic, 14)) <> ""
            SongInfo + ", "
          EndIf
        EndIf
          
        If Trim(GetDatabaseString(#DBMusic, 14)) <> ""
          SongInfo + GetDatabaseString(#DBMusic, 14)
          
          If Trim(GetDatabaseString(#DBMusic, 15)) <> ""
            SongInfo + " (" + GetDatabaseString(#DBMusic, 15) + ")"
          EndIf
        Else
          If Trim(GetDatabaseString(#DBMusic, 15)) <> ""
            SongInfo + " (" + GetDatabaseString(#DBMusic, 15) + ")"
          EndIf         
        EndIf
      EndIf
  
      If Trim(GetDatabaseString(#DBMusic, 16)) <> ""
        SongInfo + ", " + GetDatabaseString(#DBMusic, 16)
      EndIf
      
      SongInfo = UCase(SongInfo)
    EndIf    
  
    AddGadgetItem(ListIcon, Records - 1, RSet(FormatNumber(GetDatabaseFloat(#DBMusic, 1)), 6, "0") + Chr(10) +
                                SongInfo + Chr(10) +
                                GetDatabaseString(#DBMusic, 0))    
    

  Wend  
  FinishDatabaseQuery(#DBMusic)    
  
  SelectRow(ListIcon, Row)  
  SetGadgetText(#FramePicklist, "Picklist (" + Str(Records) + " matches)")
  
  If ListIcon = #ListiconPicklistSearch
    HideGadget(#ListIconPicklistSearch, #False)    
    Visible\ListiconPicklistSearch = #True      
  EndIf  
EndProcedure

Procedure FillListiconDatabase(ListIcon = #ListiconDatabase)
  Protected.s SearchString = Trim(GetGadgetText(#StringSearchDatabase))
  Protected.s OrderQuery, WordString, SearchQuery, Song
  Protected.i Word, Words, Records, Row 

  OrderQuery = LCase(ReplaceString(GetGadgetText(#ComboboxSortDatabase), ".", ""))
 
  If OrderQuery <> "sort"
    OrderQuery = " ORDER BY " + OrderQuery
  Else 
    OrderQuery = ""
  EndIf
  
  If SearchString <> "Search..." And SearchString <> ""    
    ;Escape single quotes
    SearchString = ReplaceString(SearchString, "'", "''")
    
    ;remove non-search character
    SearchString = ReplaceString(SearchString, "-", "")     
    
    ;Split string in words
    Words = CountString(SearchString, " ") + 1    
    
    For Word = 1 To Words
      WordString = StringField(SearchString, Word, " ")      
      SearchQuery + "(artist LIKE '%" + WordString + "%' " +
                    "OR title LIKE '%" + WordString + "%' " +
                    "OR label LIKE '%" + WordString + "%' " +
                    "OR catno LIKE '%" + WordString + "%' " +
                    "OR year LIKE '%" + WordString + "%' " +
                    "OR country LIKE '%" + WordString + "%' " +
                    "OR genre LIKE '%" + WordString + "%' " +                                        
                    "OR bpm LIKE '%" + WordString + "%')"
      If Word < Words
        SearchQuery + " AND "
      EndIf
    Next
    SearchQuery = " WHERE " + SearchQuery
  EndIf
 
  ClearGadgetItems(ListIcon)
  
  DatabaseQuery(#DBMusic, "SELECT id, artist, title, label, catno, country, year, genre, bpm, filename FROM music " + SearchQuery + OrderQuery)    
  While NextDatabaseRow(#DBMusic)      
    Records + 1
    If Trim(GetDatabaseString(#DBMusic, 1)) = "" And  Trim(GetDatabaseString(#DBMusic, 2)) = ""
      Song = OSPath(GetFilePart(GetDatabaseString(#DBMusic, 9)))
    Else
      Song = GetDatabaseString(#DBMusic, 1) + " - " + GetDatabaseString(#DBMusic, 2)  
    EndIf
    
    AddGadgetItem(Listicon, -1, UCase(GetDatabaseString(#DBMusic, 0) + Chr(10) + 
                                         Song + Chr(10) +                                          
                                         GetDatabaseString(#DBMusic, 3) + Chr(10) +
                                         GetDatabaseString(#DBMusic, 4) + Chr(10) +
                                         GetDatabaseString(#DBMusic, 5) + Chr(10) +
                                         GetDatabaseString(#DBMusic, 6) + Chr(10) +
                                         GetDatabaseString(#DBMusic, 7) + Chr(10) +
                                         RSet(FormatNumber(GetDatabaseFloat(#DBMusic, 8)), 6, "0") + Chr(10)))
  Wend  
  FinishDatabaseQuery(#DBMusic)    
  
  SetGadgetText(#LabelTotalRecords, Str(Records) +  " Records")  
  SelectRow(Listicon, Row)
  
  If ListIcon = #ListiconDatabaseSearch
    HideGadget(#ListIconDatabaseSearch, #False)    
    Visible\ListiconDatabaseSearch = #True 
  EndIf
EndProcedure

Procedure SetHyperlinkFonts(BlackItem.i)
  Protected.i i 
  Protected.i UnderlineFont = LoadFont(#PB_Any, "Bebas-Regular", 12, #PB_Font_Underline)  
  Protected.i ActiveFont = LoadFont(#PB_Any, "Bebas-Regular", 12, #PB_Font_Bold)       
  
  For i = #HyperlinkSettings To #HyperlinkUpgrade
    SetGadgetColor(i, #PB_Gadget_FrontColor, #Blue)
    SetGadgetFont(i, FontID(UnderlineFont))   
    SetGadgetColor(i, #PB_Gadget_BackColor, #White)           
  Next i
  
  SetGadgetFont(BlackItem, FontID(ActiveFont))    
  SetGadgetColor(BlackItem, #PB_Gadget_FrontColor, #Black)       
  SetGadgetColor(BlackItem, #PB_Gadget_BackColor, #White)         
EndProcedure

Procedure FillListiconMusicLibrary(ListIcon = #ListiconMusicLibrary)
  Protected.s SearchString = Trim(GetGadgetText(#StringSearchFiles))
  Protected.s OrderQuery = LCase(GetGadgetText(#ComboboxSortFiles))
  Protected.s WordString, SearchQuery
  Protected.i Word, Words  
     
  If OrderQuery <> "sort"
    OrderQuery = " ORDER BY " + OrderQuery
    If GetGadgetText(#ComboboxSortFiles) = "Added"
      OrderQuery + " DESC"
    EndIf
  Else
    OrderQuery = ""
  EndIf
  
  If SearchString <> "Search..." And SearchString <> ""    
    ;Escape single quotes
    SearchString = ReplaceString(SearchString, "'", "''")
    
    ;remove non-search character
    SearchString = ReplaceString(SearchString, "-", "")     
    
    ;Split string in words
    Words = CountString(SearchString, " ") + 1    
    
    For Word = 1 To Words
      WordString = StringField(SearchString, Word, " ")      
      SearchQuery + "(bpm LIKE '%" + WordString + "%' " +
                    "OR file LIKE '%" + WordString + "%' " +
                    "OR folder LIKE '%" + WordString + "%')"
      If Word < Words
        SearchQuery + " AND "
      EndIf
    Next
    SearchQuery = " WHERE " + SearchQuery
  EndIf
 
  ButtonStopMusicLibrarySong()    
  ClearGadgetItems(ListIcon)    
 
  DatabaseQuery(#DBFiles, "SELECT bpm,file,folder,added FROM files" + SearchQuery + OrderQuery)
  While NextDatabaseRow(#DBFiles)
    AddGadgetItem(ListIcon, -1, GetDatabaseString(#DBFiles, 3) + Chr(10) + 
                                             RSet(FormatNumber(GetDatabaseFloat(#DBFiles, 0)), 6, "0") + Chr(10) +
                                             OSPath(ReplaceString(GetDatabaseString(#DBFiles, 1), "''", "'")) + Chr(10) +
                                             ReplaceString(GetDatabaseString(#DBFiles, 2), "''", "'"))
  Wend
  FinishDatabaseQuery(#DBFiles)  
   
  If ListIcon = #ListiconMusicLibrarySearch
    HideGadget(#ListIconMusicLibrarySearch, #False)    
    Visible\ListiconMusicLibrarySearch = #True      
  EndIf  
EndProcedure

Procedure ApplySettings()
  Protected.s Values, Key 
  Protected.i Item, Items, Result, Gadget = 51  
  
  ;Save playlist settings   
  If PreferencesFile()
    ForEach SettingsPanel()
      If SettingsPanel()\Section <> ""
        If Left(SettingsPanel()\Section, 6) = "Filter"
          PreferenceGroup("Filter")          
        ElseIf SettingsPanel()\Section = "Directories"
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            PreferenceGroup("Directories Linux")
          CompilerElse
            PreferenceGroup("Directories Windows")            
          CompilerEndIf
        ElseIf SettingsPanel()\Section = "Session"
          CompilerIf #PB_Compiler_OS = #PB_OS_Linux
            PreferenceGroup("Session Linux")
          CompilerElse
            PreferenceGroup("Session Windows")
          CompilerEndIf          
        Else
          PreferenceGroup(SettingsPanel()\Section)
        EndIf
      EndIf
      Key = ReplaceString(SettingsPanel()\Description, " ", "_")            
      
      If SettingsPanel()\Gadget <> #SettingListview
        WritePreferenceString(Key, GetGadgetText(Gadget))
      Else
        ;Walkthrough Listview to find selected items
        Values = ""        
        Items = CountGadgetItems(Gadget)

        For Item = 0 To Items - 1
          If GetGadgetItemState(Gadget, Item) = 1
            Values + GetGadgetItemText(Gadget, Item) + "|"
          EndIf
        Next Item 
        
        ;Remove | from the end of Values-string
        Values = RemoveString(Values, "|", #PB_String_CaseSensitive, Len(Values) - 4)
        WritePreferenceString(Key, Values)
      EndIf
      Gadget + 1
    Next
    ClosePreferences()  
         
    ;Clear files database if audio path has been changed
    If GetGadgetText(51) <> Preferences\PathAudio      
      DatabaseUpdate(#DBFiles, "DELETE FROM files")         
    EndIf
    
    LoadPreferences()
  EndIf 
  
  If CountGadgetItems(#ListiconPlaylist) > 0
    If Preferences\MaximumPlaybackTime = "Infinite" And Preferences\PlaylistType = "Random"
      SetGadgetItemColor(#ListiconPlaylist, CountGadgetItems(#ListiconPlaylist) - 1, #PB_Gadget_FrontColor, #Gray)
    Else
      SetGadgetItemColor(#ListiconPlaylist, CountGadgetItems(#ListiconPlaylist) - 1, #PB_Gadget_FrontColor, GetGadgetItemColor(#ListiconPlaylist, #PB_Gadget_FrontColor, 0))      
    EndIf  
  EndIf  
EndProcedure

Procedure.b CheckSettingMinMaxSongs()
  Protected.i MinSongs = Val(GetGadgetText(GadgetNumber\MinSongs)) 
  Protected.i MaxSongs = MaxSongs(GetGadgetText(GadgetNumber\MaxSongs))   
  
  If MinSongs > MaxSongs
    MessageRequester("Settings error", "Maximum songs must be higher than minimum songs.", #PB_MessageRequester_Error)
    ProcedureReturn #True
  EndIf
EndProcedure
 
Procedure.b CheckSettingMinMaxPlaybackTime()
  Protected.i MinSeconds = MinPlaybackTime(GetGadgetText(GadgetNumber\MinPlaybackTime))
  Protected.i MaxSeconds = MaxPlaybackTime(GetGadgetText(GadgetNumber\MaxPlaybackTime))  
  
  If MinSeconds > MaxSeconds
    MessageRequester("Settings error", "Maximum playback time must be higher than minimum playback time.", #PB_MessageRequester_Error)
    ProcedureReturn #True    
  EndIf  
EndProcedure
  
Procedure.b PreferencesFile()
  Protected Result.b
  
  If FileSize(OSPath("assets/data")) <> -2  
    CreateDirectory(OSPath("assets/data"))
  EndIf  
  
  If FileSize(OSPath("assets/data/mixperfect.ini")) = -1
    Result = CreatePreferences(OSPath("assets/data/mixperfect.ini"))
  
    If Result 
      PreferenceComment(#AppName + " settings")
      PreferenceComment("")      
      PreferenceComment("Deleting this file will reset all settings in " + #AppName + ".")  
      PreferenceComment("Manually modifying may cause errors!") 
      PreferenceComment("")
    EndIf    
  Else
    Result = OpenPreferences(OSPath("assets/data/mixperfect.ini"))
  EndIf  
  
  If Result <> 0
    ProcedureReturn #True
  EndIf
EndProcedure

Procedure CreateAppIcon(Window.i)
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    If FileSize("assets/app-icon.png") <> -1
      gtk_window_set_icon_from_file(WindowID(Window), "assets/app-icon.png", #Null)    
    EndIf  
  CompilerEndIf
EndProcedure

Procedure DeselectListviewItems(Gadget.i, Description.s)
  Protected.i Items = CountGadgetItems(Gadget)
  Protected.i Item
  
  For Item = 0 To Items - 1
    SetGadgetState(Gadget, -1)
  Next Item
  
  SetGadgetText(Gadget + 400, Description + Chr(13) + "(0 items selected)")  
EndProcedure

Procedure ExitProgram(Restart.b = #False)
  ExitProgram = #True
  ApplySettings()
  
  ;Save the position of current playlist and database
  If PreferencesFile()           
    PreferenceGroup("Session")      
    WritePreferenceLong("Playlist_position", GetGadgetState(#ListiconPlaylist))

    PreferenceGroup("Database")
    WritePreferenceInteger("Row", GetGadgetState(#ListiconDatabase))
    ClosePreferences()
  EndIf        
            
  ;Close databases
  CloseDatabase(#DBMusic)   
  CloseDatabase(#DBFiles)  
   
  ;Free BASS  
  BASS_StreamFree(CurrentSong)
  BASS_StreamFree(NextSong)
  BASS_StreamFree(Chan\Mixer)
  BASS_StreamFree(Chan\MixerBeatTest) 
  BASS_StreamFree(Chan\MixerCustomTransition)    
  BASS_Free()
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows
    BASS_Free_Library()
    BASS_Mixer_Free_Library()
    BASS_Tags_Free_Library()
    BASS_FX_Free_Library()   
    BASS_AAC_Free_Library()
    BASS_FLAC_Free_Library()    
    BASS_OPUS_Free_Library()  
    BASS_Encode_Free_Library()     
    BASS_Encode_MP3_Free_Library()      
    BASSENCO_FLAC_Free_Library()
    BASSENC_OGG_Free_Library()
    BASS_Enc_OPUS_Free_Library()    
  CompilerElse
    CloseLibrary(libBASS)
    CloseLibrary(libBASSFX)
    CloseLibrary(libBASSMix)
    CloseLibrary(libBASSTags)    
    CloseLibrary(libBASSAac)       
    CloseLibrary(libBASSFLAC)   
    CloseLibrary(libBASSOPUS)   
    CloseLibrary(libBASSEnc)
    CloseLibrary(libBASSEncMP3)    
    CloseLibrary(libBASSEncFLAC)
    CloseLibrary(libBASSOGG)
    CloseLibrary(libBASSEncOPUS)      
  CompilerEndIf  
  
  If Not Restart
    End
  EndIf
EndProcedure

;------------------------------------ Main

;- Main code

Define.i Event, Row, Y
Define.s ID, Warning
Define.q PosBytes
Define.b CloseWindow
Define.f Percent, StopPosition, PosSec

Initialize()
CreateWindowMainTemp()
CreateWindowMain()

InitializationReady = #True ;don't move this

LoadPreviousPlaylist()

BindEvent(#PB_Event_SizeWindow, @ResizeWindows())
ResizeWindow(#WindowMain, WindowX(#WindowMainTemp), WindowY(#WindowMainTemp), WindowWidth(#WindowMainTemp) - 1, WindowHeight(#WindowMainTemp) - 1)
 
HideWindow(#WindowMain, #False)
HideWindow(#WindowMainTemp, #True)

CompilerIf #PB_Compiler_OS = #PB_OS_Linux    
  SetWindowColor(#WindowMain, SystemBackgroundColor)
CompilerEndIf

If Preferences\PathAudio <> "" And FileSize(Preferences\PathAudio) <> -2
  Warning = "Music folder " + Preferences\PathAudio + " does not exists."
EndIf

If Preferences\PathSleeves <> "" And FileSize(Preferences\PathSleeves) <> -2
  If Warning <> ""
    Warning + Chr(13) + Chr(13)
  EndIf
  
  Warning + "Sleeves folder " + Preferences\PathSleeves + " does not exists."
EndIf

If Warning <> ""
  MessageRequester("Warning", Warning, #PB_MessageRequester_Warning)
EndIf

ResizeWindows()

InitializationReady1 = #True

If ProgramParameter(0) = "upgraded"
  SetGadgetState(#Panel, 5)
EndIf

If #DebugMusicAndSleeves
  ;Only for testing if sleeve files and music files exists  
  CheckMusicAndSleeveFiles()
EndIf

;Handle window events
Repeat 
  Event = WaitWindowEvent()
  
  If Decoding   
    DecodeMix()
  EndIf
  
  While IsThread(CollectingFiles)
    Select WaitWindowEvent()  
      Case #PB_Event_CloseWindow 
        StopCollectingFiles = #True   
        Break
    EndSelect      
  Wend
 
  If StopCollectingFiles And IsGadget(#LabelFile)   
    CloseWindow(#WindowMusicLibraryProgress)
    DisableWindow(#WindowMain, #False)    
  EndIf 
     
  Select Event
    Case #PB_Event_SizeWindowFinished
      ResizeWaveform()
    Case #PB_Event_Menu 
      If GetGadgetState(#Panel) = 0 And Not IsGadget(#ButtonCancelBeatSyncTest) And Not IsGadget(#ButtonCancelCustomPlaylist) And Not IsGadget(#ButtonCancelDatabaseAddRecord) And Not IsGadget(#ButtonCancelExport) 
        Select EventMenu()
          Case #AltC
            ButtonCreateCustomPlaylist()
          Case #AltR
            ButtonCreateRandomPlaylist()
          Case #AltL
            ButtonLoadPlaylist()
          Case #AltS
            ButtonSavePlaylist()
          Case #AltE            
            ButtonExportToAudioFile()
          Case #AltP 
            If BASS_ChannelIsActive(Chan\Mixer) = #BASS_ACTIVE_PLAYING 
              ButtonPause(#PB_EventType_LeftClick)                      
            Else
              ButtonPlay(#PB_EventType_LeftClick)                      
            EndIf
          Case #AltO           
            EditSong()
          Case #AltA
            ButtonAlternativeSong()
        EndSelect
      EndIf
      Select GetActiveGadget()
        Case #ArtistString
          Select EventMenu() 
            Case #EnterKey
              FieldPopupSelect(#PB_EventType_LeftClick, #ListviewArtist, #ArtistString)
              HideGadget(#ContainerArtist, #True)    
              Visible\Container = 0
            Case #EscKey
              HideGadget(#ContainerArtist, #True)
              Visible\Container = 0              
            Case #Upkey
              Row = GetGadgetState(#ListviewArtist)             
              If Row > 0
                SelectRow(#ListviewArtist, Row - 1)                
              EndIf
            Case #DownKey  
              If Visible\Container = #ContainerArtist
                Row = GetGadgetState(#ListviewArtist)     
                If Row < CountGadgetItems(#ListviewArtist) - 1
                  SelectRow(#ListviewArtist, Row + 1)
                EndIf     
              Else
                SetActiveGadget(#LabelString)
              EndIf
          EndSelect
        Case #LabelString
          Select EventMenu() 
            Case #EnterKey
              FieldPopupSelect(#PB_EventType_LeftClick, #ListviewLabel, #LabelString)
              HideGadget(#ContainerLabel, #True)    
              Visible\Container = 0
            Case #EscKey
              HideGadget(#ContainerLabel, #True)
              Visible\Container = 0              
            Case #Upkey
              If Visible\Container = #ContainerLabel              
                Row = GetGadgetState(#ListviewLabel)             
                If Row > 0
                  SelectRow(#ListviewLabel, Row - 1)                
                EndIf
              Else
                SetActiveGadget(#ArtistString)                
              EndIf
            Case #DownKey  
              If Visible\Container = #ContainerLabel
                Row = GetGadgetState(#ListviewLabel)     
                If Row < CountGadgetItems(#ListviewLabel) - 1
                  SelectRow(#ListviewLabel, Row + 1)
                EndIf     
              Else
                SetActiveGadget(#CountryString)
              EndIf
          EndSelect  
        Case #CountryString
          Select EventMenu() 
            Case #EnterKey
              FieldPopupSelect(#PB_EventType_LeftClick, #ListviewCountry, #CountryString)
              HideGadget(#ContainerCountry, #True)    
              Visible\Container = 0
            Case #EscKey
              HideGadget(#ContainerCountry, #True)
              Visible\Container = 0              
            Case #Upkey
              If Visible\Container = #ContainerCountry              
                Row = GetGadgetState(#ListviewCountry)             
                If Row > 0
                  SelectRow(#ListviewCountry, Row - 1)                
                EndIf
              Else
                SetActiveGadget(#LabelString)                
              EndIf
            Case #DownKey  
              If Visible\Container = #ContainerCountry
                Row = GetGadgetState(#ListviewCountry)     
                If Row < CountGadgetItems(#ListviewCountry) - 1
                  SelectRow(#ListviewCountry, Row + 1)
                EndIf     
              Else
                SetActiveGadget(#GenreString)
              EndIf
          EndSelect   
        Case #GenreString
          Select EventMenu() 
            Case #EnterKey
              FieldPopupSelect(#PB_EventType_LeftClick, #ListviewGenre, #GenreString)
              HideGadget(#ContainerGenre, #True)    
              Visible\Container = 0
            Case #EscKey
              HideGadget(#ContainerGenre, #True)
              Visible\Container = 0              
            Case #Upkey
              If Visible\Container = #ContainerGenre              
                Row = GetGadgetState(#ListviewGenre)             
                If Row > 0
                  SelectRow(#ListviewGenre, Row - 1)                
                EndIf
              Else
                SetActiveGadget(#CountryString)                
              EndIf
            Case #DownKey  
              If Visible\Container = #ContainerGenre
                Row = GetGadgetState(#ListviewGenre)     
                If Row < CountGadgetItems(#ListviewGenre) - 1
                  SelectRow(#ListviewGenre, Row + 1)
                EndIf     
              Else
                SetActiveGadget(#BPMString)
              EndIf
          EndSelect    
        Case #YearString
          Select EventMenu() 
            Case #EnterKey
              FieldPopupSelect(#PB_EventType_LeftClick, #ListviewYear, #YearString)
              HideGadget(#ContainerYear, #True)    
              Visible\Container = 0
            Case #EscKey
              HideGadget(#ContainerYear, #True)
              Visible\Container = 0              
            Case #Upkey
              If Visible\Container = #ContainerYear              
                Row = GetGadgetState(#ListviewYear)             
                If Row > 0
                  SelectRow(#ListviewYear, Row - 1)                
                EndIf
              Else
                SetActiveGadget(#CatNoString)                
              EndIf
            Case #DownKey  
              If Visible\Container = #ContainerYear
                Row = GetGadgetState(#ListviewYear)     
                If Row < CountGadgetItems(#ListviewYear) - 1
                  SelectRow(#ListviewYear, Row + 1)
                EndIf     
              EndIf
          EndSelect 
        Case #BPMString
          Select EventMenu() 
            Case #Upkey
              SetActiveGadget(#GenreString)
            Case #DownKey
              SetActiveGadget(#SleeveString)              
          EndSelect
        Case #TitleString
          Select EventMenu() 
            Case #DownKey
              SetActiveGadget(#CatNoString)              
          EndSelect     
        Case #YearString
          Select EventMenu() 
            Case #Upkey
              SetActiveGadget(#CatNoString)        
          EndSelect   
        Case #CatNoString
          Select EventMenu() 
            Case #Upkey
              SetActiveGadget(#TitleString) 
            Case #Downkey
              SetActiveGadget(#YearString)                   
          EndSelect             
        Case #SleeveString
          Select EventMenu() 
            Case #Upkey
              SetActiveGadget(#BPMString)             
          EndSelect          
        Case #TrackbarVolume
          Select EventMenu() 
            Case #EnterKey, #EscKey
              HideGadget(#TrackbarVolume, #True)
              Visible\Volume = #False
          EndSelect   
      EndSelect
    Case #PB_Event_Timer  
      Select EventTimer()
        Case #TimerDownload
          If GetGadgetState(#Panel) <> 5
            CancelDownload = #True
          EndIf
        Case #PlayingMixTimer
          ;If Not RefreshPlaylist
            UpdateTrackbar()
          ;EndIf
        Case #TrackbarPicklistTimer
          UpdateTrackbarPicklist()
        Case #TrackbarCustomTransitionTimer 
          UpdateCustomTransitionTrackbar()
        Case #TrackbarMusicLibraryTimer
          UpdateTrackbarMusicLibrary()          
        Case #TrackbarDatabaseTimer
          UpdateTrackbarDatabase()    
        Case #DatabaseAddRecordTimer  
          PosBytes = BASS_ChannelGetPosition(Chan\Database, #BASS_POS_BYTE)
          PosSec = BASS_ChannelBytes2Seconds(Chan\Database, PosBytes)
          
          If DatabaseSong\SelectionLength > 0
            StopPosition = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\SelectionEnd)         
          Else
            StopPosition = BASS_ChannelSeconds2Bytes(Chan\Database, DatabaseSong\ViewEnd)
          EndIf 
                   
          If PosBytes >= StopPosition
            ButtonStopDatabaseAddRecordSong()
          Else             
            UpdatePlayCursor()
            RealTimeSyncs(PosSec)
          EndIf
        Case #TrackbarIntroBeatSyncTestTimer
          UpdateTrackbarIntroBeatSyncTest()  
        Case #TrackbarBreakBeatSyncTestTimer          
          UpdateTrackbarBreakBeatSyncTest()          
      EndSelect      
    Case #PB_Event_Gadget 
      Select EventGadget()
        Case #Panel
          ApplySettings()
          If GetGadgetState(#Panel) = 5
            CheckLatestVersion()
          EndIf
        Case #ButtonUpgrade
          Upgrade()
        Case #ButtonPrevious
          ButtonPrevious(EventType())
        Case #ButtonPlay           
          ButtonPlay(EventType())
        Case #ButtonPause
          ButtonPause(EventType())                    
        Case #ButtonStop
          ButtonStop(EventType())
        Case #ButtonNext 
          ButtonNext(EventType())
        Case #ButtonVolume  
          ButtonVolume(EventType())
        Case #ButtonDynAmpOn  
          ButtonDynAmpOn(EventType())
        Case #ButtonDynAmpOff 
          ButtonDynAmpOff(EventType())   
        Case #ListiconMusicLibrary, #ListiconMusicLibrarySearch
          If EventType() = #PB_EventType_LeftDoubleClick
            ButtonAddFileToDatabase()
          EndIf          
        Case #ListiconPlaylist      
          ListiconPlaylist(EventType())   
        Case #ListiconPicklist
          If EventType() = #PB_EventType_LeftDoubleClick
            ButtonAddSongToCustomPlaylist()
          EndIf
        Case #ListiconDatabase, #ListiconDatabaseSearch
          If EventType() = #PB_EventType_LeftDoubleClick
            ButtonEditRecord()
          EndIf                         
        Case #StringSearchPicklist
          StringSearchPicklist(EventType())   
        Case #StringSearchFiles
          StringSearchFiles(EventType())        
        Case #StringSearchDatabase
          StringSearchDatabase(EventType())     
        Case #GenreString
          GenreString(EventType())
        Case #ArtistString
          ArtistString(EventType())
        Case #LabelString
          LabelString(EventType())
        Case #CountryString
          CountryString(EventType())
        Case #YearString
          YearString(EventType())          
        Case #CanvasWaveform 
          CanvasWaveform(EventType())
        Case #ListviewGenre
          ListviewGenre(EventType())
        Case #ListviewLabel
          ListviewLabel(EventType())
        Case #ListviewCountry
          ListviewCountry(EventType())
        Case #ListviewArtist
          ListviewArtist(EventType())
        Case #ListviewYear
          ListviewYear(EventType())  
        Case GadgetNumber\SleeveDatabase
          If EventType() = #PB_EventType_LeftClick  
            ButtonSleeveString()
          EndIf
      EndSelect 
    Case #PB_Event_CloseWindow
      Select GetActiveWindow()
        Case #WindowMain
          If Not IsGadget(#ButtonCancelBeatSyncTest) And Not IsGadget(#ButtonCancelCustomPlaylist) And Not IsGadget(#ButtonCancelDatabaseAddRecord) And Not IsGadget(#ButtonCancelExport) 
            CancelDownload = #True
            Break
          EndIf          
        Case #WindowCustomPlaylist
          HideGadget(#listIconPicklistSearch, #True)    
          Visible\ListiconPicklistSearch = #False                 
          ButtonStopPicklistSong()
          ButtonStopCustomTransition()            
          CloseWindow(#WindowCustomPlaylist)    
          DisableWindow(#WindowMain, #False)
         ; WindowBounds(#WindowMain, WindowWidth(#WindowMain), WindowHeight(#WindowMain), DesktopWidth(0), DesktopHeight(0))  
          
          If PlayerPausedByProgram
            ButtonPlay(#PB_EventType_LeftClick)             
          EndIf             
        Case #WindowDatabaseAddRecord          
          CloseWindow = #True
          If AllGadgetsData() <> DatabaseRecordData
            If MessageRequester("Warning", "Changes are not saved. Do you really want to close this window?", #PB_MessageRequester_YesNo) <> #PB_MessageRequester_Yes
              CloseWindow = #False
            EndIf
          EndIf        
          
          If CloseWindow
            If Not IsGadget(#ButtonCancelBeatSyncTest)    
              ButtonStopDatabaseAddRecordSong()
              RemoveWindowTimer(#WindowDatabaseAddRecord, #TimerSizeWindow)           
              
              ReDim MM(0)
              
              If IsImage(#OriginalWaveImage)
                FreeImage(#OriginalWaveImage)
              EndIf
              
              If IsImage(#CursorWaveImage)
                FreeImage(#CursorWaveImage)  
              EndIf
              
              If IsImage(#FirstWaveImage)
                FreeImage(#FirstWaveImage)    
              EndIf
              
              If IsImage(#SelectionWaveImage)
                FreeImage(#SelectionWaveImage)    
              EndIf
                      
              CloseWindow(#WindowDatabaseAddRecord)   
   
              DisableWindow(#WindowMain, #False)   
              ;WindowBounds(#WindowMain, WindowWidth(#WindowMain), WindowHeight(#WindowMain), DesktopWidth(0), DesktopHeight(0))  
              
              If PlayerPausedByProgram
                ButtonPlay(#PB_EventType_LeftClick)             
              EndIf              
            EndIf           
          EndIf        
        Case #WindowBeatSyncTest
          ButtonStopIntroBeatSyncTest()
          ButtonStopBreakBeatSyncTest()                    
          CloseWindow(#WindowBeatSyncTest)    
          DisableWindow(#WindowDatabaseAddRecord, #False)                        
      EndSelect
  EndSelect  
  
  Delay(1) 
ForEver

ExitProgram()


;------------------------------------ Data 


;- Images and audio
DataSection
  icon:
  IncludeBinary "pb_include/icons/icons8-mix-96.ico"
  
  upgradeblack:
  IncludeBinary "pb_include/icons/upgrade-black.png"
  
  upgradewhite:
  IncludeBinary "pb_include/icons/upgrade-white.png"
  
  zoominblack:
  IncludeBinary "pb_include/icons/zoomin-black.png"
  
  zoominwhite:
  IncludeBinary "pb_include/icons/zoomin-white.png"
 
  zoomoutblack:
  IncludeBinary "pb_include/icons/zoomout-black.png"
  
  zoomoutwhite:
  IncludeBinary "pb_include/icons/zoomout-white.png" 
  
  zoomfullblack:
  IncludeBinary "pb_include/icons/zoomfull-black.png" 
  
  zoomfullwhite:
  IncludeBinary "pb_include/icons/zoomfull-white.png"  
  
  zoomselectionblack:
  IncludeBinary "pb_include/icons/zoomselection-black.png"
  
  zoomselectionwhite:
  IncludeBinary "pb_include/icons/zoomselection-white.png"
  
  dynampoffblack: 
  IncludeBinary "pb_include/icons/dynampoff-black.png"
  
  dynampoffwhite:
  IncludeBinary "pb_include/icons/dynampoff-white.png"
  
  dynamponblack:
  IncludeBinary "pb_include/icons/dynampon-black.png"
  
  dynamponwhite:
  IncludeBinary "pb_include/icons/dynampon-white.png"
  
  nextblack:
  IncludeBinary "pb_include/icons/next-black.png" 
  
  nextwhite:
  IncludeBinary "pb_include/icons/next-white.png" 
  
  pauseblack:
  IncludeBinary "pb_include/icons/pause-black.png" 
  
  pausewhite:
  IncludeBinary "pb_include/icons/pause-white.png"  
  
  playblack:
  IncludeBinary "pb_include/icons/play-black.png"  
  
  playwhite:
  IncludeBinary "pb_include/icons/play-white.png"  
  
  previousblack:
  IncludeBinary "pb_include/icons/previous-black.png" 
    
  previouswhite:
  IncludeBinary "pb_include/icons/previous-white.png"
  
  stopblack:
  IncludeBinary "pb_include/icons/stop-black.png"
    
  stopwhite:
  IncludeBinary "pb_include/icons/stop-white.png"
  
  volumeblack:
  IncludeBinary "pb_include/icons/volume-black.png"
    
  volumewhite:
  IncludeBinary "pb_include/icons/volume-white.png"
  
  menublack:
  IncludeBinary "pb_include/icons/menu-black.png"
  
  menuwhite:
  IncludeBinary "pb_include/icons/menu-white.png" 
  
  openblack:
  IncludeBinary "pb_include/icons/open-black.png"
  
  openwhite:
  IncludeBinary "pb_include/icons/open-white.png"    
  
  saveblack:
  IncludeBinary "pb_include/icons/save-black.png"
  
  savewhite:
  IncludeBinary "pb_include/icons/save-white.png"
  
  audiofileblack:
  IncludeBinary "pb_include/icons/audiofile-black.png"
  
  audiofilewhite:
  IncludeBinary "pb_include/icons/audiofile-white.png"  

  databaseblack:
  IncludeBinary "pb_include/icons/database-black.png"
  
  databasewhite:
  IncludeBinary "pb_include/icons/database-white.png"

  helpblack:
  IncludeBinary "pb_include/icons/help-black.png"
  
  helpwhite:
  IncludeBinary "pb_include/icons/help-white.png"
  
  musiclibblack:
  IncludeBinary "pb_include/icons/musiclib-black.png"
  
  musiclibwhite:
  IncludeBinary "pb_include/icons/musiclib-white.png"   
   
  settingsblack:
  IncludeBinary "pb_include/icons/settings-black.png"
  
  settingswhite:
  IncludeBinary "pb_include/icons/settings-white.png" 
  
  shuffleblack:
  IncludeBinary "pb_include/icons/shuffle-black.png" 
  
  shufflewhite:
  IncludeBinary "pb_include/icons/shuffle-white.png"  
  
  customblack:
  IncludeBinary "pb_include/icons/custom-black.png" 
  
  customwhite:
  IncludeBinary "pb_include/icons/custom-white.png"    
  
  txtblack:
  IncludeBinary "pb_include/icons/txt-black.png" 
  
  txtwhite:
  IncludeBinary "pb_include/icons/txt-white.png"      
  
  mp3black:
  IncludeBinary "pb_include/icons/mp3-black.png" 
  
  mp3white:
  IncludeBinary "pb_include/icons/mp3-white.png"     
  
  replaceblack:
  IncludeBinary "pb_include/icons/replace-black.png" 
  
  replacewhite:
  IncludeBinary "pb_include/icons/replace-white.png"
 
  africa:
  IncludeBinary "pb_include/icons/flags/icons8-african-union-40.png"
  
  australia:
  IncludeBinary "pb_include/icons/flags/icons8-australia-40.png"
  
  austria:
  IncludeBinary "pb_include/icons/flags/icons8-austria-40.png"
  
  belgium:
  IncludeBinary "pb_include/icons/flags/icons8-belgium-80.png"
  
  canada:
  IncludeBinary "pb_include/icons/flags/icons8-canada-40.png"
  
  china:
  IncludeBinary "pb_include/icons/flags/icons8-china-40.png"
  
  croatia:
  IncludeBinary "pb_include/icons/flags/icons8-croatia-40.png"
  
  denmark:
  IncludeBinary "pb_include/icons/flags/icons8-denmark-40.png"
  
  finland:
  IncludeBinary "pb_include/icons/flags/icons8-finland-40.png"
  
  europe:
  IncludeBinary "pb_include/icons/flags/icons8-flag-of-europe-40.png"
  
  france:
  IncludeBinary "pb_include/icons/flags/icons8-france-40.png"
  
  germany:
  IncludeBinary "pb_include/icons/flags/icons8-germany-40.png"
  
  greatbritain:
  IncludeBinary "pb_include/icons/flags/icons8-great-britain-40.png"
  
  greece:
  IncludeBinary "pb_include/icons/flags/icons8-greece-40.png"
  
  hongkong:
  IncludeBinary "pb_include/icons/flags/icons8-hongkong-flag-40.png"
  
  italy:
  IncludeBinary "pb_include/icons/flags/icons8-italy-40.png"
  
  japan:
  IncludeBinary "pb_include/icons/flags/icons8-japan-40.png"
  
  mexico:
  IncludeBinary "pb_include/icons/flags/icons8-mexico-40.png"
  
  poland:
  IncludeBinary "pb_include/icons/flags/icons8-poland-40.png"
  
  spain:
  IncludeBinary "pb_include/icons/flags/icons8-spain-flag-40.png"
  
  sweden:
  IncludeBinary "pb_include/icons/flags/icons8-sweden-40.png"
  
  switzerland:
  IncludeBinary "pb_include/icons/flags/icons8-switzerland-40.png"  
  
  usa:
  IncludeBinary "pb_include/icons/flags/icons8-usa-40.png"
  
  netherlands:
  IncludeBinary "pb_include/icons/flags/icons8-netherlands-40.png"
EndDataSection

;- Help

DataSection
  HelpUpgrade:
  Data.s "The upgrade section shows the current MixPerfect Player version and automatically checks for updates. If a new version is available, a button will appear to upgrade to the latest version."
  Data.s  ""
  
  HelpDatabase:
  Data.s "Use the database to add audio files that you want " + #AppName + " to play." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'ADD RECORD' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Click on this button to select an audiofile and add it to the database. The file that you choose must be inside a subfolder of the music directory you've selected at settings." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'EDIT' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Click on this button to modify a selected item." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'DELETE' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Clicking on this button will remove a selected item from the database." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'SORT' SELECT BOX" + Chr(13) + Chr(13) 
  Data.s "Use this to sort the list by artist, title, record label, catalog number, year, country, genre or BPM." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'SEARCH...' FIELD" + Chr(13) + Chr(13) 
  Data.s "Type what you looking for in this field, and the list will be filtered on your search term. Remove your text with backspace to see the full list again." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "PLAYING A SONG" + Chr(13) + Chr(13) 
  Data.s "You can listen to a selected song with the 'play' button at the left bottom. Click on the 'stop' button to stop playing" + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "ADDING OR EDITING A RECORD" + Chr(13) + Chr(13) 
  Data.s "To add or edit a record, you must open the the database and click on the 'Add record' button or 'Edit' button." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "INPUT FIELDS" + Chr(13) + Chr(13)
  Data.s "You may add song information like artist, title, label, catalog number, country, year, genre. Those fields are not required but if you enter them, you can use the filter options in settings to create playlists based on one or more of these fields. If you leave the fields 'artist' and 'title' blank, the player will show the filename as alternative." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "THE GENRE FIELD" + Chr(13) + Chr(13) 
  Data.s "You may add multiple genres in the 'genre' field, seperating them by a comma. You can use this field to add genres like 'rock', 'techno', 'rap', but also you can add keywords like 'strong beats', 'romantic', 'german vocals', 'remix', 'sad', 'happy', 'covered song', 'male vocals' et cetera. Or you can type the name of a producer for example, so you can later create a playlist with songs made by this producer." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "THE BPM FIELD" + Chr(13) + Chr(13) 
  Data.s #AppName + " does automatically calculate the estimated BPM of the song. You may alter it, if you know the exact BPM. This is not required but can be usefull with placing markers. After you placed markers the exact BPM will be recalculated." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "ADDING A SLEEVE" + Chr(13) + Chr(13)
  Data.s "It is not required to add a sleeve. You can use the button next to the sleeve field or the grey square to open an image. The image file must be in the indicated sleeve folder. Allowed file extensions are: .jpg, .bmp, .png." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "THE WAVEFORM" + Chr(13) + Chr(13) 
  Data.s "The audiofile is displayed as waveform. This make it easy to find mix points." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "CHANGING THE WAVEFORM SCALE" + Chr(13) + Chr(13) 
  Data.s "The height of the waveform can be changed with the slider at the left of the waveform to to get a clearer picture." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "ZOOM BUTTONS" + Chr(13) + Chr(13) 
  Data.s "Use the zoom buttons below the waveform to zoom in, zoom out, zoom to a selection or to display the full waveform." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "THE CURSOR" + Chr(13) + Chr(13) 
  Data.s "The cursor is the yellow vertical line in the waveform. You can move it by clicking somewhere in the waveform. This is usefull for zooming and playback." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "PLAYING THE SONG" + Chr(13) + Chr(13) 
  Data.s "You can listen to (a part) of the song with spacebar or the play button at the top left. First move the cursor to the position from where you want to listen. You can also zoom in if necessary. Then click on the stop button or hit spacebar again to stop playing." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "PLACING MIXPOINTS" + Chr(13) + Chr(13) 
  Data.s "You can indicate mixpoints by zooming in, place the cursor at the wanted position and select a marker in the marker box at the left of the waveform. Set the selected marker by clicking the 'add' button. If you made a mistake, you can always remove a marker with the 'delete' button." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Intro markers (keyboard shortcuts I and SHIFT + I):" + Chr(13) 
  Data.s "Intro markers are required and indicate the begin and end position of the intro. You get the best result if you choose the least noisy parts, for example only beats, a vocal or a melody. You can often recognize such quiet parts in the waveform. If you add a 'intro begin' marker, an 'intro end' marker is automatically set (if possible) and the intro will get a yellow color. You can do it vice versa: first add an 'intro end' marker, and an 'intro begin' marker will be set automatically."  
  Data.s "The automatically placed marker is an estimated position (based on the BPM input field) and possible must be moved a bit for an optimal result. Important: the intro must always has a length of 32 beats (this may be less If you place a loop)." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Intro prestart marker (keyboard shortcut P):" + Chr(13) 
  Data.s "After you have set the intro markers, you can also place an 'intro prestart' marker (if desired). This can be useful if a voice or melody starts just before the beginning of the intro. The 'intro prestart' marker must be set before the 'intro begin' marker." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Intro loop markers:" + Chr(13) 
  Data.s "It is also possible to mix songs with a short intro (less than 32 beats) by placing an 'intro loop begin' marker and an 'intro loop end' marker between the intro markers. After placing those intro loop markers, right-click somewhere in the loop and enter how many times the loop must be repeated. If you don't know how to calculate this value you may also enter the number of beats between the 'intro begin' and 'intro end' markers and the number of beats between the 'intro loop begin' and 'intro loop end' markers (separate both values by a comma)." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Intro beat markers:" + Chr(13) 
  Data.s "If you've noticed the beats are not in sync after testing with the 'beat sync test' button, and if you are 100% sure that you made no mistakes (markers are at the correct position and loops repeat correctly), you can place a 'intro beat' marker on each beat position to correct this. It's sometimes necessary with old vinyl recordings." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Break markers  (keyboard shortcuts B and SHIFT + B):" + Chr(13) 
  Data.s "Break markers are required and indicate the begin and end position of the break. You get the best result if you choose the least noisy parts, for example only beats, a vocal or a melody. You can often recognize such quiet parts in the waveform. If you add a 'break begin' marker, an 'break end' marker is automatically set (if possible) and the break will get a blue color. You can do it vice versa: first add an 'break end' marker, and an 'break begin' marker will be set automatically. The automatically placed marker is an estimated position (based on the BPM input field) and and possible must be moved a bit for an optimal result. Important: the break must always has a length of 32 beats (this may be less if you place a loop)." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Break loop markers:" + Chr(13) 
  Data.s "It is also possible to mix songs with a short break (less than 32 beats) by placing an 'break loop begin' marker and an 'break loop end' marker between the break markers. After placing those break loop markers, right-click somewhere in the loop and enter how many times the loop must be repeated. If you don't know how to calculate this value you may also enter the number of beats between the 'break begin' and 'break end' markers and the number of beats between the 'break loop begin' and 'break loop end' markers (separate both values by a comma)." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Break mute marker  (keyboard shortcuts M):" + Chr(13) 
  Data.s "Optionally place a 'break mute' marker if you want to switch off the sound in the break at a certain point. For example, when a melody or singing begins just before the end of the break." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Break continue marker  (keyboard shortcuts C):" + Chr(13) 
  Data.s "Optionally place a 'break continue' marker if you want to continue mixing a small part after the break. This can be useful to complete a sung phrase or sound effect)" + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Break beat markers:" + Chr(13) 
  Data.s "If you've noticed the beats are not in sync after testing with the 'beat sync test' button, and if you are 100% sure that you made no mistakes (markers are at the correct position and loops repeat correctly), you can place a 'break beat' marker on each beat position to correct this. It's sometimes neccesary with old vinyl recordings. TIP: Intro and break must have approximately have the same length. To check whether this is the case, you can doubleclick on the blue or yellow part to compare their lengths." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "Skip markers (keyboard shortcuts S and SHIFT + S):" + Chr(13) 
  Data.s "With skip markers you can shorten a song. During playback, " + #AppName + " will skip the part between the 'skip begin' and 'skip end' markers. If you do this well, you will not notice this during playback." 
  Data.s "For example, set the 'skip start' marker at the first beat of a chorus. Then search for a chorus later in the song and put the 'end marker' on the first beat of that chorus. To test whether the cut sounds good you can place the cursor in front of the 'skip begin' marker and click on the play button. Please note that skip markers can only be placed" 
  Data.s "between the 'intro end' marker and 'break begin' marker." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "INTRO AND BREAK CHECKBOXES" + Chr(13) + Chr(13) 
  Data.s "Above the waveform you see checkboxes for the intro and break. It's not required to select any of these checkboxes, but if you want to create harmonious mixes, it's recommended to use them. Listen which elements (vocal, bass, melody, beat) you hear in the intro and break and select those checkboxes. Optionally you can also select the intro-fade-in checkbox (useful if the intro starts loud or with incomplete vocals), and select the break-fade-out checkbox (useful if the break has a loud ending)." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'BEAT SYNC TEST' BUTTON" + Chr(13) + Chr(13) 
  Data.s "You will get only smooth transitions if the markers are placed correctly. The 'Beat sync test' is a tool to check if you did it right. Click on the 'Beat sync test' button at the top left to open the beat sync test window. You see 2 players: one for the intro and one for the break. The time durations of both players must be the same." + Chr(13) + Chr(13) 
  Data.s "If you play the intro or break you will hear overlapping beats. You can change the volume of the overlapping beats with the slider on the top. The overlapped beats must be in sync with the beats of the song. If this is not the case, click 'close' button to return to the database and check if markers are in the right place. Correct their positions where neccesary." + Chr(13) + Chr(13) + Chr(13)
  
  Data.s "SAVING THE RECORD" + Chr(13) + Chr(13) 
  Data.s "If you've passed the beat sync test, you can save the record by clicking the 'save' button at the top right." + Chr(13) + Chr(13) + Chr(13) 
  Data.s ""  
  
  HelpAbout:
  Data.s #AppName + " is an auto DJ player designed to seamlessly mix your audio files. However, some preparation is required to let the player mix songs automatically. But once you have done this, you can sit back and enjoy unique mixes time after time." + Chr(13) + Chr(13) 
  Data.s "The application uses a database with manually set markers. This ensures that songs are mixed at the right points and it gives you even the option to add loops and play songs in shortened format." + Chr(13) + Chr(13) 
                
  Data.s "Smooth and harmonious transitions are ensured, thanks to beat matching, optional gain control, beat filters and options to exclude overlapping elements in transitions, like beats, basses, melodies or vocals" + Chr(13) + Chr(13)  

  Data.s "Creating random or custom playlists is easy. You can generate them based on various criteria such as BPM, genre, record label, artist, year, or country of origin. Moreover, you have options to save your playlists or export them to audio files, enabling you to listen again or sharing mixes with friends." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "HOW TO START" + Chr(13) + Chr(13) 
  Data.s "First, select your music folder at SETTINGS. Then start adding audio files to the DATABASE (if desired, you can first import audio files into FILES to listen to them and find out their BPM's)." + Chr(13) + Chr(13) 
  Data.s "If there are enough records in the database, you can create and play a custom or random playlist in the PLAYER, based on adjusted SETTINGS. Playlists can also be saved and exported to audio files." + Chr(13) + Chr(13) + Chr(13)
  
 
  Data.s "CREDITS"  + Chr(13) + Chr(13)  
  Data.s "Programmed by Martin Verlaan, (c) 2024-" + #VersionYear + " the Netherlands (contributions by PureBasic-forum-members Wilbert (waveform assembler procedure) And ChrisRfr (ObjectTheme library)."  + Chr(13) + Chr(13)
    
  Data.s "Used programming language: PureBasic, (c) Fantaisie Software, France." + Chr(13) + Chr(13) 
    
  Data.s "Used audio library: BASS, (c) Un4seen Developments Ltd, UK." + Chr(13) + Chr(13)
  
  Data.s "Used BASS Add-ons:" + Chr(13) 
  Data.s "- BASSmix, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSOPUS, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSFLAC, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSenc, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSenc_FLAC, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSenc_MP3, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSenc_OGG, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASSenc_OPUS, (c) Un4seen Developments Ltd, UK." + Chr(13) 
  Data.s "- BASS_AAC, (c) Sebastian Andersson (contributions by M. Bakker, Nero AG)." + Chr(13)
  Data.s "- BASS_FX, (c) Arthur Aminov, Israel" + Chr(13)
  Data.s "- TAGS, (c) Wraith (contributions by Ian Luck, Dylan Fitterer, Chris Troesken)." + Chr(13) + Chr(13)
  
  Data.s "Used icons: icons8.com, (c) icons8.com." + Chr(13) + Chr(13) 
  
  Data.s "Used font: Bebabs-Regular, (c) Ryoichi Tsnunekawa, Japan." + Chr(13) + Chr(13) 

  Data.s "DISCLAIMER" + Chr(13) + Chr(13)
  Data.s "MixPerfect Player is freeware and may only be distributed free of charge and in its original, unmodified form. Commercial sale or bundling with paid products is not permitted. Use of this software is entirely at your own risk. The developer accepts no liability for any damage or data loss resulting from the use of this application." + Chr(13) + Chr(13) + Chr(13)
  
  Data.s "WEBSITE"  + Chr(13) + Chr(13) 
  Data.s "For more information, please visit https://www.mixperfectplayer.nl. You’ll also find a video tutorial there if you prefer watching over reading." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "CONTACT" + Chr(13) + Chr(13) 
  Data.s "Found a bug? Do you have suggestions, questions or do you need support? Feel free to send your message to martin@mixperfectplayer.nl and you will receive an answer as soon as possible."
  Data.s ""
  
  HelpSettings:
  Data.s "Adjust the settings to create a desired playlists. Changed settings can affect the length of playlists, but you can always restore the default values by clicking the 'default' button on the top left. The following options can be set:" + Chr(13) + Chr(13) 
  
  Data.s "DIRECTORIES:" + Chr(13) + Chr(13)   
  Data.s "Path audio files (required):" + Chr(13) + "The main folder where your audio files are stored." + Chr(13) + Chr(13) 
  Data.s "Path sleeve files (required):" + Chr(13) + "The main folder where your sleeve files are stored. You may leave it blank if you don't want to display sleeve images." + Chr(13) + Chr(13) 
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows    
    Data.s "GUI THEME" + Chr(13) + Chr(13)
    Data.s "Color:" + Chr(13) + "Sets the theme of the graphical user interface. Default is the most basic theme: Light." + Chr(13) + Chr(13)    
  CompilerEndIf
  
  Data.s "PLAYLIST LENGTH:" + Chr(13) + Chr(13) 
  Data.s "Minimum number of songs:" + Chr(13) + "The minimum number of songs the playlist must contain (a value between 2 and 999)." + Chr(13) + Chr(13) 
  Data.s "Maximum number of songs:" + Chr(13) + "The maximum number of songs the playlist must contain (a value between 2 and 999)." + Chr(13) + Chr(13) 
  Data.s "Minimum playback time:" + Chr(13) + "Minimum playback duration of the playlist (a duration between 2 minutes and 10 hours)." + Chr(13) + Chr(13) 
  Data.s "Maximum playback time:" + Chr(13) + "Maximum playback duration of the playlist (a duration between 2 minutes and 10 hours, or infinite length). Maximum playback duration. If Infinite is selected and a random playlist is loaded, an infinite mix will play." + Chr(13) + Chr(13) 
  
  Data.s "SONG LENGTH:" + Chr(13) + Chr(13) 
  Data.s "Shorten songs:" + Chr(13) + "If you have placed skip-markers in songs, these songs can be played in abbreviated form. Default is Random, which plays songs alternately short and long, but you can also choose 'Always' Or 'Never' to play the songs in their original length." + Chr(13) + Chr(13) 
  
  Data.s "REPEATING:" + Chr(13) + Chr(13) 
  Data.s "Unique songs before repeating:" + Chr(13) + "Prevents the repetition of the same songs. The choosen value determines how many unique songs should be played before a previously played song is repeated. You can choose a value between 2 and 100." + Chr(13) + Chr(13) 
  
  Data.s "SPEED: " + Chr(13) + Chr(13) 
  Data.s "BPM of first song:" + Chr(13) + "The BPM value of the first song in the playlist. The selection list contains BPM's of songs from the database. Default is random." + Chr(13) + Chr(13) 
  Data.s "BPM order of songs:" + Chr(13) + "Determine whether the speed of songs in the playlist should change in ascending, descending or random order." + Chr(13) + Chr(13) 
  Data.s "Maximum BPM distance:" + Chr(13) + "Determines how much the pitch can be adjusted (a value between 0.5 and 1.0). The lower the value, the less noticeable the pitch adjustment. You can choose a value between 0.5 and 9.5. Default is 2.0, which adjust the pitch no more than 2 bpm lower or higher. This does not mean that the playlist cannot contain songs with a lower or higher BPM. The trick is that if a song being mixed has about the same speed as the current playing speed, it will continue at the original speed after mixing." + Chr(13) + Chr(13) 
  Data.s "Pitch reset:" + Chr(13) + "Determines when the pitch will be adjusted to the original speed of a song. This way, the playlist can contain songs with very different BMP values ​​without excessively adjusting the pitch. The lower the value, the less noticeable the pitch adjustment." + Chr(13) + Chr(13) 
  
  Data.s "TRANSITIONS:" + Chr(13) + Chr(13) 
  Data.s "Keep beats going: " + Chr(13) + "Choose whether transitions always must have beats. Default is Yes, which prevents that some transitions don't have beats." + Chr(13) + Chr(13) 
  Data.s "Filter overlapped beats:" + Chr(13) + "Specifies which song(s) should have filtered beats during a transition. During a transition it sounds better if the beats of one song sound less heavy. Possible options are 'Current song', 'Next song', 'Both songs' Or 'None'." + Chr(13) + Chr(13) 
  Data.s "Combine beats:" + Chr(13) + "Choose whether beats from 2 songs can be combined during transitions. This option only has an effect if the database contains songs for which you have indicated whether beats are audible in the intro or in the break. Default is 'Yes', which results in overlapping beats." + Chr(13) + Chr(13) 
  Data.s "Combine basses:" + Chr(13) + "Choose whether basses from 2 songs can be combined during transitions. This option only has an effect if the database contains songs for which you have indicated whether basses are audible in the intro or in the break. Default is 'No', which results in more harmonic transitions but fewer mix combinations are possible." + Chr(13) + Chr(13) 
  Data.s "Combine vocals:" + Chr(13) + "Choose whether vocals from 2 songs can be combined during transitions. This option only has an effect if the database contains songs for which you have indicated whether vocals are audible in the intro or in the break. Default is 'No', which results in more harmonic transitions but fewer mix combinations are possible." + Chr(13) + Chr(13) 
  Data.s "Combine melodies:" + Chr(13) + "Choose whether melodies from 2 songs can be combined during transitions. This option only has an effect if the database contains songs for which you have indicated whether melodies are audible in the intro or in the break. Default is 'No', which results in more harmonic transitions but fewer mix combinations are possible." + Chr(13) + Chr(13) 
  Data.s "Always combine if no matches left: " + Chr(13) +  "Generates a longer playlist if set to Yes." + Chr(13) + Chr(13) 
 
  Data.s "FILTERS:" + Chr(13) + Chr(13) 
  Data.s "The filter boxes contain data that you have added to the database. By selecting one or more items (hold Ctrl-key and click left mouse button) you can generate playlists with songs from specific artists, years, countries, record labels or genres." + Chr(13) + Chr(13) 
  Data.s "Evolution mode:" + Chr(13) +"Below the filter box with years you can enable/disable the Evolution mode. Enabled it generate a random playlist with songs arranged chronologically by year, with (if possible) approximately the same number of songs per year. Evolution mode will be ignored if 'Maximum playback time' is set to 'infinite'." + Chr(13) + Chr(13) + Chr(13) 
  Data.s ""
  
  HelpFiles:
  Data.s "Here you can import your audio files, so you can listen to them and add the songs that you like to the database. Also you can see the BPM of each song. This is especially usefull If you have few songs in the database." + "By first adding audio files of one BPM value, And then adding audio files of a subsequent BPM value, there are no major differences in BPM and the player can be used immediately." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'ADD FOLDER' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Click on this button to select folder with audio files. This must be a subfolder of the music directory you've selected at settings. You can cancel the file scanning process anytime and also resume by clicking on 'Add folder' button again and select the same folder." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'CLEAR LIST' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Clicking on this button will remove all files." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'DELETE FROM LIST' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Clicking on this button will remove a selected file." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'ADD TO DATABASE' BUTTON" + Chr(13) + Chr(13) 
  Data.s "Click on this button to add a selected file to the database. If a file has been added it will show 'Yes' in the 'Added' column." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'SORT' SELECT BOX" + Chr(13) + Chr(13) 
  Data.s "Use this to sort the list by BPM, file, folder or 'added'." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "'SEARCH....' FIELD" + Chr(13) + Chr(13) 
  Data.s "Type what you looking for in this field, and the list will be filtered on your search term. Remove your text with backspace to see the full list again." + Chr(13) + Chr(13) + Chr(13) 
  
  Data.s "PLAYNG A SONG" + Chr(13) + Chr(13) 
  Data.s "You can listen to a selected song with the play button at the left bottom. Click on the stop button to stop playing."
  Data.s ""
  
  HelpPlayer:
  Data.s "You can only play a mix if you have added enough records to the database and created (or loaded) a random or custom playlist." + Chr(13) + Chr(13) + Chr(13)

  Data.s "PLAYER CONTROLS" + Chr(13) + Chr(13)
  Data.s "Use the icons at the top left to start playing, pause, stop playing, or jump to the previous or next track. To play or pause you may also double click on a song in the playlist, or use the keyboard shortcut ALT + P. An alternative way to skip to another song is by clicking on a song in the playlist." + Chr(13) + Chr(13)  

  Data.s "Volume:" + Chr(13)  
  Data.s "Click on the speaker icon to adjust the sound level." + Chr(13) + Chr(13) 
  
  Data.s "Dynamic amplitude:" + Chr(13)  
  Data.s "The icon to the left of the speaker can be used to enable or disable dynamic amplitude. Enabling makes the sound level of all songs approximately the same. However, this can make soft moments undesirably too loud and make fades in and fades out inaudible. TIP: If you use mp3's, an alternative and better method to make all songs approximately the same loudness is to use the free program MP3Gain, which can be downloaded at https://mp3gain.sourceforge.net/" + Chr(13) + Chr(13) 

  Data.s "Rewind / fast forward:" + Chr(13) 
  Data.s "You can rewind or fast forward a song using the slider at the top right. During a transition it is not possible to use the slider." + Chr(13)+ Chr(13) 
  
  Data.s "Loading a playlist:" + Chr(13)  
  Data.s "Every time you run " + #AppName + " , it will load the playlist from the previous session by default. However, sometimes you want to restore an earlier saved playlist. If you load a playlist, the current playlist will be overwritten. The default folder for saved playlists is mixperfect/playlists, but you may choose any folder to load a playlist." + Chr(13) + Chr(13)  
  
  Data.s "Saving the current playlist:" + Chr(13)  
  Data.s "Every time you run " + #AppName + ", it will load the playlist from the previous session by default. However If you want to make sure that you can restore a playlist at anytime, you can save it. The default folder for saving playlists is mixperfect/playlists, but you may choose any folder to save the playlist. The playlist file will be saved with the extension '.mix', so don't change that." + Chr(13) + Chr(13)  
    
  Data.s "Creating a random playlist:" + Chr(13)  
  Data.s "Random playlists are based on your prefered settings. The length of a random playlist depends on the settings and the amount of songs in the database. Also it is important that you have selected a music folder at the settings." + Chr(13) + Chr(13)  

  Data.s "Creating a custom playlist:" + Chr(13)  
  Data.s "Before you create a custom playlist, make sure that you have selected a music folder at the settings and that the database contains enough songs." + Chr(13) + Chr(13) 

  Data.s "    The picklist:" + Chr(13)  
  Data.s "       The picklist shows the songs that you may add to your custom playlist. The list is based on prefered settings. The amount of songs to choose from depends on the settings and the amount of songs in the database. If you add a song to the custom playlist, the picklist will only show songs that can be mixed with the song you've added." + Chr(13) + Chr(13) 

  Data.s "       'Sort' select box:" + Chr(13) 
  Data.s "       Use this to sort the list by BPM, artist, record label, year or country." + Chr(13) + Chr(13) 

  Data.s "       'Search...' field:" + Chr(13) 
  Data.s "       Type what you looking for in this field, and the list will be filtered on your search term. Remove your text with backspace to see the full list again." + Chr(13) + Chr(13) 

  Data.s "       Playing a song:" + Chr(13) 
  Data.s "       You can listen to a selected song with the 'play' button at the left bottom. Click on the 'stop' button to stop playing." + Chr(13) + Chr(13) 

  Data.s "       'Add' button:" + Chr(13) 
  Data.s "       Use this button to add a selected song to the custom playlist." + Chr(13) + Chr(13) 

  Data.s "    The custom playlist:" + Chr(13)  
  Data.s "       The custom playlist contains songs that you've added from the picklist." + Chr(13) + Chr(13) 

  Data.s "       'Remove last song' button:" + Chr(13)
  Data.s "       Click on this button to delete the last song in the custom playlist." + Chr(13) + Chr(13) 
  
  Data.s "       Playing a transition:" + Chr(13) 
  Data.s "       You can listen how the transition of a selected song to the next song sounds with the 'play' button at the left bottom. Click on the 'stop' button to stop playing." + Chr(13) + Chr(13)   
  
  Data.s "       'Load' button:" + Chr(13) 
  Data.s "       Click on this button to load a previous saved custom playlist. Click on this button to load a previously saved custom playlist. Please note that the settings of the loaded custom playlist may differ from the current settings (if you have changed them in the meantime). Adjust them if needed before adding new songs." + Chr(13) + Chr(13)  
  
  Data.s "       'Save' button:" + Chr(13) 
  Data.s "       Click on this button to save the current custom playlist." + Chr(13) + Chr(13)    
  
  Data.s "       'Apply' button:" + Chr(13) 
  Data.s "       Click on this button to load the custom playlist into the Player Panel." + Chr(13) + Chr(13)  
   
  Data.s "Exporting the current playlist to a text file:" + Chr(13)  
  Data.s "You can export the current playlist to a text file. The default folder for exporting playlists is mixperfect/exports, but you may choose also another folder." + Chr(13) + Chr(13)   
   
  Data.s "Exporting the current playlist to an audio file:" + Chr(13)  
  Data.s "You can export the current playlist to an audio file. The default folder for exporting playlists is mixperfect/exports, but you may choose also another folder." + Chr(13) + Chr(13)  
  
  Data.s "Editing a selected song:" + Chr(13)  
  Data.s " Press ALT + O or right click on a selected song to edit the song info and mix-markers" + Chr(13)+ Chr(13) + Chr(13)
   
  Data.s "Replace a selected song with an alternative song:" + Chr(13)  
  Data.s "If in the settings the option 'Always combine if no matches left' is enabled, a !-sign can appear after some tracknumbers. This indicates that the previous and next transition of those songs may not sound harmonious due to different vocals, bass lines, or melodies being mixed together. In that case an random alternative song can be choosen by selecting the song and pressing ALT + A." + Chr(13)+ Chr(13) + Chr(13)
  
  Data.s "KEYBOARD SHORTCUTS" + Chr(13) + Chr(13)
  Data.s "The following shortcut keys can be used:" + Chr(13) 
  Data.s "ALT + P - play / pause." + Chr(13)  
  Data.s "ALT + R - create a random playlist." + Chr(13)
  Data.s "ALT + C - create a custom playlist." + Chr(13)
  Data.s "ALT + S - save the current playlist." + Chr(13)
  Data.s "ALT + L - load a playlist." + Chr(13)
  Data.s "ALT + E - export the current playlist to an mp3-file." + Chr(13) 
  Data.s "ALT + O - edit the selected song (song info and mix-markers)." + Chr(13)   
  Data.s "ALT + A - replace the selected song with random alternative song (useful if the transition from the song to another song does not sound harmonious)." + Chr(13) + Chr(13)      
  Data.s ""  
EndDataSection
; IDE Options = PureBasic 6.21 (Linux - x64)
; CursorPosition = 1048
; FirstLine = 1018
; Folding = ---------------------------------------------------
; EnableAsm
; EnableThread
; EnableXP
; DPIAware
; Executable = mixperfect
; DisableDebugger
; CompileSourceDirectory
; Compiler = PureBasic 6.21 (Linux - x64)