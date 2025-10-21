; BASS 2.4 C/C++ header file, copyright (c) 1999-2017 Ian Luck.
; Please report bugs/suggestions/etc... To bass@un4seen.com
; 
; See the BASS.CHM file for implementation documentation
; 
; BASS v2.4 include for PureBasic v4.20
; C to PB adaption by Roger "Rescator" Hågensen, 27th March 2008, http://EmSai.net/

; Needed by some code in this include and various other BASS sourcecodes.

; Ready? Here we go...

; C to PB comment:
; PureBasic has no direct match for C like typedefs, just treat these as longs instead.
; HMUSIC is a long,	MOD music handle
; HSAMPLE is a long,	sample handle
; HCHANNEL is a long,	playing sample's channel handle
; HSTREAM is a long,	sample stream handle
; HRECORD is a long,	recording handle
; HSYNC is a long,	synchronizer handle
; HDSP is a long,	DSP handle
; HFX is a long,	DX8 effect handle
; HPLUGIN is a long,	Plugin handle
 
#BASSVERSION = $204
#BASSVERSIONTEXT = "2.4"

#BASSTRUE = 1
#BASSFALSE = 0

; - BASS Error codes returned by BASS_GetErrorCode
#BASS_OK	             =0	 ; all is OK
#BASS_ERROR_MEM	      =1 	; memory error
#BASS_ERROR_FILEOPEN	 =2 	; can't open the file
#BASS_ERROR_DRIVER	   =3	 ; can't find a free/valid driver
#BASS_ERROR_BUFLOST	  =4	 ; the sample buffer was lost
#BASS_ERROR_HANDLE	   =5 	; invalid handle
#BASS_ERROR_FORMAT	   =6	 ; unsupported sample format
#BASS_ERROR_POSITION	 =7	 ; invalid position
#BASS_ERROR_INIT		    =8	 ; BASS_Init has not been successfully called
#BASS_ERROR_START	    =9	 ; BASS_Start has not been successfully called
#BASS_ERROR_ALREADY	  =14	; already initialized/paused/whatever
#BASS_ERROR_NOCHAN	   =18	; can't get a free channel
#BASS_ERROR_ILLTYPE	  =19	; an illegal type was specified
#BASS_ERROR_ILLPARAM	 =20	; an illegal parameter was specified
#BASS_ERROR_NO3D		    =21	; no 3D support
#BASS_ERROR_NOEAX	    =22	; no EAX support
#BASS_ERROR_DEVICE	   =23	; illegal device number
#BASS_ERROR_NOPLAY	   =24	; not playing
#BASS_ERROR_FREQ		    =25	; illegal sample rate
#BASS_ERROR_NOTFILE	  =27	; the stream is not a file stream
#BASS_ERROR_NOHW		    =29	; no hardware voices available
#BASS_ERROR_EMPTY	    =31	; the MOD music has no sequence Data
#BASS_ERROR_NONET	    =32	; no internet connection could be opened
#BASS_ERROR_CREATE	   =33	; couldn't create the file
#BASS_ERROR_NOFX		    =34	; effects are not available
#BASS_ERROR_NOTAVAIL	 =37	; requested data/action is not available
#BASS_ERROR_DECODE	   =38	; the channel is/isn't a "decoding channel"
#BASS_ERROR_DX		      =39	; a sufficient DirectX version is not installed
#BASS_ERROR_TIMEOUT	  =40	; connection timedout
#BASS_ERROR_FILEFORM	 =41	; unsupported file format
#BASS_ERROR_SPEAKER	  =42	; unavailable speaker
#BASS_ERROR_VERSION   =43	; invalid BASS version (used by add-ons)
#BASS_ERROR_CODEC     =44	; codec is not available/supported
#BASS_ERROR_ENDED     =45	; the channel/file has ended
#BASS_ERROR_BUSY      =46 ; the device is busy
#BASS_ERROR_UNKNOWN	  =-1	; some other mystery error

;- BASS_SetConfig options
#BASS_CONFIG_BUFFER        =0
#BASS_CONFIG_UPDATEPERIOD  =1
#BASS_CONFIG_GVOL_SAMPLE   =4
#BASS_CONFIG_GVOL_STREAM   =5
#BASS_CONFIG_GVOL_MUSIC    =6
#BASS_CONFIG_CURVE_VOL     =7
#BASS_CONFIG_CURVE_PAN     =8
#BASS_CONFIG_FLOATDSP      =9
#BASS_CONFIG_3DALGORITHM   =10
#BASS_CONFIG_NET_TIMEOUT   =11
#BASS_CONFIG_NET_BUFFER    =12
#BASS_CONFIG_PAUSE_NOPLAY  =13
#BASS_CONFIG_NET_PREBUF    =15
#BASS_CONFIG_NET_PASSIVE   =18
#BASS_CONFIG_REC_BUFFER    =19
#BASS_CONFIG_NET_PLAYLIST  =21
#BASS_CONFIG_MUSIC_VIRTUAL =22
#BASS_CONFIG_VERIFY        =23
#BASS_CONFIG_UPDATETHREADS =24
#BASS_CONFIG_DEV_BUFFER = 27
#BASS_CONFIG_VISTA_TRUEPOS = 30
#BASS_CONFIG_IOS_MIXAUDIO = 34
#BASS_CONFIG_DEV_DEFAULT = 36
#BASS_CONFIG_NET_READTIMEOUT = 37
#BASS_CONFIG_VISTA_SPEAKERS = 38
#BASS_CONFIG_IOS_SPEAKER = 39
#BASS_CONFIG_HANDLES = 41

CompilerIf #PB_Compiler_Unicode = #PB_Compiler_Unicode
  #BASS_UNICODE = $80000000
  #BASS_CONFIG_UNICODE = 42
CompilerElse
  #BASS_UNICODE = 0
  #BASS_CONFIG_UNICODE = 0
CompilerEndIf

