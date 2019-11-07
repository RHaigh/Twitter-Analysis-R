# Sentiment Analysis 
# Begin with our tweetsDF dataframe object from the twitter_api_scraper file.
# Clean tweets to remove hashtags, emoji, etc. 
tweetsDF$text=gsub("&amp", "", tweetsDF$text)
tweetsDF$text = gsub("&amp", "", tweetsDF$text)
tweetsDF$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweetsDF$text)
tweetsDF$text = gsub("@\\w+", "", tweetsDF$text)
tweetsDF$text = gsub("[[:punct:]]", "", tweetsDF$text)
tweetsDF$text = gsub("[[:digit:]]", "", tweetsDF$text)
tweetsDF$text = gsub("http\\w+", "", tweetsDF$text)
tweetsDF$text = gsub("[ \t]{2,}", "", tweetsDF$text)
tweetsDF$text = gsub("^\\s+|\\s+$", "", tweetsDF$text)
tweetsDF$text <- iconv(tweetsDF$text, "UTF-8", "ASCII", sub="")

# Determine emotion for each tweet using NRC dictionary
emotions <- get_nrc_sentiment(tweetsDF$text)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

sentiment_graph_plotly <- plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE,
         title="Emotion Type for hashtag: #Brexit")

# Final output will be a plotly bar graph showing the frequency of each emotion registered in your sample.  