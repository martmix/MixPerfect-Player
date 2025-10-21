; 	BASSenc 2.4 C/C++ header file
; 	Copyright (c) 2003-2014 Un4seen Developments Ltd.
; 
; 	See the BASSENC.CHM file for more detailed documentation
;
;	BASSenc v2.4.12.x Windows include for PureBasic v5.31
;	C to PB adaption by Roger Hågensen, 2015-03-22, http://forums.purebasic.com/
;
;	Changes from last update to the PB include files:
;	p-ascii pseudotype changed to p-utf8.
;	File changed to match bassenc.h more closely.
;	MacOS had some fucnction prototypes excluded by mistake.
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
;HENCODE is a long,	Encoder handle

EnableExplicit ;Used to ensure strict coding

;- BASSencode version constants
#BASSENCODEVERSION		= $02040C00 ;BASSencode API version this include was made for.
#BASSENCODEVERSIONTEXT	= "2.4"

; Additional error codes returned by BASS_ErrorGetCode
#BASS_ERROR_ACM_CANCEL	= 2000	; ACM codec selection cancelled
#BASS_ERROR_CAST_DENIED	= 2100	; access denied (invalid password)

; Additional BASS_SetConfig options
#BASS_CONFIG_ENCODE_PRIORITY		= $10300
#BASS_CONFIG_ENCODE_QUEUE			= $10301
#BASS_CONFIG_ENCODE_CAST_TIMEOUT	= $10310

; Additional BASS_SetConfigPtr options
#BASS_CONFIG_ENCODE_ACM_LOAD		= $10302
#BASS_CONFIG_ENCODE_CAST_PROXY	= $10311

; BASS_Encode_Start flags
#BASS_ENCODE_NOHEAD			= 1		; don't send a WAV header to the Encoder
#BASS_ENCODE_FP_8BIT			= 2		; convert floating-point sample data to 8-bit integer
#BASS_ENCODE_FP_16BIT		= 4		; convert floating-point sample data to 16-bit integer
#BASS_ENCODE_FP_24BIT		= 6		; convert floating-point sample data to 24-bit integer
#BASS_ENCODE_FP_32BIT		= 8		; convert floating-point sample data to 32-bit integer
#BASS_ENCODE_BIGEND			= 16		; big-endian sample data
#BASS_ENCODE_PAUSE			= 32		; start encording paused
#BASS_ENCODE_PCM				= 64		; write PCM sample data (no Encoder)
#BASS_ENCODE_RF64				= 128		; send an RF64 header
#BASS_ENCODE_MONO				= $100	; convert to mono (if not already)
#BASS_ENCODE_QUEUE			= $200	; queue data to feed Encoder asynchronously
#BASS_ENCODE_WFEXT			= $400	; WAVEFORMATEXTENSIBLE "fmt" chunk
#BASS_ENCODE_CAST_NOLIMIT	= $1000	; don't limit casting data rate
#BASS_ENCODE_LIMIT			= $2000	; limit data rate to real-time
#BASS_ENCODE_AIFF				= $4000	; send an AIFF header rather than WAV
#BASS_ENCODE_AUTOFREE		= $40000	; free the Encoder when the channel is freed

; BASS_Encode_GetACMFormat flags
#BASS_ACM_DEFAULT	= 1	; use the format as default selection
#BASS_ACM_RATE		= 2	; only list formats with same sample rate as the source channel
#BASS_ACM_CHANS	= 4	; only list formats with same number of channels (eg. mono/stereo)
#BASS_ACM_SUGGEST	= 8	; suggest a format (HIWORD=format tag)

; BASS_Encode_GetCount counts
#BASS_ENCODE_COUNT_IN				= 0	; sent to Encoder
#BASS_ENCODE_COUNT_OUT				= 1	; received from Encoder
#BASS_ENCODE_COUNT_CAST				= 2	; sent to cast server
#BASS_ENCODE_COUNT_QUEUE			= 3	; queued
#BASS_ENCODE_COUNT_QUEUE_LIMIT	= 4	; queue limit
#BASS_ENCODE_COUNT_QUEUE_FAIL		= 5	; failed to queue

; BASS_Encode_CastInit content MIME types
#BASS_ENCODE_TYPE_MP3	=	"audio/mpeg"
#BASS_ENCODE_TYPE_OGG	=	"application/ogg"
#BASS_ENCODE_TYPE_AAC	=	"audio/aacp"

