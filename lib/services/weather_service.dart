import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "5be44db63880aeafe14cfaecbf01a547";
  static const String _baseUrl =
      "https://api.openweathermap.org/data/2.5/weather";

  /// Lấy dữ liệu thời tiết theo lat/lon
  static Future<Map<String, dynamic>?> fetchWeather(
    double lat,
    double lon,
  ) async {
    final url = Uri.parse("$_baseUrl?lat=$lat&lon=$lon&appid=$_apiKey");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final weather = data["weather"][0];
      final main = data["main"];
      final wind = data["wind"];

      // ✅ 1. Dịch sang tiếng Việt
      final weatherMain = _translateMain(weather["main"]);
      final description = _translateDescription(weather["description"]);

      // ✅ 2. Chuyển đổi đơn vị
      final tempC = (main["temp"] - 273.15).toStringAsFixed(1); // Kelvin → °C
      final speedKmH = (wind["speed"] * 3.6).toStringAsFixed(1); // m/s → km/h
      final direction = _degToDirection(wind["deg"]);

      // ✅ 3. Lấy icon tương ứng với main
      final icon = _getWeatherIcon(weather["main"]);

      // ✅ 4. Trả về map dữ liệu đã xử lý
      return {
        "location": data["name"],
        "main": weatherMain,
        "description": description,
        "temperature": tempC,
        "windSpeed": speedKmH,
        "windDirection": direction,
        "pressure": main["pressure"],
        "humidity": main["humidity"],
        "icon": icon,
      };
    } else {
      print("❌ Lỗi lấy dữ liệu thời tiết: ${response.statusCode}");
      return null;
    }
  }

  // 🔹 Dịch main sang tiếng Việt
  static String _translateMain(String main) {
    switch (main) {
      case "Clouds":
        return "Nhiều mây";
      case "Clear":
        return "Trời quang";
      case "Rain":
        return "Mưa";
      case "Drizzle":
        return "Mưa phùn";
      case "light rain":
        return "Mưa phùn";
      case "Thunderstorm":
        return "Dông";
      case "Snow":
        return "Tuyết";
      case "Mist":
        return "Sương mù";
      default:
        return main;
    }
  }

  // 🔹 Dịch mô tả chi tiết
  static String _translateDescription(String desc) {
    switch (desc) {
      case "overcast clouds":
        return "Mây u ám";
      case "scattered clouds":
        return "Mây rải rác";
      case "few clouds":
        return "Ít mây";
      case "broken clouds":
        return "Mây đứt đoạn";
      case "clear sky":
        return "Trời trong";
      default:
        return desc;
    }
  }

  // 🔹 Đổi hướng gió từ độ sang hướng
  static String _degToDirection(num deg) {
    if (deg >= 337.5 || deg < 22.5) return "Bắc";
    if (deg >= 22.5 && deg < 67.5) return "Đông Bắc";
    if (deg >= 67.5 && deg < 112.5) return "Đông";
    if (deg >= 112.5 && deg < 157.5) return "Đông Nam";
    if (deg >= 157.5 && deg < 202.5) return "Nam";
    if (deg >= 202.5 && deg < 247.5) return "Tây Nam";
    if (deg >= 247.5 && deg < 292.5) return "Tây";
    if (deg >= 292.5 && deg < 337.5) return "Tây Bắc";
    return "Không rõ";
  }

  // 🔹 Icon thời tiết tương ứng với main
  static String _getWeatherIcon(String main) {
    switch (main) {
      case "Clouds":
        return "☁️";
      case "Clear":
        return "☀️";
      case "Rain":
        return "🌧️";
      case "Drizzle":
        return "🌦️";
      case "Thunderstorm":
        return "⛈️";
      case "Snow":
        return "❄️";
      case "Mist":
        return "🌫️";
      default:
        return "🌍";
    }
  }
}
