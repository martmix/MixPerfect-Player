EnableExplicit ;Used to ensure strict coding

#BASSENCODEVERSION		= $02040B00 ;BASSencode API version this include was made for.
#BASSENCODEVERSIONTEXT	= "2.4"
#BASS_ERROR_ACM_CANCEL	= 2000	; ACM codec selection cancelled
#BASS_ERROR_CAST_DENIED	= 2100	; access denied (invalid password)
#BASS_CONFIG_ENCODE_PRIORITY		= $10300
#BASS_CONFIG_ENCODE_QUEUE			= $10301
#BASS_CONFIG_ENCODE_CAST_TIMEOUT	= $10310
#BASS_CONFIG_ENCODE_ACM_LOAD		= $10302
#BASS_CONFIG_ENCODE_CAST_PROXY	= $10311
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
#BASS_ACM_DEFAULT	= 1	; use the format as default selection
#BASS_ACM_RATE		= 2	; only list formats with same sample rate as the source channel
#BASS_ACM_CHANS	= 4	; only list formats with same number of channels (eg. mono/stereo)
#BASS_ACM_SUGGEST	= 8	; suggest a format (HIWORD=format tag)
#BASS_ENCODE_COUNT_IN				= 0	; sent to Encoder
#BASS_ENCODE_COUNT_OUT				= 1	; received from Encoder
#BASS_ENCODE_COUNT_CAST				= 2	; sent to cast server
#BASS_ENCODE_COUNT_QUEUE			= 3	; queued
#BASS_ENCODE_COUNT_QUEUE_LIMIT	= 4	; queue limit
#BASS_ENCODE_COUNT_QUEUE_FAIL		= 5	; failed to queue
#BASS_ENCODE_TYPE_MP3	=	"audio/mpeg"
#BASS_ENCODE_TYPE_OGG	=	"application/ogg"
#BASS_ENCODE_TYPE_AAC	=	"audio/aacp"
#BASS_ENCODE_STATS_SHOUT	= 0	; Shoutcast stats
#BASS_ENCODE_STATS_ICE		= 1	; Icecast mount-point stats
#BASS_ENCODE_STATS_ICESERV	= 2	; Icecast server stats
#BASS_ENCODE_NOTIFY_ENCODER		= 1		; Encoder died
#BASS_ENCODE_NOTIFY_CAST			= 2		; cast server connection died
#BASS_ENCODE_NOTIFY_CAST_TIMEOUT	= $10000	; cast timeout
#BASS_ENCODE_NOTIFY_QUEUE_FULL	= $10001	; queue is out of space
#BASS_ENCODE_NOTIFY_FREE			= $10002	; Encoder has been freed
#BASS_ENCODE_SERVER_NOHTTP			= 1		; no HTTP headers

Prototype.l BASS_Encode_GetVersion()
Prototype.l BASS_Encode_AddChunk(handle.l, *id, *buffer, length.l)
Prototype.l BASS_Encode_IsActive(handle.l)
Prototype.l BASS_Encode_Stop(handle.l)
Prototype.l BASS_Encode_StopEx(handle.l, queue.l)
Prototype.l BASS_Encode_SetPaused(handle.l, paused.l)
Prototype.l BASS_Encode_Write(handle.l, *buffer, length.l)
Prototype.l BASS_Encode_SetNotify(handle.l, *proc, *user)
Prototype.q BASS_Encode_GetCount(handle.l, count.l)
Prototype.l BASS_Encode_SetChannel(handle.l, channel.l)
Prototype.l BASS_Encode_GetChannel(handle.l)
Prototype.l BASS_Encode_CastInit(handle.l, server.p-ascii, pass.p-ascii, content.p-ascii, name.p-ascii, url.p-ascii, genre.p-ascii, desc.p-ascii, headers.p-ascii, bitrate.l, pub.l)
Prototype.l BASS_Encode_CastSetTitle(handle.l, title.p-ascii, url.p-ascii)
Prototype.l BASS_Encode_CastSendMeta(handle.l, type.l, *data, length.l)
Prototype.i BASS_Encode_CastGetStats(handle.l, type.l, pass.p-ascii)
Prototype.l BASS_Encode_ServerInit(handle.l, port.p-ascii, buffer.l, burst.l, flags.l, *proc, *user)
Prototype.l BASS_Encode_ServerKick(handle.l, client.p-ascii)
Prototype.l BASS_Encode_Start(handle.l, *cmdline, flags.l, *proc, *user)
Prototype.b BASS_Encode_UserOutput(handle.l, offset.q, buffer.l, length.l)   
Prototype.b BASS_Encode_StartUser(handle.l, *filename, flags.l, *proc, *user)

