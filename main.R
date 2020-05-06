# Instalación de devtools y descargar paquete
install.packages("devtools") 
devtools::install_github("renanxcortes/springerQuarantineBooksR", force=TRUE)
library(springerQuarantineBooksR)

# Dónde deseas guardar los libros
setwd ("Users/Alex/Downloads/springer_pdfs")
# Descargar todos los libros en pdf
download_springer_book_files(filetype = "pdf")

# Vamos a crear una tabla con los títulos de Springer
miTabla_springer <- download_springer_table()

install.packages("DT") 
library(DT) 
# Tag HTML para referenciar a su enlace en Springer
miTabla_springer$open_url <- paste0(
  '<a target="_blank" href="', 
  miTabla_springer$open_url, 
  '">URL_En_Springer</a>' 
)
# Vamos a mantener sólo información relevante
miTabla_springer <- miTabla_springer[, c(1:3, 19, 20)]
datatable(miTabla_springer, 
          # Remover los números de fila
          rownames = FALSE, 
          # Agregar filtro en la parte superior de las columnas
          filter = "top", 
          # Añadir los botones de descarga de tabla
          extensions = "Buttons", 
          options = list( 
            autoWidth = TRUE, 
            # Ubicación de los botones de descarga de tabla, y formatos disponibles
            dom = "Blfrtip", 
            buttons = c("copy", "csv", "excel", "pdf", "print"),
            # Mostrar las primeras 8 entradas, por default despliega 10 
            pageLength = 8, 
            # Ordenar la columna de Título de libro, de manera ascendente
            order = list(0, "asc") 
          ), 
          escape = FALSE 
)

library(dplyr)
libros_especificos <- miTabla_springer %>%
  filter(str_detect(
    # Busca en la columna "book_title" la palabra en relación con los libros de tu interés
    book_title,
    "Python" 
  )) %>%
  pull(book_title)

download_springer_book_files(springer_books_titles = libros_especificos)