; BASS_Encode_CastGetStats types
#BASS_ENCODE_STATS_SHOUT	= 0	; Shoutcast stats
#BASS_ENCODE_STATS_ICE		= 1	; Icecast mount-point stats
#BASS_ENCODE_STATS_ICESERV	= 2	; Icecast server stats

; typedef void (CALLBACK ENCODEPROC(HENCODE handle, DWORD channel, const void *buffer, DWORD length, void *user)
; /* Encoding callback function.
; handle : The Encode
; channel: The channel handle
; buffer : Buffer containing the encoded data
; length : Number of bytes
; user   : The 'user' parameter value given when calling BASS_Encode_Start */

; typedef void (CALLBACK ENCODEPROCEX(HENCODE handle, DWORD channel, const void *buffer, DWORD length, QWORD offset, void *user)
; /* Encoding callback function with offset info.
; handle : The Encoder
; channel: The channel handle
; buffer : Buffer containing the encoded data
; length : Number of bytes
; offset : File offset of the data
; user   : The 'user' parameter value given when calling BASS_Encode_StartCA */

; typedef BOOL (CALLBACK ENCODECLIENTPROC(HENCODE handle, BOOL connect, const char *client, char *headers, void *user)
; /* Client connection notification callback function.
; handle : The Encoder
; connect: TRUE/FALSE=client is connecting/disconnecting
; client : The client's address (xxx.xxx.xxx.xxx:port)
; headers: Request headers (optionally response headers on return)
; user   : The 'user' parameter value given when calling BASS_Encode_ServerInit
; RETURN : TRUE/FALSE=accept/reject connection (ignored if connect=FALSE) */

; typedef void (CALLBACK ENCODENOTIFYPROC(HENCODE handle, DWORD status, void *user)
; /* Encoder death notification callback function.
; handle : The Encoder
; status : Notification (BASS_ENCODE_NOTIFY_xxx)
; user   : The 'user' parameter value given when calling BASS_Encode_SetNotify */

; Encoder notifications
#BASS_ENCODE_NOTIFY_ENCODER		= 1		; Encoder died
#BASS_ENCODE_NOTIFY_CAST			= 2		; cast server connection died
#BASS_ENCODE_NOTIFY_CAST_TIMEOUT	= $10000	; cast timeout
#BASS_ENCODE_NOTIFY_QUEUE_FULL	= $10001	; queue is out of space
#BASS_ENCODE_NOTIFY_FREE			= $10002	; Encoder has been freed

; BASS_Encode_ServerInit flags
#BASS_ENCODE_SERVER_NOHTTP			= 1		; no HTTP headers

PrototypeC BASS_Encode_GetVersion()
PrototypeC BASS_Encode_Start(handle.l, *cmdline, flags.l, *proc, *user)
PrototypeC BASS_Encode_Stop(handle.l)
PrototypeC BASS_Encode_Write(handle.l, *buffer, length.l)

Global libBASSEnc = OpenLibrary(#PB_Any, GetPathPart(ProgramFilename()) + "assets/bass/linux/libbassenc.so")
If Not libBASSEnc 
  libBASSEnc = OpenLibrary(#PB_Any, "/usr/lib/bass/linux/libbass.so")
  If Not libBASSEnc
    MessageRequester("Library loading error", "Failed to load libbassenc.so" + Chr(13) + Chr(13) + 
                                            "To solve the problem, open the subfolder 'assets' in your terminal and enter this command:" + Chr(13)+ Chr(13) + 
                                            "sudo cp -avr bass /usr/lib/", #PB_MessageRequester_Error)
    End
  EndIf
EndIf

Global BASS_Encode_GetVersion.BASS_Encode_GetVersion = GetFunction(libBASSEnc, "BASS_Encode_GetVersion")
Global BASS_Encode_Start.BASS_Encode_Start = GetFunction(libBASSEnc, "BASS_Encode_Start")
Global BASS_Encode_Stop.BASS_Encode_Stop = GetFunction(libBASSEnc, "BASS_Encode_Stop")
Global BASS_Encode_Write.BASS_Encode_Write = GetFunction(libBASSEnc, "BASS_Encode_Write")
; IDE Options = PureBasic 6.03 LTS (Linux - x64)
; CursorPosition = 149
; FirstLine = 102
; EnableXP
; EnableUser
; CPU = 1
; SubSystem = .
; CompileSourceDirectory
; EnableCompileCount = 7
; EnableBuildCount = 0
; EnableExeConstant
; EnableUnicode