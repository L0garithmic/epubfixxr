@echo off
	echo working (this may take a minute or two)

for %%f in (calibre\to-fix\*.epub) do (	
	if not exist "02-fixed" mkdir 02-fixed
	calibre\ebook-convert "%%f" "02-fixed\%%~nf.epub"  --output-profile tablet --chapter --preserve-cover-aspect-ratio
)
	del /s /q calibre\to-fix\*.*
exit