
## ----, warning=FALSE, echo=FALSE-----------------------------------------
library(foreign)
datos <- read.dta("../data/working_10_Cleaner.dta")


datos <- datos[,c("ability","Countryb","Q6","Q23","Q24","Q25","Q27",
    					"Parenthood", "foreign", "foreignEdu2",
						"multidisc", "TimePermCG5","PermanentCG5",
						"mobilityPG24")]

datos$Countryb <- droplevels(as.factor(as.character(datos$Countryb)))
datos$Countryb <- relevel(datos$Countryb,ref="united kingdom")

datos$time <- datos$TimePermCG5

datos$status <- datos$PermanentCG5

datos <- datos[!is.na(datos$time),]



datos$time <- datos$time +0.001

datos$Q6 <- droplevels(datos$Q6)



## ------------------------------------------------------------------------
library(survival)
library(rms)


## ------------------------------------------------------------------------
S1 <- with(datos, Surv(time,status))


## ----, fig.width=5-------------------------------------------------------
survplot(npsurv(S1 ~ 1))



## ----, fig.width=5-------------------------------------------------------
mod1 <- npsurv(S1 ~ mobilityPG24 , datos)
mod1
survplot(mod1, ylab=expression(hat(S)(t)))


## ------------------------------------------------------------------------
survdiff(S1~ mobilityPG24 , datos)


## ------------------------------------------------------------------------
# elijo una paleta de colores
library(RColorBrewer)
colores <- brewer.pal(6,"Dark2")



## ----, fig.width=5-------------------------------------------------------
mod2 <- npsurv(S1 ~ Q6 , datos)
mod2
survplot(mod2, col = colores, lwd = 2,
         ylab = expression(hat(S)(t)),
         time.inc = 5,
         conf = "none", levels.only = TRUE)


## ------------------------------------------------------------------------
survdiff(S1 ~ Q6 , datos)


## ----, echo=FALSE--------------------------------------------------------
# elijo una paleta de colores
library(RColorBrewer)
colores <- brewer.pal(10,"Paired")



## ----, fig.width=5-------------------------------------------------------
mod3 <- npsurv(S1 ~ Countryb , datos)
mod3
survplot(mod3, col = colores, lwd = 2,
         ylab = expression(hat(S)(t)),
         time.inc = 5,
         conf = "none", levels.only = TRUE)


## ------------------------------------------------------------------------
survdiff(S1 ~ Countryb , datos)


## ------------------------------------------------------------------------
table(datos$Q6)
table(datos$Countryb)


## ------------------------------------------------------------------------
# Pongo social sciences como referencia. En countryb no hace falta pq uk ya es la referencia
datos$Q6 <- relevel(datos$Q6, ref = "Social Sciences" )


## ----, warning=FALSE-----------------------------------------------------
# me quedo con datos 
filtro <- !is.na(datos$Q6) & !is.na(datos$mobilityPG24)
table(filtro)
S1.nuevo <-  with(datos[filtro,], Surv(time,status))
mod.cph <- coxph(S1.nuevo ~ Q6 * mobilityPG24 * Countryb, 
    data = datos[filtro, ], method="breslow")

mod.cph.step <- step(mod.cph)

summary(mod.cph.step)


## ------------------------------------------------------------------------
coeficientes <- coef(mod.cph.step)
data.frame(1:length(coeficientes), coeficientes)
# España, sin movilidad y ciencias sociales
perfil1 <- coeficientes[13]

# España, movilidad, ciencias sociales 
perfil2 <- coeficientes[6] + coeficientes[13] + coeficientes[22]

(riesgo <- exp(perfil1)/exp(perfil2))




## ------------------------------------------------------------------------
# Alemania, movilidad, ciencias sociales

perfil3 <- coeficientes[6]+ coeficientes[9] + coeficientes[18]
exp(perfil2) / exp(perfil3)


## ------------------------------------------------------------------------
anova(mod.cph.step)


## ----, echo=FALSE--------------------------------------------------------
## Plot KM curves

res.km <- npsurv( Surv(time,status) ~ mobilityPG24 , data=datos[filtro & datos$Countryb=="united kingdom" & datos$Q6=="Social Sciences",])
survplot(fit  = res.km,
         conf = c("none","bands","bars")[1],
         xlab = "", ylab = "Survival",
#          label.curves = TRUE,                     # label curves directly
         time.inc = 5,                          # time increment
#          n.risk   = TRUE,                         # show number at risk
         )

## Plot Cox prediction (use survfit)
lines(survfit(mod.cph.step,
              newdata = data.frame(mobilityPG24 = 0:1,
                        Q6=levels(datos$Q6)[1], Countryb=levels(datos$Countryb)[1])),
      col = "darkred", lwd=1.2, lty = 1:2, mark.time = FALSE)

legend(x = "topright",
       legend = c("Kaplan-Meier", "Cox "),
       lwd = 2, bty = "n",
       col = c("black", "darkred"))



