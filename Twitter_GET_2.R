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
EnsurePackage("stringr")

api_key <- "7Kd5tkviHHWZvtFjgK9NBD4sl"
api_secret <- "VAjRzWrsdNpsmmvpzSXxPUK4g2BG41s4vi4JaufVpmqk7KONo4"
access_token <- "973235860178132992-HY93d01U1Nrj5wYJG8uE5x8F6Jqig1J"
access_token_secret <- "pK8lEBlpRXiNqiYw53c6H9bvNTS0R7USUmngvLbpAAK4Y"

myapp = oauth_app("twitter", key=api_key, secret=api_secret)
sig = sign_oauth1.0(myapp, token=access_token, token_secret=access_token_secret)

keywords <- c('Firearms%20policy','gunpolicy','guncontrol','gun','gunsense','guns','gunsafety','guncontrolnow','gunviolence',
              'firearms','gunrights')
callAPI <- function(tweetsCount,max_id,word){
  if(tweetsCount==0){
    url <- paste0("https://api.twitter.com/1.1/search/tweets.json?q=",word,"&count=100")
  }else{
    url <- paste0("https://api.twitter.com/1.1/search/tweets.json?q=",word,"&count=100&max_id=",max_id)
  }
  api.call <- GET(url,sig)
  return(api.call)
  
}

maxTweets <- 20000
for(word in keywords){
  write(paste0("Key Word: ",word),"gun.txt",append = TRUE)
  try <- 0
  retry <- 0
  max_id = NULL
  tweetsCount <- 0
  lowest_id <- NULL
  df <- data.frame()
  while(TRUE){
    
    api.call <- callAPI(tweetsCount,max_id,word)
    try <- try+1
    result = content(api.call,as="text")
    df <- fromJSON(result)
    tweetsCount <- tweetsCount+length(df$statuses$text)
    if(!is.null(max_id)){
      if(max_id %in% df$statuses$id){
        df$statuses <- df$statuses[!(df$statuses$id %in% max_id),]
      }
    }
    to_db <- toJSON(df)
    lowest_id <- min(df$statuses$id)
    max_id <- lowest_id
    write(paste0("Current Total: ",tweetsCount),"gun.txt",append = TRUE)
    
    mongo <- mongo(collection = "gunTweets",db="psgvGUN",url = "******")
    mongo$insert(fromJSON(to_db))
    if(try==180){
      write(paste0("API calls ",try," for: ",word), "gun.txt",append = TRUE)
      if(tweetsCount>=maxTweets | retry==5){
        write(paste0("Tweets: ",tweetsCount," retry: ",retry), "gun.txt",append = TRUE)
        write("Going to sleep","gun.txt",append = TRUE)
        Sys.sleep(960)
        write("Waking up","gun.txt",append = TRUE)
        break
      }else{
        if(!retry){
          write(paste0("First retry for ",word),"gun.txt",append = TRUE)
          retry=1
        }else{
          retry <- retry+1
          write(paste0("Retry no: ",retry," for ",word),"gun.txt",append = TRUE)
        }
        try <- 0
        write("Going to sleep","gun.txt",append = TRUE)
        Sys.sleep(960)
        write("Waking up","gun.txt",append = TRUE)
      }
    }
    
  }
}