#BASS_CONFIG_SRC = 43
#BASS_CONFIG_SRC_SAMPLE = 44
#BASS_CONFIG_ASYNCFILE_BUFFER = 45
#BASS_CONFIG_OGG_PRESCAN = 47
#BASS_CONFIG_MF_VIDEO = 48
#BASS_CONFIG_AIRPLAY = 49
#BASS_CONFIG_DEV_NONSTOP = 50
#BASS_CONFIG_IOS_NOCATEGORY = 51
#BASS_CONFIG_VERIFY_NET = 52
#BASS_CONFIG_DEV_PERIOD = 53
#BASS_CONFIG_FLOAT = 54
#BASS_CONFIG_NET_SEEK = 56
#BASS_CONFIG_AM_DISABLE = 58
#BASS_CONFIG_NET_PLAYLIST_DEPTH = 59
#BASS_CONFIG_NET_PREBUF_WAIT = 60

;- BASS_SetConfigPtr options
#BASS_CONFIG_NET_AGENT = 16
#BASS_CONFIG_NET_PROXY = 17
#BASS_CONFIG_IOS_NOTIFY = 46

;- Initialization flags
#BASS_DEVICE_8BITS      = 1	     ; 8 bit
#BASS_DEVICE_MONO       = 2	     ; mono
#BASS_DEVICE_3D         = 4	     ; enable 3D functionality
#BASS_DEVICE_16BITS     = 8      ; limit output To 16 bit
#BASS_DEVICE_LATENCY    = $100   ; calculate device latency (BASS_INFO struct)
#BASS_DEVICE_CPSPEAKERS = $400   ; detect speakers via Windows control panel
#BASS_DEVICE_SPEAKERS   = $800   ; force enabling of speaker assignment
#BASS_DEVICE_NOSPEAKER  = $1000  ; ignore speaker arrangement
#BASS_DEVICE_DMIX       = $2000  ; use ALSA "dmix" plugin
#BASS_DEVICE_FREQ       = $4000  ; set device sample rate
#BASS_DEVICE_STEREO     = $8000  ; limit output To stereo
#BASS_DEVICE_HOG        = $10000 ; hog/exclusive mode
#BASS_DEVICE_AUDIOTRACK = $20000 ; use AudioTrack output
#BASS_DEVICE_DSOUND     = $40000 ; use DirectSound output

;- DirectSound interfaces (For use With BASS_GetDSoundObject)
#BASS_OBJECT_DS     = 1	; IDirectSound
#BASS_OBJECT_DS3DL	= 2	; IDirectSound3DListener

;- Device info structure
Structure BASS_DEVICEINFO Align #PB_Structure_AlignC
	*name   ;description
	*driver ;driver
	flags.l
EndStructure

;- BASS_DEVICEINFO flags
#BASS_DEVICE_ENABLED  = 1
#BASS_DEVICE_DEFAULT  = 2
#BASS_DEVICE_INIT     = 4
#BASS_DEVICE_LOOPBACK = 8

#BASS_DEVICE_TYPE_MASK = $FF000000
#BASS_DEVICE_TYPE_NETWORK = $01000000
#BASS_DEVICE_TYPE_SPEAKERS = $02000000
#BASS_DEVICE_TYPE_LINE = $03000000
#BASS_DEVICE_TYPE_HEADPHONES = $04000000
#BASS_DEVICE_TYPE_MICROPHONE = $05000000
#BASS_DEVICE_TYPE_HEADSET = $06000000
#BASS_DEVICE_TYPE_HANDSET = $07000000
#BASS_DEVICE_TYPE_DIGITAL = $08000000
#BASS_DEVICE_TYPE_SPDIF = $09000000
#BASS_DEVICE_TYPE_HDMI = $0A000000
#BASS_DEVICE_TYPE_DISPLAYPORT = $40000000

;- ID3v1 tag structure

Structure TAG_ID3
	id.a[3]
	title.a[30]
	artist.a[30]
	album.a[30]
	year.a[4]
	comment.a[30]
	genre.b
EndStructure

;- BASS_GetDeviceInfo flags
#BASS_DEVICES_AIRPLAY = $1000000

Structure BASS_INFO
	flags.l     ;device capabilities (DSCAPS_xxx flags)
	hwsize.l    ;size of total device hardware memory
	hwfree.l    ;size of free device hardware memory
	freesam.l   ;number of free sample slots in the hardware
	free3d.l    ;number of free 3D sample slots in the hardware
	minrate.l   ;min sample rate supported by the hardware
	maxrate.l   ;max sample rate supported by the hardware
	eax.l       ;device supports EAX? (always FALSE if BASS_DEVICE_3D was not used)
	minbuf.l    ;recommended minimum buffer length in ms (requires BASS_DEVICE_LATENCY)
	dsver.l     ;DirectSound version
	latency.l   ;delay (in ms) before start of playback (requires BASS_DEVICE_LATENCY)
	initflags.l ;BASS_Init "flags" parameter
	speakers.l  ;number of speakers available
	freq.l      ;current output rate (Vista/OSX only)
EndStructure

;- BASS_INFO flags (from DSOUND.H)
#DSCAPS_CONTINUOUSRATE  =$00000010	;supports all sample rates between min/maxrate
#DSCAPS_EMULDRIVER      =$00000020	;device does not have hardware DirectSound support
#DSCAPS_CERTIFIED       =$00000040	;device driver has been certified by Microsoft
#DSCAPS_SECONDARYMONO   =$00000100	;mono
#DSCAPS_SECONDARYSTEREO =$00000200	;stereo
#DSCAPS_SECONDARY8BIT   =$00000400	;8 bit
#DSCAPS_SECONDARY16BIT  =$00000800	;16 bit

;- Recording device info Structure
Structure BASS_RECORDINFO
	flags.l    ;device capabilities (DSCCAPS_xxx flags)
	formats.l  ;supported standard formats (WAVE_FORMAT_xxx flags)
	inputs.l   ;number of inputs
	singlein.l ;TRUE = only 1 input can be set at a time
	freq.l     ;current input rate (Vista/OSX only)
