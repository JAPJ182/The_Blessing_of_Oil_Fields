
#load("C:/Users/USER/Desktop/DID roads/did_roads/did_roads.RData")
lista = c('readr','readxl','sqldf','plyr', 
          'did' , 'arrow',  'plyr', 'ggplot2',
          'dplyr','fixest' , 'gargle' , 'stringr'
          #, 'bigrquery' 
)
for (i in 1:length(lista) ) {
  if(lista[i] %in% rownames(installed.packages( lib.loc = "C:/Program Files/R/R-4.2.2/library")) == FALSE) {
    install.packages(lista[i])
  }
  lapply(lista[i], library, character.only = TRUE)
}

## First cambio sobre una funcion en R
