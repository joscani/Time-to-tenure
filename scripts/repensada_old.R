####################################################################
# Auth: jlcr
# Subj: Cargar y depurar bd de stata
# Date: Mayo 2014
####################################################################
# La variable de tiempo va a ser TimePermCani y la de movilidad es mobilityPT, (0,1), 1
# si se mueve.
# y la de  status va a ser PermanentCani.

# Eliminar los que TimePermCani<0
# y a los que son 0 sumarles 0.1

# La de  país es Countryb
# Género es Q23
# Edad es Q24
# Single not single Q25
# Q26 es hijos menores de 18 ()
# Q6 es campo de investigación
# 



# Librerías (no todas necesarias)
library(foreign)
library(effects)
library(car)
library(memisc)
library(MASS)
library(RColorBrewer)

colores <- brewer.pal(10,"Set3")

# carga datos, datos de fecha del 22/05/2014 
datos <- read.dta("../data/working_10_newvariablesV10_Druid_22052014.dta")
names(datos)

datos <- datos[,c("Countryb","Q23","Q24","Q25","Q26","Q6","TimePermCani","mobilityPT","PermanentCani",
									"foreignEdu2","multidisc","ability","Parenthood","publ_prod2", "Q21_5_1_countb", "Q21_2_1_countb")]
# elimino factores de países que no están
datos$Countryb <- droplevels(as.factor(as.character(datos$Countryb)))

# elijo UK como categoría de referencia
datos$Countryb <- relevel(datos$Countryb,ref="united kingdom")

datos$time <- datos$TimePermCani

datos$status <- datos$PermanentCani

datos2 <- datos[datos$time>=0 & !is.na(datos$time),]
datos2 <- datos2[datos2$ability>=0, ]

datos2$Q6 <- droplevels(datos2$Q6)

#################
# modelos
################

library(survival)
# datos.ventana <- datos2[datos2$time<5,]
S1 <- with(datos2, Surv(time+0.01,status))

# Estimación kaplan-Meier
plot(survfit(S1 ~ 1))
plot(survfit(S1 ~ mobilityPT , datos2), col=c(1,2), ylab=expression(hat(S)(t)))

# Test in R over kaplan-meier. buscar biblio

# log.rang test
survdiff(S1 ~ mobilityPT , datos2)

# con rho=1 tenemos generalised Wilcoxon test
survdiff(S1 ~ mobilityPT , datos2, rho=1)

# con rho=1/2 tenemos Tarone-Ware test
survdiff(S1 ~ mobilityPT , datos2, rho=1/2)


# Cox proportional hazard model

##########
# mobility
##########
fit1 <- coxph(S1 ~ mobilityPT, datos2)
summary(fit1)
# Moverse reduce en un 24% el hazard(riesgo o probabilidad) de obtener una plaza
# permanente y es significativo
nuevos.datos2 <- expand.grid(Countryb=levels(datos2$Countryb),mobilityPT=c(0,1))
nuevos.datos2
plot(survfit(fit1,newdata=nuevos.datos2[c(1,11),]),
     col=c("darkblue","darkred"),cex=0.2)
legend("topright",c("No Mobility","Mobility"),col=c("darkblue","darkred"), lwd=2)



survfit(fit1,newdata=nuevos.datos2[c(1,11),])

# los que se mueven tardan en media un año más en conseguir la plaza


##########
## PAIS ##
##########

# Veamos rápidamente si el país influye

fit2 <- coxph(S1 ~ Countryb, datos2)
summary(fit2)

# valores bajos en los test. indican que si influye el país
# el valor  de exp(coef) para Francia es de 1.17, lo que indica que el riesgo
# de conseguir una plaza permanente en Francia es un 17% más alta que en la de 
# referencia que es el Reino Unido


# Si vemos la curva de supervivencia, está claro que la de Francia está por 
# debajo de la del reino unido (a igual tiempo transcurrido desde el doctorado)
# quedan menos franceses sin tener plaza permanente
plot(survfit(fit2, newdata=nuevos.datos2[c(1,3),]),
     col=c("darkred","darkblue"),cex=0.2, lwd=2, main="Survivor curves \n (2 countries)")
legend("topright",c("United Kingdom","France"),col=c("darkred","darkblue"),lty=1,lwd=2)

# otra forma 
curv1 <- survfit(fit2, newdata=nuevos.datos2[c(1,3),])
plot(curv1$time, curv1$surv[,1],type="b",pch=19,cex=0.4 ,col="darkred",ylab="Survivor",xlab="Time in years")
points(curv1$time, curv1$surv[,2],type="b",pch=19,cex=0.4,col="darkblue")
legend("topright",c("United Kingdom","France"),col=c("darkred","darkblue"),lty=1,lwd=2)


##########
## Disciplina ##
##########
fit3 <- coxph(S1 ~ Q6, datos2)
summary(fit3)

