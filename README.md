# EpubFixxr

Releases are on the right! --> 

All eBook actions, use the folder 01-input for their input directory unless otherwise noted.

00-runfirst					Calibre, EpubCheck and Java are required. Run 00-runfirst.bat if you have not already

01-epub-check-and-repair 	Checks for errors and attempts to repair if necessary. Only errors on "fatal" errors. Usually fatal cant be fixed
02-optimize-epub-images		Compresses EPUB images using MozJPG at quality 90 (extremely low loss but way smaller filesize) 
03-optimize-comic-images	Compresses comicbook images (CBR, CBZ, CB*) using MozJPG\90. Note: This moves all images to the ROOT folder.
04-epub-to-epub				If your ePub is a mess inside, this runs it through Calibre and cleans it up
05-folder-to-epub			Converts extracted ePub folders into a ePub files. This is not magic, must already be formatted
06-pdf-to-epub				Converts PDF files to ePubs. Does not do OCR. Best for photo/childrens books. Removes TOC from end of ePub

99-check-only				Checks any ePubs in 01-input for errors. Does NOT repair
99-repair-only				Repairs any ePubs in calibre\to-fix. Outputs to 02-fixed

If you wish to submit changes or fixes, I would love to see them! Just remember, my goal here was simple, clean scripts
I am not particularly  looking for long drawn out fancy methods to do the same things I hacked together.
But, if you got something that saves some lines of code or does a better job, please submit a pull request!!
