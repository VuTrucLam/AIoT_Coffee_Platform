# routes/notifications.py
from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from utils.database import db  # DÙNG BIẾN db TOÀN CỤC
from datetime import datetime
from bson import ObjectId

notifications_bp = Blueprint('notifications', __name__, url_prefix='/api')

# === LƯU THÔNG BÁO MỚI ===
@notifications_bp.route('/notifications', methods=['POST'])
@jwt_required()
def create_notification():
    try:
        user_id = get_jwt_identity()  # Lấy từ JWT
        data = request.get_json()

        # Validate
        if not data or 'title' not in data or 'body' not in data:
            return jsonify({"error": "Thiếu title hoặc body"}), 400

        notification = {
            "title": data['title'],
            "body": data['body'],
            "sensor": data.get('sensor'),
            "level": data.get('level', 'danger'),
            "user_id": user_id,
            "timestamp": datetime.utcnow(),
            "is_read": False
        }

        result = db.notifications.insert_one(notification)
        
        return jsonify({
            "message": "Lưu thông báo thành công",
            "id": str(result.inserted_id)
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# === LẤY DANH SÁCH THÔNG BÁO ===
@notifications_bp.route('/notifications', methods=['GET'])
@jwt_required()
def get_notifications():
    try:
        user_id = get_jwt_identity()
        page = request.args.get('page', 1, type=int)
        per_page = request.args.get('per_page', 10, type=int)

        # Lấy dữ liệu
        notifications = list(
            db.notifications.find({"user_id": user_id})
            .sort("timestamp", -1)
            .skip((page - 1) * per_page)
            .limit(per_page)
        )

        total = db.notifications.count_documents({"user_id": user_id})

        # Chuyển ObjectId → str
        for n in notifications:
            n['_id'] = str(n['_id'])

        return jsonify({
            "notifications": notifications,
            "total": total,
            "page": page,
            "per_page": per_page
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# === ĐÁNH DẤU ĐÃ ĐỌC ===
@notifications_bp.route('/notifications/<notif_id>', methods=['PUT'])
@jwt_required()
def mark_as_read(notif_id):
    try:
        user_id = get_jwt_identity()

        result = db.notifications.update_one(
            {"_id": ObjectId(notif_id), "user_id": user_id},
            {"$set": {"is_read": True}}
        )

        if result.modified_count == 0:
            return jsonify({"error": "Không tìm thấy hoặc không có quyền"}), 404

        return jsonify({"message": "Đã đọc"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500