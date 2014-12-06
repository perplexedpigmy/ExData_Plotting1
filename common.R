# Common.R
# 
# Toolbox for common functionality.
# Make retrieval information as well as information tagging
# Generic and common
# 
# Tow Functions are introduced
#   getFile - retrieves a file over the internet
#   createFileMetaData - Creates a metadata shadow file with relevant tagging
#
# The separation of these funcitions allow the separate development of 
# This generic functionalities wihtout affecting the excercises. 
# Tagging as well as file fetching may be improved in the future 
# and the excercise may benefit from the performant future development.

# create a meta data shadow to the original file 
# whoe name is full.name
# 
# Current metadata includes
#    Original URL           - url
#    Donwload Date & time   - date
#    md5 signature          - md5
#
# Args:
#   full.name - The file whose meta data we are to keep
#   url       - origin URL of the file
createFileMetaData <- function(full.name, url) {
    meta.file = paste(full.name, "meta", sep=".")
    library(tools)       # md5sum
    writeLines(c(paste("date", Sys.time(), sep=":"),
                 paste("url", url, sep=":"),
                 paste("md5", md5sum(full.name), sep=":")), 
               meta.file)
}

# Retrieve file from the net.
# And creates for it a shadow metadata file
# 
# Args: 
#    url   - The url location of the file
#    dir   - Output directory
#    name  - Output file name 
#    unzip - Unzip the downloaded file (Default FALSE)
#    quiet - if set to FALSE will display the download progress (default TRUE)
getFile <- function(url, dir, name, unzip=FALSE, quiet = TRUE) {
    full.path <- file.path(dir, name)
    if (!file.exists(full.path)) {
        dir.create(file.path(".", dir), showWarnings = FALSE)    
        download.file(url, destfile = full.path, method = "curl", quiet = quiet)
        createFileMetaData(full.path, url)
        if (unzip) unzip(full.path, overwrite = T, exdir=dir)
    }   
}
