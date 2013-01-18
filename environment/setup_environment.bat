@cls
@echo off

setlocal ENABLEDELAYEDEXPANSION

REM don't bother setting up an environment if we're not interactive
echo %CMDCMDLINE% | find /i "/c" >nul
if not errorlevel 1 goto exit



REM welcome message (first to promote the sense of being fast)
for /f "tokens=1 delims=:" %%j in ('ping %computername% -4 -n 1 ^| findstr Reply') do (
    set localip=%%j
)
echo [%1] %computername% (%localip:~11%)


REM startup dir
cd c:\

REM always use pushd
doskey dirs=pushd
doskey pd=popd $*
doskey cd=%~dp0pushd_cd_alias $*

REM set up msls
doskey ls=%~dp0msls\ls.exe $*

REM emulate a bit of linux
doskey cat=type $*
doskey mv=move $*

REM enable ansi colors
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    %~dp0ansicon\x86\ansicon.exe -p
) else (
    %~dp0ansicon\x64\ansicon.exe -p
)

REM environment variables
endlocal
set PATH=%PATH%;%~dp0bin
set CONSOLE_NR=%1

REM run clink (this HAS to be the last command, that's why we already put echo to on)
echo on
@%~dp0clink\clink.bat inject --quiet --profile %~dp0clink_profile --scripts %~dp0clink_scripts


:exit