@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..\..") do set "WORKSPACE_ROOT=%%~fI"
set "AMUTORRENT_ROOT=%WORKSPACE_ROOT%\repos\amutorrent"

if not exist "%AMUTORRENT_ROOT%\server\server.js" (
    echo ERROR: aMuTorrent checkout was not found at "%AMUTORRENT_ROOT%".
    exit /b 1
)

if not defined AMUTORRENT_NODE_EXE (
    if exist "C:\bin\nodejs-v22-old\node.exe" (
        set "AMUTORRENT_NODE_EXE=C:\bin\nodejs-v22-old\node.exe"
    ) else (
        set "AMUTORRENT_NODE_EXE=node"
    )
)

for %%I in ("%AMUTORRENT_NODE_EXE%") do set "AMUTORRENT_NODE_DIR=%%~dpI"
if not "%AMUTORRENT_NODE_DIR%"=="" if exist "%AMUTORRENT_NODE_DIR%node.exe" set "PATH=%AMUTORRENT_NODE_DIR%;%PATH%"

for /f "usebackq delims=" %%V in (`"%AMUTORRENT_NODE_EXE%" -v 2^>nul`) do set "AMUTORRENT_NODE_VERSION=%%V"
if not defined AMUTORRENT_NODE_VERSION (
    echo ERROR: Could not run Node with AMUTORRENT_NODE_EXE="%AMUTORRENT_NODE_EXE%".
    echo Set AMUTORRENT_NODE_EXE to a Node 20-22 node.exe path.
    exit /b 1
)

for /f "tokens=1 delims=." %%M in ("%AMUTORRENT_NODE_VERSION:v=%") do set "AMUTORRENT_NODE_MAJOR=%%M"
if %AMUTORRENT_NODE_MAJOR% LSS 20 (
    echo ERROR: aMuTorrent requires Node 20-22. "%AMUTORRENT_NODE_EXE%" reports %AMUTORRENT_NODE_VERSION%.
    exit /b 1
)
if %AMUTORRENT_NODE_MAJOR% GTR 22 (
    echo ERROR: aMuTorrent server dependencies are pinned for Node 20-22. "%AMUTORRENT_NODE_EXE%" reports %AMUTORRENT_NODE_VERSION%.
    echo Use C:\bin\nodejs-v22-old\node.exe or set AMUTORRENT_NODE_EXE to a Node 22 runtime.
    exit /b 1
)

if not defined PORT set "PORT=4000"
if not defined BIND_ADDRESS set "BIND_ADDRESS=127.0.0.1"

pushd "%AMUTORRENT_ROOT%" || exit /b 1

if not exist "server\node_modules\express" goto :install_server_deps
if not exist "server\node_modules\better-sqlite3" goto :install_server_deps
goto :server_deps_done

:install_server_deps
    echo Installing aMuTorrent server dependencies with %AMUTORRENT_NODE_VERSION%...
    call "%AMUTORRENT_NODE_DIR%npm.cmd" ci --prefix server --omit=dev
    if errorlevel 1 goto :fail

:server_deps_done

if not exist "node_modules\esbuild" (
    echo Installing aMuTorrent frontend dependencies with %AMUTORRENT_NODE_VERSION%...
    call "%AMUTORRENT_NODE_DIR%npm.cmd" install
    if errorlevel 1 goto :fail
)

if not exist "static\dist\app.bundle.js" goto :build_frontend
if not exist "static\output.css" goto :build_frontend
goto :frontend_done

:build_frontend
    echo Building aMuTorrent frontend assets...
    call "%AMUTORRENT_NODE_DIR%npm.cmd" run build
    if errorlevel 1 goto :fail

:frontend_done

echo Starting aMuTorrent on http://%BIND_ADDRESS%:%PORT% with %AMUTORRENT_NODE_VERSION%...
echo Press Ctrl+C to stop.
"%AMUTORRENT_NODE_EXE%" server\server.js %*
set "exit_code=%ERRORLEVEL%"
popd
endlocal & exit /b %exit_code%

:fail
set "exit_code=%ERRORLEVEL%"
popd
endlocal & exit /b %exit_code%
