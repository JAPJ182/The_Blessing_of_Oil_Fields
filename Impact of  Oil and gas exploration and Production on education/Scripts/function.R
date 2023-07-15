
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

library(haven)
Priorizacion_racionesxgrupo <- read_dta("C:/Users/Usuario/Downloads/Costeo PAE 2023/Costeo PAE 2023/Data/Final/Priorizacion_racionesxgrupo.dta")
library(haven)
Output_costo_transporte <- read_dta("C:/Users/Usuario/Downloads/Costeo PAE 2023/Costeo PAE 2023/Data/Final/Output_costo_transporte.dta")
haven::print_labels(Output_costo_transporte)
str(Output_costo_transporte)
arrow::write_parquet(Output_costo_transporte, 'costo_transporte.parquet')
getwd()
library(readxl)
DIVIPOLA_Municipios <- read_excel("C:/Users/Usuario/Downloads/DIVIPOLA_Municipios.xlsx", 
                                  range = "A1:G1132")
colnames(DIVIPOLA_Municipios) = c('dept_cod', 'dept', 'mun_cod' , 'muni', 'tipo_mun',
                                  'LATI', 'LONG' )
DIVIPOLA_Municipios = DIVIPOLA_Municipios[c(11:nrow(DIVIPOLA_Municipios)), ]
arrow::write_parquet(DIVIPOLA_Municipios, 'Municipios.parquet')


###########################
ETC_center = data.frame()
for (i in unique(Output_costo_transporte$Cod_ETC)) {
  tempo = subset(Output_costo_transporte,Output_costo_transporte$Cod_ETC == i)
  temp = data.frame(table(tempo$Divipola_MUNICIPIO) )
  temp = subset(temp, temp$Freq == max(temp$Freq))
  temp$ETC = i
  colnames(temp)[1] = 'main_mun_etc'
  ETC_center = rbind(temp, ETC_center)
}
ETC_center = sqldf("SELECT 
                  LATI LAT_ORIGEN, LONG LONG_ORIGEN, 0 AS ID_ORIGEN, ETC
FROM ETC_center
      INNER JOIN DIVIPOLA_Municipios
      ON mun_cod = main_mun_etc")



arrow::write_parquet(ETC_center, 'ETC_center.parquet')

unique(ETC_center$ETC)
