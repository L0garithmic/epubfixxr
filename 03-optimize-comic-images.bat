	@ECHO OFF
	::These set the locations to be referenced below
	set cmp=%cd%\comp
	set cmpd=%cd%\comp\decompress
	set label=RepairCompressed
	::Starts the Loop, any epub files in 01-input
	
for %%f in (01-input\*.cb*) do (	
	::Creates missing directories - necessary
	if not exist "04-shrunk" mkdir 04-shrunk
	if not exist "comp\images" mkdir comp\images
	if not exist "comp\decompress" mkdir comp\decompress

	::Decompress the ePub
	7z.exe e "%%f" -o"%cmpd%\%%~nf"
	cls

	::Optimizing the images
	echo Optimizing the images, this can be VERY slow. Be patient.
		for %%g in ("%cmpd%\%%~nf\*.jpg") do (
			cjpeg -quality 70 "%%g" > comp/images/%%~nxg

		)
	::Copies the compressed images to the book folders
	xcopy /s /i /q /y "%cmp%\images" "%cmpd%\%%~nf"

	::Removes any empty directories
	ROBOCOPY "%cmpd%\%%~nf" "%cmpd%\%%~nf" /S /MOVE >NUL

	::Compresses the books
	7z.exe a "%cmpd%\%%~nf.cbz" "%cd%\comp\decompress\%%~nf" -mx0 -mmt2 -tzip
	
	::Copies the books to "Shrunk"
	xcopy /s /i /q /y "%cmpd%\%%~nf.cbz" "04-shrunk"

	rmdir /Q /S comp
)
