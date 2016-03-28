library(dplyr)
library(nycflights13)
library(ggplot2)
library(microbenchmark)
library(Lahman)
flights
class(flights)
# ! not data.frame, by subset return always tbl_df
df2 <- data_frame(x = 1:3, y = 3:1)
class(df2[, 1])
class(df2[[1]]) == class(df2$x)
#   filter----

filter(flights, month == 1 & day == 1)
filter(flights, month == 11 | 12)

microbenchmark(
  filter(flights, month == 11 | 12),
  filter(flights, month == 11 | month == 12),
  filter(flights, month %in% c(11, 12)),
  subset(flights, month == 11 | month == 12),
  flights[flights$month == 11 | flights$month == 12 & !is.na(flights$month), , drop = FALSE]
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
#   select, arrange rename----
# Missing values always come at the end:
arrange(flights, year, month, day)
arrange(flights, desc(arr_delay))
# select, cheatsheet
?select
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))
select(flights, ends_with("delay"))
select(flights, starts_with("dep"),  ends_with("delay"))
rename(flights, tail_num = tailnum)

#   mutate----

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

# only new variables 
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# modulo arithmetic %/% integer division
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# use log2
log2(2)
# lag and lead

lead(1:10,5)
lag(1:10,5)

x <- sample(5)
x -lag(x)
#values change true
x != lag(x)

df <- data.frame(year = 2000:2005, value = (0:5) ^ 2)
scrambled <- df[sample(nrow(df)), ]
right <- mutate(scrambled, prev = lag(value, order_by = year))
arrange(right, year)

# ranking: use min_rank
x <- c(1, 2, 2, NA, 3, 4)
data_frame(
  row_number(x),
  min_rank(x),
  dense_rank(x),
  percent_rank(x),
  cume_dist(x)
) %>% knitr::kable()
tail(flights)
# Exercises
#   1
flights <- mutate(flights,
                  dep_time = 60 * (dep_time %/% 100) + dep_time %% 100,
                  air_time = 60 * (air_time %/% 100) + air_time %% 100
)

#   2

transmute(flights,
          dep_delay,
          dep_time,
          sched_time = dep_time + dep_delay
)
ggplot(flights) +
  geom_bar(mapping = aes(x = dep_time, fill = dep_time))

ggplot(data = flights) + 
  geom_point(mapping = aes(x = dep_delay , y = dep_time))

#   3
# is and should data
airtime <- transmute(flights,
                     dep_time = 60 * (dep_time %/% 100) + dep_time %% 100,
                     arr_time = 60 * (arr_time %/% 100) + arr_time %% 100,
                     air_time_is = arr_time - dep_time,
                     air_time_should = 60 * (air_time %/% 100) + air_time %% 100,
                     dep_delay,
                     arr_delay
)

#   4


#   summarise and pipe----
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# pipe
str(flights)
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL")

ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE) 

delays <- flights %>% 
  group_by(dest) %>%
  summarise( 
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

# not cancelled flights 
not_cancelled <- filter(flights, !is.na(dep_delay))
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(delays, aes(n, delay)) + 
  geom_point()

delays %>% 
  filter(n > 25) %>% 
  ggplot(aes(n, delay)) + 
    geom_point()


batting <- tbl_df(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H) / sum(AB),
    ab = sum(AB)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(aes(ab, ba)) +
    geom_point() + 
    geom_smooth(se = FALSE)

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )
not_cancelled %>% count(dest)


