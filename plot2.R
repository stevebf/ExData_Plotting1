# download the zipped file from cloudfront.net
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp,mode="wb")

# extract the zipped file
con <- unz(temp, "household_power_consumption.txt")

# load the full data set into R
fulldata <- read.table(con,
                       header = TRUE,
                       sep=";",
                       na.strings="?",
                       colClasses=c("character",
                                    "character",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric",
                                    "numeric"
                       ))
unlink(temp)

# Get the data for 2/2/2007
data1 <- subset(fulldata, Date=='2/2/2007')

# Get the data for 1/2/2007
data2 <- subset(fulldata, Date=='1/2/2007')

# Make one data frame containing the data for both days
plotdata <- rbind(data1, data2)

# Creae a DateTime column from the original date column and time column
plotdata$DateTime <- as.POSIXct(paste(plotdata$Date, plotdata$Time), format="%d/%m/%Y %H:%M:%S")

# order the plot data by DateTime so that the points are plotted in the right order
plotdata <- plotdata[order(plotdata$DateTime),] 

# open the PNG file that we are going to write the plot to
png(file="plot2.png",width = 480, height = 480)

# create the histogram
plot(plotdata$DateTime,plotdata$Global_active_power,
     type="l",
     main="",
     xlab="",
     ylab="Global Active Power (kilowatts)")

# close the graphic device
dev.off()
