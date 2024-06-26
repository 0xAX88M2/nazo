@if "%ECHOON%"=="" @echo off
SETLOCAL

REM ******************************************************************
REM Usage:
REM        winsymconv_test
REM ******************************************************************

REM ******************************************************************
REM Initialize
REM ******************************************************************
SET SCRIPT_LOCATION=%~dp0
SET DBGHELP_WINHTTP=
SET USE_WINHTTP=

REM ******************************************************************
REM Go to script location
REM ******************************************************************
pushd %SCRIPT_LOCATION%

REM ******************************************************************
REM  Make sure the symbol file directory exists
REM ******************************************************************
SET SYMBOL_DIR=%SCRIPT_LOCATION%symbol
if NOT EXIST %SYMBOL_DIR% MKDIR %SYMBOL_DIR%
if NOT EXIST %SYMBOL_DIR% echo Failed to create directory '%SYMBOL_DIR%' & goto :fail

REM ******************************************************************
REM Testing on the staging instance.
REM ******************************************************************
echo Testing on the staging instance ...

google_converter.exe ^
    -n http://msdl.microsoft.com/download/symbols ^
    -n http://symbols.mozilla.org/firefox ^
    -n http://chromium-browser-symsrv.commondatastorage.googleapis.com ^
    -n https://download.amd.com/dir/bin ^
    -n https://driver-symbols.nvidia.com ^
    -n https://software.intel.com/sites/downloads/symbols ^
    -n https://www.nvaccess.org/files/nvda/symbols ^
    -l %SYMBOL_DIR% ^
    -s https://clients2.google.com/cr/staging_symbol ^
    -mf %SCRIPT_LOCATION%missing_symbols_test.txt ^
    -t https://clients2.google.com/cr/staging_symbol/fetchfailed ^
    -b "google|chrome|internal|private" ^
    > %SCRIPT_LOCATION%last_cycle_staging.txt

REM ******************************************************************
REM Testing on the production instance.
REM ******************************************************************
echo Testing on the production instance ...

google_converter.exe ^
    -n http://msdl.microsoft.com/download/symbols ^
    -n http://symbols.mozilla.org/firefox ^
    -n http://chromium-browser-symsrv.commondatastorage.googleapis.com ^
    -n https://download.amd.com/dir/bin ^
    -n https://driver-symbols.nvidia.com ^
    -n https://software.intel.com/sites/downloads/symbols ^
    -n https://www.nvaccess.org/files/nvda/symbols ^
    -l %SYMBOL_DIR% ^
    -s https://clients2.google.com/cr/symbol ^
    -mf %SCRIPT_LOCATION%missing_symbols_test.txt ^
    -t https://clients2.google.com/cr/symbol/fetchfailed ^
    -b "google|chrome|internal|private" ^
    > %SCRIPT_LOCATION%last_cycle_prod.txt

:success
ENDLOCAL
exit /b 0

:fail
ENDLOCAL
exit /b 1
