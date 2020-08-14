@echo off

:: Sets working dir
set mypath=%cd%
=if not exist "01-input" mkdir 01-input
	
:: Choice download Calibre installer
CHOICE /M "Do you have the Calibre Portable Installer downloaded and placed in the directory?"
if %errorlevel%==1 goto NoDownload
if %errorlevel%==2 goto Download

::Open Calibre download site
:Download
start https://calibre-ebook.com/dist/portable
cls
Echo Once the exe is downloaded, stick it in the directory with this batch file
Pause

:NoDownload
:: Extracts Calibre to temp dir (ignoring version num)
for /f %%i in ('dir /b calibre-portable-installer*.exe') do cmd /c %%i "C:\Calibre"

:: Copies the files to the working dir
xcopy /s /i "C:\Calibre\Calibre Portable\Calibre" "%cd%\calibre"

:: Creates some empty folders
	if not exist "01-input" mkdir 01-input

:: Deletes temp dir
rmdir  /S /Q "C:\Calibre"

:: Choice to delete Calibre installer
cls
Echo Calibre has been extracted and is ready to be used
CHOICE /M "Would you like to delete the installer?"
if %errorlevel%==1 goto Delete
if %errorlevel%==2 goto NoDelete
:Delete
del /S /Q calibre-portable-installer*.exe
:NoDelete
exit