EndStructure

;- BASS_RECORDINFO flags (from DSOUND.H)
#DSCCAPS_EMULDRIVER = #DSCAPS_EMULDRIVER	;device does not have hardware DirectSound recording support
#DSCCAPS_CERTIFIED  = #DSCAPS_CERTIFIED	 ;device driver has been certified by Microsoft

;- defines for formats field of BASS_RECORDINFO (from MMSYSTEM.H)
#WAVE_FORMAT_1M08 =$00000001 ;11.025 kHz, Mono,   8-bit
#WAVE_FORMAT_1S08 =$00000002 ;11.025 kHz, Stereo, 8-bit
#WAVE_FORMAT_1M16 =$00000004 ;11.025 kHz, Mono,   16-bit
#WAVE_FORMAT_1S16 =$00000008 ;11.025 kHz, Stereo, 16-bit
#WAVE_FORMAT_2M08 =$00000010 ;22.05  kHz, Mono,   8-bit
#WAVE_FORMAT_2S08 =$00000020 ;22.05  kHz, Stereo, 8-bit
#WAVE_FORMAT_2M16 =$00000040 ;22.05  kHz, Mono,   16-bit
#WAVE_FORMAT_2S16 =$00000080 ;22.05  kHz, Stereo, 16-bit
#WAVE_FORMAT_4M08 =$00000100 ;44.1   kHz, Mono,   8-bit
#WAVE_FORMAT_4S08 =$00000200 ;44.1   kHz, Stereo, 8-bit
#WAVE_FORMAT_4M16 =$00000400 ;44.1   kHz, Mono,   16-bit
#WAVE_FORMAT_4S16 =$00000800 ;44.1   kHz, Stereo, 16-bit

;- Sample info structure
Structure BASS_SAMPLE
	freq.l     ; default playback rate
	volume.f   ; default volume (0-1)
	pan.f      ; default pan (-1=left, 0=middle, 1=right)
	flags.l    ; BASS_SAMPLE_xxx flags
	length.l   ; length (in bytes)
	max.l      ; maximum simultaneous playbacks
	origres.l  ; original resolution
	chans.l    ; number of channels
	mingap.l   ; minimum gap (ms) between creating channels
	mode3d.l   ; BASS_3DMODE_xxx mode
	mindist.f  ; minimum distance
	maxdist.f  ; maximum distance
	iangle.l   ; angle of inside projection cone
	oangle.l   ; angle of outside projection cone
	outvol.f   ; delta-volume outside the projection cone
	vam.l      ; voice allocation/management flags (BASS_VAM_xxx)
	priority.l ; priority (0=lowest, 0xffffffff=highest)
EndStructure

;- SAMPLE flags
#BASS_SAMPLE_8BITS     = 1      ; 8 bit
#BASS_SAMPLE_FLOAT     = 256    ; 32-bit floating-point
#BASS_SAMPLE_MONO      = 2      ; mono
#BASS_SAMPLE_LOOP      = 4      ; looped
#BASS_SAMPLE_3D        = 8      ; 3D functionality
#BASS_SAMPLE_SOFTWARE  = 16     ; not using hardware mixing
#BASS_SAMPLE_MUTEMAX   = 32     ; mute at max distance (3D only)
#BASS_SAMPLE_VAM       = 64     ; DX7 voice allocation & management
#BASS_SAMPLE_FX        = 128    ; old implementation of DX8 effects
#BASS_SAMPLE_OVER_VOL  = $10000 ; override lowest volume
#BASS_SAMPLE_OVER_POS  = $20000 ; override longest playing
#BASS_SAMPLE_OVER_DIST = $30000 ; override furthest from listener (3D only)

;- STREAM flags
#BASS_STREAM_PRESCAN  = $20000  ; enable pin-point seeking/length (MP3/MP2/MP1)
#BASS_STREAM_AUTOFREE = $40000  ; automatically free the stream when it stop/ends
#BASS_STREAM_RESTRATE = $80000  ; restrict the download rate of internet file streams
#BASS_STREAM_BLOCK    = $100000 ; download/play internet file stream in small blocks
#BASS_STREAM_DECODE   = $200000 ; don't play the stream, only decode (BASS_ChannelGetData)
#BASS_STREAM_STATUS   = $800000 ; give server status info (HTTP/ICY tags) in DOWNLOADPROC

#BASS_MP3_IGNOREDELAY = $200    ; ignore LAME/Xing/VBRI/iTunes delay & padding info
#BASS_MP3_SETPOS      = #BASS_STREAM_PRESCAN

;- MUSIC flags
#BASS_MUSIC_FLOAT      = #BASS_SAMPLE_FLOAT
#BASS_MUSIC_MONO       = #BASS_SAMPLE_MONO
#BASS_MUSIC_LOOP       = #BASS_SAMPLE_LOOP
#BASS_MUSIC_3D         = #BASS_SAMPLE_3D
#BASS_MUSIC_FX         = #BASS_SAMPLE_FX
#BASS_MUSIC_AUTOFREE   = #BASS_STREAM_AUTOFREE
#BASS_MUSIC_DECODE     = #BASS_STREAM_DECODE
#BASS_MUSIC_PRESCAN    = #BASS_STREAM_PRESCAN ;calculate playback length
#BASS_MUSIC_CALCLEN    = #BASS_MUSIC_PRESCAN
#BASS_MUSIC_RAMP       = $200 ;normal ramping
#BASS_MUSIC_RAMPS      = $400 ;sensitive ramping
#BASS_MUSIC_SURROUND   = $800 ;surround sound
#BASS_MUSIC_SURROUND2  = $1000 ;surround sound (mode 2)
#BASS_MUSIC_FT2PAN     = $2000 ;apply FastTracker 2 panning To XM files
#BASS_MUSIC_FT2MOD     = $2000 ;play .MOD as FastTracker 2 does
#BASS_MUSIC_PT1MOD     = $4000 ;play .MOD as ProTracker 1 does
#BASS_MUSIC_NONINTER   = $10000 ;non-interpolated sample mixing
#BASS_MUSIC_SINCINTER  = $800000 ;sinc interpolated sample mixing
#BASS_MUSIC_POSRESET   = $8000 ;stop all notes when moving position
#BASS_MUSIC_POSRESETEX = $400000 ;stop all notes and reset bmp/etc when moving position
#BASS_MUSIC_STOPBACK   = $80000 ;stop the music on a backwards jump effect
#BASS_MUSIC_NOSAMPLE   = $100000 ;don't load the samples

