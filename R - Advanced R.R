####### Componentes Basicos #######
#data frames
df <- data.frame(runif(3), runif(3))
names(df) <- c(1, 2)

#Nombres no sintácticos
df$'3' <- df$'1' + df$'2'
?reserved

#create vectors
a <- c(1, 5, 3, 2)
b <- a
b[[1]] <- 10
# Los vectores vienen en dos sabores: vectores atómicos y listas. 
# Se diferencian en cuanto a los tipos de sus elementos: para los vectores atómicos, 
# todos los elementos deben tener el mismo tipo; para las listas, los elementos 
# pueden tener diferentes tipos.
# Los cuatro tipos comunes de vectores atómicos son lógicos, enteros, dobles y de carácter

#integer
1L

#coertion
c(1, FALSE)
c("a", 1)
c(TRUE, 1L)

#attributes
# Los atributos le permiten asociar metadatos adicionales arbitrarios a cualquier objeto.
a <- 1:3
attr(a, "x") <- "abcdef"
attr(a, "x")

# Arrays definition & structure
x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))

dim(x1)

#dates
date <- as.Date("1970-02-01")
class(date)
typeof(date)

#######    Factors #######
# Un factor es un vector que solo puede contener valores predefinidos. 
# Se utiliza para almacenar datos categóricos. 
# Los factores se construyen sobre un 
# vector entero con dos atributos: una class, “factor”, que hace que se comporte de 
# manera diferente a los vectores enteros normales, y levels, que define el conjunto
# de valores permitidos.
x <- factor(c("a", "b", "b", "a"))
x
typeof(x)
attributes(x)
str(x)

#Cuando tabula un factor obtendrá recuentos de todas las categorías, incluso las no observadas
sex_char <- c("m", "m", "m")
sex_factor <- factor(sex_char, levels = c("m", "f"))

table(sex_char)
table(sex_factor)
#
#factores ordenados
grade <- ordered(c("b", "b", "a", "c"), levels = c("c", "b", "a"))
grade

f1 <- factor(letters)
levels(f1) <- rev(levels(f1))

f2 <- rev(factor(letters))
f3 <- factor(letters, levels = rev(letters))

####### Lists #######
# Las listas son un paso más en complejidad que los vectores atómicos: cada elemento 
# puede ser de cualquier tipo, no solo vectores. 
list1 <- list(
  1:3, 
  "a", 
  c(TRUE, FALSE, TRUE), 
  c(2.3, 5.9)
)

typeof(list1)
str(list1)

#dim : en listas crea matrices
l <- list(1:3, "a", TRUE, 1.0)
dim(l) <- c(2, 2) #creamos matriz 2x2
l[[1,1]]
l[[1,2]]
l[[2,1]]
l[[2,2]]

# Los dos vectores S3 más importantes construidos sobre 
# las listas son los data frames y los tibbles.

####### data frame #######
# Un data frame es una lista con nombre de vectores con atributos para (columna) 
# La longitud de cada uno de sus vectores debe ser la misma. 
df1 <- data.frame(x = 1:3, y = letters[1:3])
typeof(df1)
attributes(df1)
str(df1)
# Esto le da a los data frames su estructura rectangular y 
# explica por qué comparten las propiedades de las matrices y las listas:

# tible es una reinvención del data frame


####### Subconjuntos #######
#Tres operadores de subconjuntos $, [, [[
#Vectores
x <- c(2.1, 4.2, 3.3, 5.4)
x[c(1,4)] #> incluye elementos
x[order(x)]
order(x) # da los indices del vector

x[-c(1,4)] #> excluye elementos

x[c(TRUE, TRUE, FALSE, FALSE)]
x[x > 3]

#Matrices
a <- matrix(1:9, nrow = 3)
colnames(a) <- c("A", "B", "C")
a

a[1:2, ]

a[c(TRUE, FALSE, TRUE), c("B", "A")]

a[0, -2]

#Data frames
df <- data.frame(x = 1:3, y = 3:1, z = letters[1:3])
df[df$x == 2, ] #selecciona filas cuya valor en la columna x es 2
df[c(1, 3), ] #selecciona filas 1 y 3
df[2:3, ] #selecciona filas 2 a 3
df[, c("x", "z")] #selecciona columnas x y z

# Conservar la dimensionalidad
# usar drop = FALSE.
df <- data.frame(a = 1:2, b = 1:2)
str(df[, "a"])
str(df[, "a", drop = FALSE])

# Operador de subconjunto [[, diferencia con [
x <- list(1:3, "a", 4:6)
x[1]
class(x[1]) # tipo lista, un tren más pequeño, varios valores
x[[1]]
class(x[[1]]) #tipo numérico, en contenido del vagon en particular, valor individual

