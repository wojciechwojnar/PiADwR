library(lubridate)
library(readr)
library(stringr)
library(data.table)



###Zadanie domowe 23.11.2020 ----

#(i)
dl = length(gas_base$Date)

# Jako char:
gas_base$Date <- paste(
  as.character(gas_base$Date),
  paste( sample(0:23, dl, replace = TRUE), sample(0:59, dl, replace = TRUE), sample(0:59, dl, replace = TRUE), sep = ":")
)

str(gas_base$Date)
gas_base
# Jako data:

gas_base$Date <- ymd_hms(gas_base$Date, tz ="UTC")

#(ii)

#zaokraglenie do MIESIACA:

#floor_date(datetimes, unit = "month")

#aggregate(MeasuredValue ~ floor_date(Date, unit = "month"),
#          data = gas_base,
#          FUN = mean, na.rm = TRUE)


gas_base = as.data.table(gas_base)


gas_base[, list(MeanMeasured = mean(MeasuredValue, na.rm = TRUE),
                MaxMeasured = max(MeasuredValue, na.rm = TRUE),
                MinMeasured = min(MeasuredValue, na.rm = TRUE),
                MedianMeasured = median(MeasuredValue, na.rm = TRUE)),
         by = floor_date(Date, unit = "month")]

#zaokraglenie do ROKU:

gas_base[, list(MeanMeasured = mean(MeasuredValue, na.rm = TRUE),
                MaxMeasured = max(MeasuredValue, na.rm = TRUE),
                MinMeasured = min(MeasuredValue, na.rm = TRUE),
                MedianMeasured = median(MeasuredValue, na.rm = TRUE)),
         by = floor_date(Date, unit = "year")]

#(iii)

#(a)

#Traktowana jako data:


gas_base[, `:=`(Year = year(Date),
                Month = month(Date),
                Day = day(Date),
                Hour = hour(Date),
                Minute = minute(Date),
                Second = second(Date))]
#gas_base


#Traktowane jak napis:

napis <- function(date){
  division = str_match(date, "([0-9]{4})[- .]([0-9]{2})[- .]([0-9]{2})[ ]([0-9]{2})[- :]([0-9]{2})[- :]([0-9]{2})")
  Year = division[2]
  Month = division[3]
  Day = division[4]
  Hour = division[5]
  Minute = division[6]
  Sec = division[7]
  
  return( c(Year, Month, Day, Hour, Minute, Sec))
}


gas_base[, c("Year", "Month", "Day", "Hour", "Minute", "Second")] <- transpose(gas_base[, lapply(Date, napis)])
gas_base