@echo off
::Creates directories if they do not exist (required)
	=if not exist "03-converted" mkdir 03-converted
	=if not exist "calibre\temp" mkdir calibre\temp

for %%f in (01-input\*.pdf) do (
			if not exist "04-shrunk" mkdir 04-shrunk
			calibre\ebook-convert "%%f" "calibre\temp\%%~nf.mobi" --output-profile tablet --mobi-keep-original-images --dont-compress 
)
		
for %%b in (calibre\temp\*.mobi) do (	
			if not exist "04-shrunk" mkdir 04-shrunk
			calibre\ebook-convert "%%b" "03-converted\%%~nb.epub" --output-profile tablet --remove-first-image --no-svg-cover --no-default-epub-cover 
)
	rmdir /S /Q "%cd%\calibre\temp"