; BASS_Encode_Load_Library

Threaded _BASS_Encode_Load_Library_DLL_.i

Procedure BASS_Encode_Free_Library()
	If IsLibrary(_BASS_Encode_Load_Library_DLL_)
		CloseLibrary(_BASS_Encode_Load_Library_DLL_)
	EndIf
EndProcedure

Procedure.i BASS_Encode_Load_Library(dllpath$)
	Protected dll.i, result.i

	If IsLibrary(_BASS_Encode_Load_Library_DLL_)
		ProcedureReturn #False
	EndIf

	_BASS_Encode_Load_Library_DLL_ = OpenLibrary(#PB_Any, dllpath$)

	dll = _BASS_Encode_Load_Library_DLL_

	If IsLibrary(dll) = #False
		ProcedureReturn #False
	EndIf

	GetFunctionProto(dll, BASS_Encode_GetVersion)

	If BASS_Encode_GetVersion = #Null
		;BASS_GetVersion() not found, is this really bassencdll ?
		BASS_Encode_Free_Library()
		ProcedureReturn #False
	EndIf

	;Make sure BASSenc API and bassenc.dll are compatible.

	result = BASS_Encode_GetVersion()

	If (result & $FFFF0000) <> (#BASSENCODEVERSION & $FFFF0000) Or (result < #BASSENCODEVERSION)
		BASS_Encode_Free_Library()
		ProcedureReturn #False
	EndIf

	GetFunctionProto(dll, BASS_Encode_AddChunk)
	GetFunctionProto(dll, BASS_Encode_IsActive)
	GetFunctionProto(dll, BASS_Encode_Stop)
	GetFunctionProto(dll, BASS_Encode_StopEx)
	GetFunctionProto(dll, BASS_Encode_SetPaused)
	GetFunctionProto(dll, BASS_Encode_Write)
	GetFunctionProto(dll, BASS_Encode_SetNotify)
	GetFunctionProto(dll, BASS_Encode_GetCount)
	GetFunctionProto(dll, BASS_Encode_SetChannel)
	GetFunctionProto(dll, BASS_Encode_GetChannel)
	;GetFunctionProto(dll, BASS_Encode_StartACM)
  GetFunctionProto(dll, BASS_Encode_Start)
	;GetFunctionProto(dll, BASS_Encode_StartLimit)
	;GetFunctionProto(dll, BASS_Encode_GetACMFormat)
	;GetFunctionProto(dll, BASS_Encode_StartACMFile)
	GetFunctionProto(dll, BASS_Encode_CastInit)
	GetFunctionProto(dll, BASS_Encode_CastSetTitle)
	GetFunctionProto(dll, BASS_Encode_CastSendMeta)
	GetFunctionProto(dll, BASS_Encode_CastGetStats)
  GetFunctionProto(dll, BASS_Encode_ServerInit)
	GetFunctionProto(dll, BASS_Encode_ServerKick)
	GetFunctionProto(dll, BASS_Encode_UserOutput) 
	GetFunctionProto(dll,BASS_Encode_StartUser)
	ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 6.04 LTS (Windows - x64)
; CursorPosition = 137
; FirstLine = 86
; Folding = -
; EnableXP