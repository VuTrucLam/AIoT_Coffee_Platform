from flask import Blueprint, request, jsonify
from utils.database import db
from models.user_model import User
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity
from bson import ObjectId
from datetime import timedelta

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()

    required_fields = ["name", "email", "farm_name", "account_type", "password"]
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Thiếu thông tin cần thiết"}), 400

    if db.users.find_one({"email": data["email"]}):
        return jsonify({"error": "Email đã được đăng ký"}), 400

    user = User(
        data["name"],
        data["email"],
        data["farm_name"],
        data["account_type"],
        data["password"]
    )

    db.users.insert_one(user.to_dict())
    return jsonify({"message": "Đăng ký thành công"}), 201

@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json(force=True)

    user = db.users.find_one({"email": data["email"]})
    if not user:
        return jsonify({"error": "Email không tồn tại"}), 404

    if not User.check_password(data["password"], user["password"]):
        return jsonify({"error": "Sai mật khẩu"}), 401

    # Tạo token có hiệu lực 1 ngày
    access_token = create_access_token(
        identity=str(user["_id"]),
        expires_delta=timedelta(days=1)
    )

    user_info = {
        "name": user["name"],
        "email": user["email"],
        "farm_name": user["farm_name"],
        "account_type": user["account_type"]
    }

    return jsonify({
        "message": "Đăng nhập thành công",
        "user": user_info,
        "access_token": access_token
    }), 200

@auth_bp.route("/me", methods=["GET"])
@jwt_required()
def get_current_user():
    try:
        user_id = get_jwt_identity()  # Lấy user_id từ token

        user = db.users.find_one({"_id": ObjectId(user_id)})
        if not user:
            return jsonify({"error": "Không tìm thấy người dùng"}), 404

        user_info = {
            "id": str(user["_id"]),
            "name": user.get("name"),
            "email": user.get("email"),
            "farm_name": user.get("farm_name"),
            "account_type": user.get("account_type")
        }

        return jsonify({"user": user_info}), 200
    except Exception as e:
        print("ERROR:", e)
        return jsonify({"error": str(e)}), 500