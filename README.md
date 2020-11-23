# ePubFixxr

Edit: Actually working on an entire rebuild, far simpler with more features. No ETA. Use this one for now

Releases are on the right! --> 

TL:DR | ePubFixxr is a collection of tools meant to help identify broken eBooks, repair them, convert them, optimize/shrink them (new >) sort them, rename them. It is a work in progress, entirely batch files, uses Calibre, EpubCheck and Java. If you see changes needed, feel free to let me know.

* `00-runfirst`
  * Calibre, EpubCheck and Java are required. Run 00-runfirst.bat to check for and install if needed
* `01-epub-check-and-repair`
  * Checks for errors and attempts to repair if necessary. Only errors on "fatal" errors. Usually fatal cant be fixed
* `02-optimize-epub-images`
  * Compresses EPUB images using MozJPG at quality 90 (extremely low loss but way smaller filesize) 
* `03-optimize-comic-images`
  * Compresses comicbook images (CBR, CBZ, CB*) using MozJPG\90. Note: This moves all images to the ROOT folder.
* `04-epub-to-epub`
  * If your ePub is a mess inside, manually run this and it uses Calibre to clean it up
* `05-folder-to-epub`
  * Converts extracted ePub folders into ePub files. This is not magic, must already be formatted as ePub
* `06-pdf-to-epub`
  * Converts PDF files to ePubs. Does not do OCR. Best for photo/childrens books. Removes TOC from end of ePub

* `99-check-only`
  * Checks any ePubs in 01-input for errors. Does NOT repair
* `99-repair-only`
  * Repairs any ePubs in calibre\to-fix. Outputs to 02-fixed
  
 
All eBook actions, use the folder 01-input for their input directory unless otherwise noted.
01-epub-check-and-repair can now check recursively through folders in 01-input. It is currently the only one that can

If you wish to submit changes or fixes, I would love to see them! Just remember, my goal here was simple, clean scripts
I am not particularly  looking for long drawn out fancy methods to do the same things I hacked together.
But, if you got something that saves some lines of code or does a better job, please submit a pull request!!
