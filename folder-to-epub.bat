		for %%f in (folders\) do (	
			if not exist "03-shrunk" mkdir 03-shrunk
			calibre\ebook-convert "%%f" "03-shrunk\%%~nf.epub"  --output-profile tablet --chapter --preserve-cover-aspect-ratio
		)