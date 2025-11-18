from pymongo import MongoClient
from config import Config
from dateutil.parser import parse

client = MongoClient(Config.MONGO_URI)
db = client[Config.DB_NAME]
users = db["users"]
notifications = db["notifications"]
logs = db["logs"]