;- SPEAKER assignment flags
#BASS_SPEAKER_FRONT      = $01000000 ;front speakers
#BASS_SPEAKER_REAR       = $02000000 ;rear/side speakers
#BASS_SPEAKER_CENLFE     = $03000000 ;center & LFE speakers (5.1)
#BASS_SPEAKER_REAR2      = $04000000 ;rear center speakers (7.1)
Macro BASS_SPEAKER_N(n) : (n<<24) : EndMacro ;n'th pair of speakers (max 15)
#BASS_SPEAKER_LEFT       = $10000000 ;modifier: left
#BASS_SPEAKER_RIGHT      = $20000000 ;modifier: right
#BASS_SPEAKER_FRONTLEFT  = #BASS_SPEAKER_FRONT|#BASS_SPEAKER_LEFT
#BASS_SPEAKER_FRONTRIGHT = #BASS_SPEAKER_FRONT|#BASS_SPEAKER_RIGHT
#BASS_SPEAKER_REARLEFT   = #BASS_SPEAKER_REAR|#BASS_SPEAKER_LEFT
#BASS_SPEAKER_REARRIGHT  = #BASS_SPEAKER_REAR|#BASS_SPEAKER_RIGHT
#BASS_SPEAKER_CENTER     = #BASS_SPEAKER_CENLFE|#BASS_SPEAKER_LEFT
#BASS_SPEAKER_LFE        = #BASS_SPEAKER_CENLFE|#BASS_SPEAKER_RIGHT
#BASS_SPEAKER_REAR2LEFT  = #BASS_SPEAKER_REAR2|#BASS_SPEAKER_LEFT
#BASS_SPEAKER_REAR2RIGHT = #BASS_SPEAKER_REAR2|#BASS_SPEAKER_RIGHT

#BASS_ASYNCFILE = $40000000
 

#BASS_RECORD_PAUSE      = $8000 ; start recording paused
#BASS_RECORD_ECHOCANCEL = $2000
#BASS_RECORD_AGC        = $4000

;- DX7 voice allocation & management flags
#BASS_VAM_HARDWARE  = 1
#BASS_VAM_SOFTWARE  = 2
#BASS_VAM_TERM_TIME = 4
#BASS_VAM_TERM_DIST = 8
#BASS_VAM_TERM_PRIO	= 16

;- BASS Structures
Structure BASS_CHANNELINFO Align #PB_Structure_AlignC
	freq.l 	    ; default playback rate
	chans.l     ; channels
	flags.l     ; BASS_SAMPLE/STREAM/MUSIC/SPEAKER flags
	ctype.l     ; type of channel
	origres.l   ; original resolution
	plugin.l    ; plugin handle
	sample.l    ; sample
 *filename    ; filename
EndStructure

#BASS_ORIGRES_FLOAT = $10000

;- BASS_CHANNELINFO types
#BASS_CTYPE_SAMPLE		       = 1
#BASS_CTYPE_RECORD		       = 2
#BASS_CTYPE_STREAM		       = $10000
#BASS_CTYPE_STREAM_OGG	     = $10002
#BASS_CTYPE_STREAM_MP1	     = $10003
#BASS_CTYPE_STREAM_MP2	     = $10004
#BASS_CTYPE_STREAM_MP3	     = $10005
#BASS_CTYPE_STREAM_AIFF	     = $10006
#BASS_CTYPE_STREAM_CA        = $10007
#BASS_CTYPE_STREAM_MF        = $10008
#BASS_CTYPE_STREAM_AM        = $10009
#BASS_CTYPE_STREAM_DUMMY     = $18000
#BASS_CTYPE_STREAM_DEVICE    = $18001
#BASS_CTYPE_STREAM_WAV	     = $40000 ; WAVE flag, LOWORD=codec
#BASS_CTYPE_STREAM_WAV_PCM	 = $50001
#BASS_CTYPE_STREAM_WAV_FLOAT = $50003
#BASS_CTYPE_MUSIC_MOD	       = $20000
#BASS_CTYPE_MUSIC_MTM	       = $20001
#BASS_CTYPE_MUSIC_S3M	       = $20002
#BASS_CTYPE_MUSIC_XM		     = $20003
#BASS_CTYPE_MUSIC_IT		     = $20004
#BASS_CTYPE_MUSIC_MO3	       = $00100 ; MO3 flag

Structure BASS_PLUGINFORM Align #PB_Structure_AlignC
	ctype.l ; channel type
	*name   ; format description
	*exts   ; file extension filter (*.ext1;*.ext2;etc...)
EndStructure

Structure BASS_PLUGININFO Align #PB_Structure_AlignC
	version.l ; version (same form as BASS_GetVersion)
	formatc.l ; number of formats
	*formats.BASS_PLUGINFORM ; the array of formats
EndStructure

;- 3D vector (For 3D positions/velocities/orientations)
Structure BASS_3DVECTOR
	X.f ; +=right, -=left
	Y.f ; +=up, -=down
	z.f ; +=front, -=behind
EndStructure

;- 3D channel modes
#BASS_3DMODE_NORMAL   = 0 ;normal 3D processing
#BASS_3DMODE_RELATIVE = 1 ;position is relative to the listener
#BASS_3DMODE_OFF      = 2 ;no 3D processing

