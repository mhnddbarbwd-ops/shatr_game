import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // تشغيل اللعبة بملء الشاشة
  runApp(GameWidget(game: ShatrGame()));
}

// كلاس اللعبة المبني على محرك Flame
class ShatrGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // 1. استدعاء الجدار (الخلفية)
    // لاحظ في Flame نكتب اسم الصورة فقط وهو يبحث في مجلد images تلقائياً!
    final bgSprite = await loadSprite('agent2_bg.png');
    final bgComponent = SpriteComponent(
      sprite: bgSprite,
      size: size, // اجعل حجم الجدار بحجم شاشة الجوال بالكامل
    );
    add(bgComponent);

    // 2. استدعاء الكيبورد والأسلاك
    final keypadSprite = await loadSprite('agent_bg.png');
    final keypadComponent = SpriteComponent(
      sprite: keypadSprite,
      size: Vector2(250, 250), // حجم الكيبورد (نقدر نكبره أو نصغره لاحقاً)
      // موقعه: نضعه على يمين الشاشة وفي المنتصف تقريباً
      position: Vector2(size.x - 280, size.y / 2 - 125), 
    );
    add(keypadComponent);
  }
}
