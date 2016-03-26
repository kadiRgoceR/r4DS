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
# multi layer plots, adding smooth
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping= aes(x = displ, y = hwy))
# multi layer without repeating
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(data = subset(mpg, cyl == 8))

# Exercises:
# 1: all the geoms take the initial plot to adapt 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = class)) + 
  geom_point() + 
  geom_smooth()
# 2.1: yes, both are the same 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot(mapping = aes(x = displ, y = hwy)) + 
  geom_point(data = mpg) + 
  geom_smooth(data = mpg)
# 2.2: yes 
ggplot(mapping = aes(x = displ, y = hwy)) + 
  geom_point(data = mpg) + 
  geom_smooth(data = subset(mpg, cyl == 8))
# 2.3: no... before geom must the data assigned..
ggplot(mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(data = mpg)
# 2.4: no: geom needs always a initial or assigned.
ggplot(mapping = aes(x = displ, y = hwy)) + 
  geom_point(data = mpg) + 
  geom_smooth()

# bar charts
# dont need y axis
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
# multi level
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
# positions: dodge, stack, jitter, fill, identity
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") +
  ggtitle('Position = "dodge"')

# for see the overlapping points
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter") + 
  ggtitle('Position = "jitter"')

### stats: default algorithms, exists 22 stats go help
?geom_bar
demo <- data.frame(
  a = c("bar_1","bar_2","bar_3"),
  b = c(20, 30, 40)
)
demo
ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")
# stat arguments changeable

?stat_count

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut), width = 0.4)

ggplot(data = diamonds) + 
  geom_count(mapping = aes(x = cut, y = clarity))

ggplot(data = diamonds) + 
  geom_count(mapping = aes(x = cut, y = clarity, size = ..prop.., group = clarity))

# Coordinate systems: 8 systems go help
?coord_cartesian

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1) + 
  coord_polar()
#  pie chart

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = factor(1), fill = cut), width = 1) + 
  coord_polar(theta = "y")

### facets: subplots  one variable
str(diamonds)
head(diamonds)

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1) + 
  coord_polar() + 
  facet_wrap( ~ clarity)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class)

# two variables
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1) + 
  coord_polar() + 
  facet_grid(color ~ clarity)
#   Here the first subplot displays all of the points that 
#have an I1 code for clarity and a D code for color
# same as one variable
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1) + 
  coord_polar() + 
  facet_grid(. ~ clarity)

# Exercises
# 1. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
# 2.
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ drv)

###conclusion for ggplot
# a data set, a geom, a set of mappings, a stat, a position adjustment, 
#a coordinate system, and a faceting scheme.
      # ggplot(data = <DATA>) + 
      #   <GEOM_FUNCTION>(
      #     mapping = aes(<MAPPINGS>),
      #     stat = <STAT>, 
      #     position = <POSITION>
      #   ) +
      #   <COORDINATE_FUNCTION> +
      #   <FACET_FUNCTION>
  
### Communication

# labels
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth() + 
  labs(title = "Fuel efficiency vs. Engine size",
       x = "Engine displacement (L)", 
       y = "Highway fuel efficiency (mpg)",
       color = "Type of Car") 
# zooming
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth() + 
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30)) 
# 8 themes: skins
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth() + 
  theme_bw() 
  

