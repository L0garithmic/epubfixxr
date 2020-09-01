@echo off

for /d %%X in (01-input\*) do (	
	pushd "%%X"
	"%cd%\7z.exe" a "%cd%\01-input\%%~nX.epub" "*" -tzip -mx5
	popd
	rmdir  /S /Q "%%X"
	)

for %%f in (01-input\*.epub) do (	
	if not exist "03-converted" mkdir 03-converted
	calibre\ebook-convert "%%f" "03-converted\%%~nf.epub"  --output-profile tablet --chapter --preserve-cover-aspect-ratio
	del /F "%%f"
)

