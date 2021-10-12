# check bookmarks ####

if( ! exists("bms") ) source("R/read_readme.R")

bms_years = unclass(as.POSIXlt(bms$date))$year + 1900

#  README.md head ####

readme = paste0(
   "[`", unique(bms_years), "`]",
   "(#date-", unique(bms_years),")",
   collapse = " "
)

readme = c("# My bookmarks", "", paste("Go to year:", readme))

#  README.md body ####

for( i in seq_along(bms_tags) ) {
   if( i == 1 || bms_years[i] < bms_years[i - 1] ) {
      readme = c(readme, "", as.character(bms$date[i], "## :date: %Y"), "")
   }
   readme = c(readme, paste0(
      "* [", bms$title[i], "](", bms$link[i], ") ",
      "added: `", as.character(bms$date[i], "%F %R"), "`"
   ) )
   if( length(bms_tags[[i]]) > 0 ) {
      readme = c(readme, paste(
         "  + tagged:", paste0("**", sort( bms_tags[[i]] ), "**", collapse = " ")
      ) )
   }
}

# write README.md ####

message("Saving bookmarks by date in README.md")

writeLines(readme, "README.md")

rm(list = ls(pattern = "^readme"))
