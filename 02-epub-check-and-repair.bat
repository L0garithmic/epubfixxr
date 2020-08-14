@echo off

for %%f in (01-input\*.epub) do (	
	if not exist "01-input" mkdir 01-input
	if not exist "calibre\to-fix" mkdir calibre\to-fix
	
	set "loc=%%f"
	setlocal enableDelayedExpansion
		java -Xss1024k -jar epubcheck.jar "!loc!" --fatal >nul
		if "!ERRORLEVEL!"=="1" ( 
		call :fixFile "!loc!" 
		) else if "!ERRORLEVEL!"=="0" ( 
		call :NormalFile "!loc!" 
		)
	endlocal
)


:: Starts the Repair process. Runs at the end.
call "repair.bat"
exit

::Normal File, Nothing to fix.
:NormalFile
echo Check Status :Good: %1
EXIT /B 0

::Broken file, needs fixed.
:fixFile
echo Check Status :Needs Repair: %1
COPY %1 "calibre\to-fix\%~n1.epub"

EXIT /B 0


::End of file
