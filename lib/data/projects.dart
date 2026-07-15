/// Project catalogue. Screenshots are NOT listed here — they're discovered at
/// runtime from `screensDir` via AssetsService, so dropping images into the
/// folder is enough. All content is from the discovery interview; company
/// projects are proprietary (no source links), metrics only when verifiable.
library;

class ProjectLink {
  const ProjectLink(this.label, this.url, this.icon);
  final String label;
  final String url;
  final String icon; // mapped to an IconData in the widget
}

class Project {
  const Project({
    required this.name,
    required this.screensDir,
    required this.tagline,
    required this.category,
    required this.client,
    required this.isHero,
    this.role,
    this.problem,
    this.solution,
    this.features = const [],
    this.stack = const [],
    this.challenge,
    this.highlights = const [],
    this.links = const [],
  });

  final String name;
  final String screensDir; // e.g. assets/projects_screens/fozdoc/
  final String tagline;
  final List<String> category;
  final String client;
  final bool isHero;

  final String? role;
  final String? problem;
  final String? solution;
  final List<String> features;
  final List<String> stack;
  final String? challenge;
  final List<String> highlights; // short outcome / notable bullets
  final List<ProjectLink> links;

  static const String _base = 'assets/projects_screens/';

  // ---- HERO CASE STUDIES ------------------------------------------------
  static const List<Project> heroes = [
    Project(
      name: 'FozDoc',
      screensDir: '${_base}fozdoc/',
      tagline:
          'A healthcare e-commerce platform with AI-powered skin analysis and '
          'personalised product recommendations.',
      category: ['Healthcare', 'E-commerce', 'AI'],
      client: 'Croco-IT',
      isHero: true,
      role: 'Flutter Engineer · mobile team',
      problem:
          'Pharmacy apps only let people browse and buy. The client wanted a '
          'smarter experience: analyse a skin condition with AI and receive '
          'personalised skincare recommendations — all in one app.',
      solution:
          'A scalable Flutter app combining full e-commerce with an AI skin-'
          'analysis workflow that feeds personalised recommendations, wrapped '
          'in a smooth, production-ready experience.',
      features: [
        'AI skin analysis',
        'Personalised recommendations',
        'Catalog & search',
        'Cart & checkout',
        'Wishlist',
        'Order history',
        'Auth & profiles',
        'Push notifications',
      ],
      stack: ['Flutter', 'Bloc/Cubit', 'Clean Architecture', 'REST', 'Firebase',
          'GetIt'],
      challenge:
          'The hardest part was making the AI flow feel effortless: image '
          'selection → upload → async analysis states → presenting predictions '
          '→ linking results to product recommendations, all without breaking '
          'the journey or dropping frames.',
      highlights: [
        'Production healthcare app blending commerce + AI',
        'Advanced async state handling for the analysis pipeline',
        'Reusable, performance-tuned UI components',
      ],
    ),
    Project(
      name: 'HRmobic',
      screensDir: '${_base}hrmobic/',
      tagline:
          'An enterprise HR & workforce platform: attendance, leave and '
          'approvals, fully integrated with the company ERP.',
      category: ['Enterprise HR', 'Productivity'],
      client: 'Croco-IT',
      isHero: true,
      role: 'Flutter Engineer · mobile team',
      problem:
          'Managing employees through spreadsheets and disconnected systems '
          'made attendance, leave and approvals inefficient. The goal: one '
          'mobile platform integrated with the company ERP.',
      solution:
          'A scalable Flutter app where employees and HR run daily operations '
          'from a single experience — synchronising employees, attendance, '
          'leave requests, approvals and notifications with ERP services.',
      features: [
        'Secure authentication',
        'Attendance check-in/out',
        'Leave requests & approvals',
        'Role-based access',
        'Employee profiles',
        'Announcements',
        'ERP integration',
        'Push notifications',
      ],
      stack: ['Flutter', 'Bloc/Cubit', 'Clean Architecture', 'REST',
          'ERP integration', 'FCM'],
      challenge:
          'Enterprise workflows — approval chains, role-dependent features and '
          'synchronised ERP data — are complex. I isolated business logic from '
          'presentation with clean layering so the app stayed maintainable as '
          'requirements evolved.',
      highlights: [
        'Digitised real organisational HR workflows',
        'Role-based permissions & approval chains',
        'Shared component library across modules',
      ],
    ),
    Project(
      name: 'Al-Masry Pharmacy',
      screensDir: '${_base}al_masry_pharmacy/',
      tagline:
          'A production pharmacy e-commerce app delivering fast, personalised '
          'shopping over a GraphQL commerce backend.',
      category: ['Healthcare', 'E-commerce'],
      client: 'Croco-IT',
      isHero: true,
      role: 'Flutter Engineer · mobile team',
      problem:
          'Buying from a pharmacy meant a physical visit — hard to search, '
          'compare and reorder. The client wanted a modern mobile commerce '
          'experience that scales with the business.',
      solution:
          'A scalable Flutter app for browsing thousands of products, instant '
          'search, wishlists, ordering, tracking and secure checkout — smooth '
          'and responsive throughout.',
      features: [
        'GraphQL product search',
        'Categories & filters',
        'Wishlist',
        'Cart & secure checkout',
        'Order history',
        'Offers & promotions',
        'Authentication',
        'Notifications',
      ],
      stack: ['Flutter', 'Bloc/Cubit', 'Clean Architecture', 'GraphQL', 'REST',
          'FCM'],
      challenge:
          'Integrating a GraphQL commerce backend while staying highly '
          'responsive: complex product relationships, filters, wishlist sync '
          'and cart. I built reusable data layers and optimised queries to keep '
          'scrolling and navigation smooth.',
      highlights: [
        'Serving real customers in production',
        'GraphQL integrated cleanly into a Flutter commerce app',
        'Reusable UI + optimised list performance',
      ],
    ),
  ];

  // ---- GRID PROJECTS ----------------------------------------------------
  static const List<Project> grid = [
    Project(
      name: 'Ram Pharmacy',
      screensDir: '${_base}ram_pharmacy/',
      tagline:
          'Migration and modernisation of an existing pharmacy app — improved '
          'maintainability, UX and performance while shipping new features.',
      category: ['Healthcare', 'E-commerce'],
      client: 'Croco-IT',
      isHero: false,
      stack: ['Flutter', 'Bloc/Cubit', 'Clean Architecture', 'REST', 'Firebase'],
    ),
    Project(
      name: 'Apple E-Store',
      screensDir: '${_base}apple_e_store/',
      tagline:
          'A personal e-commerce project exploring modern commerce '
          'architecture, polished UI and complete shopping flows.',
      category: ['E-commerce', 'Personal'],
      client: 'Personal',
      isHero: false,
      stack: ['Flutter', 'Bloc', 'Clean Architecture', 'REST'],
      links: [
        // Repo URL to be provided; shows a "View Code" button when set.
      ],
    ),
  ];
}
