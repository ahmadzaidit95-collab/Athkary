# أذكاري — Flutter

## التشغيل (مرة واحدة)
1. افتح ترمنال جوه الفولدر ده (اللي فيه pubspec.yaml).
2. ولّد فولدرات المنصات (android / ios / web ...):

       flutter create --project-name adhkari .

   لو لقيت lib/main.dart اتبدّل بالعدّاد الافتراضي، رجّع نسختك من الـ zip.
3. نزّل الحزم:

       flutter pub get

4. شغّل:

       flutter run

## أندرويد
لو هتبني نسخة release، ضيف في android/app/src/main/AndroidManifest.xml
قبل <application>:

    <uses-permission android:name="android.permission.INTERNET"/>

(مطلوب عشان google_fonts تحمّل الخطوط.)

## الهيكل
    lib/
      main.dart
      core/theme/     app_colors, app_theme, theme_controller
      core/utils/     responsive.dart
      features/home/  home_screen.dart
      features/placeholder/
    assets/images/    صور البانر والخلفيات
    assets/icons/     الأيقونات النهائية
