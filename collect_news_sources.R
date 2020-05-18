# Enter in a list of strings, each of which is the @username of a verified news provider account
news <- get_timelines(c("cnn", "BBCWorld", "SkyNews", "telegraph", "rt_com", "guardiannews", "ajenglish", "financialtimes"), n = 1000) %>%
  # As with our oriignal tweet collection, we will select and rename the most relevent columns
  dplyr::select(user_id, status_id, created_at, screen_name, text, favorite_count, retweet_count, urls_expanded_url) %>%
  dplyr::select(DateTime = created_at, User = screen_name, Tweet = text) %>%
  mutate(DateTime = anytime::anytime(DateTime))
  
# Clean the text portion of the tweets using the string cleaning function detailed in the original scrape file
news$Tweet <- gsub("&amp", "", news$Tweet)
news$Tweet <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", news$Tweet)
news$Tweet <- gsub("@\\w+", "", news$Tweet) 
news$Tweet <- gsub("[[:punct:]]", "", news$Tweet) 
news$Tweet <- gsub("[[:digit:]]", "", news$Tweet) 
news$Tweet <- gsub("http\\w+", "", news$Tweet) 
news$Tweet <- gsub("[ \t]{2,}", "", news$Tweet) 
news$Tweet <- gsub("^\\s+|\\s+$", "", news$Tweet) 
news$Tweet <- iconv(news$Tweet, "UTF-8", "ASCII", sub="")

# You now have a comprehensive dataframe of the last several hundred tweets from each account. Further analysis of these tweets could include word count or sentiment analysis. 
