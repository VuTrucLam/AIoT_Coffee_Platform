from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from bson import ObjectId
from models.log_model import LogModel
from utils import database

log_bp = Blueprint("logs", __name__)

@log_bp.route("/logs", methods=["POST"])
@jwt_required()
def create_log():
    try:
        user_id = get_jwt_identity()  # lấy từ token
        
        data = request.json
        log = LogModel(
            user_id=user_id,
            date=data["date"],
            activity=data["activity"],
            cost=data.get("cost", 0),
            note=data.get("note", "")
        )

        database.logs.insert_one(log.to_dict())
        return jsonify({"message": "Tạo nhật ký thành công"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@log_bp.route("/logs", methods=["GET"])
@jwt_required()
def get_logs():
    try:
        user_id = get_jwt_identity()

        logs = list(database.logs.find({"user_id": user_id}).sort("date", -1))

        for log in logs:
            log["_id"] = str(log["_id"])

        return jsonify({"logs": logs}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@log_bp.route("/logs/<log_id>", methods=["PUT"])
@jwt_required()
def update_log(log_id):
    try:
        user_id = get_jwt_identity()

        data = request.json
        update_data = {
            "date": data.get("date"),
            "activity": data.get("activity"),
            "cost": data.get("cost", 0),
            "note": data.get("note", "")
        }

        result = database.logs.update_one(
            {"_id": ObjectId(log_id), "user_id": user_id},
            {"$set": update_data}
        )

        if result.matched_count == 0:
            return jsonify({"error": "Không tìm thấy nhật ký hoặc không có quyền"}), 404

        return jsonify({"message": "Cập nhật thành công"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@log_bp.route("/logs/<log_id>", methods=["DELETE"])
@jwt_required()
def delete_log(log_id):
    try:
        user_id = get_jwt_identity()

        result = database.logs.delete_one(
            {"_id": ObjectId(log_id), "user_id": user_id}
        )

        if result.deleted_count == 0:
            return jsonify({"error": "Không tìm thấy nhật ký hoặc không có quyền"}), 404

        return jsonify({"message": "Xóa thành công"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
