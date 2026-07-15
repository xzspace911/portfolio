/// Single source of truth for Ahmed's real content. Every section reads from
/// here, so adding/editing content is a data change — not surgery on widgets.
/// Nothing in this file is invented; all values came from the discovery
/// interview. Metrics are intentionally omitted until attributable.
library;

class SocialLink {
  const SocialLink(this.label, this.url);
  final String label;
  final String url;
}

/// A headline figure for the proof band. Values are qualitative or
/// self-verifiable — never fabricated engagement metrics.
class Stat {
  const Stat(this.value, this.label);
  final String value;
  final String label;
}

/// One of the identity pillars in the About section.
class Pillar {
  const Pillar(this.icon, this.title, this.body);
  final String icon; // emoji-free: mapped to an IconData in the widget
  final String title;
  final String body;
}

/// A "prefer X over Y" engineering trade-off.
class Tradeoff {
  const Tradeoff(this.prefer, this.over);
  final String prefer;
  final String over;
}

/// A role in the work-experience section.
class Experience {
  const Experience({
    required this.company,
    required this.role,
    required this.period,
    required this.summary,
    required this.points,
    required this.current,
  });
  final String company;
  final String role;
  final String period;
  final String summary;
  final List<String> points;
  final bool current;
}

/// A named group of skills for the Skills & Tech Stack section.
class SkillGroup {
  const SkillGroup(this.title, this.items);
  final String title;
  final List<String> items;
}

/// A milestone on the growth timeline. [ownership] (0–1) rises down the list —
/// the visual metaphor for increasing ownership and engineering maturity.
class Milestone {
  const Milestone({
    required this.era,
    required this.title,
    required this.body,
    required this.ownership,
    required this.ownershipLabel,
    this.tags = const [],
  });

  final String era;
  final String title;
  final String body;
  final double ownership;
  final String ownershipLabel;
  final List<String> tags;
}

class Profile {
  Profile._();

  static const String name = 'Ahmed Waleed';
  static const String handle = 'XZSPACE';
  static const String initials = 'XZ';
  // Assets are discovered at runtime via AssetsService (drop-in), not hardcoded.

  static const String role = 'Flutter Engineer';
  static const String roleLong = 'Mobile Application Developer · Flutter';
  static const String company = 'Croco-IT';
  static const String location = 'Cairo, Egypt';
  static const String availability = 'Open to remote & relocation';

  /// Hero display headline, broken into two lines. The accent line renders in
  /// the violet gradient.
  static const String heroTitleTop = 'From idea';
  static const String heroTitleAccent = 'to production.';

  /// The hook — the one sentence meant to stick.
  static const String hook =
      'I don’t just build Flutter apps — I ship products.';

  /// Supporting sub-hook shown under the headline.
  static const String subhook =
      'From idea to production — premium digital products with elegant design, '
      'scalable architecture, and exceptional user experiences.';

  /// The differentiator, in Ahmed's voice.
  static const String differentiator =
      'A design-minded Flutter engineer: I craft the interfaces I build — '
      'shaping visual hierarchy, interaction, and performance into products '
      'that are both beautiful and built to grow.';

  static const int yearsSoftware = 5;
  static const int yearsFlutter = 3;

  // Languages
  static const List<String> languages = [
    'Arabic — Native',
    'English — B2',
    'German — B1',
  ];

  // --- Proof band -------------------------------------------------------
  // Self-verifiable / qualitative only. (Downloads & ratings are held back
  // until attributable to a specific app + store.)
  static const List<Stat> stats = [
    Stat('3+', 'Years with Flutter'),
    Stat('5+', 'Years in software'),
    Stat('8+', 'Products shipped'),
    Stat('3', 'Languages spoken'),
  ];

  // --- About ------------------------------------------------------------
  static const String aboutEyebrow = 'ABOUT';

  /// Large lead statement for the About section.
  static const String aboutLead =
      'I build at the intersection of design and engineering.';

