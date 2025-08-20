import 'dart:ui';

// Function to update category images from news data
void updateCategoryImages(Map<int, String> categoryImageMap) {
  for (var category in categoriesConst) {
    final categoryId = category['id'] as int;
    if (categoryImageMap.containsKey(categoryId)) {
      category['image'] = categoryImageMap[categoryId]!;
    }
  }
}

// Function to get image URL from news item
String getNewsImageUrl(dynamic newsItem) {
  try {
    final yoastHeadJson = newsItem['yoast_head_json'];
    if (yoastHeadJson != null &&
        yoastHeadJson['og_image'] != null &&
        yoastHeadJson['og_image'].isNotEmpty) {
      return yoastHeadJson['og_image'][0]['url'];
    }
  } catch (e) {
    print('Error extracting image URL: $e');
  }
  return "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png";
}

List<Color> colorsList = [
  Color(0xFF4834D4),
  Color(0xFF00B894),
  Color(0xFF0984E3),
  Color(0xFFFDCB6E),
];

List categoriesConst = [
  {
    "id": 18,
    "count": 206,
    "description": "الرئيسي لجميع الاخبار",
    "name": "آخر الأخبار",
    "parent": 0,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 43,
    "count": 2,
    "description": "",
    "name": "أسواق المال",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 13,
    "count": 26215,
    "description": "",
    "name": "أمن",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 2,
    "count": 8190,
    "description": "",
    "name": "اقتصاد",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 40,
    "count": 1,
    "description": "",
    "name": "الصحة",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 17,
    "count": 6743,
    "description": "",
    "name": "العالم",
    "parent": 0,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 9,
    "count": 1194,
    "description": "",
    "name": "تقارير وحوارات",
    "parent": 0,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },

  {
    "id": 3,
    "count": 1239,
    "description": "",
    "name": "ثقافة وفن",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 5,
    "count": 7422,
    "description": "",
    "name": "رياضة",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 6,
    "count": 36401,
    "description": "",
    "name": "سياسة",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 16,
    "count": 38696,
    "description": "",
    "name": "عواجل",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },

  {
    "id": 15,
    "count": 23,
    "description": "",
    "name": "قالوا في السياسة",
    "parent": 0,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 4,
    "count": 43434,
    "description": "",
    "name": "محلي",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
  {
    "id": 7,
    "count": 5994,
    "description": "",
    "name": "منوعات",
    "parent": 18,
    "image": "https://dijlah.tv/wp-content/uploads/2025/03/dlogo.png",
  },
];
