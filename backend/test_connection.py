from pymongo import MongoClient

uri = "mongodb+srv://vutruclam1202_db_user:noP1aOLPof7dAAcR@aiotcluster.k9gtfgk.mongodb.net/?appName=AIoTCluster"
client = MongoClient(uri)

db = client['coffeedb']
collection = db['test']

collection.insert_one({"name": "Cà phê Arabica", "age": 2})

for doc in collection.find():
    print(doc)