#Ordenacion
#order() toma un vector como entrada y devuelve un vector entero 
x <- c("b", "c", "a")
order(x)
x[order(x)]

#Ordenar dataframe
df <- data.frame(x = c(1, 2, 3, 1, 2), y = 5:1, z = letters[1:5])
df[order(df$x), ]


#Tablas de búsqueda en vectores, coincidencia de caracteres
x <- c("m", "f", "u", "f", "f", "m", "m") 
lookup <- c(m = "Male", f = "Female", u = NA)
lookup[x]
unname(lookup[x])

#Tablas de búsqueda en vectores, coincidencia de caracteres
grades <- c(1, 2, 2, 3, 1)
info <- data.frame(
  grade = 3:1,
  desc = c("Excellent", "Good", "Poor"),
  fail = c(F, F, T)
)

id <- match(grades, info$grade) #match (aguja,pajar)
info[id, ]

####### Flujo de control ####
# if trabaja con escalares; ifelse() trabaja con vectores.
x <- c(1:10)
ifelse(x %% 5 == 0, "XXX", as.character(x))

#Equivalente vectorizado
  dplyr::case_when(
  x %% 35 == 0 ~ "fizz buzz",
  x %% 5 == 0 ~ "fizz",
  x %% 7 == 0 ~ "buzz",
  is.na(x) ~ "???",
  TRUE ~ as.character(x)
)

####### Funciones ####
# Argumentos, cuerpo y entorno
#función anonima
square <- function(x) x^2
deviation <- function(x) x - mean(x)

#funciones anonimas en una lista
funs <- list(
  half = function(x) x / 2,
  double = function(x) x * 2
)

funs$double(10)
funs$half(10)

#funciones anidadas  
x <- runif(100, min =1 , max = 100)
mean(x)
sqrt(mean(square(deviation(x))))

#Canalización
library(magrittr)

x %>%
  deviation() %>%
  square() %>%
  mean() %>%
  sqrt()

#Llamar a funciones con argumentos en una estructura de datos
args <- list(1:10)
mean(args) #error
do.call(mean, args) #do this way

#Valor de función explicito (via return) e implicito (ultima operacion ejecutada)
#implicito
j01 <- function(x) {
  if (x < 10) {
    0
  } else {
    10
  }
}

j01 (14)
#explicito
j02 <- function(x) {
  if (x < 10) {
    return(0)
  } else {
    return(10)
  }
}


##### Entornos #####
library(rlang)
env_print(global_env())
env_print(current_env())

e3 <- env(x = 1, y = 2)

search_envs()
env_print(base_env())

#entorno de ejecucion de la función - cada vez que se ejecuta la funcion
#siempre se crea un nuevo entorno, que se elimina una vez ejecutada la funcion (es efimero)
g <- function(x) {
  if (!env_has(current_env(), "a")) {
    message("Defining a")
    a <- 1
  } else {
    a <- a + 1
  }
  a
}
g(10)
g(10)


#### Programacion funcional ####
#Toma de entrada una función y devuelve un vector
randomise <- function(f) f(runif(1000))
randomise(mean)
randomise(sum) 
randomise(length)

###### Using map de purr ######
triple <- function(x) x * 3 # Definimos funcion a utilizar
purrr::map(1:3, triple) # Toma un vector y una función, llama a la función por cada elemento y devuelve una lista
#Existen 23 variantes, que modifican el resultado de map:  map_lgl(), map_int(), map_dbl() y map_chr()
purrr::map_int(1:3, triple) # Devuelve lista de 3 enteros, vector atómico de tipo entero
purrr::map_dbl(mtcars, function(x) length(unique(x))) # Función anonima en linea que devuelve vector atómico del tipo especificado

#Escrito de otra manera
purrr::map_dbl(mtcars, ~ length(unique(.x))) #En lugar de una función existente, puedo crear una nueva
#Reemplazos de bucle for como lapply(), apply() y tapply() son funcionales también


###### Using replacemnts for iterations: lapply(), apply(), tapply() ######
#apply resume una matriz al colapsar cada file o columna en un solo valor
#Va muy bien par amatrices y funciones de resumen numerico
apply(X = mtcars, #X: matriz, MARGIN: filas o columnas, FUN: la funcion
      MARGIN = 2, 
      FUN = mean ) 


?lapply  #returns a list of the same length than X
lapply(X = mtcars, 
      FUN = mean ) 

?sapply #returns a vector or matrix
sapply(X = mtcars, 
       FUN = mean ) 

?tapply #apply a function to a group of data rows 
        #defined by levels of a factor
tapply(X = mtcars$mpg, 
      INDEX = gear ,
       FUN = mean ) 
