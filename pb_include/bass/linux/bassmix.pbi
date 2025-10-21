;	BASSmix 2.4 C/C++ header file
;	Copyright (c) 2005-2015 Un4seen Developments Ltd.
;
;	See the BASSMIX.CHM file for more detailed documentation
;
;	BASSmix v2.4.7.9 Windows include for PureBasic v5.31
;	C to PB adaption by Roger Hågensen, 2015-03-22, http://forums.purebasic.com/
;
;	Changes from last update to the PB include files:
;	File changed to match bassmix.h more closely.
;	Test code put in seperate file.
;
;	General changes when porting from bass.h to bass.pbi:
;	As much of the non-Windows platform stuff is kept as possible (iOS, Windows CE, Linux, MacOS) even if PureBasic do not support all those platforms.
;	Windows spesific stuff has compiletime check and inclusion to make the include itself as neutral as possible and match BASS.h where possible.
;  MacOS and Linux alternatives are left where encountered, some fiddling around may be needed though.
;	Any callback definitions are retained but commented out so you can see how they should be made.
;	Some C stuff has been dropped when not needed or an alternative implementation added instead.

;C to PB comment:
;PureBasic has no direct match for C like typedefs, just treat these as longs instead.
;TRUE is 1 (#TRUE)
;FALSE is 0 (#FALSE)
;BYTE is a byte
;WORD is a word
;DWORD is a long
;QWORD is a quad
;BOOL is a long
;HMUSIC is a long,	MOD music handle
;HSAMPLE is a long,	sample handle
;HCHANNEL is a long,	playing sample's channel handle
;HSTREAM is a long,	sample stream handle
;HRECORD is a long,	recording handle
;HSYNC is a long,		synchronizer handle
;HDSP is a long,		DSP handle
;HFX is a long,		DX8 effect handle
;HPLUGIN is a long,	Plugin handle

EnableExplicit ;Used to ensure strict coding
 
;- BASSmix version constants
#BASSMIXVERSION		= $02040709 ;BASSmix API version this include was made for.
#BASSMIXVERSIONTEXT	= "2.4"

; additional BASS_SetConfig option
#BASS_CONFIG_MIXER_BUFFER	= $10601
#BASS_CONFIG_MIXER_POSEX	= $10602
#BASS_CONFIG_SPLIT_BUFFER	= $10610

; BASS_Mixer_StreamCreate flags
#BASS_MIXER_END		= $10000	; end the stream when there are no sources
#BASS_MIXER_NONSTOP	= $20000	; don't stall when there are no sources
#BASS_MIXER_RESUME	= $1000	; resume stalled immediately upon new/unpaused source
#BASS_MIXER_POSEX		= $2000	; enable BASS_Mixer_ChannelGetPositionEx support

; source flags
#BASS_MIXER_BUFFER	= $2000	; buffer data for BASS_Mixer_ChannelGetData/Level
#BASS_MIXER_LIMIT		= $4000	; limit mixer processing to the amount available from this source
#BASS_MIXER_MATRIX	= $10000	; matrix mixing
#BASS_MIXER_PAUSE		= $20000	; don't process the source
#BASS_MIXER_DOWNMIX	= $400000; downmix to stereo/mono
#BASS_MIXER_NORAMPIN	= $800000; don't ramp-in the start

;mixer attributes
#BASS_ATTRIB_MIXER_LATENCY	= $15000

; splitter flags
#BASS_SPLIT_SLAVE		= $1000	; only read buffered data

; envelope node
Structure BASS_MIXER_NODE
	pos.q
	val.f
EndStructure

; envelope types
#BASS_MIXER_ENV_FREQ		= 1
#BASS_MIXER_ENV_VOL		= 2
#BASS_MIXER_ENV_PAN		= 3
#BASS_MIXER_ENV_LOOP		= $10000 ; FLAG: loop

; additional sync type
#BASS_SYNC_MIXER_ENVELOPE			= $10200
#BASS_SYNC_MIXER_ENVELOPE_NODE	= $10201

; BASS_CHANNELINFO type
#BASS_CTYPE_STREAM_MIXER	= $10800
#BASS_CTYPE_STREAM_SPLIT	= $10801

;HCHANNEL is a long,	playing sample's channel handle
;is a long,	sample stream handle
;HRECORD is a long,	recording handle
;HSYNC is a long,	synchronizer handle
;HDSP is a long,	DSP handle
;HFX is a long,	DX8 effect handle
;HPLUGIN is a long,	Plugin handle

;- Prototype Definitions

PrototypeC BASS_Mixer_GetVersion()
PrototypeC BASS_Mixer_StreamCreate(freq.l, chans.l, flags.l)
PrototypeC BASS_Mixer_StreamAddChannel(handle.l, channel.l, flags.l)
PrototypeC BASS_Mixer_ChannelRemove(handle.l)
PrototypeC BASS_Mixer_StreamAddChannelEx(handle.l, channel.l, flags.l, start.q, length.q)
PrototypeC BASS_Mixer_ChannelSetPosition(handle.l, pos.q, mode.l)
PrototypeC BASS_Mixer_ChannelGetPosition(handle.l, mode.l)
PrototypeC BASS_Mixer_ChannelSetSync(handle.l, type.l, param.q, *proc, *user)
PrototypeC BASS_Mixer_ChannelRemoveSync(channel.l, sync.l)


Global libBASSMix = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassmix.so")
If Not libBASSMix 
  libBASSMix = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbassmix.so")
  If Not libBASSMix
    MessageRequester("Library loading error", "Failed to load libbassmix.so" + Chr(13) + Chr(13) + 
                                            "To solve the problem, open the subfolder 'assets' in your terminal and enter this command:" + Chr(13)+ Chr(13) + 
                                            "sudo cp -avr bass /usr/lib/", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

Global BASS_Mixer_GetVersion.BASS_Mixer_GetVersion = GetFunction(libBASSMix, "BASS_Mixer_GetVersion")
Global BASS_Mixer_StreamCreate.BASS_Mixer_StreamCreate = GetFunction(libBASSMix, "BASS_Mixer_StreamCreate")
Global BASS_Mixer_StreamAddChannel.BASS_Mixer_StreamAddChannel = GetFunction(libBASSMix, "BASS_Mixer_StreamAddChannel")
Global BASS_Mixer_ChannelRemove.BASS_Mixer_ChannelRemove = GetFunction(libBASSMix, "BASS_Mixer_ChannelRemove")
Global BASS_Mixer_StreamAddChannelEx.BASS_Mixer_StreamAddChannelEx = GetFunction(libBASSMix, "BASS_Mixer_StreamAddChannelEx")
Global BASS_Mixer_ChannelSetPosition.BASS_Mixer_ChannelSetPosition = GetFunction(libBASSMix, "BASS_Mixer_ChannelSetPosition")
Global BASS_Mixer_ChannelGetPosition.BASS_Mixer_ChannelGetPosition = GetFunction(libBASSMix, "BASS_Mixer_ChannelGetPosition")
Global BASS_Mixer_ChannelSetSync.BASS_Mixer_ChannelSetSync = GetFunction(libBASSMix, "BASS_Mixer_ChannelSetSync")
Global BASS_Mixer_ChannelRemoveSync.BASS_Mixer_ChannelRemoveSync = GetFunction(libBASSMix, "BASS_Mixer_ChannelRemoveSync")
Global BASS_Mixer_ChannelRemoveSync.BASS_Mixer_ChannelRemoveSync = GetFunction(libBASSMix, "BASS_Mixer_ChannelRemoveSync")
; IDE Options = PureBasic 6.11 LTS (Linux - x64)
; CursorPosition = 126
; FirstLine = 80
; EnableXP
; EnableUser
; CPU = 1
; SubSystem = .
; CompileSourceDirectory
; EnableCompileCount = 58
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode