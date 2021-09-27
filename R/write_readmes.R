#  check bookmarks ####

stopifnot(exists("bms"), exists("bms_tags"))

# create README.md ####

readme = character()

bms_years = unclass(as.POSIXlt(bms$date))$year

for( i in seq_along(bms_tags) ) {
   if( i == 1 || bms_years[i] < bms_years[i - 1] ) {
      readme = c(readme, "", as.character(bms$date[i], "## %Y"), "")
   }
   readme = c(readme, paste0(
      "* [", bms$title[i], "](", bms$link[i], ") ",
      "added: `", as.character(bms$date[i], "%F %R"), "`"
   ) )
   if( length(bms_tags[[i]]) > 0 ) {
      readme = c(readme, paste(
         "  + tagged:", paste0("**", bms_tags[[i]], "**", collapse = " ")
      ) )
   }
}

#  write README.md ####

message("Saving bookmarks by date in README.md")

writeLines(readme, "README.md")
