# Ensure you have run twitter_api_scraper.R file before proceeding with this script

# List the number of unique locations you have gathered with your scrape
length(unique(tweets$location))

# Visual Analysis 1: Bar chart showing frequency of tweets within each unique location
tweets %>%
  count(location, sort = TRUE) %>%
  mutate(location = reorder(location,n)) %>%
  na.omit() %>%
  top_n(20) %>%
  ggplot(aes(x = location,y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Location",
       y = "Count",
       title = "Twitter users - unique locations ")

# The final results will be a graph demonstrating the most common locations of individuals tweeting about your chosen hashtag
# Note that the most common result will be blank. This represent accounts that do not disclose their location. 

# Visual Analysis 2: Line chart showing frequency of tweets within specified date range
tweets %>%
  ts_plot("3 hours") + # Specify x-axis intervals
  ggplot2::theme_minimal() +
  ggplot2::theme(plot.title = ggplot2::element_text(face = "bold")) +
  ggplot2::labs(
    x = NULL, y = NULL,
    title = "Frequency of #coronavirus Twitter",
    subtitle = "Twitter status (tweet) counts aggregated using three-hour intervals",
    caption = "\nSource: Data collected from Twitter's REST API via rtweet"
  )

# The advantages of this graph lie in being able to correlate spikes in social media activity with events
