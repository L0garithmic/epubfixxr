@echo off
	echo working (this may take a minute or two)

for %%f in (01-input\*.epub) do (	
	if not exist "03-converted" mkdir 03-converted
	calibre\ebook-convert "%%f" "03-converted\%%~nf.epub"  --output-profile tablet --chapter --preserve-cover-aspect-ratio
)
exit