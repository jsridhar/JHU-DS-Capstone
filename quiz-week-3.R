library(stringr); library(tm); library(RWeka); library(rJava)

createSample <- function(fileName) {

  f <- sprintf("./Coursera-SwiftKey/final/en_US/en_US.%s.txt", fileName)
  fileData <- readLines(con <- file(f, open = "r")) #load file
  on.exit(close(con))
  
  sampleText <- sample(fileData, 10000) #10K samaple lines
  sampleText <- removeNumbers(sampleText)
  sampleText <- removePunctuation(sampleText)
  sampleText <- stripWhitespace(sampleText)
  
  return(sampleText)
}

generateGrams <- function(input, f) {
  gram <- NGramTokenizer(input, Weka_control(min=f, max=f))
  gram <- data.frame(table(gram))
  gram <- gram[order(gram$Freq, decreasing = TRUE),]
  gram$gram <- factor(gram$gram, levels=unique(as.character(gram$gram)))
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

  r3Words <- word(t, -3, -1); r2Words <- word(t, -2, -1)
  print(threeGrams[match(r3Words, threeGrams$gram),]$Freq)
  print(twoGrams[match(r2Words, twoGrams$gram),]$Freq)
}

if (file.exists("grams.rda")) load(file = "grams.rda") else createGrams("grams.rda")

suggestNextWord("The guy in front of me just bought a pound of bacon, a bouquet, and a case of",
            c("beer", "cheese", "soda", "pretzels"))

suggestNextWord("You're the reason why I smile everyday. Can you follow me please? It would mean the",
                c("universe", "best", "most", "world"))

suggestNextWord("Hey sunshine, can you follow me and make me the",
                c("smelliest", "bluest", "saddest", "happiest"))

suggestNextWord("Very early observations on the Bills game: Offense still struggling but the",
                c("referees", "players", "crowd", "defence"))

suggestNextWord("Go on a romantic date at the",
                c("beach", "movies", "grocery", "mall"))

suggestNextWord("Well I'm pretty sure my granny has some old bagpipes in her garage I'll dust them off and be on my",
                c("way", "motorcycle", "horse", "phone"))

suggestNextWord("Ohhhhh #PointBreak is on tomorrow. Love that film and haven't seen it in quite some",
                c("time", "years", "weeks", "thing"))

suggestNextWord("After the ice bucket challenge Louis will push his long wet hair out of his eyes with his little",
                c("fingers", "toes", "eyes", "ears"))

suggestNextWord("Be grateful for the good times and keep the faith during the",
                c("worse", "hard", "bad", "sad"))

suggestNextWord("If this isn't the cutest thing you've ever seen, then you must be",
                c("insensitive", "callous", "asleep", "insane"))
