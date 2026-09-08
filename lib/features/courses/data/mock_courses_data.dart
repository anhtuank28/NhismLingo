class CourseItem {
  final String id;
  final String title;
  final String imageUrl;
  final String level; // VD: A1, A2, B2
  final int totalLessons;
  final double progress; // 0.0 -> 1.0
  final String category; // Translation key
  final double rating;
  final int reviewCount;

  CourseItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.level,
    required this.totalLessons,
    required this.progress,
    required this.category,
    required this.rating,
    required this.reviewCount,
  });
}

final List<CourseItem> mockCoursesList = [
  CourseItem(
    id: 'c1',
    title: 'Tiếng Anh Giao Tiếp Cơ Bản',
    imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=600&auto=format&fit=crop',
    level: 'A1',
    totalLessons: 20,
    progress: 0.45,
    category: 'courses.categories.speaking',
    rating: 4.8,
    reviewCount: 120,
  ),
  CourseItem(
    id: 'c2',
    title: 'Luyện Thi IELTS 7.0+',
    imageUrl: 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?q=80&w=600&auto=format&fit=crop',
    level: 'B2',
    totalLessons: 45,
    progress: 0.0,
    category: 'courses.categories.vocabulary',
    rating: 4.9,
    reviewCount: 340,
  ),
  CourseItem(
    id: 'c3',
    title: 'English for Travelers',
    imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?q=80&w=600&auto=format&fit=crop',
    level: 'A2',
    totalLessons: 15,
    progress: 0.0,
    category: 'courses.categories.speaking',
    rating: 4.7,
    reviewCount: 89,
  ),
  CourseItem(
    id: 'c4',
    title: 'Ngữ pháp Nền tảng',
    imageUrl: 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?q=80&w=600&auto=format&fit=crop',
    level: 'B1',
    totalLessons: 30,
    progress: 0.8,
    category: 'courses.categories.grammar',
    rating: 4.9,
    reviewCount: 215,
  ),
];

final List<String> mockCategories = [
  'courses.categories.all',
  'courses.categories.speaking',
  'courses.categories.vocabulary',
  'courses.categories.grammar',
];
