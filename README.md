# Twitter Analysis with R

Author - Richard Haigh SG & Alex Betts ONS

Date of initial upload - 7/11/2019

Written - R Desktop 3.5.2

Environment - RStudio v1.2.1335

Packages:
dplyr v0.8.3,
tidytext v0.2.2,
rtweet v0.6.9,
tidyverse v1.2.1,
qdapRegex v0.7.2,
plotly v4.9.0,
tm v0.7-6,
DT v0.9,
syuzhet v1.0.4,
orca v1.1-1,
wordcloud2 0.2.0

An example of code demonstrating how to interact with the Twitter API to collect tweets with designated hashtags and then analyse this data for sentiment and location.

In order to utilise this code, you will require:

1. A twitter developer account
2. A google developer account with an activated GeoCoding API key

A helpful guide on how to achieve this (with visuals) can be found here: https://www.extly.com/docs/autotweetng_joocial/tutorials/how-to-auto-post-from-joomla-to-twitter/apply-for-a-twitter-developer-account/#apply-for-a-developer-account

The code comments will show where to insert your keys in string format. Note that depending on the power of your system, collecting tweets may take several minutes. Tweets collected are limited to 18000 every 15 minutes by the API. 

The individual elements: API interaction, location and sentiment analysis, have been separated into individual files for ease of understanding. You may collect tweets of a particular hashtag, or from specific accounts then you can simply run 
subsequent graphical components for more in-depth analysis. 

Thanks to Dr Alex Betts of DEFRA for his help in providing the base API interaction code. Use all applications in a responsible manner and ensure you stick to the twitter developer code of ethics and terms and conditions at all times. 