# Los p-valores bajos indican que influyen 
# El riesgo en Social Sciences multiplica por 1.78 el riesgo en Agri Scienci
ficti <- data.frame(id=1:nlevels(datos2$Q6),Q6=levels(datos2$Q6))

plot(survfit(fit3,newdata=ficti[c(1,6),]),col=c("darkred","darkblue"),cex=0.2, lwd=2, main="Survivor curves \n (2 Fields)",conf.int=FALSE)

# otra forma
# plot(survfit(fit3,newdata=ficti[c(1,6),])$time, survfit(fit3,newdata=ficti[c(1,6),])$surv[,1],type="n",ylim=c(0,1))
# lines(survfit(fit3,newdata=ficti[c(1,6),]),type="l",conf.int=TRUE,cex=0.2,lwd=0.5)

legend("topright",c("Natural Sciences","Social Sciences"),col=c("darkred","darkblue"),lty=1,lwd=2)


##########
## Género ##
##########
fit4 <- coxph(S1 ~ Q23, datos2)
summary(fit4)
# Ser hombre tiene un incremento del  riesgo del 13% con respecto a ser mujer
cox.zph(fit4,transform="rank")

#########
# EDAD ##
#########
fit5 <- coxph(S1 ~ Q24, datos2)
summary(fit5)
#Aumntar un año de edad disminuye el riesgo un 1.3% 
cox.zph(fit5,transform="rank")

######################
# Single not single Q25
######################
fit6 <- coxph(S1 ~ Q25, datos2)
summary(fit6)
# no es significativo
cox.zph(fit6,transform="rank")

######################
# Foreign edu
######################
fit7 <- coxph(S1 ~ foreignEdu2, datos2)
summary(fit7)
# significativo por poco
cox.zph(fit7,transform="rank")

################
# multidisc
###############
fit8 <- coxph(S1 ~ multidisc, datos2)
summary(fit8)
#significativo por poco
cox.zph(fit8,transform="rank")

################
# ability: Años desde el master 
###############
fit9 <- coxph(S1 ~ ability, datos2)
summary(fit9)
# no significativo
cox.zph(fit9,transform="rank")

################
# Parenthood (edad a la que tuviste hijos)
###############
fit10 <- coxph(S1 ~ Parenthood, datos2)
summary(fit10)
#
cox.zph(fit10,transform="rank")



################
# publ_prod2 (publicaciones)
###############
fit11 <- coxph(S1 ~ publ_prod2, datos2)
summary(fit11)
# 
cox.zph(fit11,transform="rank")

################
# Q21_5_1_countb (cuanto importan las razones de investigación en tu toma de decisiones laborales (5 mucho))
###############
fit12 <- coxph(S1 ~ Q21_5_1_countb, datos2)
summary(fit12)
# no significativo
cox.zph(fit12,transform="rank")


################
# Q21_2_1_countb (cuanto importan las razones personales en tu toma de decisiones laborales (5 mucho))
###############
fit13 <- coxph(S1 ~ Q21_2_1_countb, datos2)
summary(fit13)
# no significativo
cox.zph(fit13,transform="rank")



#######################
# Modelo multivariante#
#######################
# machaco modelos anteriores pq esta sintaxis
# viene de repensada.R ( meter las de razones de movilidad)

fit7 <- coxph(S1 ~ mobilityPT + Countryb + Q6 + Q23 + Q24 + 
								foreignEdu2 + multidisc + ability +Parenthood +
								publ_prod2  , 
							datos2)
summary(fit7)
anova(fit7)


anova(fit7) # ver help(anova.coxph)

# quito Parenthood

fit7.1 <- coxph(S1 ~ mobilityPT + Countryb + Q6 + Q23 + Q24 + 
								foreignEdu2 + multidisc + ability  +
								publ_prod2  , 
							datos2)

anova(fit7.1)

# quito ability
fit7.2 <- coxph(S1 ~ mobilityPT + Countryb + Q6 + Q23 + Q24 + 
									foreignEdu2 + multidisc  + publ_prod2  , 
								datos2)

anova(fit7.2)
cox.zph(fit7.2, transform="rank")


# estratifico por país
fit8 <- coxph(S1 ~ mobilityPT + strata(Countryb) + Q6 + Q23 + Q24 + 
								foreignEdu2 + multidisc  + publ_prod2  , 
							datos2)

summary(fit8)
anova(fit8)
cox.zph(fit8)


# cheqeamos interacciones. (se complica mucho el modlo)



###############################
# Seleccion modelo mediante AIC (Cazando modelos)
###############################
library(MASS)
# Me quedo con los casos completos para poder realizar el stepAIC
datos3 <- datos2[complete.cases(datos2),]
table(datos3$Countryb)
S1 <- with(datos3,Surv(time,status))
fit.basal <- coxph(S1 ~ 1, datos3) 
fit.sup <- coxph(S1 ~    strata(Countryb) +mobilityPT + (Countryb+ Q6 + Q23 + Q24 + 
								 	foreignEdu2 + multidisc  + publ_prod2)^2 , datos3)

