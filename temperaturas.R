#### This scrypt comes from the temperature regulating system, that I used on my master thesis experiments.
#### It have 5 modules with 5 pairs of temperature receptors, one for the ambient temperature treatment and one for the ambient + 
#### 4°C treatment. Each one of the 25 columns of the file are one pair of ambient/warm, and data and time are the first two columns.
#### The file total.csv and total.txt are the data

## First: Set your work directory with setwd("addres of your directory")
#### Importing the data
temperaturas <- read.table("total.txt", header = T, 
                           colClasses = c("character", "character", rep("numeric", 25) )) ##It is important to put the first two columns
                                                                                          ## as character, because, if not, R reads like 
                                                                                          ## numeric and the format crashes
View(temperaturas) ##exploring the data
str(temperaturas)
head(temperaturas)

##

temperaturas <- unite(temperaturas, "datetime", c("data", "tempo"), sep = "") #Here you can use the lubridate package

library(lubridate)

meus_modulos <- c("ID", "IIE", "IIIA", "IVA", "VA")

temperaturas$datetime <- mdy_hms(temperaturas$datetime) ## Transforming into the right format

##Gráficos
library(ggplot2)

temp <- ggplot(temperaturas, aes(x = datetime, y = IA)) + geom_point() ##Testing with a random block
temp

#função para agilizar
linhatemp <- function(dados, x, y, cor = "Black"){ ##ta dando errado por algum motivo
  library(ggplot2)
  t <- ggplot(dados, aes(x = x, y = y, fill = cor)) 
  t + geom_point()
}

ggarrange(for(i in 1:5){ggplot(temperaturas, aes(x = datetime, y = meus_modulos[i])) 
  + geom_point()},
          nrow = 2, ncol = 3)

