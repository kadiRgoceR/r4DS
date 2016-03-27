library(dplyr)
library(nycflights13)
flights
class(flights)
# ! not data.frame, by subset return always tbl_df
df2 <- data_frame(x = 1:3, y = 3:1)
class(df2[, 1])
class(df2[[1]]) == class(df2$x)
### filter

filter(flights, month == 1 & day == 1)
filter(flights, month == 11 | 12)
library(microbenchmark)

microbenchmark(
  filter(flights, month == 11 | 12),
  filter(flights, month == 11 | month == 12),
  filter(flights, month %in% c(11, 12)),
  subset(flights, month == 11 | month == 12),
  flights[flights$month == 11 | flights$month == 12 & !is.na(flights$month), , drop = FALSE],
  )

microbenchmark(
  filter(flights, month == 1 & day == 1),
  filter(flights, month == 1, day == 1)
  
)

# !De morgans law
flights
microbenchmark(
  filter(flights, !(arr_delay > 120 | dep_delay > 120)),
  filter(flights, arr_delay <= 120, dep_delay <= 120)
)

# logicals
df <- data_frame(
  x = c(FALSE, TRUE, FALSE), 
  y = c(TRUE, FALSE, TRUE)
)
filter(df, cumany(x)) # all rows after first TRUE
filter(df, cumall(y)) # all rows until first FALSE

# !NA
df <- data_frame(x = c(1, NA, 3))
filter(df, x > 1)
filter(df, is.na(x) | x > 1)


# Exercises
#   1
flights
(dep_summer <- filter(flights, month %in% c(6,7,8)))
(dest_houston <- filter(flights, dest == "IAH" | dest == "HOU"))
airlines_uniq <- unique.data.frame(airlines)
ind <- pmatch(c("American","United","Delta"), airlines_uniq$name, nomatch = NA_integer_, duplicates.ok = FALSE)
carrier_id <- as.character(airlines_uniq$carrier[ind])
(oper_DUA <- filter(flights, carrier %in% carrier_id))
(filter(flights, dep_delay > 120 | arr_delay > 120 ))
(filter(flights, dep_delay < 0 & arr_delay > 120 ))
(filter(flights, dep_delay > 60 & arr_delay > 120 ))
(filter(flights, (dep_delay > 60 | arr_delay > 60 ) & air_time >  30 ) )
(filter(flights, dep_time > 0 & dep_time < 360))
#   arrange
# Missing values always come at the end:
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))
#   select
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))
select(flights, carrier, starts_with("U"))
