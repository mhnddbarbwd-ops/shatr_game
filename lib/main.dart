import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // إخفاء شريط الإشعارات لجعل اللعبة بملء الشاشة
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ShatrGameApp());
}

class ShatrGameApp extends StatelessWidget {
  const ShatrGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shatr Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // ثيم مظلم يناسب أجواء اللعبة
      home: const GameMainScreen(),
    );
  }
}

class GameMainScreen extends StatefulWidget {
  const GameMainScreen({super.key});

  @override
  State<GameMainScreen> createState() => _GameMainScreenState();
}

class _GameMainScreenState extends State<GameMainScreen> {
  bool isVaultOpened = false; // متغير يحدد هل نجح اللاعب في فتح الخزنة أم لا

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية الممر المظلم وباب الخزنة (تملأ الشاشة بالكامل)
          Positioned.fill(
            child: Image.asset(
              'assets/images/agent2_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // 2. المنطقة التفاعلية (صندوق على الجدار بجانب الباب تماماً)
          // قمت بتحديد موقع الصندوق ليكون فوق جهاز التحكم الصغير الموجود بالخلفية الأصلية
          Positioned(
            left: MediaQuery.of(context).size.width * 0.02, // على الجدار الأيسر
            top: MediaQuery.of(context).size.height * 0.45,  // في المنتصف عمودياً
            child: GestureDetector(
              onTap: () {
                // عند الضغط هنا.. يفتح لغز الكيبورد فوراً!
                _openKeypadInterface(context);
              },
              child: Container(
                width: 70,
                height: 110,
                // وضعنا لون أحمر شفاف جداً لتراه الآن وتعرف أين تضغط، لاحقاً سنجعله مخفي تماماً!
                color: Colors.red.withOpacity(0.3), 
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.vibration, color: Colors.white, size: 20),
                    Text("اضغط هنا", style: TextStyle(fontSize: 8, color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),

          // 3. شاشة النجاح (تظهر فقط إذا أدخل اللاعب الكود الصحيح)
          if (isVaultOpened)
            Container(
              color: Colors.black90,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.lock_open, color: Colors.green, size: 100),
                    const SizedBox(height: 20),
                    const Text(
                      'أحسنت أيها العميل! تم فك الشفرة وفتح الخزنة بنجاح 🎉',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade800),
                      onPressed: () {
                        setState(() {
                          isVaultOpened = false; // إعادة اللعبة من جديد
                        });
                      },
                      child: const Text('إعادة المحاولة', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // دالة تفتح واجهة التحكم كـ Popup تفاعلي فوق الشاشة
  void _openKeypadInterface(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // يسمح للاعب بالخروج لو ضغط خارج الصندوق
      builder: (context) {
        return const KeypadPuzzleWidget();
      },
    ).then((isSuccess) {
      // إذا رجعت الواجهة بكلمة true، يعني اللغز تم حله!
      if (isSuccess == true) {
        setState(() {
          isVaultOpened = true;
        });
      }
    });
  }
}

// كلاس واجهة لغز الكيبورد والأسلاك المدخلة
class KeypadPuzzleWidget extends StatefulWidget {
  const KeypadPuzzleWidget({super.key});

  @override
  State<KeypadPuzzleWidget> createState() => _KeypadPuzzleWidgetState();
}

class _KeypadPuzzleWidgetState extends State<KeypadPuzzleWidget> {
  String currentCode = ""; // الأرقام التي يكتبها اللاعب حالياً
  final String correctCode = "1972"; // الشفرة السرية الصحيحة لفتح اللغز

  void _pressNumber(String number) {
    if (currentCode.length < 4) {
      setState(() {
        currentCode += number;
      });

      // التحقق عند اكتمال 4 أرقام
      if (currentCode == correctCode) {
        // إذا الكود صحيح، ننتظر نصف ثانية ثم نغلق الواجهة بنجاح
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
      } else if (currentCode.length == 4) {
        // إذا الكود خاطئ، نعطي تنبيه ونمسح الشاشة بعد ثانية
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ شفرة خاطئة! تم قفل النظام مؤقتاً.'), duration: Duration(seconds: 1)),
        );
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            currentCode = "";
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        height: 280,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800, width: 2),
        ),
        child: Row(
          children: [
            // القسم الأيسر: الأزرار والشاشة الرقمية للحساب
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    // الشاشة الرقمية الصغيرة المضيئة باللون الأحمر
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.red.shade900),
                      ),
                      child: Text(
                        currentCode.padRight(4, '_'), // يظهر شرطات مكان الأرقام الفارغة
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 22,
                          fontFamily: 'monospace',
                          letterSpacing: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // أزرار الكيبورد الحقيقية القابلة للنقر!
                    Expanded(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 1.6,
                        ),
                        itemCount: 12,
                        itemBuilder: (context, index) {
                          List<String> labels = [
                            "1", "2", "3",
                            "4", "5", "6",
                            "7", "8", "9",
                            "*", "0", "#"
                          ];
                          String btnLabel = labels[index];
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A2A2A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => _pressNumber(btnLabel),
                            child: Text(btnLabel, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // القسم الأيمن: واجهة الأسلاك الملونة
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black25,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("دائرة الأسلاك", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    _buildWire(Colors.red, "الأحمر"),
                    _buildWire(Colors.blue, "الأزرق"),
                    _buildWire(Colors.green, "الأخضر"),
                    _buildWire(Colors.amber, "الأصفر"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة بناء سلك تفاعلي يعطيك تنبيه عند لمسه
  Widget _buildWire(Color color, String wireName) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✂️ قمت بلمس السلك $wireName! (سنبرمج لغز قطع الأسلاك في التحديث القادم)'), duration: const Duration(milliseconds: 800)),
        );
      },
      child: Container(
        width: double.infinity,
        height: 22,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(wireName, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
