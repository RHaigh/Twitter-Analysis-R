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
