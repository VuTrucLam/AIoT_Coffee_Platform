# AIoT Coffee Platform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![C++](https://img.shields.io/badge/C%2B%2B-00599C?style=for-the-badge&logo=cplusplus&logoColor=white)](https://cplusplus.com/)


[![Author](https://img.shields.io/badge/Author-VuTrucLam-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VuTrucLam)
[![Contributors](https://img.shields.io/github/contributors/VuTrucLam/AIoT_Coffee_Platform?style=for-the-badge)](https://github.com/VuTrucLam/AIoT_Coffee_Platform/graphs/contributors)


## Tổng Quan

"AIoT - Giải pháp tối ưu canh tác cà phê" nền tảng giám sát, phân tích, tự động và tối ưu hóa quá trình sản xuất cà phê. Sử dụng công nghệ để biến đổi canh tác truyền thống, nặng nhọc thành nông nghiệp dữ liệu, chính xác và bền vững thích ứng với biến đổi khí hậu.

**Mục tiêu:**

- Xử lý dữ liệu đầu vào (hình ảnh, thông số môi trường) và đưa ra khuyến nghị cụ thể.
- Ứng dụng mô hình học sâu trong phân tích và dự đoán sức khỏe cây trồng, cảnh báo sớm nguy cơ sâu bệnh hoặc thiếu hụt dinh dưỡng, đồng thời tối ưu hóa lịch trình chăm sóc.
- Xây dựng hệ thống chatbot AI có khả năng tư vấn dựa trên dữ liệu huấn luyện riêng.
- Tạo nền tảng có thể mở rộng thành hệ thống hỗ trợ nông nghiệp thông minh.

## Tính năng

**Dữ liệu và giám sát:**

- Thu thập dữ liệu môi trường real-time
- Đồng bộ dữ liệu thời tiết từ OpenWeather API
- Cảnh báo khi phát hiện bất thường

**Quản lý:**

- Nhật ký hoạt động
- Profile

**Hệ Thống:**

- Đăng ký, đăng nhập
- Quản lý phiên đăng nhập

## Ngôn ngữ, Công cụ lập trình

### Ngôn ngữ lập trình chính

| STT | Ngôn ngữ | Mục đích |
|-----|----------|----------|
|1|Dart|Lập trình ứng dụng di động|
|2|Python|Backend API, Cloud Functions, gọi AI API, xử lý dữ liệu AI|
|3|C++|Xử lý device firmware|

### Framework và Nền tảng phát triển

| STT | Framework/Nền tảng | Mục đích |
|-----|--------------------|----------|
|1|Flutter|Phát triển ứng dụng di động đa nền tảng|
|2|Flask |Xây dựng API backend|
|3|Firebase |Realtime Database/Firestore, Cloud Functions, Hosting, FCM|
|4|MongoDB|NoSQL database|

### Thư viện và Package chính

**Flutter**

| STT | Thư viện | Mục đích |
|-----|----------|----------|
|1|flutter|Core framework|
|2|http|Gọi REST API (AI, OpenWeather, Flask backend)|
|3|firebase_core|Kết nối Flutter với Firebase|
|4|firebase_database|Realtime Database – đọc/ghi dữ liệu cảm biến thời gian thực|
|5|shared_preferences|Lưu local token, cấu hình người dùng|
|6|flutter_local_notifications|Thông báo đẩy cục bộ + âm thanh cảnh báo|
|7|just_audio|Phát âm thanh cảnh báo|
|8|geolocator|Lấy tọa độ GPS vườn cà phê để gọi OpenWeather|
|9|intl|Định dạng ngày giờ, tiền tệ Việt Nam|
|10|google_fonts|Font cho giao diện|
|11|fl_chart|Vẽ biểu đồ|

**Python**

| STT | Thư viện | Mục đích |
|-----|----------|----------|
|1|pymongo|Kết nối và thao tác với MongoDB|
|2|flask|Xây dựng REST API backend|


## Cấu trúc dự án

```
AIoT_Coffee_Platform/
├── lib/                      # 📱 Dart/Flutter code (chính)
├── web/                      # 🌐 Web frontend (HTML, CSS, JS)
├── backend/                  # 🔌 Backend API
├── android/                  # 📱 Android native code
├── ios/                      # 📱 iOS native code (Swift)
├── windows/                  # 💻 Windows desktop
├── linux/                    # 💻 Linux desktop
├── macos/                    # 💻 macOS desktop
├── assets/                   # 🖼️ Images, icons, resources
├── test/                     # 🧪 Unit & widget tests
├── pubspec.yaml              # 📦 Dart dependencies
├── requirements.txt          # 📦 Python dependencies
├── firebase.json             # 🔥 Firebase config
├── analysis_options.yaml     # ✨ Code quality rules
└── .vscode/                  # 🛠️ VSCode settings
```

## Hướng dẫn cài đặt

### 1. Clone

```
git clone https://github.com/VuTrucLam/AIoT_Coffee_Platform.git
```
```
cd AIoT_Coffee_Platform
```

### 2. Backend Setup
```
cd backend
```
Khởi tạo môi trường ảo
```
python -m venv venv
```
```
venv\Scripts\activate
```
```
pip install -r requirements.txt
```

### 3. Run

```
python app.py
```
```
flutter pub get
```
```
flutter run #mobile
```
```
flutter run -d chrome #web
```

## Liên Hệ & Hỗ Trợ

<div align="center">

<br>

[![Email](https://img.shields.io/badge/Email-VuTrucLam-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:vutruclam1202@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-VuTrucLam-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/tr%C3%BAc-lam-v%C5%A9-a318b9375/)
[![GitHub](https://img.shields.io/badge/GitHub-VuTrucLam-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/VuTrucLam)



**Built with ❤️ by VuTrucLam & Teams**

</div>

