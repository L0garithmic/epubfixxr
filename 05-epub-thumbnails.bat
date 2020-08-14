@echo off
:: Choice download Calibre installer
CHOICE /M "Do you already have CBXShell Installed?"
if %errorlevel%==1 goto NoDownload
if %errorlevel%==2 goto Download

::Open Calibre download site
:Download
start https://github.com/T800G/CBXShell/releases/latest
cls
Echo Download, extract, install, then hit enter (Will add reg keys to windows)
echo check epubthumb.reg for whats being added if you wish
Pause

:NoDownload
 @echo off
 rem  set __COMPAT_LAYER=RunAsInvoker  
 REGEDIT.EXE  /S  "%~dp0\epubthumb.reg"