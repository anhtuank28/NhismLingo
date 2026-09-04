class UserProfile {
  final String name;
  final int streak;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.streak,
    required this.avatarUrl,
  });
}

class UpNextLesson {
  final String unitText;
  final String title;
  final String subtitle;
  final double progress;

  const UpNextLesson({
    required this.unitText,
    required this.title,
    required this.subtitle,
    required this.progress,
  });
}

class RecommendedCourse {
  final String id;
  final String title;
  final String subtitle;
  final String lessonCount;
  final String badgeText;
  final String imageUrl;

  const RecommendedCourse({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lessonCount,
    required this.badgeText,
    required this.imageUrl,
  });
}

const mockUserProfile = UserProfile(
  name: 'Tuấn',
  streak: 5,
  avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=150', // Avatar nam
);

const mockUpNext = UpNextLesson(
  unitText: 'Unit 3 • Lesson 4',
  title: 'Ordering in a Restaurant',
  subtitle: 'Learn essential phrases for ordering food.',
  progress: 0.4,
);

const mockRecommendedCourses = [
  RecommendedCourse(
    id: 'c1',
    title: 'Business English',
    subtitle: 'Master vocabulary for emails, meetings, and...',
    lessonCount: '12 Lessons',
    badgeText: '★ B1 Intermediate',
    imageUrl: 'https://images.unsplash.com/photo-1573164713988-8665fc963095?auto=format&fit=crop&q=80&w=400',
  ),
  RecommendedCourse(
    id: 'c2',
    title: 'Travel Survival',
    subtitle: 'Navigate airports, and ask for directions.',
    lessonCount: '8 Lessons',
    badgeText: '✈️ A2 Pre-Int',
    imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&q=80&w=400',
  ),
];
