import 'package:flutter/material.dart';
import '../services/notification_service.dart'; 
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notifications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    notifications = await Server.getNotifications();
    setState(() => loading = false);
  }

  String timeAgo(DateTime t) {
    final diff = DateTime.now().difference(t);

    if (diff.inMinutes < 1) return "Vừa xong";
    if (diff.inMinutes < 60) return "${diff.inMinutes} phút trước";
    if (diff.inHours < 24) return "${diff.inHours} giờ trước";

    return "${t.day}/${t.month}/${t.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông báo")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final isRead = item["da_doc"] == 1;

                IconData icon;
                Color bg;

                switch (item["loai"]) {
                  case "Cảnh báo":
                    icon = Icons.warning_amber_rounded;
                    bg = Colors.orange.shade100;
                    break;

                  case "Gợi ý":
                    icon = Icons.lightbulb_outline;
                    bg = Colors.blue.shade100;
                    break;

                  default:
                    icon = Icons.notifications;
                    bg = Colors.grey.shade300;
                }

                return GestureDetector(
                  onTap: () {
                    Server.markNotificationRead(item["id"]);
                    fetchNotifications();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isRead ? Colors.grey.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                          child: Icon(icon, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["noi_dung"],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                timeAgo(DateTime.parse(item["ngay_tao"])),
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
