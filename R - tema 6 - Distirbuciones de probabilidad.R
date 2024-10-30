#TEMA 6 
#Ejercicio 8(p6)
pnorm(q=1, mean=70, sd=5,lower.tail = TRUE)

#Ejercicio Examen parcial (p11)
#Sigue la variable una distr poisson
n=100
p=0.5
l=n*p

pbinom(q=50,size=n,prob=p,lower.tail=TRUE)
ppois(q=50,lambda = l,lower.tail=TRUE)


#Ejercicio Examen parcial (p23)
#for (i in 1:5,0.1) #first option
for (i in seq(1, 2, by = 0.2)) #second option
{
  paramsd=i #Empezamos con sd=1
  prob=pnorm(q=8, mean=5, sd=paramsd,lower.tail = FALSE)
  cat(paramsd, " - ", prob, "\n") # Add newline character for better readability
}

pnorm(q=8, mean=5, sd=1.2,lower.tail = FALSE)
