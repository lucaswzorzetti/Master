#### Importando os dados
temperaturas <- read.table("total.txt", header = T, 
                           colClasses = c("character", "character", rep("numeric", 25) ))
View(temperaturas)
str(temperaturas)
head(temperaturas)

temperaturas <- unite(temperaturas, "datetime", c("data", "tempo"), sep = "")

library(lubridate)

meus_modulos <- c("ID", "IIE", "IIIA", "IVA", "VA")

temperaturas$datetime <- mdy_hms(temperaturas$datetime) ##transformando no formato certo

##Gráficos
library(ggplot2)

temp <- ggplot(temperaturas, aes(x = datetime, y = IA)) + geom_point() ##testando com um bloco aleatorio
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

