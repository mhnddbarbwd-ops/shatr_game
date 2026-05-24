import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // إجبار اللعبة على الوضع الأفقي وإخفاء شريط الإشعارات
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const CyberGameApp());
}

class CyberGameApp extends StatelessWidget {
  const CyberGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dark Cipher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF09090B), // أسود داكن جداً
        fontFamily: 'monospace', // خط المبرمجين الأساسي
      ),
      home: const TerminalScreen(),
    );
  }
}

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  String inputCode = "";
  final String targetCode = "1972";
  List<String> systemLogs = [
    "> SYSTEM BOOT SEQUENCE INITIATED...",
    "> ENCRYPTION LEVEL: MAXIMUM",
    "> WAITING FOR OVERRIDE CODE...",
  ];
  
  bool isError = false;
  bool isSuccess = false;

  void _handleKeyPress(String key) {
    if (isSuccess || isError) return; // منع الإدخال أثناء عرض النتيجة

    setState(() {
      if (inputCode.length < 4) {
        inputCode += key;
        systemLogs.add("> INPUT DETECTED: *");
      }

      if (inputCode.length == 4) {
        _verifyCode();
      }
    });
  }

  void _verifyCode() {
    if (inputCode == targetCode) {
      setState(() {
        isSuccess = true;
        systemLogs.add("> CODE ACCEPTED.");
        systemLogs.add("> SYSTEM UNLOCKED.");
      });
    } else {
      setState(() {
        isError = true;
        systemLogs.add("> ERROR: INVALID OVERRIDE CODE!");
        systemLogs.add("> SYSTEM LOCKDOWN IN 3... 2... 1...");
      });

      // إعادة تعيين النظام بعد ثانيتين في حال الخطأ
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            isError = false;
            inputCode = "";
            systemLogs.clear();
            systemLogs.addAll([
              "> SYSTEM RESET SUCCESSFUL.",
              "> WAITING FOR OVERRIDE CODE...",
            ]);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // تحديد لون الواجهة بناءً على الحالة (أخضر للنجاح، أحمر للخطأ، سيان للوضع الطبيعي)
    Color mainColor = isSuccess 
        ? Colors.greenAccent 
        : (isError ? Colors.redAccent : Colors.cyanAccent);

    return Scaffold(
      body: Container(
        // خلفية متدرجة تعطي إحساس الشاشة القديمة
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF1A1A24), Color(0xFF09090B)],
            radius: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // القسم الأيسر: شاشة الأوامر (Terminal Logs)
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: mainColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: mainColor.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TERMINAL v1.0.0 -- STATUS: ${isSuccess ? 'UNLOCKED' : (isError ? 'LOCKED' : 'SECURE')}",
                        style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                      ),
                      const Divider(color: Colors.white24),
                      Expanded(
                        child: ListView.builder(
                          itemCount: systemLogs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                systemLogs[index],
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                      // مؤشر الإدخال
                      Text(
                        "> $inputCode${inputCode.length < 4 ? '_' : ''}",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 20),

              // القسم الأيمن: لوحة المفاتيح
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "INPUT OVERRIDE",
                      style: TextStyle(color: mainColor, letterSpacing: 2),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          List<String> keys = [
                            '1', '2', '3',
                            '4', '5', '6',
                            '7', '8', '9',
                            'SYS', '0', 'CLR'
                          ];
                          return CyberButton(
                            label: keys[index],
                            color: mainColor,
                            onTap: () {
                              if (keys[index] == 'CLR') {
                                setState(() {
                                  inputCode = "";
                                  systemLogs.add("> INPUT CLEARED.");
                                });
                              } else if (keys[index] == 'SYS') {
                                // زر شكلي حالياً
                              } else {
                                _handleKeyPress(keys[index]);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// كلاس مخصص لزر بستايل سايبر بانك (إطار مضيء)
class CyberButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const CyberButton({
    super.key,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<CyberButton> createState() => _CyberButtonState();
}

class _CyberButtonState extends State<CyberButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          color: isPressed ? widget.color.withOpacity(0.2) : Colors.transparent,
          border: Border.all(
            color: widget.color.withOpacity(isPressed ? 1.0 : 0.5),
            width: 2,
          ),
          boxShadow: isPressed
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: isPressed ? Colors.white : widget.color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
