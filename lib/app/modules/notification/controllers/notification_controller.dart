import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';

class NotificationController extends GetxController {
  final isLoading = true.obs; 
  final notifications = <Map<String, dynamic>>[].obs;
  final _api = ApiProvider();

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading(true);
      final res = await _api.getNotifications();
      if (res.isOk) {
        final List<dynamic> data = res.body;
        notifications.assignAll(data.map((e) => e as Map<String, dynamic>).toList());
      }
    } catch (e) {
      print("Error fetch notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> markAsRead(int index) async {
    final notif = notifications[index];
    if (notif['is_read'] == true) return;
    
    // Optimistic UI update
    final updatedNotif = Map<String, dynamic>.from(notif);
    updatedNotif['is_read'] = true;
    notifications[index] = updatedNotif;
    
    try {
      await _api.markNotificationRead(notif['id']);
    } catch (e) {
      print("Failed to mark as read: $e");
      notifications[index] = notif; // revert
    }
  }
}
