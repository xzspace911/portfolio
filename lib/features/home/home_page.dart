import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../../core/design/app_motion.dart';
import 'section_nav.dart';
import '../contact/contact_section.dart';
import '../experience/experience_section.dart';
import '../hero/hero_section.dart';
import '../journey/journey_section.dart';
import '../principles/principles_section.dart';
import '../proof/proof_band.dart';
import '../skills/skills_section.dart';
import '../work/featured_work_section.dart';
import 'widgets/top_nav.dart';

/// Root scaffold. Single-page scroll in the work-first storytelling order:
/// Hero → (credibility strip) → Featured Work → Experience → Story → Skills →
/// Engineering Principles → Contact. Nav links smooth-scroll to each section.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  bool _scrolled = false;

  // Anchors for nav targets.
  final _keys = <String, GlobalKey>{
    'work': GlobalKey(),
    'story': GlobalKey(),
    'skills': GlobalKey(),
    'contact': GlobalKey(),
  };

  // Approx floating-nav height to offset scroll targets so headings clear it.
  static const double _navOffset = 92;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 24;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _navigate(String id) {
    if (id == 'top') {
      _scrollController.animateTo(0,
          duration: Motion.slower, curve: Motion.emphasized);
      return;
    }
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final viewport = RenderAbstractViewport.of(box);
    final reveal = viewport.getOffsetToReveal(box, 0).offset - _navOffset;
    final target =
        reveal.clamp(0.0, _scrollController.position.maxScrollExtent);
    _scrollController.animateTo(target,
        duration: Motion.slower, curve: Motion.emphasized);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<SectionNav>.value(
        value: SectionNav(_navigate),
        child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                const HeroSection(),
                const ProofBand(),
                KeyedSubtree(
                    key: _keys['work'], child: const FeaturedWorkSection()),
                const ExperienceSection(),
                KeyedSubtree(
                    key: _keys['story'], child: const JourneySection()),
                KeyedSubtree(
                    key: _keys['skills'], child: const SkillsSection()),
                const PrinciplesSection(),
                KeyedSubtree(
                    key: _keys['contact'], child: const ContactSection()),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopNav(scrolled: _scrolled, onNavigate: _navigate),
          ),
        ],
        ),
      ),
    );
  }
}
