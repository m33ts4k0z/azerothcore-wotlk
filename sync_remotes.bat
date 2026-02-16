@echo off
SETLOCAL EnableExtensions

echo [1/4] Checking for uncommitted changes...
git status --porcelain | findstr /R "^" >nul
if %ERRORLEVEL% equ 0 (
    echo ERROR: You have uncommitted changes. Please commit or stash them first.
    exit /b 1
)

echo [2/4] Fetching remotes...
git fetch ac
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%
git fetch playerbots
if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

echo [3/4] Merging ac/master...
git merge ac/master --no-edit
if %ERRORLEVEL% neq 0 (
    echo CONFLICT: Detected in ac/master. Aborting merge.
    git merge --abort
    exit /b 1
)

echo [4/4] Merging playerbots/Playerbot...
git merge playerbots/Playerbot --no-edit
if %ERRORLEVEL% neq 0 (
    echo CONFLICT: Detected in playerbots/Playerbot. Aborting merge.
    git merge --abort
    exit /b 1
)

echo SUCCESS: All changes merged successfully.
