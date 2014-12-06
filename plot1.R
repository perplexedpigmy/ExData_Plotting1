# plot1.R
# 
# Running the file
# will geenerate a PNG with Histogram of Frequency of Kilowatt
# common.R is required for data retrieval common functinality
source("common.R") # import getFile &  createFileMetaData

# Constants 
data.dir <- 'data'
data.file <- file.path(data.dir, "household_power_consumption.txt")

# Reference dates. will only be used in dynaic filtering
start.date = as.POSIXct("01/02/2007", format="%d/%m/%Y")
end.date = as.POSIXct("03/02/2007", format="%d/%m/%Y")

getFile("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
        "data",
        "power_consumption.zip",
        unzip = TRUE)

# Read & convert to datetime
# Constraint: File is immutable hence we can use skip & nrow
data <- read.table( data.file, 
                    sep=";", 
                    header=F,
                    skip=66637,
                    nrows=2880,
                    na.strings=c("?"))
names(data) <- names(read.csv(data.file, nrows=1,sep=";"))
data$Datetime <- strptime(paste(data$Date, data$Time), "%d/%m/%Y %H:%M:%S")

# Alternativley dynamic filtering, requires library('data.table')
#data <- data[ between(raw.data$Datetime, start.date, end.date),]

png(filename="plot1.png", height=480, width=480)
    hist(data$Global_active_power, main = "Global Active Power", 
         ylab = "Frequency", xlab = "Global Active Power (kilowatts)", 
         col = "red", breaks = 13, xaxp = c(0, 6, 3),
         ylim = c(0, 1200), xlim = c(0, 6) )
dev.off()   