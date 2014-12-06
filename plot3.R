# plot3.R
# 
# Running the file 
# will generate a PNG of different sub metering diagram
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

png(filename="plot3.png", height=480, width=480)
    plot(data$Datetime, data$Sub_metering_1, type = "l", 
         xlab = "", ylab = "Energy sub metering")
    points(data$Datetime, data$Sub_metering_2, type = "l", 
           xlab = "", ylab = "Energy sub metering", col = "red")
    points(data$Datetime, data$Sub_metering_3, type = "l", 
           xlab = "", ylab = "Energy sub metering", col = "blue")
    legend("topright", lty = 1, col = c("black", "red", "blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()