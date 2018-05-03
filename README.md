# Data Collection from twitter for Sentiment Analysis

In recent years, social media has become a popular tool for students, faculty and staff to share their thoughts, 
feelings and ideas on a variety of topics at Penn State. We can keep track of all the discussed topics at any point in time, as well as determine the sentiments and emotions of the public associated with each topic using Artificial Intelligence.

This project includes R scripts for collecting data related to Penn State from twitter. 
Twitter_PSU.R uses the R package "twitteR" for data collection.

Twitter_GET_2.R is an automated script for data collection through direct REST API calls. Using this script we are making full advantage of the twitter search API. The twitteR package cannot be used to retreive every information provided by the twitter search API such as the user profile information.

insertMongoPSU.py can be used to load json file containing tweets to Mongo DB.

The tweets analysed using IBM natural language understanding (NLU) service from IBM cloud can be visualized on tableau [here](https://public.tableau.com/profile/karpagalakshmi#!/vizhome/Integrated/Dashboard1?publish=yes).
