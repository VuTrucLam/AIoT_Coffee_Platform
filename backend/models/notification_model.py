from datetime import datetime
from bson import ObjectId

class NotificationModel:
    def __init__(self, title, body, sensor=None, level="danger", user_id=None):
        self.title = title
        self.body = body
        self.sensor = sensor  
        self.level = level   
        self.user_id = user_id
        self.timestamp = datetime.utcnow()
        self.is_read = False

    def to_dict(self):
        return {
            "title": self.title,
            "body": self.body,
            "sensor": self.sensor,
            "level": self.level,
            "user_id": self.user_id,
            "timestamp": self.timestamp,
            "is_read": self.is_read
        }

    @staticmethod
    def from_dict(data):
        notification = NotificationModel(data["title"], data["body"])
        notification.sensor = data.get("sensor")
        notification.level = data.get("level", "danger")
        notification.user_id = data.get("user_id")
        notification.timestamp = data.get("timestamp")
        notification.is_read = data.get("is_read", False)
        return notification