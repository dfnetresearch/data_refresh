library(dplyr)
library(shiny)
library(shinyBS)

# function to initialize app run log 
createLogFile <- function(logfile, header) {
  if(!file.exists(logfile)) {write.table(data.frame(header), file=logfile, sep=",", quote=FALSE, row.names=FALSE, col.names=FALSE)} 
}

# function to update app run log 
updateLogFile <- function(value, logfile) {
  logdata <- read.csv(logfile, header=TRUE, stringsAsFactors=FALSE)
  temp <- colnames(logdata)
  logdata <- rbind(value, logdata)
  colnames(logdata) <- temp 
  write.table(logdata, file=logfile, sep=",", quote=FALSE, row.names=FALSE, col.names=TRUE)
}