# Ensure you have run twitter_api_scraper.R file from repository before proceeding with script

# Load in stop words that break text analysis (.,/ etc)
data("stop_words")

# Get a list of unique words within the text of all your tweets
tweet_clean <- tweets %>%
  dplyr::select(text) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  filter(!word %in% c("rt", "t.co"))

# Visual Analysis 1: Bar chart output using ggplot to show top 15 most commonly used words within collected tweets
tweet_clean %>%
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  labs(x = "Count",
       y = "Unique words",
       title = "Count of unique words found in tweets")

# Visual Analysis 2: Wordcloud representing most commonly used words
# Requiring the wordcloud2 library, we can also take our word count and pass it to the wordcloud2() function
wordcloud_data <- tweets %>%
      dplyr::select(text) %>%
      unnest_tokens(word, text) %>%
      anti_join(stop_words) %>%
      filter(!word %in% c("rt", "t.co")) %>%
      count(word, sort = TRUE) %>%
      top_n(100) %>%
      mutate(word = reorder(word, n))

wordcloud2(wordcloud_data, size = 2, minSize = 0, gridSize =  0,
               fontFamily = 'Segoe UI', fontWeight = 'bold',
               color = 'random-dark', backgroundColor = "white",
               minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE,
               rotateRatio = 0.4, shape = 'circle', ellipticity = 0.65,
               widgetsize = NULL, figPath = NULL, hoverFunction = NULL)

# Wordcloud2 allows you to alter the background color and even the shape of your wordcloud
# A comprehensive guide on the functions within the package can be found at: https://www.r-graph-gallery.com/196-the-wordcloud2-library.html
 
# WARNING a known issue with wordcloud package versions > 0.2.0 blocks plotly graphs from visualising on shiny apps if on the same page / tab as a wordcloud object
# Downgrade to version 0.2.0 to avoid this problem
 
# Visual Analysis 3: Bar chart breaking down this word count by positive or negative sentiment
# Perform initial sentiment analysis using get_sentiment function of syuzhet package
sent_analysis <- tweet_clean %>%
  inner_join(get_sentiments("bing")) %>% # bing refers to a particular sentiment analysis library
  count(word, sentiment, sort = TRUE) %>%
  ungroup()

# Put into bar chart output using ggplot
sent_analysis %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(title = "Twitter #brexit Sentiment Analysis",
       y = "Sentiment Score",
       x = NULL) +
  coord_flip()

# Visual Analysis 4: Bar chart breaking down sentiment by individual emotions, rather than positive / negative
# Determine emotion for each tweet using NRC dictionary
emotions <- get_nrc_sentiment(tweets$text)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])

sentiment_graph_plotly <- plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE,
         title="Emotion Type for hashtag: #Brexit")

# Final output will be a plotly bar graph showing the frequency of each emotion registered in your sample.  

