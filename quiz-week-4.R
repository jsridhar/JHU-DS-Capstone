library(stringr); library(tm); library(RWeka); library(rJava)

createSample <- function(fileName) {

  f <- sprintf("./Coursera-SwiftKey/final/en_US/en_US.%s.txt", fileName)
  fileData <- readLines(con <-file(f, open = "r")) #load file
  on.exit(close(con))
  
  sampleText <- sample(fileData, 20000) #20K samaple lines
  sampleText <- removeNumbers(sampleText)
  sampleText <- removePunctuation(sampleText)
  sampleText <- stripWhitespace(sampleText)
  sampleText <- stemDocument(sampleText)
  
  return(sampleText)
}

generateGrams <- function(input, f) {
  gram <- NGramTokenizer(input, Weka_control(min=f, max=f))
  gram <- data.frame(table(gram))
  gram <- gram[order(gram$Freq, decreasing = TRUE),]
  gram$gram <- factor(gram$gram, levels=unique(as.character(gram$gram)))
  gram$gram <- levels(gram$gram)
  return(gram)
}

createGrams <- function(fileName) {
  input <- c(createSample("twitter"), createSample("blogs"), createSample("news"))
  
  threeGrams <<- generateGrams(input, 3)
  twoGrams <<- generateGrams(input, 2)

  save(threeGrams, twoGrams, file = fileName)
}

suggestNextWord <- function(input, resultList) {

  t <-  apply(expand.grid(input, resultList), 1, paste, collapse=" ")
  t <- removeNumbers(t)
  t <- removePunctuation(t)
  t <- stripWhitespace(t)
  t <- stemDocument(t)

  r3Words <- word(t, -3, -1); r2Words <- word(t, -2, -1)
  message("Sentence:", input)
  print(resultList)
  print(threeGrams[match(r3Words, threeGrams$gram),]$Freq)
  print(twoGrams[match(r2Words, twoGrams$gram),]$Freq)
}

if (!file.exists("grams.rda")) createGrams("grams.rda")
if (!exists("threeGrams") || !exists("twoGrams")) load(file = "grams.rda")

suggestNextWord("When you breathe, I want to be the air for you. I'll be there for you, I'd live and I'd",
            c("eat", "sleep", "die", "give"))

suggestNextWord("Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his",
                c("spiritual", "financial", "marital", "horticultural"))

suggestNextWord("I'd give anything to see arctic monkeys this",
                c("month", "weekend", "decade", "morning"))

suggestNextWord("Talking to your mom has the same effect as a hug and helps reduce your",
                c("hunger", "happiness", "stress", "sleepiness"))

suggestNextWord("When you were in Holland you were like 1 inch away from me but you hadn't time to take a",
                c("minute", "look", "picture", "walk"))

suggestNextWord("I'd just like all of these questions answered, a presentation of evidence, and a jury to settle the",
                c("matter", "case", "incident", "account"))

suggestNextWord("I can't deal with unsymetrical things. I can't even hold an uneven number of bags of groceries in each",
                c("hand", "finger", "arm", "toe"))

suggestNextWord("Every inch of you is perfect from the bottom to the",
                c("center", "side", "top", "middle"))

suggestNextWord("I'm thankful my childhood was filled with imagination and bruises from playing",
                c("outside", "inside", "weekly", "daily"))

suggestNextWord("I like how the same people are in almost all of Adam Sandler's",
                c("pictures", "movies", "stories", "novels"))
