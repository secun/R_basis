library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(lubridate)

# Set the working directory to the location of the current script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
getwd()
# Read the Excel file into a data frame
data <- read_excel("Notas_Parcial1.xlsx", sheet="Parcial 1")
# Replace spaces with hyphens in column names
colnames(data) <- c("Alumno","PT1","PT2","PT3","PT4","PT5","PT6",
                    "PT7","PT8","PT9","PT10","PT11","PT12",
                    "PP1","PP2","PP3","PP4", 
                    "NotaTeorica_12","NotaPractica_4","NotaTeorica_10","NotaPractica_10")

# Remove row 1
data= data[-1,]
# remove no presentados ,transform data
data= subset(data, NotaTeorica_12 != 0)
str(data)
data$NotaTeorica_12 = as.double(data$NotaTeorica_12,round=3)
data$NotaPractica_4 = as.double(data$NotaPractica_4,round=3)
data$NotaTeorica_10 = as.double(data$NotaTeorica_10,round=3)
data$NotaPractica_10=as.double(data$NotaPractica_10, round=3)


#Plantilla de resultados
Plantilla=as.vector(c("B",	"D",	"D",	"D",	"C",	"D",	"B",	"D",	"C","B",	"B",	"A",	# Preguntas teóricas
                      "B",	"A",	"B",	"C")) # Preguntas prácticas


#### Analisis por preguntas ####
# Use apply to create all contingency tables
pt_cols <- select(data, starts_with("PT"))
pp_cols <- select(data, starts_with("PP"))
contingency_tables_pt <- apply(X=pt_cols, 
                               MARGIN=2,
                               FUN= table, 
                               useNA= "ifany")
contingency_tables_pp <- apply(X=pp_cols, 
                               MARGIN=2,
                               FUN= table, 
                               useNA= "ifany")

#### Visualize per question ######
#Screen for 12 theoretical questions + 4 practical questions
#Mark the right question
colorines <- data.frame(
  A =  factor(sample(c("green", "grey"), 16, replace = TRUE)),
  B = factor(sample(c("green", "grey"), 16, replace = TRUE)),
  C = factor(sample(c("green", "grey"), 16, replace = TRUE)),
  D = factor(sample(c("green", "grey"), 16, replace = TRUE))
)
colorines[1,]= c("grey", "green","grey","grey")
colorines[2,]= c("grey", "grey","grey","green")
colorines[3,]= c("grey", "grey","grey","green")
colorines[4,]= c("grey", "grey","grey","green")
colorines[5,]= c("grey", "grey","green","grey")
colorines[6,]= c("grey", "grey","grey","green")
colorines[7,]= c("grey", "green","grey","grey")
colorines[8,]= c("grey", "grey","green","grey") # No B answers
colorines[9,]= c("grey", "grey","green","grey")
colorines[10,]= c("grey", "green","grey","grey")
colorines[11,]= c("grey", "green","grey","grey")
colorines[12,]= c("green", "grey","grey","grey")
colorines[13,]= c("grey","green","grey","grey")
colorines[14,]= c("green", "grey","grey","grey")
colorines[15,]= c("grey", "green","grey","grey")
colorines[16,]= c("grey","green","grey", "grey") # No B answers

# Set up the plotting area as a 4x3 matrix
par(mfrow = c(4, 3),cex.axis =2)
par(mar=c(1,1,1,1))
# Loop through each question and create a barplot
for (i in 1:12) {
  barplot(contingency_tables_pt[[i]], 
          main = paste("Pregunta Teórica", i),
          xlab = dimnames(contingency_tables_pt[[i]]),
          col= as.character(colorines[i,])
  )
}

# Set up the plotting area as a 2x2 matrix
par(mfrow = c(2, 2), cex.axis =2)
par(mar=c(1,1,1,1))
# Loop through each question and create a barplot
for (i in 1:4) {
  barplot(contingency_tables_pp[[i]], 
          main = paste("Pregunta Teórica", i),
          xlab =  dimnames(contingency_tables_pp[[i]]),
          col= as.character(colorines[12+i,])
  )
}
# Reset to default single plot layout
par(mfrow = c(1, 1))

#### Visualize total alumni ######
hist(data$NotaTeorica_10, main = "Resultados examen teórico sobre 10")
hist(data$NotaPractica_10 , main = "Resultados examen Practico sobre 10")

#Transform data
# Create the box plot for nota teorica
# Transform data to long format
data_long <- pivot_longer(data[,20:21], cols = everything(), names_to = "Variable", values_to = "Value")

# Create box plot for both scores
ggplot(data_long, aes(x = Variable, y = Value)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  labs(title = "Box Plot of Theoretical and Practical Scores",
       x = "Tipo examen",
       y = "Calificacion") +
  theme_minimal()


#Bivariate analysis
cov(data$NotaTeorica_10,data$NotaPractica_10)
cor(data$NotaTeorica_10,data$NotaPractica_10)

#install.packages("ggrepel")
library(ggrepel)
ggplot(data = data, aes(x=NotaTeorica_10,y=NotaPractica_10,label = Alumno)) + 
  geom_point()+
  geom_text_repel(max.overlaps=45, size=1.5) + # Use geom_text_repel for better label positioning
  #             geom_text(aes(label = Alumno),size=3, angle = 45,vjust = -1) + # Adjust vjust as needed for better positioning of labels
  xlim(-1, 10) +
  ylim(-1, 10) +
  labs(title = "Scatter Plot of Calificaciones de Teoría y Práctica",
       x = "Calificación Teorica (0-10)",
       y = "Calificación Practica (0-10)") +
  theme_minimal()
   
   
#### Analisis respuestas en blanco ######
data$NA_Count <- apply(data, 1, function(x) sum(is.na(x)))
data[data$NA_Count !=0,c(1,22)]
