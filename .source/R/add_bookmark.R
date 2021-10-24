# get new bookmark link ####

new_args = commandArgs(trailingOnly = TRUE)

new_args = ifelse(trimws(new_args) != "", trimws(new_args), NA)

if( is.na(new_link <- new_args[1]) ) stop("You didn't provide the new bookmark's URL.")

# get (or lookup) title ####

new_title = if( is.na(new_args[2]) ) {
   message("You didn't provide the new bookmark's title. Looking it up...")

   if( ! suppressWarnings(require("xml2", lib.loc = ".source/R")) ) {
      options(repos = "https://cran.rstudio.com")
      install.packages("xml2", lib = ".source/R", quiet = TRUE)
      message("xml2 installed from https://cran.rstudio.com")
      library("xml2", lib.loc = ".source/R")
   }

   xml_text(xml_find_first(read_html(new_link), "/html/head/title"), trim = TRUE)
} else new_args[2]

# set title @GITHUB_ENV ####

gh_env_test = "if [ -z \"$GITHUB_ENV\" ]; then echo FALSE; else echo TRUE; fi"

gh_env_test = as.logical(system(gh_env_test, intern = TRUE)) # TRUE for workflow runs

if(gh_env_test) system(paste("echo \"TITLE=", new_title, "\" >> $GITHUB_ENV", sep = "'"))

rm(gh_env_test)

# get new bookmark tags ####

new_tags = if( ! is.na(new_args[3]) ) {
   trimws( strsplit(new_args[3], ",")[[1]] )
} else character()

#  append old bookmarks ####

if( file.exists("README.md") ) {
   source(".source/R/read_readme.R")
   bms = rbind(data.frame(link = new_link, title = new_title, date = Sys.time()), bms)
   bms_tags = c(list(new_tags), bms_tags)
} else {
   bms = data.frame(link = new_link, title = new_title, date = Sys.time())
   bms_tags = list(new_tags)
}

message("Adding bookmark: ", new_title, "\nwith tags:", paste0(" \"", new_tags, "\""))

# run R/write_readmes.R ####

rm(list = ls(pattern = "^new"))

source(".source/R/write_readmes.R")
