@echo off
@title FurkisPack Manager

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

:install
@title Installing FurkisPack
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
pause
goto mainmenu

:update
@title Updating FurkisPack
echo Updating FurkisPack...

REM Check if Git exists in PATH
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Git not found! Please select 'Install FurkisPack' first to install Git.
    echo.
    pause
    goto mainmenu
)

if not exist ".git" (
    echo .git folder not found. Initializing repository...
    git init
    git remote add origin https://github.com/furkanaliunal/lethal_company_mod_pack.git
)

echo Fetching updates...
git fetch origin
git reset --hard origin/main
git clean -fd

@title Update Completed!
echo Update process completed!
pause
goto mainmenu

:clear
@title Clearing FurkisPack Mod
echo Switching to no-mod branch...
git reset --hard origin/no-mod

@title Completed!
echo Mod pack deactivated successfully!
pause
goto mainmenu
