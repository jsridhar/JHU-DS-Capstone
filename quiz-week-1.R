library(tm)
library(stringi)

# Q1: The en_US.blogs.txt  file is how many megabytes?
blogFileSize <- file.info("./Coursera-SwiftKey/final/en_US/en_US.blogs.txt")$size / (1024*1024)
message("Q1. Size of en_US.blogs.txt: ", blogFileSize, " MB")

# Q2: The en_US.twitter.txt has how many lines of text?
tweets <- readLines(con <- file("./Coursera-SwiftKey/final/en_US/en_US.twitter.txt", open = "r"))
close(con)
message("Q2. Number of lines in en_US.twitter.txt: ", length(tweets))

# Q3: What is the length of the longest line seen in any of the three en_US data sets?
blogs <- readLines(con <- file("./Coursera-SwiftKey/final/en_US/en_US.blogs.txt", open = "r"))
close(con)
message("Q3. Length of longest line in blogs file: ", max(stri_length(blogs)))

news <- readLines(con <- file("./Coursera-SwiftKey/final/en_US/en_US.news.txt", open = "r"))
close(con)
message("Q3. Length of longest line in new file: ", max(stri_length(news)))

message("Q3. Length of longest line in twitter file: ", max(stri_length(tweets)))

# Q4: In the en_US twitter data set, if you divide the number of lines where the word "love" (all lowercase) occurs by the number of lines the word "hate" (all lowercase) occurs, about what do you get?
numberLoves <- length(grep("love", tweets))
numberHates <- length(grep("hate", tweets))
message("Q4. In Twitter - # lines with love / # lines with hate: ", numberLoves / numberHates)

# Q5: The one tweet in the en_US twitter data set that matches the word "biostats" says what?
biostatsTweet <- grep("biostats", tweets)
message("Q4. 'biostats' tweet: ", tweets[biostatsTweet])

#Q6: How many tweets have the exact characters "A computer once beat me at chess, but it was no match for me at kickboxing"
exactTweets <- grep("A computer once beat me at chess, but it was no match for me at kickboxing", tweets)
message("Q6: Exact tweet in Twitter: ", length(exactTweets))
