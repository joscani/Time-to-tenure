
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



## ------------------------------------------------------------------------
sum( is.na( datos$time))
sum( is.na( datos$status))



## ------------------------------------------------------------------------
datos <- datos[!is.na(datos$time),]



## ------------------------------------------------------------------------
table(datos$status)



## ------------------------------------------------------------------------
 head(with(datos, table(time, status)),10)


## ------------------------------------------------------------------------
datos$time <- datos$time +0.5


## ------------------------------------------------------------------------
table(datos$ability<0)



## ------------------------------------------------------------------------
table(datos$Q6)
datos$Q6 <- droplevels(datos$Q6)

table(datos$Q6)


## ------------------------------------------------------------------------
library(survival)


## ------------------------------------------------------------------------
S1 <- with(datos, Surv(time,status))


## ------------------------------------------------------------------------
attributes(S1)


## ------------------------------------------------------------------------
S1[1:6]


## ------------------------------------------------------------------------

datos[1:6, c("time","status")]



## ----, fig.width=5-------------------------------------------------------
plot(survfit(S1 ~ 1))



## ----, fig.width=5-------------------------------------------------------
plot(survfit(S1 ~ 1,), xlim=c(0,20))


## ------------------------------------------------------------------------
# todos datos, incluyendo los censurados
with(datos, tapply(time,mobilityPG2, function(x)c(media=mean(x),mediana=median(x))))

# solo lso que tienen status=1

with(datos[datos$status==1,], tapply(time,mobilityPG2, function(x)c(media=mean(x),mediana=median(x))))



## ----, fig.width=5-------------------------------------------------------
mod1 <- survfit(S1 ~ mobilityPG2 , datos)
plot(mod1, col=c(1,2), ylab=expression(hat(S)(t)))


## ------------------------------------------------------------------------

summary(mod1)



## ------------------------------------------------------------------------
mod1



## ------------------------------------------------------------------------
# todos datos, incluyendo los censurados
with(datos, tapply(time,Q6, function(x)c(media=mean(x),mediana=median(x))))

# solo lso que tienen status=1

with(datos[datos$status==1,], tapply(time,Q6, function(x)c(media=mean(x),mediana=median(x))))



## ------------------------------------------------------------------------
# elijo una paleta de colores
library(RColorBrewer)
colores <- brewer.pal(10,"Set3")



## ----, fig.width=5-------------------------------------------------------
mod2 <- survfit(S1 ~ Q6 , datos)
plot(mod2, col=colores[1:6], ylab=expression(hat(S)(t)),lwd=3,cex=0.2)


## ------------------------------------------------------------------------

summary(mod2)



## ------------------------------------------------------------------------
mod2



## ------------------------------------------------------------------------
mod3 <- survreg(S1 ~ Q6, data=datos, dist ="exponential")
summary(mod3)


## ------------------------------------------------------------------------
round(summary(mod3)$table,3)


## ------------------------------------------------------------------------
# la Weibull es la distribución por defecto en survreg y no hace falta especificarlo
mod4 <- survreg(S1 ~ Q6, data=datos)
summary(mod4)
round(summary(mod4)$table,4)



## ------------------------------------------------------------------------
anova(mod3, mod4)



## ------------------------------------------------------------------------
datos$Q6_rec <- datos$Q6
levels(datos$Q6_rec)
levels(datos$Q6_rec)[c(1,4,5)] <- "Grupo1"
levels(datos$Q6_rec)



## ------------------------------------------------------------------------
mod5 <- survreg(S1 ~ Q6_rec, data=datos)
anova(mod4,mod5)