fit.stp <- stepAIC(fit.basal,scope=list(lower=fit.basal,upper=fit.sup),
 ,direction="both")

cox.zph(fit.stp)

anova(fit.stp)

# la edad no veo claro qeu sea una variable a modelar
# me da ideas sobre un mejor modelo, dónde incluyo la interacción entre
# Q6 y Q24 que parece importante

S1 <- with(datos2,Surv(time,status))

fit.def <- coxph(S1 ~ Q6 + strata(Countryb) + Q24 + Q23 + mobilityPT + 
								 	multidisc + publ_prod2 + foreignEdu2 + Q6:Q24, data = datos2)

summary(fit.def)

anova(fit.def)
# quito publ_prod2
fit.def <- coxph(S1 ~ Q6 + strata(Countryb) + Q24 + Q23 + mobilityPT + 
                   multidisc  + foreignEdu2 + Q6:Q24, data = datos2)


anova(fit.def)

ficticio <- expand.grid(
												Countryb=levels(datos2$Countryb),
												Q24=seq(26,60,8),
												Q23 = levels(datos2$Q23),
												mobilityPT=c(0,1),
												multidisc=c(0,1),
                        foreignEdu2=c(0,1),
                        Q6 = levels(datos2$Q6)
												)
# nótese que tenemos más patrones en ficticio que en lso datos

summary(fit.def)

# Voy a quitar la interacción entre Q6 y Q24, (al ver los IC veo que el 1 está
# en todos)
fit.def <- coxph(S1 ~ Q6 + strata(Countryb) + Q24 + Q23 + mobilityPT + 
                   multidisc  + foreignEdu2 , data = datos2)


anova(fit.def)
summary(fit.def)
cox.zph(fit.def,transform="rank")

# Si quiero ver la estimación de las curvas para gente con igual edad y que sólo difieran 
# en países
ind <- expand.grid(Q6=levels(datos2$Q6)[6],Q24=45,Q23=levels(datos2$Q23)[2],
                   mobilityPT=c(1),multidisc=0,foreignEdu2=1)
ind

plot(survfit(fit.def,newdata=ind))
survfit(fit.def,newdata=ind)

# sin estratificar

fit.def.nstrat <- coxph(S1 ~ Q6 + Countryb + Q24 + Q23 + mobilityPT + 
                   multidisc  + foreignEdu2 , data = datos2)


anova(fit.def.nstrat)
summary(fit.def.nstrat)
cox.zph(fit.def.nstrat,transform="rank")



plot(survfit(fit.def.nstrat))
survfit(fit.def.nstrat,newdata=ind)

ind <- expand.grid(Countryb="spain",Q6=levels(datos2$Q6)[1],Q24=45,Q23=levels(datos2$Q23)[2],
                   mobilityPT=c(0,1),multidisc=0,foreignEdu2=0)

plot(survfit(fit.def,newdata=ind))
plot(survfit(fit.def.nstrat,newdata=ind))

survfit(fit.def,newdata=ind)
survfit(fit.def.nstrat,newdata=ind)

# nueva idea sacada de http://www.ats.ucla.edu/stat/r/examples/asa/asa_ch4_r.htm 
# para dibujar las funciones, en 

summary(fit.def.nstrat)

fit.surv <- survfit(fit.def.nstrat, conf.type="none")
fit.surv$social.sciences <- fit.surv$surv^exp(0.512937)
fit.surv$humanities <- fit.surv$surv^exp(0.316796)
plot(fit.surv$time, fit.surv$surv, xlab =" Time to get a permanent (years after PhD)",
     ylab="Survival Probability",ylim=c(0,1),type="b",pch=19,cex=0.6)
points(fit.surv$time,fit.surv$social.sciences, type="b",pch=19, col="darkred",cex=0.6)
points(fit.surv$time,fit.surv$humanities, type="b",pch=19, col="darkblue",cex=0.6)
legend("topright",c("Reference categories","Social science","Humanities"),
       col=c("black","darkred","darkblue"),
       lwd=2)

library(gof)
cumres(fit.def)

# con países


# arboles
library(party)
datos4 <- datos2[,c("time","status","Q6","Countryb","Q24","Q23","mobilityPT","multidisc",
                    "foreignEdu2")]
datos4 <- datos4[complete.cases(datos4),]

stree <- ctree(Surv(time,status) ~Q6 + Countryb + Q24 + Q23 + mobilityPT + 
                 multidisc  + foreignEdu2, datos4,
               controls= ctree_control(minsplit=100))
plot(stree)


# random forest, (extensivo en cálculo)
install.packages("randomForestSRC")
library(randomForestSRC)
res <- rfsrc(Surv(time,status) ~mobilityPT + Countryb+ Q6 + Q23 + Q24 + 
                                foreignEdu2 + multidisc  + publ_prod2, datos2)
plot(res)
