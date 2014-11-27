####################################################################
# Auth: jlcr
# Subj: Análisis supervivencia, utilizando Utilizando Puesto - Position 1 
# Date: November  2014
####################################################################

# La variable de tiempo va a ser TimePermCG , la de status PermanentCG
# y la de movilidad mobilityPG2

# Eliminar los que TimePermCG<0
# y a los que son 0 sumarles 0.1

# Q6 : dicipline
# Q23 : Sex
# Q24 : Age
# Q25 : Single
# Q27 : Children (ver variable Parenthood tb )
# Countryb : Country
# foreign : Extranjero
# foreignEdu2 : Si te has educado en un país extranjero
# multidisc : Mobility disciplinar
# Publications


# Librerías (no todas necesarias)
library(foreign)
library(effects)
library(car)
library(memisc)
library(MASS)
library(RColorBrewer)

colores <- brewer.pal(10,"Set3")

# carga datos, 
datos <- read.dta("../data/working_10_Cleaner.dta")
names(datos)

datos <- datos[,c("ability","Countryb","Q6","Q23","Q24","Q25","Q27",
						"Parenthood", "foreign", "foreignEdu2",
						"multidisc", "TimePermCG","PermanentCG",
						"mobilityPG2")]

# elimino factores de países que no están
datos$Countryb <- droplevels(as.factor(as.character(datos$Countryb)))

# elijo UK como categoría de referencia
datos$Countryb <- relevel(datos$Countryb,ref="united kingdom")

datos$time <- datos$TimePermCG

datos$status <- datos$PermanentCG

# quito perdidos 
datos2 <- datos[datos$time>=0 & !is.na(datos$time),]

datos2 <- datos2[datos2$ability>=0, ]

datos2$Q6 <- droplevels(datos2$Q6)

#################
# Con survival
################

library(survival)
# datos.ventana <- datos2[datos2$time<5,]
S1 <- with(datos2, Surv(time+0.1,status, type ="right"))

# Estimación kaplan-Meier
plot(survfit(S1 ~ 1))
plot(survfit(S1 ~ mobilityPG2 , datos2), col=c(1,2), ylab=expression(hat(S)(t)))

# Test in R over kaplan-meier. buscar biblio

# log.rang test
survdiff(S1 ~ mobilityPG2 , datos2)

# con rho=1 tenemos generalised Wilcoxon test
survdiff(S1 ~ mobilityPG2 , datos2, rho=1)

# con rho=1/2 tenemos Tarone-Ware test
survdiff(S1 ~ mobilityPG2 , datos2, rho=1/2)


# probamos distribuciones

library(flexsurv)

model <- flexsurvreg(S1 ~ mobilityPG2, dist ="exp", data = datos2) # fit the exponential model
model
