#### This scrypt comes from the temperature regulating system, that I used on my master thesis experiments.
#### It have 5 modules with 5 pairs of temperature receptors, one for the ambient temperature treatment and one for the ambient + 
#### 4°C treatment. Each one of the 25 columns of the file are one pair of ambient/warm, and date and time are the first two columns.
#### The file total.csv and total.txt are the data

## First: Set your work directory with setwd("addres of your directory")
#### Importing the data
temperatures <- read.table("total.txt", header = T, 
                           colClasses = c("character",
                                          "character", 
                                          rep("numeric", 25) ))
##î It is important to put the first two columns
 ## as character, because, if not, R reads like 
 ## numeric and the format crashes

View(temperatures) ##exploring the data
str(temperatures)
head(temperatures)

##Packages you'll need
library(ggplot2)
library(tidyverse)
library(ggpubr)
library(lubridate)

temperatures <- temperatures %>% mutate(date = temperatures$data, time = temperatures$tempo)
temperatures <- unite(temperatures, "datetime",
                      c("data", "tempo"), sep = "") #Here you can use the lubridate package
View(temperatures)

my_modules <- c("ID", "IIE", "IIIA", "IVA", "VA") ##Here you select what modules did you used

temperatures$datetime <- mdy_hms(temperatures$datetime) ## Transforming into the right format (data and time)

class(temperatures$datetime)## It is a POSIXct and POSIXT, POSIXct is the format that 



##Graphs
temp <- ggplot(temperatures, aes(x = datetime, y = IA)) + geom_point() ##Testing with a random block
temp

#Function to speed up the production of graphs with their aesthetics components
line_temp <- function(fun.data, fun.y, title = " ", cor = "black") {
  fun.data$fun.y <- fun.data[, fun.y]
  ggplot(fun.data, aes(x = datetime, y = fun.y)) + 
    geom_point(color = cor) + ylab("Temperature [°C]") +
    ggtitle(title) +
    scale_x_datetime(date_labels = "%d%B", date_breaks = "1 day") +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          plot.title = element_text(hjust = 0.5, vjust = 0, size = 20, face = "bold"),
          axis.text.x = element_text(angle = 60, size = 10, face = "bold", vjust = 0.6),
          axis.text.y = element_text(angle = 90, size = 10, face = "bold"),
          axis.title.x = element_text(size = 12, face = "bold"),
          axis.title.y = element_text(size = 12, face = "bold"),
          panel.background = element_blank(),
          axis.line = element_line(size = 1, lineend = "round", arrow = arrow())) +
    xlab("Time") 
}

line_temp(temperatures, "IA", title = "Módulo I-A", cor = "red") #Testing, don't forget to use "" on fun.y


### Making an arrange of my five modules
pallete <- c("navyblue", "darkgreen", "black", "darkred", "gold4")
my_modules
ggarrange(line_temp(temperatures, my_modules[1], paste("Módulo", my_modules[1], sep = " "),
                    cor = pallete[1]),
          line_temp(temperatures, my_modules[2], paste("Módulo", my_modules[2], sep = " "),
                    cor = pallete[2]),
          line_temp(temperatures, my_modules[3], paste("Módulo", my_modules[3], sep = " "),
                    cor = pallete[3]),
          line_temp(temperatures, my_modules[4], paste("Módulo", my_modules[4], sep = " "),
                    cor = pallete[4]),
          line_temp(temperatures, my_modules[5], paste("Módulo", my_modules[5], sep = " "),
                    cor = pallete[5]),
          nrow = 2, ncol = 3)

