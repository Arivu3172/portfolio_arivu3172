import 'package:portfolio_arivu/globals/app_assets.dart';

/// Shared portfolio copy used across cinematic scenes.
class PortfolioContent {
  static const name = 'Arivazhagan A';
  static const role = 'Senior Flutter Developer';
  static const tagline =
      'Production Flutter for Android, iOS, and web — clean architecture, sharp UI, reliable delivery.';

  static const aboutBody =
      'Flutter developer with 2+ years of production experience. '
      'I ship mobile and web products with clean Dart, solid state management, '
      'and stable API / Firebase integrations — from first wireframe to store release.';

  static const aboutFocus =
      'I care about motion that feels intentional, UI that stays readable, '
      'and code that other developers can extend without fear.';

  static const stats = [
    PortfolioStat(value: '2+', label: 'Years'),
    PortfolioStat(value: '4+', label: 'Apps Shipped'),
    PortfolioStat(value: '3', label: 'Platforms'),
    PortfolioStat(value: '100%', label: 'Client Focus'),
  ];

  static const experience = [
    PortfolioExp(
      role: 'Flutter Developer',
      org: 'Howdy · TimesMed · Coding Style',
      detail: 'UI systems, auth, REST, Firebase, performance, and release support.',
    ),
    PortfolioExp(
      role: 'Healthcare products',
      org: 'TimesMed Doctor, Patient & VKA',
      detail: 'Clinical flows, role-based screens, and production stability.',
    ),
    PortfolioExp(
      role: 'Product craft',
      org: 'Cross-platform delivery',
      detail: 'Reusable widgets, clean architecture, and polished motion.',
    ),
  ];

  static const education = [
    PortfolioCred(
      title: 'Computer Science / Engineering',
      meta: 'Degree path · Foundations in software & systems',
    ),
    PortfolioCred(
      title: 'Flutter & Mobile Craft',
      meta: 'Certificates · Continuous hands-on production work',
    ),
  ];

  static const skillGroups = [
    PortfolioSkillGroup(
      title: 'Core',
      items: ['Flutter', 'Dart', 'Material 3', 'Cupertino', 'Responsive UI'],
    ),
    PortfolioSkillGroup(
      title: 'State & Architecture',
      items: [
        'Provider',
        'GetX',
        'Clean Architecture',
        'Repository pattern',
        'Modular widgets',
      ],
    ),
    PortfolioSkillGroup(
      title: 'Backend & Data',
      items: ['REST API', 'Firebase', 'Auth', 'Firestore', 'Cloud Messaging'],
    ),
    PortfolioSkillGroup(
      title: 'Ship',
      items: ['Android', 'iOS', 'Web', 'Play Console', 'App Store', 'Git'],
    ),
  ];

  static const process = [
    PortfolioStep(
      no: '01',
      title: 'Brief',
      detail: 'Goals, users, platforms, and success metrics.',
    ),
    PortfolioStep(
      no: '02',
      title: 'Design',
      detail: 'Flows, UI kit, and motion that match the product tone.',
    ),
    PortfolioStep(
      no: '03',
      title: 'Build',
      detail: 'Flutter features, APIs, auth, and solid architecture.',
    ),
    PortfolioStep(
      no: '04',
      title: 'Ship',
      detail: 'QA, store builds, fixes, and post-launch support.',
    ),
  ];

  static const projects = [
    PortfolioProject(
      image: AppAssets.project1,
      title: 'Howdy',
      role: 'Flutter Developer',
      year: '2024',
      platforms: 'Android · iOS',
      description:
          'Cross-platform social product with clean UI and production flows.',
      tags: ['Flutter', 'API', 'UI System'],
    ),
    PortfolioProject(
      image: AppAssets.project2,
      title: 'TimesMed Doctor & Patient',
      role: 'Flutter Developer',
      year: '2024',
      platforms: 'Android · iOS',
      description: 'Healthcare apps connecting doctors and patients in real time.',
      tags: ['Flutter', 'Firebase', 'Healthcare'],
    ),
    PortfolioProject(
      image: AppAssets.project3,
      title: 'TimesMed VKA',
      role: 'Flutter Developer',
      year: '2025',
      platforms: 'Android · iOS',
      description: 'Clinical Flutter module for specialized medical workflows.',
      tags: ['Flutter', 'Modules', 'UX'],
    ),
    PortfolioProject(
      image: AppAssets.project4,
      title: 'Coding Style',
      role: 'Flutter Developer',
      year: '2025',
      platforms: 'Multi-platform',
      description:
          'Architecture showcase — reusable widgets, solid patterns, polished UI.',
      tags: ['Architecture', 'Widgets', 'Craft'],
    ),
  ];

  static const services = [
    PortfolioService(
      title: 'Flutter App Development',
      description: 'Android, iOS, and web apps from UI to release.',
    ),
    PortfolioService(
      title: 'Feature & API Work',
      description: 'Auth, REST, Firebase, and complex product flows.',
    ),
    PortfolioService(
      title: 'Bug Fix & Optimization',
      description: 'Stabilize apps, improve speed, and clean code.',
    ),
    PortfolioService(
      title: 'MVP Builds',
      description: 'Scoped startup MVPs with clear milestones.',
    ),
  ];
}

class PortfolioStat {
  const PortfolioStat({required this.value, required this.label});
  final String value;
  final String label;
}

class PortfolioExp {
  const PortfolioExp({
    required this.role,
    required this.org,
    required this.detail,
  });
  final String role;
  final String org;
  final String detail;
}

class PortfolioCred {
  const PortfolioCred({required this.title, required this.meta});
  final String title;
  final String meta;
}

class PortfolioSkillGroup {
  const PortfolioSkillGroup({required this.title, required this.items});
  final String title;
  final List<String> items;
}

class PortfolioStep {
  const PortfolioStep({
    required this.no,
    required this.title,
    required this.detail,
  });
  final String no;
  final String title;
  final String detail;
}

class PortfolioProject {
  const PortfolioProject({
    required this.image,
    required this.title,
    required this.role,
    required this.year,
    required this.platforms,
    required this.description,
    required this.tags,
  });
  final String image;
  final String title;
  final String role;
  final String year;
  final String platforms;
  final String description;
  final List<String> tags;
}

class PortfolioService {
  const PortfolioService({required this.title, required this.description});
  final String title;
  final String description;
}
