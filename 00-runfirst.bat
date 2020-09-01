@echo off

:: To do a fresh install. remove the rem from these lines.
:: Optionally. Delete epubcheck.jar, the calibre/lib folders and run this script
	rem rmdir  /S /Q "calibre"
	rem rmdir  /S /Q "lib"
	rem del /S /Q epubcheck.jar

:startchecks
:: pre checks
	=if not exist "01-input" mkdir 01-input
	=if not exist "02-fixed" mkdir 02-fixed
	=if not exist "03-converted" mkdir 03-converted
	=if not exist "04-shrunk" mkdir 04-shrunk
	=if exist "calibre" goto :epubcheck
	=if exist "calibre-portable-installer.exe" goto :cextract

:cdownload
	echo Downloading/Installing Calibre (100mb ish)
:: powershell 2.0 is far faster at downloading, but may be depreciated.
	powershell -Command "(New-Object Net.WebClient).DownloadFile('https://calibre-ebook.com/dist/portable', 'calibre-portable-installer.exe')"
:: powershell 3.0 incase 2.0 fails
	=if exist "calibre-portable-installer.exe" goto :cextract
	powershell -Command "Invoke-WebRequest https://calibre-ebook.com/dist/portable -OutFile calibre-portable-installer.exe"

:cextract
	calibre-portable-installer.exe "C:\Calibre"
	xcopy /s /i "C:\Calibre\Calibre Portable\Calibre" "%cd%\calibre" >NUL
	rmdir  /S /Q "C:\Calibre"
	del /S /Q calibre-portable-installer.exe
	goto :epubcheck


:epubcheck
:: pre checks
	=if exist "test.txt" del /S /Q test.txt
	=if exist "test2.txt" del /S /Q test2.txt
	=if exist "lib" (goto :checkjava) else (goto :epdownload) 
	=if exist "epubcheck.jar" (goto :checkjava) else (goto :epdownload) 
	=if exist "epubcheck.zip" (goto :epextract) else (goto :epdownload) 
	

:: creating download. All the str mess, is formatting the text so there it is only a link
:epdownload
	curl -s https://api.github.com/repos/w3c/epubcheck/releases/latest | findstr "browser_download_url.*zip" > test.txt
	(set /p str=)<test.txt 
	set str=%str: =% 
	set str=%str:"=% 
	set str=%str:browser_download_url:=% 
	echo %str% > test2.txt
	(set /p str2=)<test2.txt 

echo Downloading/Installing ePubCheck (15mb ish)
:: powershell 2.0 is far faster at downloading, but may be depreciated.
	powershell -Command "(New-Object Net.WebClient).DownloadFile('%str2%', 'epubcheck.zip')"
:: powershell 3.0 incase 2.0 fails
	=if exist "epubcheck.zip" goto :epextract
	powershell -Command "Invoke-WebRequest %str2% -OutFile epubcheck.zip"

:epextract
	=if exist "epubcheck" goto :copy
	echo Extracting ePubCheck
	7z x epubcheck.zip -o*

:: more cleanup
	del /S /Q epubcheck.zip

:copy
	for /D %%f in (epubcheck\*) do rename "%%f" "epubcheck"
	xcopy /s /i "epubcheck\epubcheck\lib" "%cd%\lib"
	copy /y "epubcheck\epubcheck\epubcheck.jar" "%cd%\epubcheck.jar*"

:: cleanup
	rmdir  /S /Q "%cd%\epubcheck"
	del /S /Q test.txt
	del /S /Q test2.txt
	goto :allexists
	
:checkjava
:: Checks to see if you have Java installed
	reg query "HKLM\Software\JavaSoft"
	if errorlevel 1 (goto :checkjava64) ELSE (goto :allexists)
:checkjava64
	reg query "HKLM\Software\Wow6432Node\JavaSoft"
	if errorlevel 1 (goto :nojava) ELSE (goto :allexists)

:nojava
	cls
	echo --- Java is not installed. ---
	echo.
	echo Java has really random URL's. So its easier to have you download and install manually 
	echo After installing manually, hit any hey here and it will re-run the checks.
	echo If the link does not open automatically, the link is java.com/download
	echo.
	start "" https://java.com/download/
	pause
	goto :startchecks


:allexists
	cls
	echo EpubCheck 	appears to be installed
	echo Calibre 	appears to be installed
	echo Java 		appears to be installed 
	echo Folders 	were created 
	echo Have fun!
	echo.
	echo.
	echo Frodo: I wish the Ring had never come to me. I wish none of this had happened.
	echo Gandalf: So do all who live to see such times, but that is not for them to decide. 
	echo All we have to decide is what to do with the time that is given to us.
	TIMEOUT 15
	exit