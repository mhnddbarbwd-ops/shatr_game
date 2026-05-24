import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // مكتبة التحكم باتجاه الشاشة
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart'; // مكتبة التفاعل والضغطات

void main() async {
  // التأكد من تهيئة بيئة فلاتر قبل تشغيل أي شيء
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. إجبار اللعبة على العمل بالوضع الأفقي (Landscape) فقط
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // إخفاء شريط الإشعارات العلوي لتعيش جو اللعبة
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(GameWidget(game: ShatrGame()));
}

// كلاس اللعبة الرئيسي
class ShatrGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 2. استدعاء الجدار (الخلفية)
    final bgSprite = await loadSprite('agent2_bg.png');
    final bgComponent = SpriteComponent(
      sprite: bgSprite,
      size: size, // الآن مع الوضع الأفقي ستأخذ حجمها الطبيعي بدون ضغط
    );
    add(bgComponent);

    // 3. إضافة جهاز الإدخال (الكيبورد والأسلاك)
    final keypadSprite = await loadSprite('agent_bg.png');
    
    // استخدمنا الكلاس التفاعلي الذي صنعناه بالأسفل بدلاً من المكون العادي
    final keypad = InteractiveKeypad(
      sprite: keypadSprite,
      // تصغير الحجم ليكون منطقياً مقارنة بباب الخزنة
      size: Vector2(200, 200), 
      // تحديد موقعه ليكون على الجدار الأيمن بجانب الخزنة
      // (65% من عرض الشاشة لليمين، و 40% من الارتفاع للأسفل)
      position: Vector2(size.x * 0.65, size.y * 0.40), 
    );
    add(keypad);
  }
}

// 4. الكلاس المسؤول عن المنطق البرمجي (التفاعل مع الكيبورد)
// أضفنا `TapCallbacks` ليصبح هذا الجزء من الصورة قابلاً للضغط
class InteractiveKeypad extends SpriteComponent with TapCallbacks {
  InteractiveKeypad({super.sprite, super.position, super.size});

  // هذه الدالة تتنفذ فوراً عندما يلمس اللاعب الكيبورد
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    // هنا يبدأ المنطق البرمجي الحقيقي!
    // حالياً سنطبع رسالة في الكونسول للتأكد من التفاعل
    debugPrint("🔥 تم الضغط على جهاز فك الشفرة! 🔥");
    
    // (لاحقاً هنا سنقوم بإخفاء الغرفة وعرض شاشة مقربة للكيبورد لكي يكتب اللاعب الرقم السري أو يقطع الأسلاك)
  }
}
