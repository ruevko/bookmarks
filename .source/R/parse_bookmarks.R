# define bookmarks file ####

doc_args = commandArgs(trailingOnly = TRUE)

doc_file = ifelse(is.na(doc_args[1]), ".source/DEMO/GoogleBookmarks.html", doc_args[1])

stopifnot(file.exists(doc_file), ! file.exists("README.md"))

doc_unlabeled = ifelse(is.na(doc_args[2]), "Unlabeled", doc_args[2])

# (install &) load xml2 ####

if( ! suppressWarnings(require("xml2", lib.loc = ".source/R")) ) {
   options(repos = "https://cran.rstudio.com")
   install.packages("xml2", lib = ".source/R", quiet = TRUE)
   message("xml2 installed from https://cran.rstudio.com")
   library("xml2", lib.loc = ".source/R")
}

#   parse the bookmarks ####

doc = read_html(doc_file)

doc_nodes = xml_find_all(doc, "//a")

doc_nodes = doc_nodes[ ! duplicated(xml_text(doc_nodes)) ]

message("There are ", length(doc_nodes), " unique bookmarks in \"", doc_file, "\"")

#  parse bookmarks tags ####

doc_tags = xml_text(xml_find_first(doc, "/html/body/dl"), trim = TRUE)

doc_tags = strsplit(doc_tags, "(\\n\\s*){2,}")[[1]]

doc_tags = lapply(
   setNames(
      seq_along(doc_tags)[ c(FALSE, TRUE) ],
      doc_tags[ seq_along(doc_tags)[ c(TRUE, FALSE) ] ]
   ),
   function(tag) strsplit(doc_tags[tag], "\\n\\s*")[[1]]
)

# bookmarks tags 2 list ####

if( doc_unlabeled %in% names(doc_tags) ) {
   message("Ignoring the \"", doc_unlabeled, "\" tag")
   doc_tags = doc_tags[ - which(names(doc_tags) == doc_unlabeled) ]
}

bms_tags = lapply(xml_text(doc_nodes), function(x) {
   x_tags = character()
   for( tag in names(doc_tags) ) {
      if( x %in% doc_tags[[tag]] ) x_tags = c(x_tags, tag)
   }
   return(x_tags)
} )

message("Tags:", paste0(" \"", unique(unlist(bms_tags)), "\""))

# bookmarks 2 dataframe ####

bms = as.numeric(xml_attr(doc_nodes, "add_date"))

bms = ifelse(is.na(bms), as.numeric(Sys.time()), bms)

bms = ifelse(bms > 1e10, round(bms / 1e6), bms) # in case of microseconds

bms = data.frame(
   link = xml_attr(doc_nodes, "href"),
   title = xml_text(doc_nodes),
   date = as.POSIXct(bms, origin = "1970-01-01")
)

# run R/write_readmes.R ####

rm(list = ls(pattern = "^doc"))

bms_tags = bms_tags[order(bms$date, decreasing = TRUE)]

bms = bms[order(bms$date, decreasing = TRUE), ]

rownames(bms) = NULL

source(".source/R/write_readmes.R")
