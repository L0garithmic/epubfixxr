@echo off
	echo working (this may take a minute or two)

for %%f in (01-input\*.pdf) do (	
	if not exist "02-converted" mkdir 02-converted
	calibre\ebook-convert "%%f" "02-converted\%%~nf.epub"  --output-profile tablet --chapter --preserve-cover-aspect-ratio
)
exit