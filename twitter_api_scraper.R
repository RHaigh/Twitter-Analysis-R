library(dplyr)
library(tidytext)
library(rtweet)
library(tidyverse)
library(dplyr)
library(qdapRegex)     
library(plotly)
library(tm)
library(DT)
library(syuzhet)
library(orca)

# You must first create a twitter developer account. This may take several weeks to be approved.
# Once this has been accomplished, register the creation of an app and obtain your api details.
# A helpful guide on how to achieve this (with visuals) can be found here: https://www.extly.com/docs/autotweetng_joocial/tutorials/how-to-auto-post-from-joomla-to-twitter/apply-for-a-twitter-developer-account/#apply-for-a-developer-account

consumer_key <- "insert consumer key"
consumer_secret <- "insert consumer secret"
access_token <- "insert access token"
access_secret <- "insert access secret"

token <- create_token(
  app = "insert your chosen app name",
  consumer_key = consumer_key,
  consumer_secret = consumer_secret,
  access_token = access_token,
  access_secret = access_secret)

# You will also require a google maps API key to perform location analysis.
# Apply for a google developer account and activate the GeoCoding API from your dashbaord once this has been approved. 

Sys.setenv(GOOGLE_API_KEY = "API key")

# Download Tweets
# Note this only goes back 6-9 days - longer history requires enterprise level API.

# Enter in the filters you would like to search for. For this example we will use #Brexit and some related terms:
tweets <- search_tweets(
  "#brexit OR #euexit OR #leave OR #remain -filter:retweets -filter:quote -filter:replies",
  n = 18000, include_rts = FALSE, type = "recent",
  retryonratelimit = TRUE
)

# Note that the twitter API allows a maximum collection of only 18000 tweets per day so plan your scrape accordingly. 

tweetsDF <- tweets %>%
  select(created_at, text) %>%
  arrange(desc(created_at))

text <- str_c(tweetsDF$text, collapse = "")

# Clean up the text to remove unwanted characters / data:
text <- text %>%
  str_remove("\\n") %>%                   # remove linebreaks
  rm_twitter_url() %>%                    # Remove URLS
  rm_url() %>%
  str_remove_all("#\\S+") %>%             # Remove any hashtags
  str_remove_all("@\\S+") %>%             # Remove any @ mentions
  removeWords(stopwords("english")) %>%   # Remove common words (a, the, it etc.)
  removeNumbers() %>%
  stripWhitespace() %>%
  removeWords(c("amp"))                   # Final cleanup of other small changes

tweets <- Corpus(VectorSource(text)) %>%
  TermDocumentMatrix() %>%
  as.matrix()

tweets <- sort(rowSums(tweets), decreasing=TRUE)
tweets <- data.frame(word = names(tweets), freq=tweets, row.names = NULL)


