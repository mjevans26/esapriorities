#read raw workplan data from csv 
data_raw <- read.csv("./data-raw/workplan.csv", header = TRUE, na.strings = "N/A ")

#whitespace needs to be removed from strings to eliminae 'pseudolevels' of factors 
data_clean <- data.frame(lapply(data_raw, function(x) stringr::str_trim(x)))

#some string variables should be treated as such
data_clean$Package.Name <- as.character(data_raw$Package.Name)
data_clean$Species.name <- as.character(data_raw$Species.name)
data_clean$Range <- as.character(data_raw$Range)
data_clean$Current.Candidate <- as.character(data_raw$Current.Candidate)

#replace blank 'Current candidate' values with 'N'
data_clean$Current.Candidate[data_clean$Current.Candidate==""] <- "N"
data_clean$Current.Candidate <- as.factor(data_clean$Current.Candidate)

#separate LPN and prioritization bins
targets <- grep("LPN",data_clean$Priority.Bin.Ranking)
data_clean$LPN <- NA
data_clean$LPN[targets] <- as.numeric(gsub("LPN ","",data_clean$Priority.Bin.Ranking[targets]))
data_clean$Priority <- NA
data_clean$Priority[-targets] <- as.numeric(data_clean$Priority.Bin.Ranking[-targets])

#create new priority ranking on single scale
data_clean$newPriority <- NA
data_clean$newPriority[targets] <- as.numeric(gsub("LPN ","",data_clean$Priority.Bin.Ranking[targets]))
data_clean$newPriority <- sapply(data_clean$newPriority, function(x) x <- x/2 + 0.5)
data_clean$newPriority[-targets] <- as.numeric(data_clean$Priority.Bin.Ranking[-targets])

#for queries by state split multple states into duplicate rows creating unique species*state combinations
data_states <- tidyr::unnest(data_clean, States = strsplit(data$Range, ","), .id = "OriginRow")

devtools::use_data(data_clean, data_states, overwrite = TRUE)