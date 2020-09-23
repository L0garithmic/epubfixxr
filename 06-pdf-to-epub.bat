@echo off
::Creates directories if they do not exist (required)
	=if not exist "03-converted" mkdir 03-converted
	=if not exist "calibre\temp" mkdir calibre\temp

for %%f in (01-input\*.pdf) do (
::This is the initial conversion of PDF to ePub, but it makes a fugly TOC at the end of the file. So...  the other steps remove that,
	calibre\ebook-convert "%%f" "calibre\temp\%%~nf.epub" --output-profile tablet --chapter --preserve-cover-aspect-ratio --no-default-epub-cover

::Decompresses the newly created ePub
	for %%E in (calibre\temp\*.epub) do (7z.exe x "%%E" -aoa -o"%cd%\calibre\temp\%%~nE")

::Removes the 2 files that hold the TOC
	del /s /q index_split_001.html
	del /s /q toc.ncx

::Compresses the folder into a ePub thats wont pass checks
	for /d %%X in (calibre\temp\*) do (	
		del /S /Q "%%~nX.epub"
		pushd "%%X"
		"%cd%\7z.exe" a "%cd%\calibre\temp\%%~nX.epub" "*" -tzip -mx5
		popd
		rmdir  /S /Q "%%X"
	)

::Converts the ePub so it passes checks via calibre
	for %%G in (calibre\temp\*.epub) do (	
		calibre\ebook-convert "%%G" "03-converted\%%~nG.epub" --output-profile tablet --chapter --preserve-cover-aspect-ratio --no-default-epub-cover
		del /F "%%G"
	)
	
::Empties the temp dir's (don't delete the directory in the loop!)
	del /s /q calibre\temp\*.* >NUL
	
)
::Deletes the temp dir's
	rmdir  /S /Q "%cd%\calibre\temp"
