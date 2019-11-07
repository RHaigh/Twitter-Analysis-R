# Breakdown users tweeting about Brexit by unique locations
users <- search_users("#brexit",
                      n = 500) # Select your population sample

length(unique(users$location))

users %>%
  ggplot(aes(location)) +
  geom_bar() + coord_flip() +
  labs(x = "Count",
       y = "Location",
       title = "Twitter Users - Unique Locations ")

user_location_breakdown <- users %>%
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