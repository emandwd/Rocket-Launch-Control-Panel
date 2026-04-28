; Include file for Irvine32.lib
INCLUDE Irvine32.inc

WinExec PROTO, lpCmdLine:PTR BYTE, uCmdShow:DWORD
Beep    PROTO, dwFreq:DWORD, dwDuration:DWORD
ExitProcess PROTO, dwExitCode:DWORD

.data

titleMsg BYTE "==============================================",0dh,0ah, \
             "        ROCKET LAUNCH CONTROL PANEL",0dh,0ah, \
             "==============================================",0dh,0ah,0

controls BYTE 0dh,0ah, \
"[F] Enable Fuel System",0dh,0ah, \
"[E] Enable Engine System",0dh,0ah, \
"[S] Enable Safety Lock",0dh,0ah, \
"[L] Launch Rocket",0dh,0ah, \
"[A] Abort Mission",0dh,0ah,0

fuelOnMsg     BYTE "Fuel System ENABLED",0dh,0ah,0
engineOnMsg   BYTE "Engine System READY",0dh,0ah,0
safetyMsg     BYTE "Safety Lock ACTIVATED",0dh,0ah,0
launchBlocked BYTE "Launch Blocked - System Is Not Ready",0dh,0ah,0
authMsg       BYTE "Enter Launch Authorization Code: ",0
deniedMsg     BYTE "ACCESS DENIED",0dh,0ah,0
grantedMsg    BYTE "ACCESS GRANTED",0dh,0ah,0
countMsg      BYTE "Starting Countdown...",0dh,0ah,0
abortMsg      BYTE "!!! LAUNCH ABORTED !!!",0dh,0ah,0
igniteMsg     BYTE "IGNITION STARTED",0dh,0ah,0
successMsg    BYTE "ROCKET LAUNCHED SUCCESSFULLY",0dh,0ah,0

telemetryTitle BYTE 0dh,0ah,"====== ROCKET TELEMETRY ======",0dh,0ah,0
altLabel BYTE "Altitude: ",0
speedLabel BYTE "Speed: ",0
fuelLabel BYTE "Fuel: ",0
percent BYTE " %",0
meter BYTE " m",0
kmh BYTE " km/h",0

fuelState   BYTE 0
engineState BYTE 0
safetyState BYTE 0

authCode DWORD 1234

altitude DWORD 0
speed DWORD 0
fuel DWORD 100

; ---------- SPEECH ----------
speakFuel        BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Fuel system enabled')""",0
speakEngine      BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Engine system ready')""",0
speakSafety      BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Safety Lock Activated')""",0
speakLaunch      BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Launch sequence initiated')""",0
speakAbort       BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Launch aborted')""",0
speakIgnition    BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Ignition Started')""",0
speakSuccess     BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Rocket Launched Successfully')""",0
speakBlock       BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Launch Blocked - System Is Not Ready')""",0
speakAuthPrompt  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Enter Launch Authorization Code')""",0
speakGranted     BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Access Granted')""",0
speakDenied      BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Access Denied')""",0

speak10 BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Ten')""",0
speak9  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Nine')""",0
speak8  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Eight')""",0
speak7  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Seven')""",0
speak6  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Six')""",0
speak5  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Five')""",0
speak4  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Four')""",0
speak3  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Three')""",0
speak2  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('Two')""",0
speak1  BYTE "powershell -Command ""Add-Type -AssemblyName System.Speech;(New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('One')""",0

spaces BYTE "       ",0

countVal DWORD 0

.code

; ---------------- CHECK ABORT (FIXED) ----------------
CheckAbort PROC
    call KeyPressed
    jz  CADone
    call ReadKey
    cmp al, 'a'
    jne CADone

    mov eax, red
    call SetTextColor
    mov edx, OFFSET abortMsg
    call WriteString
    INVOKE WinExec, ADDR speakAbort, 1
    INVOKE Beep, 900, 200
    INVOKE Beep, 900, 200
    INVOKE Beep, 900, 200
    INVOKE ExitProcess, 0

; ---------------- IGNITION ----------------
Ignition PROC
    mov eax, green
    call SetTextColor
    mov edx, OFFSET igniteMsg
    call WriteString
    INVOKE WinExec, ADDR speakIgnition, 1
    mov eax, 1800      ; 1800 milliseconds
    call Delay
    mov edx, OFFSET successMsg
    call WriteString
    INVOKE WinExec, ADDR speakSuccess, 1
    mov eax, 1800      ; 1800 milliseconds
    call Delay
    call ShowTelemetry
    ret
Ignition ENDP

; ---------------- ALARM ----------------
Alarm PROC
    INVOKE Beep, 900, 200
    INVOKE Beep, 900, 200
    INVOKE Beep, 900, 200
    ret
Alarm ENDP

; ---------------- MAIN ----------------
main PROC
    call Clrscr
    mov edx, OFFSET titleMsg
    call WriteString
    mov edx, OFFSET controls
    call WriteString

