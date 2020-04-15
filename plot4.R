
library(readr)
library(dplyr)
library(lubridate)

# --- Preparation
# Download, extract files, remove tmp file
if (!file.exists("./data")) {
	dir.create("./data/")
	fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
	download.file(fileUrl, destfile="./data/exdata_data_household_power_consumption.zip", method="curl")
	unzip("./data/exdata_data_household_power_consumption.zip", exdir = "./data/")
	file.remove("./data/exdata_data_household_power_consumption.zip")
}

# na = c(""), locale(decimal_mark = ".", grouping_mark = ",")
power_con <- read_delim("./data/household_power_consumption.txt",
			delim = ";",
			col_types = cols(
				Date = col_date(format = "%d/%m/%Y"),
				Time = col_time(format = "%H:%M:%S"),
				Global_active_power = col_number(),
				Global_reactive_power = col_number(),
  				Voltage = col_number(),
  				Global_intensity = col_number(),
  				Sub_metering_1 = col_number(),
  				Sub_metering_2 = col_number(),
  				Sub_metering_3 = col_number()
			)
		)
selected_days <- power_con %>%
				filter(Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02")) %>%
				mutate(Datetime = as_datetime(Date) + Time, Weekday = wday(Datetime, label = TRUE))


par(mfcol = c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

with(selected_days, {
	plot(Datetime, Global_active_power, type = "l", ylab = "Global Average Power (kilowatts)", xlab = "")

	plot(Datetime, Sub_metering_1, col = "black", type = "l", ylab = "Energy sub metering", xlab = "")
	points(Datetime, Sub_metering_2, col = "red", type = "l")
	points(Datetime, Sub_metering_3, col = "blue", type = "l")
	legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1)

	plot(Datetime, Voltage, type = "l", ylab = "Voltage (volt)", xlab = "datetime")
	plot(Datetime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatt)", xlab = "datetime")

})
	
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()