  static const List<String> aboutBody = [
    'I’m a Flutter engineer who designs the interfaces I build. My work started '
        'with self-taught curiosity, grew through freelance projects I owned '
        'end-to-end, and now spans production applications at Croco-IT.',
    'Somewhere along the way my focus shifted — from “how do I build this '
        'screen?” to “why does this feature exist, how should it scale, and how '
        'do I make it reliable for years?” That’s the product-minded engineer I '
        'am today.',
  ];

  // --- Engineering Principles ------------------------------------------
  static const String principlesEyebrow = 'PRINCIPLES';
  static const String principlesTitle = 'How I think about engineering.';
  static const String philosophyLead =
      'I don’t measure success by the number of features shipped — but by '
      'whether a product stays maintainable months after release.';
  static const List<Tradeoff> tradeoffs = [
    Tradeoff('Scalability', 'quick fixes'),
    Tradeoff('Readability', 'clever code'),
    Tradeoff('Reusability', 'duplication'),
    Tradeoff('User experience', 'needless complexity'),
    Tradeoff('Long-term maintainability', 'short-term speed'),
  ];
  static const String philosophyClose =
      'Good architecture lets a team move faster over time, and great UX is the '
      'result of thoughtful design and disciplined engineering. Beyond writing '
      'code, I review architecture, mentor teammates, hunt down bottlenecks and '
      'improve workflows — aiming to leave every project better than I found it.';

  static const List<Pillar> pillars = [
    Pillar('design', 'Design-minded',
        'I craft visual hierarchy, interaction, and motion — not just implement handoffs.'),
    Pillar('architecture', 'Scalable architecture',
        'Feature-first Clean Architecture, Bloc/Cubit, and DI that stays maintainable months later.'),
    Pillar('performance', 'Performance-obsessed',
        'Fewer rebuilds, const discipline, DevTools profiling — kept at a smooth 60fps.'),
    Pillar('product', 'Product thinking',
        'I optimise for the user and the business, not just the ticket.'),
  ];

  // --- Journey / Timeline ----------------------------------------------
  static const String journeyEyebrow = 'JOURNEY';
  static const String journeyTitle = 'A story of increasing ownership.';
  static const String journeyIntro =
      'Not a list of jobs — the arc of how I grew: from curiosity, to owning '
      'complete products alone, to engineering production systems with a '
      'product mindset.';

  static const List<Milestone> milestones = [
    Milestone(
      era: '2020',
      title: 'The first lines of code',
      body:
          'Started with curiosity about how digital products are built. Learned '
          'programming fundamentals and shipped small projects — the habit of '
          'building began here.',
      ownership: 0.15,
      ownershipLabel: 'Learning the craft',
      tags: ['Fundamentals', 'Curiosity'],
    ),
    Milestone(
      era: '2023',
      title: 'Choosing Flutter',
      body:
          'Committed to Flutter for its blend of engineering and creativity — '
          'building complete mobile experiences with custom UI, smooth motion, '
          'and maintainable architecture.',
      ownership: 0.4,
      ownershipLabel: 'Owning the build',
      tags: ['Flutter & Dart', 'UI/UX', 'Certified'],
    ),
    Milestone(
      era: '2023 — 2024',
      title: 'Freelance: end-to-end products',
      body:
          'Delivered ~4 applications solo — requirements, UX design, '
          'architecture, API integration, publishing and maintenance. This is '
          'where independent product delivery became second nature.',
      ownership: 0.7,
      ownershipLabel: 'Owning whole products',
      tags: ['Solo delivery', 'Product thinking', 'Shipping'],
    ),
    Milestone(
      era: '2025',
      title: 'Formal foundations',
      body:
          'Graduated CS (Modern Academy) and completed the DEPI × MCIT mobile '
          'track (ITI-equivalent) and the McKinsey Forward program — sharpening '
          'engineering fundamentals and professional practice.',
      ownership: 0.8,
      ownershipLabel: 'Deepening the fundamentals',
      tags: ['CS degree', 'DEPI × MCIT', 'McKinsey Forward'],
    ),
    Milestone(
      era: 'Jul 2025 — now',
      title: 'Croco-IT: production at scale',
      body:
          'Building production applications (FozDoc, HRmobic, Al-Masry Pharmacy '
          'and more) with Clean Architecture, Bloc/Cubit, GraphQL and CI/CD — '
          'inside a 50+ engineer organisation.',
      ownership: 0.9,
      ownershipLabel: 'Owning production systems',
      tags: ['Clean Architecture', 'Bloc', 'GraphQL', 'CI/CD'],
    ),
    Milestone(
      era: 'What’s next',
      title: 'Product-minded engineer',
      body:
          'My focus shifted from “how do I build this screen?” to “why does it '
          'exist, how does it scale, how does it stay reliable for years?” '
          'Now leveling up architecture, Flutter Web, system design and testing.',
      ownership: 1.0,
      ownershipLabel: 'Owning architecture & outcomes',
      tags: ['System design', 'Flutter Web', 'Scale'],
    ),
  ];

