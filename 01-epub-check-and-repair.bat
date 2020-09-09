@echo off

:: Creates missing directories if necessary
	if not exist "01-input" mkdir 01-input
	if not exist "calibre\to-fix" mkdir calibre\to-fix
	if exist "01-input\failed-check" call :moveoldfail
	
:: Checks 02-fixed for files before script runs, moves files if necessary
	for /F %%i in ('dir /b /a "02-fixed\*"') do (call :02fmovefiles)
	
:: Checks 01-input for epubs before script runs, errors if none
	for /F "delims=" %%a in ('dir /b /s "01-input\*.epub"') do (goto :epubyes)
	goto :epubno

	
:: Begins the initial checks. Calls scripts to copy/move broken files if necessary
:epubyes
for /R "01-input" %%f in (*.epub) do (
	set "loc=%%f"
	setlocal enableDelayedExpansion
		java -Xss1024k -jar epubcheck.jar "!loc!" --fatal >nul
		if "!ERRORLEVEL!"=="1" ( 
		call :brokenfile "!loc!" 
		) else if "!ERRORLEVEL!"=="0" ( 
		call :normalfile "!loc!" 
		)
	endlocal
)


:: Export folder contents to text files for comparison - Pre-test 1
:exportdir
	if not exist "calibre\to-fix" mkdir calibre\to-fix
	dir /a "01-input\failed-check" /b > "xfailcheck.txt"
	dir /a "02-fixed" /b > "xfixed.txt"

:: Checks if there are actually any files to repair - Pre-test 2 (if no, jumps to Step 4)
	for /f %%i in ("xfailcheck.txt") do set size=%%~zi
	if not %size% gtr 0 goto :checksgood
	
:: Starts the Repair process if
	call :repairscript
	goto :allchecks
	exit
:: Actual end of script if things work right


:: ---- Crude attempt at a repair status check script ---- ::

:allchecks
:: Checks if the two files are identical - Step 3 (If identical jumps to Step 4) otherwise jumps to Step 5
	fc /b xfixed.txt xfailcheck.txt > nul
	if errorlevel 1 goto checkneeded
	goto :checksgood
	
:: Since the folders are NOT identical, it now lists the files that are broken.
:checkneeded
	cls
	set "folderA=01-input\failed-check"
	set "folderB=02-fixed"
	for %%a in ("%folderA%\*.epub") do if not exist "%folderB%\%%~na_recoded%%~xa" echo Repair NOT successful on %%~na_recoded%%~xa
	for %%a in ("%folderA%\*.epub") do if not exist "%folderB%\%%~na_recoded%%~xa" echo Repair NOT successful on %%~na_recoded%%~xa >> failed-repairs.txt
	echo %date%-%time% >> failed-repairs.txt
	echo. >> failed-repairs.txt
	echo this has been exported to a text file "failed-repairs.txt"
	echo.
	call :cleanup
	pause
	exit

:: This is if the fix/repair directories are identical and/or empty. Success! - Step 4 (calls Cleanup)
:checksgood
	cls
	echo All checks and/or repairs seem to of completed as intended with no obvious errors. You're all set!
	echo.
	for /F %%i in ('dir /b /a "02-fixed\*"') do (call :repairlist)
	echo.
	call :cleanup
	pause
	exit
	
:: ---- Called Dependencies Below Here ----

:: attempt at repair. Often works, if not, thats what all the checks are for. (only called)
:repairscript
	cls
	echo working (this may take a minute or two)
for %%f in (calibre\to-fix\*.epub) do (	
	if not exist "02-fixed" mkdir 02-fixed
	calibre\ebook-convert "%%f" "02-fixed\%%~nf.epub"  --output-profile tablet --chapter --preserve-cover-aspect-ratio
) 
	EXIT /B 0

:: :the warning if 02-fixed contains files, it must be empty. exits if there are
:02fmovefiles
	if not exist "02-fixed\fixed-moved" mkdir 02-fixed\fixed-moved
	move 02-fixed\*.* 02-fixed\fixed-moved
	cls
	EXIT /B 0

:: This lists any files in the 02-fixed folder IF there are in :checksgood - Step 4B (only called)
:repairlist
	echo These books were successfully repaired!
	for /r %%i in (02-fixed\*) do echo %%~nxi\
	EXIT /B 0
	
:cleanup
:: Deletes files in the to-fix folder (only called)
	del /s /q calibre\to-fix\*.* >NUL
	del xfixed.txt >NUL
	del xfailcheck.txt >NUL
	EXIT /B 0
	
:: Normal File, Nothing to fix. (only called)
:normalfile
	echo Check Status :Good: %1
	EXIT /B 0

:: Broken file, needs fixed. (only called)
:brokenfile
	echo Check Status :Needs Repair: %1
	COPY %1 "calibre\to-fix\%~n1.epub" >NUL
	if not exist "01-input\failed-check" mkdir 01-input\failed-check
	MOVE %1 "01-input\failed-check\%~n1.epub" >NUL
	EXIT /B 0
	
:moveoldfail
:: Checks 01-input\failed-check for files before script runs, moves files if necessary
	for /F %%i in ('dir /b /a "01-input\failed-check\*"') do (
	if not exist "01-input\failed-check-old" mkdir 01-input\failed-check-old
	move 01-input\failed-check\*.* 01-input\failed-check-old)
	cls
	EXIT /B 0
	
:epubno
:: Errors if there are no ePubs in 01-input
	cls
	echo No ePubs exist in 01-input or any subfolders in said directory. Please put some in there!
	pause
	exit