;- software 3D mixing algorithms (used With BASS_CONFIG_3DALGORITHM)
#BASS_3DALG_DEFAULT = 0
#BASS_3DALG_OFF     = 1
#BASS_3DALG_FULL    = 2
#BASS_3DALG_LIGHT   = 3
;typedef DWORD (CALLBACK STREAMPROC)(HSTREAM handle, void *buffer, DWORD length, void *user);
; User stream callback function. NOTE: A stream function should obviously be as quick
;as possible, other streams (and MOD musics) can't be mixed until it's finished.
;handle : The stream that needs writing
;buffer : Buffer to write the samples in
;length : Number of bytes to write
;user   : The 'user' parameter value given when calling BASS_StreamCreate
;RETURN : Number of bytes written. Set the BASS_STREAMPROC_END flag to end the stream.

#BASS_STREAMPROC_END	=$80000000	;end of user stream flag

;- special STREAMPROCs
#STREAMPROC_DUMMY   =  0  ; "dummy" stream
#STREAMPROC_PUSH    = -1  ; push stream
#STREAMPROC_DEVICE  = -2  ; device mix stream

;- BASS_StreamCreateFileUser file systems
#STREAMFILE_NOBUFFER		= 0
#STREAMFILE_BUFFER		  = 1
#STREAMFILE_BUFFERPUSH	= 2

;- User file stream callback functions
;typedef void (CALLBACK FILECLOSEPROC)(void *user);
;typedef QWORD (CALLBACK FILELENPROC)(void *user);
;typedef DWORD (CALLBACK FILEREADPROC)(void *buffer, DWORD length, void *user);
;typedef Bool (CALLBACK FILESEEKPROC)(QWORD offset, void *user);

Structure BASS_FILEPROCS
	*close
	*length
	*read
	*seek
EndStructure

;- BASS_StreamPutFileData options
#BASS_FILEDATA_END = 0	; end & close the file

;- BASS_StreamGetFilePosition modes
#BASS_FILEPOS_CURRENT     = 0
#BASS_FILEPOS_DECODE      = #BASS_FILEPOS_CURRENT
#BASS_FILEPOS_DOWNLOAD    = 1
#BASS_FILEPOS_END         = 2
#BASS_FILEPOS_START       = 3
#BASS_FILEPOS_CONNECTED   = 4
#BASS_FILEPOS_BUFFER      = 5
#BASS_FILEPOS_SOCKET      = 6
#BASS_FILEPOS_ASYNCBUF    = 7
#BASS_FILEPOS_SIZE        = 8
#BASS_FILEPOS_BUFFERING   = 9

;typedef void (CALLBACK DOWNLOADPROC)(const void *buffer, DWORD length, void *user);
;/* Internet stream download callback function.
;buffer : Buffer containing the downloaded data... NULL=end of download
;length : Number of bytes in the buffer
;user   : The 'user' parameter value given when calling BASS_StreamCreateURL */

;- BASS_ChannelSetSync types
#BASS_SYNC_POS        = 0
#BASS_SYNC_END        = 2
#BASS_SYNC_META       = 4
#BASS_SYNC_SLIDE      = 5
#BASS_SYNC_STALL      = 6
#BASS_SYNC_DOWNLOAD   = 7
#BASS_SYNC_FREE       = 8
#BASS_SYNC_SETPOS     = 11
#BASS_SYNC_MUSICPOS   = 10
#BASS_SYNC_MUSICINST  = 1
#BASS_SYNC_MUSICFX    = 3
#BASS_SYNC_OGG_CHANGE = 12
#BASS_SYNC_MIXTIME    = $40000000	;FLAG: sync at mixtime, else at playtime
#BASS_SYNC_ONETIME    = $80000000	;FLAG: sync only once, else continuously

;typedef void (CALLBACK SYNCPROC)(HSYNC handle, DWORD channel, DWORD Data, void *user);
;/* Sync callback function. NOTE: a sync callback function should be very
;quick as other syncs can't be processed until it has finished. If the sync
;is a "mixtime" sync, then other streams and MOD musics can't be mixed until
;it's finished either.
;handle : The sync that has occured
;channel: Channel that the sync occured in
;data   : Additional data associated with the sync's occurance
;user   : The 'user' parameter given when calling BASS_ChannelSetSync */

;typedef void (CALLBACK DSPPROC)(HDSP handle, DWORD channel, void *buffer, DWORD length, void *user);
;/* DSP callback function. NOTE: A DSP function should obviously be as quick as
;possible... other DSP functions, streams and MOD musics can not be processed
;until it's finished.
;handle : The DSP handle
;channel: Channel that the DSP is being applied to
;buffer : Buffer to apply the DSP to
;length : Number of bytes in the buffer
;user   : The 'user' parameter given when calling BASS_ChannelSetDSP */

;typedef Bool (CALLBACK RECORDPROC)(HRECORD handle, const void *buffer, DWORD length, void *user);
;/* Recording callback function.
;handle : The recording handle
;buffer : Buffer containing the recorded sample data
;length : Number of bytes
;user   : The 'user' parameter value given when calling BASS_RecordStart
;RETURN : TRUE = continue recording, FALSE = stop */

;- BASS_ChannelIsActive Return values
#BASS_ACTIVE_STOPPED  = 0
#BASS_ACTIVE_PLAYING  = 1
#BASS_ACTIVE_STALLED  = 2
#BASS_ACTIVE_PAUSED   = 3

;- Channel attributes
#BASS_ATTRIB_FREQ             = 1
#BASS_ATTRIB_VOL              = 2
#BASS_ATTRIB_PAN              = 3
#BASS_ATTRIB_EAXMIX           = 4
#BASS_ATTRIB_NOBUFFER         = 5
#BASS_ATTRIB_VBR              = 6
#BASS_ATTRIB_CPU              = 7
#BASS_ATTRIB_SRC              = 8
#BASS_ATTRIB_NET_RESUME       = 9
#BASS_ATTRIB_SCANINFO         = 10
#BASS_ATTRIB_NORAMP           = 11
#BASS_ATTRIB_BITRATE          = 12
#BASS_ATTRIB_BUFFER           = 13
#BASS_ATTRIB_MUSIC_AMPLIFY    = $100
#BASS_ATTRIB_MUSIC_PANSEP     = $101
#BASS_ATTRIB_MUSIC_PSCALER    = $102
#BASS_ATTRIB_MUSIC_BPM        = $103
#BASS_ATTRIB_MUSIC_SPEED      = $104
#BASS_ATTRIB_MUSIC_VOL_GLOBAL = $105
#BASS_ATTRIB_MUSIC_ACTIVE     = $106
#BASS_ATTRIB_MUSIC_VOL_CHAN   = $200 ;+ channel #
#BASS_ATTRIB_MUSIC_VOL_INST   = $300 ;+ instrument #