## ----, echo=FALSE--------------------------------------------------------
res.km <- npsurv( Surv(time,status) ~ mobilityPG24 , data=datos[filtro & datos$Countryb=="spain" & datos$Q6=="Social Sciences",])
survplot(fit  = res.km,
         conf = c("none","bands","bars")[1],
         xlab = "", ylab = "Survival",
#          label.curves = TRUE,                     # label curves directly
         time.inc = 5,                          # time increment
#          n.risk   = TRUE,                         # show number at risk
         )

## Plot Cox prediction (use survfit)
lines(survfit(mod.cph.step,
              newdata = data.frame(mobilityPG24 = 0:1,
                        Q6=levels(datos$Q6)[1], Countryb="spain")),
      col = "darkred", lwd=1.2, lty = 1:2, mark.time = FALSE)

legend(x = "topright",
       legend = c("Kaplan-Meier", "Cox "),
       lwd = 2, bty = "n",
       col = c("black", "darkred"))



## ------------------------------------------------------------------------
test.asun <- cox.zph(mod.cph.step, transform="rank")
round(test.asun$table,3)



## ------------------------------------------------------------------------
round(p.adjust(test.asun$table[,3], method = "bonferroni"),3)


## ------------------------------------------------------------------------
mod.cph.strat <- coxph(S1.nuevo ~ Q6 + mobilityPG24 + strata(Countryb), 
    data = datos[filtro, ], method = "breslow")
test.asun <- cox.zph(mod.cph.strat, transform="rank")
round(test.asun$table,3)
round(p.adjust(test.asun$table[,3], method = "bonferroni"),3)

mod.cph.strat2 <- coxph(S1.nuevo ~ Q6 + mobilityPG24 * strata(Countryb), 
    data = datos[filtro, ], method = "breslow")

anova(mod.cph.strat, mod.cph.strat2)


## ------------------------------------------------------------------------
mod.cph.strat3 <- coxph(S1.nuevo ~  mobilityPG24 * strata(Countryb)+  strata(Q6), 
    data = datos[filtro, ], method = "breslow")

test.asun <- cox.zph(mod.cph.strat3, transform="rank")

round(test.asun$table,3)
round(p.adjust(test.asun$table[,3], method = "bonferroni"),3)

mod.cph.strat31 <- coxph(S1.nuevo ~  mobilityPG24 + strata(Countryb)+ strata(Q6), 
    data = datos[filtro, ], method = "breslow")
anova(mod.cph.strat3, mod.cph.strat31)


## ------------------------------------------------------------------------
summary(mod.cph.strat3)


## ------------------------------------------------------------------------
survplot(npsurv(Surv(time,status)~ mobilityPG24 , datos[datos$Countryb=="italy",]),conf="none")


## ----, fig.width=10, fig.height=9----------------------------------------
par(mfrow=c(3,3))
lapply(1:10, function(x){
                        survplot(
                            npsurv(Surv(time,status)~ mobilityPG24 ,
                            datos[datos$Countryb==levels(datos$Countryb)[x],]),
                            xlim = c(0,40),
                            time.inc = 2,    
                            conf="none" 
                            )
                        title(main=toupper(levels(datos$Countryb)[x]))
                        }
       )



## ----,fig.width=10-------------------------------------------------------
par(mfrow=c(2,3))
lapply(1:6, function(x){
                        survplot(
                            npsurv(Surv(time,status)~ mobilityPG24 ,
                            datos[datos$Q6==levels(datos$Q6)[x],]),
#                             xlim = c(0,40),
                            time.inc = 2,    
                            conf="none"
                            )
                        title(main=toupper(levels(datos$Q6)[x]))
                        }
       )



## ------------------------------------------------------------------------
 with(datos, table(time, status))


## ------------------------------------------------------------------------
aux <- datos[filtro & datos$Countryb!="italy",]
aux$Countryb <- droplevels(aux$Countryb)
S2 <- with(aux,Surv(time,status))


## ------------------------------------------------------------------------
mod.noitaly1 <- coxph(S2 ~  mobilityPG24 * strata(Countryb)+ strata(Q6) , 
    data = aux, method = "breslow")

test.asun <- cox.zph(mod.noitaly1, transform="rank", global=FALSE)

round(test.asun$table,3)
round(p.adjust(test.asun$table[,3], method = "bonferroni"),3)



## ------------------------------------------------------------------------

anova(mod.noitaly1)

mod.noitaly2 <- coxph(S2 ~  mobilityPG24 + strata(Countryb)+ strata(Q6) , 
    data = aux, method = "breslow")

anova(mod.noitaly2, mod.noitaly1)


## ------------------------------------------------------------------------
summary(mod.noitaly2)


## ------------------------------------------------------------------------
mod.noitaly3 <- coxph(S2 ~  mobilityPG24 + strata(Countryb)+ Q6 , 
    data = aux, method = "breslow")

anova(mod.noitaly3, mod.noitaly2)


## ------------------------------------------------------------------------
dat1 <-  expand.grid(levels(aux$Q6), levels(aux$Countryb), 0:1)
names(dat1) <- c("Q6", "Countryb", "mobilityPG24")
dat1 <- dat1[!(dat1$Countryb=="netherlands" & dat1$Q6=="Agricultural Sciences"),]
predict(mod.noitaly2, newdata=dat1, type="risk")