  // --- Work Experience -------------------------------------------------
  static const List<Experience> experiences = [
    Experience(
      company: 'Croco-IT',
      role: 'Mobile Application Developer · Flutter',
      period: 'Jul 2025 — Present',
      current: true,
      summary:
          'Building production-level mobile applications within a 50+ engineer '
          'organisation.',
      points: [
        'Architect scalable Flutter apps with feature-first Clean Architecture.',
        'Build maintainable state with Bloc/Cubit (and Provider where simpler).',
        'Integrate REST and GraphQL services with robust error handling.',
        'Craft complex, design-quality UI and micro-interactions.',
        'Optimise rendering and production stability; add analytics.',
        'Contribute to CI/CD build, signing and release workflows.',
      ],
    ),
    Experience(
      company: 'Freelance',
      role: 'Flutter / Mobile Developer',
      period: '2023 — 2024',
      current: false,
      summary:
          'Delivered ~4 applications end-to-end, owning the full product cycle '
          'independently.',
      points: [
        'Turned requirements into shipped products solo.',
        'Designed the UX, built the app, integrated APIs, published & maintained.',
        'E-commerce, business and custom Flutter experiences.',
      ],
    ),
  ];

  // --- Skills & Tech Stack ---------------------------------------------
  static const List<SkillGroup> skillGroups = [
    SkillGroup('State Management', ['Bloc', 'Cubit', 'Provider']),
    SkillGroup('Architecture', [
      'Feature-first Clean Architecture',
      'Repository pattern',
      'Dependency Injection (GetIt)',
      'Use cases',
    ]),
    SkillGroup('Backend & Data', [
      'REST (Dio · Retrofit)',
      'GraphQL',
      'Firebase (FCM · Analytics · Crashlytics · Storage)',
      'Hive',
      'Secure Storage',
    ]),
    SkillGroup('Capabilities', [
      'JWT / OTP / Social auth',
      'Push & local notifications',
      'Google Maps & location',
      'AI integration',
      'Custom animations',
      'Offline caching',
    ]),
    SkillGroup('Practice', [
      'Unit & widget testing',
      'CI/CD (GitHub Actions · Fastlane)',
      'Performance profiling (DevTools)',
      'Platform channels (Kotlin/Swift)',
      'Agile',
    ]),
    SkillGroup('Tooling', [
      'Git & GitHub',
      'Figma',
      'Postman',
      'Jira',
      'Android Studio · VS Code · Xcode',
    ]),
  ];

  // --- Contact ----------------------------------------------------------
  static const String contactTitle = 'Let’s build something people love.';
  static const String contactBody =
      'Open to mid-to-senior Flutter roles — remote or relocation. If you’re '
      'looking for an engineer who ships production products with real design '
      'sensibility, let’s talk.';

  // Links
  static const String email = 'ahmedbarakat911@outlook.com';
  static const SocialLink github =
      SocialLink('GitHub', 'https://github.com/xzspace911');
  static const SocialLink linkedin = SocialLink(
      'LinkedIn', 'https://www.linkedin.com/in/ahmed-waleed-a29964236/');

  static const List<SocialLink> socials = [github, linkedin];
}