;- BASS_ChannelSlideAttribute flags
#BASS_SLIDE_LOG = $1000000

;- BASS_ChannelGetData flags
#BASS_DATA_AVAILABL       = 0         ; query how much data is buffered
#BASS_DATA_FIXED          = $20000000 ; flag: return 8.24 fixed-point data
#BASS_DATA_FLOAT          = $40000000 ; flag: return floating-point sample data
#BASS_DATA_FFT256         = $80000000 ; 256 sample FFT
#BASS_DATA_FFT512         = $80000001 ; 512 FFT
#BASS_DATA_FFT1024        = $80000002 ; 1024 FFT
#BASS_DATA_FFT2048        = $80000003 ; 2048 FFT
#BASS_DATA_FFT4096        = $80000004 ; 4096 FFT
#BASS_DATA_FFT8192        = $80000005 ; 8192 FFT
#BASS_DATA_FFT16384       = $80000006 ; 16384 FFT
#BASS_DATA_FFT32768       = $80000007 ; 32768 FFT
#BASS_DATA_FFT_INDIVIDUAL = $10       ; FFT flag: FFT for each channel, else all combined
#BASS_DATA_FFT_NOWINDOW   = $20       ; FFT flag: no Hanning window
#BASS_DATA_FFT_REMOVEDC   = $40       ; FFT flag: pre-remove DC bias
#BASS_DATA_FFT_COMPLEX    = $80       ; FFT flag: return complex data

;- BASS_ChannelGetLevelEx flags
#BASS_LEVEL_MONO    = 1
#BASS_LEVEL_STEREO  = 2
#BASS_LEVEL_RMS     = 4
#BASS_LEVEL_VOLPAN  = 8

;- BASS_ChannelGetTags types : what's returned
#BASS_TAG_ID3 = 0                 ; ID3v1 tags : TAG_ID3 structure
#BASS_TAG_ID3V2 = 1               ; ID3v2 tags : variable length block
#BASS_TAG_OGG = 2                 ; OGG comments : series of null-terminated UTF-8 strings
#BASS_TAG_HTTP = 3                ; HTTP headers : series of null-terminated ANSI strings
#BASS_TAG_ICY = 4                 ; ICY headers : series of null-terminated ANSI strings
#BASS_TAG_META = 5                ; ICY metadata : ANSI string
#BASS_TAG_APE = 6                 ; APEv2 tags : series of null-terminated UTF-8 strings
#BASS_TAG_MP4 = 7                 ; MP4/iTunes metadata : series of null-terminated UTF-8 strings
#BASS_TAG_WMA = 8                 ; WMA tags : series of null-terminated UTF-8 strings
#BASS_TAG_VENDOR = 9              ; OGG encoder : UTF-8 string
#BASS_TAG_LYRICS3 = 10            ; Lyric3v2 tag : ASCII string
#BASS_TAG_CA_CODEC = 11           ; CoreAudio codec info : TAG_CA_CODEC structure
#BASS_TAG_MF = 13                 ; Media Foundation tags : series of null-terminated UTF-8 strings
#BASS_TAG_WAVEFORMAT = 14         ; WAVE format : WAVEFORMATEEX structure
#BASS_TAG_AM_MIME = 15            ; Android Media MIME type : ASCII string
#BASS_TAG_AM_NAME = 16            ; Android Media codec name : ASCII string
#BASS_TAG_RIFF_INFO = $100        ; RIFF "INFO" tags : series of null-terminated ANSI strings
#BASS_TAG_RIFF_BEXT = $101        ; RIFF/BWF "bext" tags : TAG_BEXT structure
#BASS_TAG_RIFF_CART = $102        ; RIFF/BWF "cart" tags : TAG_CART structure
#BASS_TAG_RIFF_DISP = $103        ; RIFF "DISP" text tag : ANSI string
#BASS_TAG_RIFF_CUE  = $104        ; RIFF "cue " chunk : TAG_CUE Structure
#BASS_TAG_RIFF_SMPL = $105        ; RIFF "smpl" chunk : TAG_SMPL Structure
#BASS_TAG_APE_BINARY = $1000      ; + index #, binary APEv2 tag : TAG_APE_BINARY structure
#BASS_TAG_MUSIC_NAME = $10000     ; MOD music name : ANSI string
#BASS_TAG_MUSIC_MESSAGE = $10001  ; MOD message : ANSI string
#BASS_TAG_MUSIC_ORDERS = $10002   ; MOD order list : BYTE array of pattern numbers
#BASS_TAG_MUSIC_AUTH  = $10003    ; MOD author : UTF-8 string
#BASS_TAG_MUSIC_INST = $10100     ; + instrument #, MOD instrument name : ANSI string
#BASS_TAG_MUSIC_SAMPLE = $10300 ; + sample #, MOD sample name : ANSI string

;- BASS_ChannelGetLength/GetPosition/SetPosition modes
#BASS_POS_BYTE        = 0         ; byte position
#BASS_POS_MUSIC_ORDER = 1         ; order.row position, MAKELONG(order,row)
#BASS_POS_OGG         = 3         ; OGG bitstream number
#BASS_POS_RESET       = $2000000  ; flag: reset user file buffers
#BASS_POS_RELATIVE    = $4000000  ; flag: seek relative To the current position
#BASS_POS_INEXACT     = $8000000  ; flag: allow seeking to inexact position
#BASS_POS_DECODE      = $10000000 ; flag: get the decoding (not playing) position
#BASS_POS_DECODEETC   = $20000000 ; flag: decode to the position instead of seeking
#BASS_POS_SCAN        = $40000000 ; flag: scan to the position

