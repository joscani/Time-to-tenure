
## ----, warning=FALSE-----------------------------------------------------
library(foreign)
datos <- read.dta("../data/working_10_Cleaner.dta")
head( names(datos))


## ------------------------------------------------------------------------
datos <- datos[,c("ability","Countryb","Q6","Q23","Q24","Q25","Q27",
						"Parenthood", "foreign", "foreignEdu2",
						"multidisc", "TimePermCG5","PermanentCG5",
						"mobilityPG24")]


## ------------------------------------------------------------------------
datos$Countryb <- droplevels(as.factor(as.character(datos$Countryb)))
datos$Countryb <- relevel(datos$Countryb,ref="united kingdom")


## ------------------------------------------------------------------------
datos$time <- datos$TimePermCG5

datos$status <- datos$PermanentCG5



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
datos$time <- datos$time +0.001


## ------------------------------------------------------------------------
table(datos$ability<0, exclude = NULL)



## ------------------------------------------------------------------------
table(datos$Q6)
datos$Q6 <- droplevels(datos$Q6)

table(datos$Q6)


## ------------------------------------------------------------------------
library(survival)
library(rms)


## ------------------------------------------------------------------------
S1 <- with(datos, Surv(time,status))


## ------------------------------------------------------------------------
attributes(S1)


## ------------------------------------------------------------------------
S1[1:6]


## ------------------------------------------------------------------------

datos[1:6, c("time","status")]



## ----, fig.width=5-------------------------------------------------------
survplot(npsurv(S1 ~ 1))



## ----, fig.width=5-------------------------------------------------------
plot(npsurv(S1 ~ 1,), xlim=c(0,20))


## ------------------------------------------------------------------------
# todos datos, incluyendo los censurados
with(datos, tapply(time,mobilityPG24, function(x)c(media=mean(x),mediana=median(x))))

# solo lso que tienen status=1

with(datos[datos$status==1,], tapply(time,mobilityPG24, function(x)c(media=mean(x),mediana=median(x))))



## ----, fig.width=5-------------------------------------------------------
mod1 <- npsurv(S1 ~ mobilityPG24 , datos)
survplot(mod1, ylab=expression(hat(S)(t)))


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
mod2 <- npsurv(S1 ~ Q6 , datos)
survplot(mod2, col = colores[1:6],
         ylab = expression(hat(S)(t)),
         time.inc = 5,
         conf = "none")


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
levels(datos$Q6_rec)[1:5] <- "Grupo1"
levels(datos$Q6_rec)



## ------------------------------------------------------------------------
mod5 <- survreg(S1 ~ Q6_rec, data=datos)
anova(mod4,mod5)


## ------------------------------------------------------------------------

datos$Q6_rec <- datos$Q6
levels(datos$Q6_rec)
levels(datos$Q6_rec)[c(1,4,5)] <- "Grupo1"
levels(datos$Q6_rec)




## ------------------------------------------------------------------------
mod5 <- survreg(S1 ~ Q6_rec, data=datos)
anova(mod4,mod5)


## ------------------------------------------------------------------------
summary(mod5)


## ------------------------------------------------------------------------
datos$Q6_rec2 <- relevel(datos$Q6_rec,ref="Social Sciences")

mod6 <- survreg(S1 ~ Q6_rec2, data=datos)

round(summary(mod6)$table,3)


## ------------------------------------------------------------------------

datos$Q6_rec3 <- datos$Q6_rec2
levels(datos$Q6_rec3)
levels(datos$Q6_rec3)[c(1,3)] <- "Grupo2"
levels(datos$Q6_rec3)

mod7 <- survreg(S1 ~ Q6_rec3, data = datos)
anova(mod6, mod7) 
round(summary(mod7)$table,3)


## ------------------------------------------------------------------------
with(datos, table(Q6, Q6_rec3))



## ------------------------------------------------------------------------
survplot(npsurv(S1 ~ Q6_rec3, datos), lwd=2, col=colores[c(1,4,5)])
survfit(S1 ~ Q6_rec3, datos)



## ------------------------------------------------------------------------
mod8 <- survfit(S1 ~ Q6 + mobilityPG24, data = datos)
plot(mod8, col=colores, lty=c(rep(1,2),rep(2,2),rep(3,2),rep(4,2), rep(5,2),
                              rep(6,2)), lwd=c(rep(2,6),rep(3,6)))


## ------------------------------------------------------------------------
mod8


## ------------------------------------------------------------------------

mod9 <- survreg(S1 ~ Q6 * mobilityPG24 * Countryb  , datos)
mod9.step <- step(mod9)


