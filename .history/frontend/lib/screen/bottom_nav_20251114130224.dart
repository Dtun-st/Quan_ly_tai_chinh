// import 'package:flutter/material.dart';
// import 'package:frontend/screen/home.dart';
// import 'package:frontend/screen/bank.dart';
// import 'package:frontend/screen/transaction.dart';
// import 'package:frontend/screen/report.dart';

// class CustomBottomNav extends StatelessWidget {
//   final int currentIndex;

//   const CustomBottomNav({super.key, required this.currentIndex});

//   void _onItemTapped(BuildContext context, int index) {
//     if (index == currentIndex) return;

//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const HomePage()),
//         );
//         break;
//       case 1:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const BankScreen()),
//         );
//         break;
//       case 2:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const TransactionScreen()),
//         );
//         break;
//       case 3:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const ReportScreen()),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) => _onItemTapped(context, index),
//       selectedItemColor: Colors.orange.shade700,
//       unselectedItemColor: Colors.grey,
//       type: BottomNavigationBarType.fixed,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: "Tổng quan"),
//         BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Tài khoản"),
//         BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Ghi chép"),
//         BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Báo cáo"),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'home.dart';
import 'bank.dart';
import 'transaction.dart';
import 'report.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BankScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TransactionScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MonthReportScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeIndex = (currentIndex >= 0 && currentIndex < 4) ? currentIndex : 0;

    return BottomNavigationBar(
      currentIndex: safeIndex,
      onTap: (index) => _onItemTapped(context, index),
      selectedItemColor: Colors.orange.shade700,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Tổng quan"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Tài khoản"),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Ghi chép"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Báo cáo"),
      ],
    );
  }
}
