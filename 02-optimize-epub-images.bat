@ECHO OFF
	:: These set the locations to be referenced below
	set cmp=%cd%\comp
	set cmpd=%cd%\comp\decompress
	set label=RepairCompressed
	::Starts the Loop, any epub files in 01-input
for %%f in (01-input\*.epub) do (	
	::Creates missing directories - necessary
	if not exist "04-shrunk" mkdir 04-shrunk
	if not exist "comp\OEBPS\images" mkdir comp\OEBPS\images
	if not exist "comp\OPS\images" mkdir comp\OPS\images
	if not exist "comp\images" mkdir comp\images
	if not exist "comp\rootimg" mkdir comp\rootimg
	if not exist "comp\decompress" mkdir comp\decompress
	if not exist "calibre\to-fix" mkdir calibre\to-fix

	:: Decompress the ePub
	7z.exe x "%%f" -aoa -o"%cmpd%\%%~nf"
	cls
	
	::Optimizing the images
	echo Optimizing the images, this can be VERY slow. Be patient.
		for %%g in ("%cmpd%\%%~nf\OEBPS\images\*.jpg") do (
			cjpeg -quality 80 "%%g" > comp/OEBPS/images/%%~nxg
		)
		for %%g in ("%cmpd%\%%~nf\OPS\images\*.jpg") do (
			cjpeg -quality 80 "%%g" > comp/OPS/images/%%~nxg
		)
		for %%g in ("%cmpd%\%%~nf\images\*.jpg") do (
			cjpeg -quality 80 "%%g" > comp/images/%%~nxg
		)
		for %%g in ("%cmpd%\%%~nf\index*.jpg") do (
			cjpeg -quality 80 "%%g" > comp/rootimg/%%~nxg
		)
	
	::Copies the compressed images to the book folders
	xcopy /s /i /q /y "%cmp%\OEBPS\images" "%cmpd%\%%~nf\OEBPS\images"
	xcopy /s /i /q /y "%cmp%\OPS\images" "%cmpd%\%%~nf\OPS\images"
	xcopy /s /i /q /y "%cmp%\images" "%cmpd%\%%~nf\images"
	xcopy /s /i /q /y "%cmp%\rootimg" "%cmpd%\%%~nf"

	::Compresses the books not a finished output
	7z.exe a "%cmpd%\%%~nf.epub" "%cmpd%\%%~nf\*" -mx5
	
	::Copies the books to Calibre to finalize
	xcopy /s /i /q /y "%cmpd%\%%~nf.epub" "calibre\to-fix"

	
	for %%f in (calibre\to-fix\*.epub) do (	
			if not exist "04-shrunk" mkdir 04-shrunk
			calibre\ebook-convert "%%f" "04-shrunk\%%~nf.epub" --output-profile tablet --no-default-epub-cover --no-svg-cover
		)
	rmdir /Q /S comp
	del /s /q calibre\to-fix\*.*


)

