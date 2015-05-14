@echo off

SETLOCAL
SET MOZ_MSVCVERSION=9
SET MOZBUILDDIR=C:\mozilla-build\
SET MOZILLABUILD=%MOZBUILDDIR%

echo "Mozilla tools directory: %MOZBUILDDIR%"

REM Get MSVC paths
call "%MOZBUILDDIR%guess-msvc.bat"

REM Use the "new" moztools-static
set MOZ_TOOLS=%MOZBUILDDIR%moztools

rem append moztools to PATH
SET PATH=%PATH%;%MOZ_TOOLS%\bin

if "%VC9DIR%"=="" (
    if "%VC9EXPRESSDIR%"=="" (
        ECHO "Microsoft Visual C++ version 9 (2008) was not found. Exiting."
        pause
        EXIT /B 1
    )

    if "%SDKDIR%"=="" (
        ECHO "Microsoft Platform SDK was not found. Exiting."
        pause
        EXIT /B 1
    )

    rem Prepend MSVC paths
    call "%VC9EXPRESSDIR%\Bin\vcvars32.bat" 2>nul
    if "%DevEnvDir%"=="" (
      rem Might be using a compiler that shipped with an SDK, so manually set paths
      SET "PATH=%VC9EXPRESSDIR%\Bin;%VC9EXPRESSDIR%\..\Common7\IDE;%PATH%"
      SET "INCLUDE=%VC9EXPRESSDIR%\Include;%VC9EXPRESSDIR%\Include\Sys;%INCLUDE%"
      SET "LIB=%VC9EXPRESSDIR%\Lib;%LIB%"
    )

    rem Don't set SDK paths in this block, because blocks are early-evaluated.

    rem Fix problem with VC++Express Edition
    if "%SDKVER%" GEQ "6" (
        rem SDK Ver.6.0 (Windows Vista SDK) and newer
        rem do not contain ATL header files.
        rem We need to use the Platform SDK's ATL header files.
        SET USEPSDKATL=1
    )
    rem SDK ver.6.0 does not contain OleAcc.idl
    rem We need to use the Platform SDK's OleAcc.idl
    if "%SDKVER%" == "6" (
        if "%SDKMINORVER%" == "0" (
          SET USEPSDKIDL=1
        )
    )
) else (
    rem Prepend MSVC paths
    rem If the SDK is Win2k8, we want to use it.
    rem The Win7 SDK (or newer) should automatically integrate itself into vcvars32.bat
    if "%SDKVER%" == "6" (
        if "%SDKMINORVER%" == "1" (
          SET USESDK=1
        )
    )
    if "%USESDK%" == "0" (
        ECHO Using VC 2008 built-in SDK
    )
    call "%VC9DIR%\Bin\vcvars32.bat"
)

if "%VC9DIR%"=="" (
    rem Prepend SDK paths - Don't use the SDK SetEnv.cmd because it pulls in
    rem random VC paths which we don't want.
    rem Add the atlthunk compat library to the end of our LIB
    set "PATH=%SDKDIR%\bin;%PATH%"
    set "LIB=%SDKDIR%\lib;%LIB%;%MOZBUILDDIR%atlthunk_compat"

    if "%USEPSDKATL%"=="1" (
        if "%USEPSDKIDL%"=="1" (
            set "INCLUDE=%SDKDIR%\include;%PSDKDIR%\include\atl;%PSDKDIR%\include;%INCLUDE%"
        ) else (
            set "INCLUDE=%SDKDIR%\include;%PSDKDIR%\include\atl;%INCLUDE%"
        )
    ) else (
        if "%USEPSDKIDL%"=="1" (
            set "INCLUDE=%SDKDIR%\include;%SDKDIR%\include\atl;%PSDKDIR%\include;%INCLUDE%"
        ) else (
            set "INCLUDE=%SDKDIR%\include;%SDKDIR%\include\atl;%INCLUDE%"
        )
    )
)

cd "%USERPROFILE%"

echo Set WDK
set INCLUDE=%INCLUDE%;c:\WinDDK\7600.16385.1\inc\api;c:\WinDDK\7600.16385.1\inc\crt;c:\WinDDK\7600.16385.1\inc\atl71
set LIB=%LIB%;c:\WinDDK\7600.16385.1\lib\wxp\i386;c:\WinDDK\7600.16385.1\lib\Crt\i386;C:\WinDDK\7600.16385.1\lib\ATL\i386
set PATH=%PATH%;c:\WinDDK\7600.16385.1\bin\x86\x86;c:\Program Files\Microsoft SDKs\Windows\v6.0A\Bin;c:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\bin;c:\mozilla-build\msys\bin;C:\Program Files (x86)\Git\bin

"%MOZILLABUILD%\msys\bin\bash" --login -i cd /c/vagrant/ && ./build.sh
