# plot4.R
# 
# Running the file
# will generate a PNG multi pane view
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

png(filename="plot4.png", height=480, width=480)
par(mfrow = c(2, 2))
# Top-Left
    plot(data$Datetime, data$Global_active_power, type = "l", 
         ylab = "Global Active Power", xlab = "")

    # Top-Right
    plot(data$Datetime, data$Voltage, type = "l", 
         ylab = "Voltage", xlab = "datetime")

    # Bottom Left
    plot(data$Datetime, data$Sub_metering_1, type = "l", 
         ylab = "Energy sub metering", xlab = "", col = "black")
    points(data$Datetime, data$Sub_metering_2, type = "l", 
           xlab = "", ylab = "Sub_metering_2", col = "red")
    points(data$Datetime, data$Sub_metering_3, type = "l", 
           xlab = "", ylab = "Sub_metering_3", col = "blue")
    legend("topright", lty = 1, col = c("black", "red", "blue"), 
           legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
           bty = "n", )

    # Bottom Right
    plot(data$Datetime, data$Global_reactive_power, type = "l", 
     xlab = "datetime", ylab = "Global_reactive_power", ylim = c(0, 0.5))
dev.off()