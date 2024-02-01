import 'package:geolocator/geolocator.dart';

class GeolocationService {
  Future<Position> getGeolocation() async {
    // 위치 서비스 활성화 여부 확인
    bool geoEnabled = await Geolocator.isLocationServiceEnabled();
    if (!geoEnabled) {
      throw Exception('Location services are disabled.');
    }

    // 권한 상태 확인 및 요청
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // 현재 위치 가져오기
    return await Geolocator.getCurrentPosition();
  }
}