;- BASS_ChannelSetDevice/GetDevice option
#BASS_NODEVICE  = $20000

;- BASS_RecordSetInput flags
#BASS_INPUT_OFF = $10000
#BASS_INPUT_ON  = $20000

#BASS_INPUT_TYPE_MASK     = $FF000000
#BASS_INPUT_TYPE_UNDEF    = $00000000
#BASS_INPUT_TYPE_DIGITAL  = $01000000
#BASS_INPUT_TYPE_LINE     = $02000000
#BASS_INPUT_TYPE_MIC      = $03000000
#BASS_INPUT_TYPE_SYNTH    = $04000000
#BASS_INPUT_TYPE_CD       = $05000000
#BASS_INPUT_TYPE_PHONE    = $06000000
#BASS_INPUT_TYPE_SPEAKER  = $07000000
#BASS_INPUT_TYPE_WAVE     = $08000000
#BASS_INPUT_TYPE_AUX      = $09000000
#BASS_INPUT_TYPE_ANALOG   = $0A000000

;- BASS_ChannelSetFX effect types
#BASS_FX_DX8_CHORUS       = 0
#BASS_FX_DX8_COMPRESSOR   = 1
#BASS_FX_DX8_DISTORTION   = 2
#BASS_FX_DX8_ECHO         = 3
#BASS_FX_DX8_FLANGER      = 4
#BASS_FX_DX8_GARGLE       = 5
#BASS_FX_DX8_I3DL2REVERB  = 6
#BASS_FX_DX8_PARAMEQ      = 7
#BASS_FX_DX8_REVERB       = 8
#BASS_FX_VOLUME           = 9

Structure BASS_DX8_CHORUS
fWetDryMix.f
fDepth.f
fFeedback.f
fFrequency.f
lWaveform.l  ;0=triangle, 1=sine
fDelay.f
lPhase.l     ;BASS_DX8_PHASE_xxx
EndStructure

Structure BASS_DX8_COMPRESSOR
fGain.f
fAttack.f
fRelease.f
fThreshold.f
fRatio.f
fPredelay.f
EndStructure

Structure BASS_DX8_DISTORTION
fGain.f
fEdge.f
fPostEQCenterFrequency.f
fPostEQBandwidth.f
fPreLowpassCutoff.f
EndStructure

Structure BASS_DX8_ECHO
fWetDryMix.f
fFeedback.f
fLeftDelay.f
fRightDelay.f
lPanDelay.l
EndStructure

Structure BASS_DX8_FLANGER
fWetDryMix.f
fDepth.f
fFeedback.f
fFrequency.f
lWaveform.l	;0=triangle, 1=sine
fDelay.f
lPhase.l		  ;BASS_DX8_PHASE_xxx
EndStructure

Structure BASS_DX8_GARGLE
dwRateHz.l    ;Rate of modulation in hz
dwWaveShape.l ;0=triangle, 1=square
EndStructure

Structure BASS_DX8_I3DL2REVERB
lRoom.l               ; [-10000, 0]      default: -1000 mB
lRoomHF.l             ; [-10000, 0]      default: 0 mB
flRoomRolloffFactor.f ;[0.0, 10.0]      default: 0.0
flDecayTime.f         ;[0.1, 20.0]      default: 1.49s
flDecayHFRatio.f      ;[0.1, 2.0]       default: 0.83
lReflections.l        ; [-10000, 1000]   default: -2602 mB
flReflectionsDelay.f  ;[0.0, 0.3]       default: 0.007 s
lReverb.l             ; [-10000, 2000]   default: 200 mB
flReverbDelay.f       ;[0.0, 0.1]       default: 0.011 s
flDiffusion.f         ;[0.0, 100.0]     default: 100.0 %
flDensity.f           ;[0.0, 100.0]     default: 100.0 %
flHFReference.f       ;[20.0, 20000.0]  default: 5000.0 Hz
EndStructure

Structure BASS_DX8_PARAMEQ
 fCenter.f
 fBandwidth.f
 fGain.f
EndStructure

Structure BASS_DX8_REVERB
fInGain.f          ; [-96.0,0.0]            default: 0.0 dB
fReverbMix.f       ; [-96.0,0.0]            default: 0.0 db
fReverbTime.f      ;[0.001,3000.0]         default: 1000.0 ms
fHighFreqRTRatio.f ;[0.001,0.999]          default: 0.001
EndStructure

#BASS_DX8_PHASE_NEG_180 = 0
#BASS_DX8_PHASE_NEG_90  = 1
#BASS_DX8_PHASE_ZERO    = 2
#BASS_DX8_PHASE_90      = 3
#BASS_DX8_PHASE_180     = 4

;typedef void (CALLBACK IOSNOTIFYPROC)(DWORD status);
; /* iOS notification callback function.
; status : The notification (BASS_IOSNOTIFY_xxx) */

#BASS_IOSNOTIFY_INTERRUPT = 1     ; interruption started
#BASS_IOSNOTIFY_INTERRUPT_END = 2 ; interruption ended

;- BASS Functions
 
