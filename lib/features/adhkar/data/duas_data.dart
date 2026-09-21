import 'adhkar_category.dart';
import 'dhikr.dart';

// ضيف محتوى كل قسم في قايمة items.
// النصوص الموجودة تجريبية، راجعها من مرجع موثوق قبل النشر.

class DuaCategories {
  DuaCategories._();

  static const adhan = AdhkarCategory.dua(
    id: 'dua-adhan',
    title: 'أذكار الأذان',
    subtitle: 'أدعية بعد الأذان',
    items: [
      Dhikr(
        text:
            'اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ وَالصَّلَاةِ الْقَائِمَةِ آتِ مُحَمَّدًا الْوَسِيلَةَ وَالْفَضِيلَةَ وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ',
        count: 1,
        source: 'صحيح البخاري',
      ),
    ],
  );

  static const prayer = AdhkarCategory.dua(
    id: 'dua-prayer',
    title: 'أذكار الصلاة',
    subtitle: 'أدعية في الصلاة',
    items: [],
  );

  static const afterPrayer = AdhkarCategory.dua(
    id: 'dua-after-prayer',
    title: 'أذكار بعد الصلاة',
    subtitle: 'أدعية بعد الصلاة',
    items: [],
  );

  static const wakeUp = AdhkarCategory.dua(
    id: 'dua-wake-up',
    title: 'أذكار الاستيقاظ',
    subtitle: 'أدعية عند الاستيقاظ',
    items: [
      Dhikr(
        text:
            'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
        count: 1,
        source: 'صحيح البخاري',
      ),
    ],
  );

  static const sleep = AdhkarCategory.dua(
    id: 'dua-sleep',
    title: 'أذكار النوم',
    subtitle: 'أدعية قبل النوم',
    items: [
      Dhikr(
        text: 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
        count: 1,
        source: 'صحيح البخاري',
      ),
    ],
  );

  static const food = AdhkarCategory.dua(
    id: 'dua-food',
    title: 'أذكار الطعام',
    subtitle: 'أدعية قبل وبعد الطعام',
    items: [
      Dhikr(
        text: 'بِسْمِ اللَّهِ',
        count: 1,
        source: 'أبو داود والترمذي',
      ),
      Dhikr(
        text:
            'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلَا قُوَّةٍ',
        count: 1,
        source: 'أبو داود والترمذي',
      ),
    ],
  );

  static const quran = AdhkarCategory.dua(
    id: 'dua-quran',
    title: 'أدعية من القرآن',
    subtitle: 'أدعية وآيات مباركة',
    items: [],
  );

  static const prophet = AdhkarCategory.dua(
    id: 'dua-prophet',
    title: 'أدعية النبي',
    subtitle: 'صلى الله عليه وسلم',
    items: [],
  );

  static const jawami = AdhkarCategory.dua(
    id: 'dua-jawami',
    title: 'جوامع الدعاء',
    subtitle: 'أدعية جامعة ومأثورة',
    items: [],
  );

  static const misc = AdhkarCategory.dua(
    id: 'dua-misc',
    title: 'أدعية متنوعة',
    subtitle: 'أدعية في مختلف المواقف',
    items: [],
  );
}