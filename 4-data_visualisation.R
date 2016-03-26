library(ggplot2)
str(mpg)
#template
#   what-data: plot object 
#   how-geom: layer, geometrical object
#   which-aes: mapping argument
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# one more dimension means level
#   levels: color, size, alpha, shape
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
# manually assigning a level for all variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
# filter the levels with logical
vo_fo_ni_to <- mpg$manufacturer %in% c("volkswagen","ford","nissan","toyota")
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color =  vo_fo_ni_to))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer))

# filter with dplyr and plot
library(dplyr)

mpg_subste <- mpg %>% filter(manufacturer %in% c("volkswagen","ford","nissan","toyota"))

ggplot(data = mpg_subste) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = manufacturer))

# geoms: point, smooth and 35 more...
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
str(mpg)
unique(mpg$drv)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = drv))

#####