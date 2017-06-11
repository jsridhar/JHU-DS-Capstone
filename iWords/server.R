#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny); library(tm); library(stringr); library(wordcloud); library(SnowballC)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  if (!exists("threeGrams") || !exists("twoGrams")) load(file = "grams.rda")

  output$plot <- renderPlot({

    wordsList <- suggestNextWord(input$sentence)

    wordcloud(wordsList$gram, wordsList$Freq, max.words=25, 
              random.order=FALSE, rot.per=0.35, colors = brewer.pal(8,"Dark2"))
  })

  suggestNextWord <- function(t) {
    
    w <- c("")
    if (nchar(t) > 0) {
      t <- removeNumbers(t)
      t <- removePunctuation(t)
      t <- stripWhitespace(t)
      t <- stemDocument(t)
      w <- str_extract(t, "\\w+( \\w+){0,1}$")
    }
    
    wList <- threeGrams[startsWith(threeGrams$gram, w),]

    if (length(wList$gram) == 0) {
      w <- str_extract(t, "\\w+( \\w+){0,0}$")
      wList <- twoGrams[startsWith(twoGrams$gram, w),]
    }

    if (length(wList$gram) == 0) wList <- threeGrams[TRUE,]
    if (length(wList$gram) > 50) wList <- wList[1:50,]
    
    wList$gram <- word(wList$gram, -1)
    
    return(wList)
  }
  
})
