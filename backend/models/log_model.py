from datetime import datetime

class LogModel:
    def __init__(self, date, activity, cost=0, note="", user_id=None):
        self.date = date                    # ngày thực hiện
        self.activity = activity            # tên hoạt động
        self.cost = cost                    # chi phí
        self.note = note                    # ghi chú
        self.user_id = user_id              # người tạo
        self.created_at = datetime.utcnow() # thời gian lưu

    def to_dict(self):
        return {
            "date": self.date,
            "activity": self.activity,
            "cost": self.cost,
            "note": self.note,
            "user_id": self.user_id,
            "created_at": self.created_at
        }

    @staticmethod
    def from_dict(data):
        log = LogModel(
            data.get("date"),
            data.get("activity"),
            data.get("cost", 0),
            data.get("note", "")
        )
        log.user_id = data.get("user_id")
        log.created_at = data.get("created_at")
        return log
