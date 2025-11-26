import 'package:shared_preferences/shared_preferences.dart';
import 'home_service.dart';

class HistoryService {
  final HomeService _homeService = HomeService();

  Future<List<Map<String, dynamic>>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    if (userId != null) {
      return await _homeService.fetchGiaoDich(userId);
    }
    return [];
  }
}