PrototypeC BASS_SetConfig (option.l,value.l)
PrototypeC BASS_GetVersion()
PrototypeC BASS_ErrorGetCode()
PrototypeC BASS_Init(device.l,freq.l,flags.l,*win,*dsguid)
PrototypeC BASS_Free()
PrototypeC.f BASS_SetVolume(volume.f)
PrototypeC BASS_StreamCreateFile(mem.l,*file,offset.q,length.q,flags.l)
PrototypeC BASS_StreamFree(Handle.l)
PrototypeC.d BASS_ChannelBytes2Seconds(Handle.l,pos.q)
PrototypeC.q BASS_ChannelSeconds2Bytes(Handle.l,pos.d)
PrototypeC BASS_ChannelIsActive(Handle.l)
PrototypeC BASS_ChannelGetInfo(Handle.l,*info.BASS_CHANNELINFO)
PrototypeC BASS_ChannelGetTags(Handle.l,tags.l)
PrototypeC BASS_ChannelPlay(Handle.l,restart.l)
PrototypeC BASS_ChannelStop(Handle.l)
PrototypeC BASS_ChannelPause(Handle.l)
PrototypeC BASS_ChannelSetAttribute(Handle.l,attrib.l,value.f)
PrototypeC BASS_ChannelGetAttribute(Handle.l,attrib.l,*value)
PrototypeC.q BASS_ChannelGetLength(Handle.l,mode.l)
PrototypeC BASS_ChannelSetPosition(Handle.l,pos.q,mode.l)
PrototypeC.q BASS_ChannelGetPosition(Handle.l,mode.l)
PrototypeC BASS_ChannelGetData(Handle.l,*buffer,length.l)
PrototypeC BASS_ChannelSetSync(Handle.l,Type.l,param.q,*proc,*user)
PrototypeC BASS_ChannelRemoveSync(Handle.l,sync.l)
PrototypeC BASS_ChannelSetFX(Handle.l,type.l,priority.l)
PrototypeC BASS_ChannelRemoveFX(Handle.l,fx.l)
PrototypeC BASS_FXSetParameters(Handle.l,*params)
PrototypeC BASS_FXGetParameters(Handle.l,*params)
  
Global libBASS = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbass.so")

If Not libBASS 
  libBASS = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbass.so")
  If Not libBASS
    MessageRequester("Library loading error", "Failed to load libbass.so" + Chr(13) + Chr(13) + 
                                            "To solve the problem, open the subfolder 'assets' in your terminal and enter this command:" + Chr(13)+ Chr(13) + 
                                            "sudo cp -avr bass /usr/lib/", #PB_MessageRequester_Error)
    End
  EndIf
EndIf  

Global BASS_SetConfig.BASS_SetConfig = GetFunction(libBASS, "BASS_SetConfig")
Global BASS_GetVersion.BASS_GetVersion = GetFunction(libBASS, "BASS_GetVersion")
Global BASS_ErrorGetCode.BASS_ErrorGetCode = GetFunction(libBASS, "BASS_ErrorGetCode")
Global BASS_Init.BASS_Init = GetFunction(libBASS, "BASS_Init")
Global BASS_Free.BASS_Free = GetFunction(libBASS, "BASS_Free")
Global BASS_SetVolume.BASS_SetVolume = GetFunction(libBASS, "BASS_SetVolume")
Global BASS_StreamCreateFile.BASS_StreamCreateFile = GetFunction(libBASS, "BASS_StreamCreateFile")
Global BASS_StreamFree.BASS_StreamFree = GetFunction(libBASS, "BASS_StreamFree") 
Global BASS_ChannelBytes2Seconds.BASS_ChannelBytes2Seconds = GetFunction(libBASS, "BASS_ChannelBytes2Seconds")
Global BASS_ChannelSeconds2Bytes.BASS_ChannelSeconds2Bytes = GetFunction(libBASS, "BASS_ChannelSeconds2Bytes")
Global BASS_ChannelIsActive.BASS_ChannelIsActive = GetFunction(libBASS, "BASS_ChannelIsActive")
Global BASS_ChannelGetInfo.BASS_ChannelGetInfo = GetFunction(libBASS, "BASS_ChannelGetInfo")
Global BASS_ChannelGetTags.BASS_ChannelGetTags = GetFunction(libBASS, "BASS_ChannelGetTags")
Global BASS_ChannelPlay.BASS_ChannelPlay = GetFunction(libBASS, "BASS_ChannelPlay")
Global BASS_ChannelStop.BASS_ChannelStop = GetFunction(libBASS, "BASS_ChannelStop")
Global BASS_ChannelPause.BASS_ChannelPause = GetFunction(libBASS, "BASS_ChannelPause")
Global BASS_ChannelSetAttribute.BASS_ChannelSetAttribute = GetFunction(libBASS, "BASS_ChannelSetAttribute")
Global BASS_ChannelGetAttribute.BASS_ChannelGetAttribute = GetFunction(libBASS, "BASS_ChannelGetAttribute")
Global BASS_ChannelGetLength.BASS_ChannelGetLength = GetFunction(libBASS, "BASS_ChannelGetLength")
Global BASS_ChannelSetPosition.BASS_ChannelSetPosition = GetFunction(libBASS, "BASS_ChannelSetPosition")
Global BASS_ChannelGetPosition.BASS_ChannelGetPosition = GetFunction(libBASS, "BASS_ChannelGetPosition")
Global BASS_ChannelGetData.BASS_ChannelGetData = GetFunction(libBASS, "BASS_ChannelGetData")
Global BASS_ChannelSetSync.BASS_ChannelSetSync = GetFunction(libBASS, "BASS_ChannelSetSync")
Global BASS_ChannelRemoveSync.BASS_ChannelRemoveSync = GetFunction(libBASS, "BASS_ChannelRemoveSync")
Global BASS_ChannelSetFX.BASS_ChannelSetFX = GetFunction(libBASS, "BASS_ChannelSetFX")
Global BASS_ChannelRemoveFX.BASS_ChannelRemoveFX = GetFunction(libBASS, "BASS_ChannelRemoveFX")
Global BASS_FXSetParameters.BASS_FXSetParameters = GetFunction(libBASS, "BASS_FXSetParameters")
Global BASS_FXGetParameters.BASS_FXGetParameters = GetFunction(libBASS, "BASS_FXGetParameters")
; IDE Options = PureBasic 6.10 LTS (Linux - x64)
; CursorPosition = 759
; FirstLine = 698
; Folding = -
; EnableThread
; EnableXP
; EnableOnError
; Executable = ../../../mixperfect
; CPU = 1
; CompileSourceDirectory
; EnableUnicode