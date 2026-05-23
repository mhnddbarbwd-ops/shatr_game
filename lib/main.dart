import 'package:flutter/material.dart';

void main() {
  runApp(const ShatrGameApp());
}

class ShatrGameApp extends StatelessWidget {
  const ShatrGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shatr | شطر',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // لون خلفية داكن جداً يميل للأسود ليعطي طابع الاختراق
        scaffoldBackgroundColor: const Color(0xFF0D0D12), 
        primaryColor: const Color(0xFF00FF9D), // أخضر نيون
        // استخدام خط افتراضي يعطي طابع التيرمينال أو الأكواد
        fontFamily: 'monospace', 
      ),
      home: const RoleSelectionScreen(),
    );
  }
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // عنوان اللعبة
              const Text(
                'شَـــطْـــر',
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00FF9D), // أخضر نيون
                  letterSpacing: 15,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'FRAGMENT / SYMBIOSIS',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 80),
              const Text(
                '/// حدد دورك في العملية ///',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              
              // زر العميل الميداني
              _buildRoleButton(
                context: context,
                title: 'العميل الميداني (الموقع)',
                color: const Color(0xFFFF3366), // أحمر/وردي نيون للإنذار والخطر
                icon: Icons.radar,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AgentScreen()),
                  );
                },
              ),
              const SizedBox(height: 25),
              
              // زر المهندس
              _buildRoleButton(
                context: context,
                title: 'المهندس (غرفة التحكم)',
                color: const Color(0xFF00D8FF), // أزرق سيبراني للمخططات
                icon: Icons.terminal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EngineerScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لبناء الأزرار بشكل عصري وحواف مضيئة
  Widget _buildRoleButton({
    required BuildContext context,
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: color.withOpacity(0.3),
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// شاشة العميل الميداني (مبدئية)
// ==========================================
class AgentScreen extends StatelessWidget {
  const AgentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('/// واجهة الموقع ///', style: TextStyle(letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFFF3366),
      ),
      body: Center(
        child: Text(
          'أنت الآن أمام الباب المقفل...',
          style: TextStyle(color: const Color(0xFFFF3366), fontSize: 20),
        ),
      ),
    );
  }
}

// ==========================================
// شاشة المهندس (مبدئية)
// ==========================================
class EngineerScreen extends StatelessWidget {
  const EngineerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('/// غرفة العمليات ///', style: TextStyle(letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF00D8FF),
      ),
      body: Center(
        child: Text(
          'جاري تحميل المخططات...',
          style: TextStyle(color: const Color(0xFF00D8FF), fontSize: 20),
        ),
      ),
    );
  }
}
