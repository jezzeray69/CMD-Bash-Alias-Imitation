choice /C 123 /N /M "Select [1/2/3]: "
if errorlevel 3 goto finish
if errorlevel 2 goto terminal

reg query "%REGKEY%" /v AutoRun >nul 2>&1
if not errorlevel 1 (
    call :log "NOTICE: An existing CMD AutoRun entry was found." Yellow
    echo It has NOT been overwritten. See README.md for how to combine commands.
    goto finish
)

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $k='HKCU:\Software\Microsoft\Command Processor'; $p=Join-Path $env:USERPROFILE '.cmd_aliases'; $q=[char]34; $v='if exist '+$q+$p+$q+' doskey /macrofile='+$q+$p+$q; New-Item -Path $k -Force | Out-Null; New-ItemProperty -Path $k -Name AutoRun -Value $v -PropertyType String -Force | Out-Null"
if errorlevel 1 (
    call :log "ERROR: Could not configure CMD AutoRun." Red
    echo The alias file is installed. Use a manual setup method in README.md.
    exit /b 1
)
call :log "CMD AutoRun configured for this user." Green
goto finish

:terminal
call :log "Windows Terminal setup is a manual profile change." Yellow
echo In Windows Terminal, open Settings, select your CMD profile,
echo and configure its Command line as documented in README.md.
goto finish

:finish
echo.
call :log "[4/4] Installation complete." Green
echo New CMD sessions can load the installed macros after startup configuration.
echo To load them into this current CMD session, run:
echo   doskey /macrofile="%TARGET%"
echo.
exit /b 0

:cancelled
call :log "Installation cancelled; no files were changed." Yellow
exit /b 2

:nextBackup
for /L %%N in (1,1,999) do (
    if not exist "%TARGET%.bak.%%N" (
        set "BACKUP=%TARGET%.bak.%%N"
        exit /b 0
    )
)
exit /b 1

:log
powershell -NoProfile -Command "Write-Host '%~1' -ForegroundColor %~2"
exit /b 0
