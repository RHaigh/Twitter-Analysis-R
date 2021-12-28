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

# Enter in the filters you would like to search for. For this example we will use #coronavirus and some related terms:
# Collect your tweets
tweets <- search_tweets(
  "schoolclosureuk OR coronavirus covid19uk -filter:retweets -filter:quote -filter:replies",
  geocode = "57.47,-4.22,100km", 
  n = 100, include_rts = FALSE, type = "recent", lang = "en", retryonratelimit = F)

# Optional arguments
# n = number of tweets, 18000 per day MAX
# lang = chosen language
# geocode = chosen lat and long and radius to collect within

# ================== DATA CLEAN  ==================
# Grab our most useful columns only
tweets <- tweets %>%
  select(created_at, text, hashtags, location) %>%
  arrange(desc(created_at))

# Remove non utf characters (emjoys, escape characters, etc) from text strings
tweets$text = gsub("&amp", "", tweets$text)
tweets$text = gsub("&amp", "", tweets$text)
tweets$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets$text)
tweets$text = gsub("@\\w+", "", tweets$text)
tweets$text = gsub("[[:punct:]]", "", tweets$text)
tweets$text = gsub("[[:digit:]]", "", tweets$text)
tweets$text = gsub("http\\w+", "", tweets$text)
tweets$text = gsub("[ \t]{2,}", "", tweets$text)
tweets$text = gsub("^\\s+|\\s+$", "", tweets$text)
tweets$text <- iconv(tweets$text, "UTF-8", "ASCII", sub="")

# Final output will be a 'tweets' dataframe with 4 columns that can be passed to further analysis tools