MainLoop:
    call ReadKey
    jz   MainLoop       

    cmp al, 'f'
    je  FuelOn
    cmp al, 'e'
    je  EngineOn
    cmp al,'s'
    je SafetyOn
    cmp al, 'l'
    je  Launch
    cmp al, 'a'
    je  AbortNow
    jmp MainLoop

; -------- Fuel --------
FuelOn:
    mov fuelState, 1
    mov eax, green
    call SetTextColor
    mov edx, OFFSET fuelOnMsg
    call WriteString
    push ecx                            
    INVOKE WinExec, ADDR speakFuel, 1
    pop ecx                             
    jmp MainLoop

; -------- Engine --------
EngineOn:
    mov engineState, 1
    mov eax, green
    call SetTextColor
    mov edx, OFFSET engineOnMsg
    call WriteString
    push ecx
    INVOKE WinExec, ADDR speakEngine, 1
    pop ecx
    jmp MainLoop

; -------- Safety --------
SafetyOn:
    mov safetyState,1
    mov eax,green
    call SetTextColor
    mov edx,OFFSET safetyMsg
    call WriteString
    push ecx
    INVOKE WinExec,ADDR speakSafety,1
    pop ecx
    jmp MainLoop

; -------- Launch --------
Launch:
    cmp fuelState, 1
    jne Block
    cmp engineState, 1
    jne Block
    cmp safetyState,1
    jne Block

AuthLoop:
    mov edx,OFFSET authMsg
    call WriteString
    push ecx
    INVOKE WinExec,ADDR speakAuthPrompt,1
    pop ecx
    call ReadDec
    cmp eax,authCode
    jne AccessDenied
    mov eax,green
    call SetTextColor
    mov edx,OFFSET grantedMsg
    call WriteString
    push ecx
    INVOKE WinExec,ADDR speakGranted,1
    pop ecx
    mov eax, 1800      ; 1800 milliseconds
    call Delay
    mov edx, OFFSET countMsg
    call WriteString
    push ecx
    INVOKE WinExec, ADDR speakLaunch, 1
    mov eax, 2500      ; 2500 milliseconds
    call Delay
    pop ecx

    call ReadKeyFlush

    mov countVal, 10        

CountdownLoop:
    call CheckAbort         
    ; Print current number
    mov eax, countVal
    call WriteDec
    call Crlf

    cmp eax,10
    je SpeakTen
    cmp eax,9
    je SpeakNine
    cmp eax,8
    je SpeakEight
    cmp eax,7
    je SpeakSeven
    cmp eax,6
    je SpeakSix
    cmp eax,5
    je SpeakFive
    cmp eax,4
    je SpeakFour
    cmp eax,3
    je SpeakThree
    cmp eax,2
    je SpeakTwo
    cmp eax,1
    je SpeakOne
    
AfterSpeak:

    mov eax,1000
    call Delay
    dec countVal
    cmp countVal,0
    jg CountdownLoop
    call Ignition
    jmp MainLoop

AccessDenied:

    mov eax,red
    call SetTextColor
    mov edx,OFFSET deniedMsg
    call WriteString
    push ecx
    INVOKE WinExec,ADDR speakDenied,1
    pop ecx
    call Alarm
    mov eax, 1800      ; 1800 milliseconds
    call Delay
    jmp AuthLoop

Block:
    mov eax, red
    call SetTextColor
    mov edx, OFFSET launchBlocked
    call WriteString
    INVOKE WinExec, ADDR speakBlock, 1
    call Alarm
    jmp MainLoop

AbortNow:
    mov eax, red
    call SetTextColor
    mov edx, OFFSET abortMsg
    call WriteString
    push ecx
    INVOKE WinExec, ADDR speakAbort, 1
    pop ecx
    call Alarm
    INVOKE ExitProcess, 0

SpeakTen:   INVOKE WinExec, ADDR speak10,1   ; speech
            jmp AfterSpeak
SpeakNine:  INVOKE WinExec, ADDR speak9,1
            jmp AfterSpeak
SpeakEight: INVOKE WinExec, ADDR speak8,1
            jmp AfterSpeak
SpeakSeven: INVOKE WinExec, ADDR speak7,1
            jmp AfterSpeak
SpeakSix:   INVOKE WinExec, ADDR speak6,1
            jmp AfterSpeak
SpeakFive:  INVOKE WinExec, ADDR speak5,1
            jmp AfterSpeak
SpeakFour:  INVOKE WinExec, ADDR speak4,1
            jmp AfterSpeak
SpeakThree: INVOKE WinExec, ADDR speak3,1
            jmp AfterSpeak
SpeakTwo:   INVOKE WinExec, ADDR speak2,1
            jmp AfterSpeak
SpeakOne:   INVOKE WinExec, ADDR speak1,1
            jmp AfterSpeak

main ENDP
END main
CADone:
    ret
CheckAbort ENDP
