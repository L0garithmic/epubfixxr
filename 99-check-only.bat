@echo off
for %%f in (01-input\*.epub) do (	
	set "loc=%%f"
	setlocal enableDelayedExpansion
		java -Xss1024k -jar epubcheck.jar "!loc!" >nul
		if "!ERRORLEVEL!"=="1" ( 
		call :brokenfile "!loc!" 
		) else if "!ERRORLEVEL!"=="0" ( 
		call :normalfile "!loc!" 
		)
	endlocal 
)
pause
::Normal File, Nothing to fix.
:normalfile
echo Check Status :Good: %1
EXIT /B 0

::Broken file, needs fixed.
:brokenfile
echo Check Status :Needs Repair: %1

EXIT /B 0


::End of file
