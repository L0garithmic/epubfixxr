@echo off
for %%f in (02-fixed\*.epub) do (	
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
pause
::Normal File, Nothing to fix.
:NormalFile
echo Check Status :Good: %1
EXIT /B 0

::Broken file, needs fixed.
:fixFile
echo Check Status :Needs Repair: %1

EXIT /B 0


::End of file
