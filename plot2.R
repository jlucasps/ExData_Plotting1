
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


png("plot2.png", width = 480, height = 480)
with(selected_days,
	plot(Datetime, Global_active_power,
		type = "l", ylab = "Global Average Power (kilowatts)", xlab = ""))
dev.off()
