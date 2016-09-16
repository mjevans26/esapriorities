#read raw workplan data from csv 
data <- read.csv("./data-raw/workplan.csv", header = TRUE, na.strings = "N/A ")

#whitespace needs to be removed from strings to eliminae 'pseudolevels' of factors 
data <- data.frame(lapply(data, function(x) stringr::str_trim(x)))

#some string variables should be treated as such
data$Package.Name <- as.character(data$Package.Name)
data$Species.name <- as.character(data$Species.name)
data$Range <- as.character(data$Range)
data$Current.Candidate <- as.character(data$Current.Candidate)

#replace blank 'Current candidate' values with 'N'
data$Current.Candidate[data$Current.Candidate==""] <- "N"
data$Current.Candidate <- as.factor(data$Current.Candidate)

#separate LPN and prioritization bins
targets <- grep("LPN",data$Priority.Bin.Ranking)
data$LPN <- NA
data$LPN[targets] <- as.numeric(gsub("LPN ","",data$Priority.Bin.Ranking[targets]))
data$Priority <- NA
data$Priority[-targets] <- as.numeric(data$Priority.Bin.Ranking[-targets])

#create new priority ranking on single scale
data$newPriority <- NA
data$newPriority[targets] <- as.numeric(gsub("LPN ","",data$Priority.Bin.Ranking[targets]))
data$newPriority <- sapply(data$newPriority, function(x) x <- x/2 + 0.5)
data$newPriority[-targets] <- as.numeric(data$Priority.Bin.Ranking[-targets])

#for queries by state split multple states into duplicate rows creating unique species*state combinations
data_states <- tidyr::unnest(data, States = strsplit(data$Range, ","), .id = "OriginRow")

devtools::use_data(data, data_states, overwrite = TRUE)