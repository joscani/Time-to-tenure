
## ----, warning=FALSE-----------------------------------------------------
library(foreign)
datos <- read.dta("../data/working_10_Cleaner.dta")
head( names(datos))


## ------------------------------------------------------------------------
datos <- datos[,c("ability","Countryb","Q6","Q23","Q24","Q25","Q27",
						"Parenthood", "foreign", "foreignEdu2",
						"multidisc", "TimePermCG","PermanentCG",
						"mobilityPG2")]


## ------------------------------------------------------------------------
datos$Countryb <- droplevels(as.factor(as.character(datos$Countryb)))
datos$Countryb <- relevel(datos$Countryb,ref="united kingdom")


## ------------------------------------------------------------------------
datos$time <- datos$TimePermCG

datos$status <- datos$PermanentCG

with


