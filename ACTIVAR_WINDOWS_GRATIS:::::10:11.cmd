@echo off
REM Get OS caption and determine version and edition
for /f "skip=1 tokens=*" %%i in ('wmic os get Caption') do (
    set "OSNAME=%%i"
    goto GotOS
)
:GotOS
REM Trim spaces (if needed)
set "OSNAME=%OSNAME%"
REM Determine OS version
echo %OSNAME% | find /I "Windows 11" >nul && (set OSVER=11)
echo %OSNAME% | find /I "Windows 10" >nul && (set OSVER=10)
if "%OSVER%"=="" (
    echo Unsupported OS version.
    exit /b 1
)
REM Set product key based on OS version and edition
if "%OSVER%"=="10" (
    echo %OSNAME% | find /I "Home" >nul && set KEY=MH37W-N47XK-V7XM9-C7227-GCQG9
    echo %OSNAME% | find /I "Pro" >nul && set KEY=W269N-WFGWX-YVC9B-4J6C9-T83GX
    echo %OSNAME% | find /I "Enterprise" >nul && set KEY=NPPR9-FWDCX-D2C8J-H872K-2YT43
    echo %OSNAME% | find /I "Education" >nul && set KEY=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
)
if "%OSVER%"=="11" (
    echo %OSNAME% | find /I "Home" >nul && set KEY=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
    echo %OSNAME% | find /I "Pro" >nul && set KEY=6TP4R-GNPTD-KYYHQ-7B7DP-JPCP9
)
if "%KEY%"=="" (
    echo Unable to detect edition from OS caption.
    pause
    exit /b 1
)

title Activar Windows %OSVER%
color 0a
mode con: cols=70 lines=20

REM Check if the 32-bit version of slmgr.vbs exists
if exist "%SystemRoot%\SysWOW64\slmgr.vbs" (
    goto SYSWOW64
) else (
    goto SYS32
)

:SYSWOW64
cscript //nologo "%SystemRoot%\SysWOW64\slmgr.vbs" /ipk %KEY% >nul
cscript //nologo "%SystemRoot%\SysWOW64\slmgr.vbs" /skms kms8.msguides.com >nul
cscript //nologo "%SystemRoot%\SysWOW64\slmgr.vbs" /ato >nul
exit

:SYS32
cscript //nologo "%SystemRoot%\System32\slmgr.vbs" /ipk %KEY% >nul
cscript //nologo "%SystemRoot%\System32\slmgr.vbs" /skms kms8.msguides.com >nul
cscript //nologo "%SystemRoot%\System32\slmgr.vbs" /ato >nul
exit
