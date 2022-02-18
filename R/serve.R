# This is a script to initiate a local web server in able to have a live preview of the book.
# You can see you changes in html output continuously almost as soon as you hit save in the Rmd file.
# For speed, use preview=T. Note that when doing thsi, cross-links will not work.

# You'll need this package
#install.packages("servr")

# More info:
# https://bookdown.org/yihui/bookdown/serve-the-book.html

# Anders
hdir <- "C:/Users/anders.kolstad/Documents/Github/ECA_NF22"

# Trond
hdir <- ""

serve_book(dir = hdir, output_dir = "docs/", preview = TRUE,
           in_session = TRUE, quiet = FALSE)


# A live preview is now viewable at http://127.0.0.1:4321
# Depending on your settings it may also apprear in the viewer inside RStudio IDE,
# or you can force it like this:  

viewer <- getOption("viewer")
viewer("http://127.0.0.1:4321")
