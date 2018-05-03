from pymongo import MongoClient
from bson import json_util
import json
client=MongoClient('**********')
db=client['psgvAI']
coll=db['psu_tweets']
i=1
with open('C:/Users/user/Documents/PSU/AI_Project/psutweets4.json') as f:
	for line in f:
		data=json.loads(line)
		if(len(data) == 1):
			coll.insert(data)
			print('done '+str(i))
			i=i+1
		else:
			for item in data:
				coll.insert(item)
			print('done '+str(i))
			i=i+1

		