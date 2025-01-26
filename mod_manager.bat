@echo off
@title FurkisPack Manager
setlocal enabledelayedexpansion

:mainmenu
cls
echo =======================================
echo       FurkisPack Management Tool
echo =======================================
echo 1. Install FurkisPack
echo 2. Update FurkisPack
echo 3. Clear FurkisPack Mod
echo 4. Exit
echo =======================================
set /p choice=Enter your choice [1-4]: 

if "%choice%"=="1" goto install
if "%choice%"=="2" goto update
if "%choice%"=="3" goto clear
if "%choice%"=="4" exit
echo Invalid choice! Please try again.
pause
goto mainmenu

:find_path
rem Kayıt defterinden Lethal Company'nin dizinini bul
set "target=HKEY_CURRENT_USER\System\GameConfigStore\Children"
set "searchValue=Lethal Company"
set "gameDir="

for /f "tokens=*" %%A in ('reg query "%target%"') do (
    for /f "tokens=*" %%B in ('reg query "%%A" /v ExeParentDirectory 2^>nul ^| find /i "%searchValue%"') do (
        for /f "tokens=2*" %%C in ('reg query "%%A" /v MatchedExeFullPath 2^>nul ^| find "MatchedExeFullPath"') do (
            set "fullPath=%%D"
            for %%E in ("!fullPath!") do set "gameDir=%%~dpE"
        )
    )
)

if "%gameDir%"=="" (
    echo Failed to locate Lethal Company directory. Exiting...
    pause
    goto mainmenu
)

echo Found game directory: %gameDir%
goto :eof

:install
@title Installing FurkisPack
call :find_path

echo Installing Git...
winget install --id Git.Git -e --source winget

if exist "C:\Program Files\Git\bin\git.exe" (
    set "PATH=%PATH%;C:\Program Files\Git\bin"
) else if exist "C:\Program Files (x86)\Git\bin\git.exe" (
    set "PATH=%PATH%;C:\Program Files (x86)\Git\bin"
) else (
    echo Git installation failed or not added to PATH. Exiting...
    pause
    goto mainmenu
)

@title Completed!
echo Installation completed!

:update
@title Updating FurkisPack

if "%gameDir%"=="" (
    call :find_path
)

echo Updating FurkisPack...

rem Check if Git exists in PATH
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Git not found! Please select 'Install FurkisPack' first to install Git.
    echo.
    pause
    goto mainmenu
)

rem Git işlemleri oyun dizininde yapılacak
cd /d "%gameDir%"

if not exist ".git" (
    echo .git folder not found. Initializing repository...
    git init
    git remote add origin https://github.com/furkanaliunal/lethal_company_mod_pack.git
)

echo Fetching updates...
git fetch origin
git reset --hard origin/main

if exist ".gitignore" (
    git clean -fd
) else (
    echo Fetching failed somehow. Ask for support. Exiting...
    pause
    goto mainmenu
)

@title Update Completed!
echo Update process completed!
pause
goto mainmenu

:clear
@title Clearing FurkisPack Mod
call :find_path

echo Switching to no-mod branch...
cd /d "%gameDir%"
git reset --hard origin/no-mod

@title Completed!
echo Mod pack deactivated successfully!
pause
goto mainmenu