## ------------------------------------------------------------------------
summary(mod9.step)
round(summary(mod9.step)$table, 3)


## ------------------------------------------------------------------------

# modelo 9 por kaplan meier

res.km <- 
## Define a function to plot survreg prediction by gender

survreg.curves <- function(model, col = "black",
                           toPredict,
                           seq.quantiles = seq(from = 0.00, to = 0.97, by = 0.01),...) {

    x = predict(model, newdata=toPredict,
                type="quantile",
                p = seq.quantiles)
    rownames(x) <- paste0("mobility = ",toPredict$mobilityPG24, " ,Discipline = ", toPredict$Q6, ", Country = ", toPredict$Countryb )  
    y = 1-seq.quantiles
    plot(x[1,],y,type="n", xlab="time", ylab="Survival", axes=F,xlim=c(0,20),...)
    axis(1)
    axis(2, at=c(0,0.25, 0.5, 0.75, 1))
    
    plotlines <- function(t){
        lines(x=t, y=y,...)
        
    }
    apply(x,1, plotlines)

}



## ------------------------------------------------------------------------
# seleccionamos de los datos, los que sean Social Sciences, movilidad 1 y 
# que pertenezcan a Uk y a Spain

dat1 <-  data.frame(Q6 = "Social Sciences", mobilityPG24 = c(0,1),
                         Countryb = "spain" )

dat1

survreg.curves(mod9.step, toPredict = dat1, main="mobility Yes vs No\n in Social Sciences in Spain")

predict(mod9.step, newdata=dat1, type="response")
# 
dat2 <- data.frame(Q6 = "Social Sciences", mobilityPG24 = c(0,1),
                         Countryb = "united kingdom" )
dat2 

survreg.curves(mod9.step, toPredict = dat2, main="mobility Yes vs No\n in Social Sciences in United kingdom")

predict(mod9.step, newdata=dat2, type="response")

dat3 <- data.frame(Q6 = c("Social Sciences"),
                   mobilityPG24 = c(0,1),
                         Countryb = "italy" )

dat3
predict(mod9.step, newdata=dat3, type="response")
survreg.curves(mod9.step, toPredict=dat3)


## ------------------------------------------------------------------------

# Curva supervivencia estimada para la cat de referencia (Uk, agricultural sciences, no movilidad)
curve(exp(-(exp(-mod9.step$coef[1]) * x)^(1/mod9.step$scale)),from=0, to=20,
        col="red", main="Survival curve for Uk, \nin agricultural sciences discipline", xlab="Time", ylab = "Survival estimate")

# Comparamos los mismos con movilidad
curve(exp(-(exp(-mod9.step$coef[1]-mod9.step$coef[7]) * x)^(1/mod9.step$scale)),
      from=0, to = 20,
        col="blue",add=TRUE)

legend("topright",c("No mobility", " Mobility"), col=c("red","blue"),lwd=2)



## ------------------------------------------------------------------------

# Curva supervivencia estimada para la cat Spain,  Social sciences, no movilidad)
curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[14]) * x)^(1/mod9.step$scale)),from=0, to=20,
        col="red", main="Survival curve for Spain, \nin Social sciences discipline", xlab="Time", ylab = "Survival estimate")

# Comparamos los mismos con movilidad
curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[14]-mod9.step$coef[7]-mod9.step$coef[23]) * x)^(1/mod9.step$scale)),
      from=0, to = 20,
        col="blue",add=TRUE)

legend("topright",c("No mobility", " Mobility"), col=c("red","blue"),lwd=2)



## ------------------------------------------------------------------------
# Curva supervivencia estimada para la cat Italia,  Social sciences, no movilidad)
curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[11]) * x)^(1/mod9.step$scale)),from=0, to=20,
        col="red", main="Survival curve for Italy, \nin Social sciences discipline", xlab="Time", ylab = "Survival estimate")

# Comparamos los mismos con movilidad
curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[11]-mod9.step$coef[7]-mod9.step$coef[20]) * x)^(1/mod9.step$scale)),
      from=0, to = 20,
        col="blue",add=TRUE)

legend("topright",c("No mobility", " Mobility"), col=c("red","blue"),lwd=2)




## ------------------------------------------------------------------------
subdatos <- datos[ datos$Countryb=="italy" & datos$Q6=="Social Sciences",]
S2 <- with(subdatos, Surv(time,status))

plot(survfit(S2 ~ mobilityPG24, subdatos))

curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[11]) * x)^(1/mod9.step$scale)),from=0, to=20,
        col="red", add=TRUE)

# Comparamos los mismos con movilidad
curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[11]-mod9.step$coef[7]-mod9.step$coef[20]) * x)^(1/mod9.step$scale)),
      from=0, to = 20,
        col="blue",add=TRUE)

legend("topright",c("No mobility", " Mobility"), col=c("red","blue"),lwd=2)




## ------------------------------------------------------------------------
subdatos <- datos[ datos$Countryb=="spain" & datos$Q6=="Social Sciences",]
S2 <- with(subdatos, Surv(time,status))

plot(survfit(S2 ~ mobilityPG24, subdatos))

curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[14]) * x)^(1/mod9.step$scale)),from=0, to=20,
        col="red", add=TRUE)

# Comparamos los mismos con movilidad
curve(exp(-(exp(-mod9.step$coef[1] - mod9.step$coef[6]- mod9.step$coef[14]-mod9.step$coef[7]-mod9.step$coef[23]) * x)^(1/mod9.step$scale)),
      from=0, to = 20,
        col="blue",add=TRUE)

legend("topright",c("No mobility", " Mobility"), col=c("red","blue"),lwd=2)



## ------------------------------------------------------------------------
subdatos <- datos[ datos$Countryb=="united kingdom" & datos$Q6=="Social Sciences",]
S2 <- with(subdatos, Surv(time,status))

plot(survfit(S2 ~ mobilityPG24, subdatos))




## ------------------------------------------------------------------------
mod.cph <- coxph(S1 ~ Q6 + mobilityPG24 + Countryb + mobilityPG24:Countryb, 
    data = datos)

summary(mod.cph)


## ------------------------------------------------------------------------
dat3
predict(mod.cph, newdata=dat3, type="risk", se.fit=TRUE)



## ------------------------------------------------------------------------
dat1
predict(mod.cph, newdata=dat1, type="risk", se.fit=TRUE)


## ------------------------------------------------------------------------
mod.cph1 <- coxph(S1 ~ Q6 + mobilityPG24 + strata(Countryb), 
    data = datos, method="breslow")

summary(mod.cph1)
predict(mod.cph1, newdata=dat1, type="risk", se.fit=TRUE)


## ------------------------------------------------------------------------
npsurv(mod.cph1)


## ------------------------------------------------------------------------
survplot(npsurv(mod.cph1), levels.only=TRUE, conf="none")



## ------------------------------------------------------------------------
ph_fit_ps <-cox.zph(mod.cph)
round(ph_fit_ps$table,3)

plot(ph_fit_ps)
abline(h=0, lty=3)


## ------------------------------------------------------------------------
mod.cph.test  <-  coxph(S1 ~ Q6 + mobilityPG24 + Countryb + mobilityPG24:Countryb, 
    data = datos)

ph_fit <- cox.zph(mod.cph.test, transform="rank", global=FALSE)
round(ph_fit$table,3)


## ------------------------------------------------------------------------
datos.bis <- survSplit(datos, cut=c(2,5), end = "time", event = "status", start="start")
datos.bis$gt[datos.bis$start<=2] <- 1
datos.bis$gt[datos.bis$start>2 & datos.bis$start<=5 ] <- 2
datos.bis$gt[datos.bis$start>5 ] <- 3
datos.bis$gt <- factor(datos.bis$gt)
# datos.bis$gt[datos.bis$start>10] <- 4
# vemos que coincide si ajusto datos.bis con start coincide 
coxph(Surv(start,time,status)~ Q6 + mobilityPG24 + Countryb + mobilityPG24:Countryb,data=datos.bis)
coxph(S1~Q6 + mobilityPG24 + Countryb + mobilityPG24:Countryb,data=datos)



## ------------------------------------------------------------------------
mod.gt <- coxph(Surv(start,time,status)~Q6 + mobilityPG24 + Countryb + mobilityPG24:Countryb + mobilityPG24:gt + Q6:gt+ Countryb:gt,data=datos.bis)

ph_fit <- cox.zph(mod.gt, transform="rank")
round(ph_fit$table,3)


## ------------------------------------------------------------------------
mod.cph.test  <-  coxph(S1 ~ Q6 +mobilityPG24 + Countryb  + mobilityPG24:Countryb   , 
    data = datos)

ph_fit <- cox.zph(mod.cph.test, transform="rank", global=FALSE)
round(ph_fit$table,3)

dat1
predict(mod.cph.test, dat1, type="risk")

summary(mod.cph.test)
anova(mod.cph.test)


