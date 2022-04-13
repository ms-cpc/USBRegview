@ECHO OFF
@setlocal enableextensions
@cd /d "%~dp0
TITLE USBRegview
:: v20220413b
:: Batch file created by Sgt. Mark Southby
:: Eric Zimmermans RLA used to create Clean SYSTEM Hive
:: Nirsoft USBDeview used to load clean SYSTEM hive for analysis
if _%1_==_payload_  goto :payload
:getadmin
    echo %~nx0: ELEVATING TO ADMINISTRATOR PROMPT...
    set vbs=%temp%\getadmin.vbs
    echo Set UAC = CreateObject^("Shell.Application"^)                >> "%vbs%"
    echo UAC.ShellExecute "%~s0", "payload %~sdp0 %*", "", "runas", 1 >> "%vbs%"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
goto :eof
:payload
IF EXIST REG\SYSTEM GOTO logcheck
:notfound
ECHO Place SYSTEM, SYSTEM.LOG1 and SYSTEM.LOG2 into REG directory.
pause
:logcheck
IF EXIST REG\SYSTEM.LOG1 GOTO logcheck2
GOTO notfound
:logcheck2
IF EXIST REG\SYSTEM.LOG2 GOTO chkclean
GOTO notfound
:chkclean
IF EXIST CLEAN\ GOTO found
ECHO Creating clean hive in CLEAN directory
MKDIR CLEAN
GOTO found
:found
ECHO SYSTEM, SYSTEM.LOG1 and SYSTEM.LOG2 located in REG directory.
ECHO CLEAN directory exists
ECHO Replaying SYSTEM transaction logs
BIN\RLA -d REG --out CLEAN
ECHO Clean Hive created in CLEAN directory.
ECHO Loading into USBDeview ...
BIN\USBDeview.exe /regfile CLEAN\reg_SYSTEM
