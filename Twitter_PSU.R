setwd("C:/Users/user/Documents/PSU/AI_Project")
EnsurePackage<-function(x)
{
  x<-as.character(x)
  #
  if (!require(x,character.only=TRUE))
  {
    install.packages(pkgs=x,dependencies = TRUE)
    require(x,character.only=TRUE)
  }
}

options(scipen=999)
EnsurePackage("httr")
EnsurePackage("mongolite")
EnsurePackage("jsonlite")
EnsurePackage("twitteR")

#Define the api key and access tokens 
api_key <- "CikTUD8S7FmVOHUi4T5rx60D8"
api_secret <- "4xGIW5Z0cHYg4GnGTyB2OLjLiWlfZYeYqcdkMdGGSM0W86ZwbA"
access_token <- "3967450513-7epHz8gvuP8XUwbIEpy4GIzHYSWYMWDMkN27MbT"
access_token_secret <- "MjU482FNlwABGa5cHgPoXWJlAPte5wLhPslHIzc4kLNQ6"

#setup authentication for search API call
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#list of keywords to be searched
keywords <- c('pennstate','Penn%20State','PennStateProud','NeverPennState','PSU','PSU22','PSUGrad','LionPATH','nittanylion',
              'LionAmbassadors','WeArePSU',	'PSUAbington',	'pennstatealtoona',	'PSAltoona',	'PennStateBeaver',
              'PSBehrend','Behrend','PennStateBerks','psubrandywine','PennStateDuBois','psu fayette','PennStateGA','pennstategv',
              'PSUHarrisburg',	'PSUHazleton',	'PSULehighValley',	'montaltopsu',	'PennStateSL',	'PSU%20Shenango',
              'PennStateWB','PSUWorldCampus','PennStateYork')

language <- "en"
number_to_collect <- 500000
today <- strsplit(as.character(Sys.time())," ")[[1]][1]
end_date <- as.character(as.Date(today)+1)
start_date <- today

#The loop collects the tweets for each keyword for the specified interval between start date and end date. The collected tweets are returned
#as a list which are converted to json objects and then stored in a file for backup. 
for(word in keywords){
    start_date <- as.character(start_date)
    end_date <- as.character(end_date)
    list_tweets <- searchTwitter(word, n=number_to_collect, since=start_date,until=end_date,lang=language,retryOnRateLimit=999999999999999999999999999999999999)
    write(paste0(word, ", ",start_date,", ",end_date,", ",length(list_tweets)),"log_psutweets4.txt",append = TRUE)
    tweets <- do.call("rbind",lapply(list_tweets,as.data.frame))
    tweets$keyword <- word
    j <- toJSON(tweets)
    write(j,"psutweets4.json",append = TRUE)
}

