# recreate bookmarks dataframe ####

readme = readLines("README.md")

message("Reading bookmarks from README.md")

readme_bms = grep("^\\*", readme)

bms = readme[readme_bms]

bms = data.frame(
   link = sub("^\\* \\[(.+)]\\((.+)) added: `(.+)`", "\\2", bms),
   title = sub("^\\* \\[(.+)]\\((.+)) added: `(.+)`", "\\1", bms),
   date = as.POSIXct( sub("^\\* \\[(.+)]\\((.+)) added: `(.+)`", "\\3", bms) )
)

# recreate bookmarks tags list ####

readme_tags = ifelse(grepl("^  \\+", readme[readme_bms + 1]), readme_bms + 1, NA)

bms_tags = strsplit(readme[readme_tags], "\\*{2}")

bms_tags = lapply(bms_tags, function(x) {
   if( is.na(x)[1] ) character() else x[ c(FALSE, TRUE) ]
} )

rm(list = ls(pattern = "^readme"))
