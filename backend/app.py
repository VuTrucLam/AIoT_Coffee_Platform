from flask import Flask, jsonify
from flask_cors import CORS
from routes.auth_routes import auth_bp
from routes.notifications import notifications_bp
from routes.log_routes import log_bp
import os
from dotenv import load_dotenv
from flask_jwt_extended import JWTManager

app = Flask(__name__)
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY")
jwt = JWTManager(app)
CORS(app)

app.register_blueprint(auth_bp, url_prefix="/auth")
app.register_blueprint(notifications_bp)
app.register_blueprint(log_bp, url_prefix="/api")

@app.route("/")
def home():
    return jsonify({"message": "Welcome to IoT Flask Backend"})

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
