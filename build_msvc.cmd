@echo off
REM build_msvc.cmd - cnc-ddraw MSVC build (local VS 18 Community, no downloads)
setlocal
cd /d "%~dp0"

set VSDIR=C:\Program Files\Microsoft Visual Studio\18\Community
call "%VSDIR%\VC\Auxiliary\Build\vcvars32.bat" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] vcvars32 failed
    exit /b 1
)

for /f %%i in ('git describe --match NeVeRmAtCh --always --dirty 2^>nul') do set COMMIT=%%i
for /f %%i in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set BRANCH=%%i
if "%COMMIT%"=="" set COMMIT=UNKNOWN
if "%BRANCH%"=="" set BRANCH=UNKNOWN
> inc\git.h echo #define GIT_COMMIT "%COMMIT%"
>> inc\git.h echo #define GIT_BRANCH "%BRANCH%"

rc /nologo /fo res.res res.rc
if errorlevel 1 (
    echo [ERROR] rc failed
    exit /b 1
)

cl /nologo /LD /MT /O2 /W0 /D_WIN32_WINNT=0x0501 /D_CRT_SECURE_NO_WARNINGS /Iinc /Isrc\detours src\*.c src\IAMMediaStream\*.c src\IDirect3D\*.c src\IDirectDraw\*.c src\detours\creatwth.cpp src\detours\detours.cpp src\detours\disasm.cpp src\detours\image.cpp src\detours\modules.cpp res.res /Feddraw.dll /link /DEF:exports.def /SUBSYSTEM:WINDOWS gdi32.lib winmm.lib ole32.lib msimg32.lib avifil32.lib uuid.lib user32.lib kernel32.lib advapi32.lib
if errorlevel 1 (
    echo [ERROR] cl link failed
    exit /b 1
)

echo [OK] ddraw_msvc.dll built
dir /b ddraw_msvc.dll
endlocal
