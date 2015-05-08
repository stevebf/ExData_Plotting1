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

# Creae a datetime column from the original date column and time column
plotdata$datetime <- as.POSIXct(paste(plotdata$Date, plotdata$Time), format="%d/%m/%Y %H:%M:%S")

# order the plot data by datetime so that the points are plotted in the right order
plotdata <- plotdata[order(plotdata$datetime),] 

# open the PNG file that we are going to write the plot to
png(file="plot4.png",width = 480, height = 480)

par(mfrow = c(2, 2))

with(plotdata, {
    
    # First Chart - top left
    # create the plot
    plot(plotdata$datetime,plotdata$Global_active_power,
         type="l",
         main="",
         xlab="",
         ylab="Global Active Power")
    
    # Second chart - top right
    plot(datetime,Voltage,
         type="l",
         col="black",
         main="")
    
    # Third chart - bottom left
    # create the histogram
    plot(datetime,Sub_metering_1,
         type="l",
         col="black",
         main="",
         xlab="",
         ylab="Energy sub metering")
    
    lines(datetime,Sub_metering_2,
          type="l",
          col="red")
    
    lines(datetime,Sub_metering_3,
          type="l",
          col="blue")
    
    legend(x="topright", 
           c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
           col=c("black","red","blue"),lty=1,bty="n",cex=0.9)
        
    # Fourth chart - bottom right
    plot(datetime,Global_reactive_power,
         type="l",
         col="black",
         main="")
    
})


# close the graphic device
dev.off()
