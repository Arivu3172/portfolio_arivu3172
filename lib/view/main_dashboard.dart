import 'package:flutter/material.dart';
import 'package:portfolio_arivu/globals/app_colors.dart';
import 'package:portfolio_arivu/globals/cinematic_scene.dart';
import 'package:portfolio_arivu/globals/text_style.dart';
import 'package:portfolio_arivu/globals/water_animations.dart';
import 'package:portfolio_arivu/globals/water_background.dart';
import 'package:portfolio_arivu/view/about_me.dart';
import 'package:portfolio_arivu/view/contact.dart';
import 'package:portfolio_arivu/view/footer_class.dart';
import 'package:portfolio_arivu/view/freelancing.dart';
import 'package:portfolio_arivu/view/home.dart';
import 'package:portfolio_arivu/view/my_certificate.dart';
import 'package:portfolio_arivu/view/my_project.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({super.key});

  @override
  State<MainDashBoard> createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  final menuItems = <String>[
    'Opening',
    'Story',
    'Credits',
    'Work',
    'Hire',
    'Contact',
  ];

  int menuIndex = 0;

  late final List<Widget> screensList = [
    const HomePage(),
    const AboutMe(),
    const MyCertificate(),
    const MyProject(),
    const FreelancingPage(),
    const ContactUs(),
    FooterClass(onScrollToTop: () => scrollTo(index: 0)),
  ];

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onPositions);
  }

  @override
  void dispose() {
    itemPositionsListener.itemPositions.removeListener(_onPositions);
    super.dispose();
  }

  void _onPositions() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;
    // Pick the item most visible near the top of the viewport.
    final best = positions
        .where((p) => p.itemLeadingEdge < 0.55)
        .fold<ItemPosition?>(null, (prev, p) {
      if (prev == null) return p;
      return p.itemLeadingEdge > prev.itemLeadingEdge ? p : prev;
    });
    final next = (best?.index ?? positions.first.index).clamp(0, 5);
    if (next != menuIndex && mounted) {
      setState(() => menuIndex = next);
    }
  }

  Future<void> scrollTo({required int index}) async {
    await _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeInOutCubic,
    );
    if (!mounted) return;
    setState(() => menuIndex = index.clamp(0, 5));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 768;
    final progress = (menuIndex + 1) / menuItems.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: isMobile ? 72.0 : 84.0,
        titleSpacing: isMobile ? 16.0 : 40.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.92),
                Colors.black.withValues(alpha: 0.35),
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              height: 2,
              width: width * progress,
              color: AppColors.themeColor,
            ),
          ),
        ),
        title: ShimmerText(
          text: 'ARIVAZHAGAN',
          style: AppTextStyles.nameStyle(fontSize: isMobile ? 18 : 24),
          duration: const Duration(seconds: 5),
        ),
        actions: isMobile
            ? [
                PopupMenuButton<int>(
                  icon: Icon(
                    Icons.menu_sharp,
                    size: 28,
                    color: AppColors.themeColor,
                  ),
                  color: AppColors.bgColor2,
                  position: PopupMenuPosition.under,
                  onSelected: (index) => scrollTo(index: index),
                  itemBuilder: (context) => menuItems
                      .asMap()
                      .entries
                      .map(
                        (e) => PopupMenuItem<int>(
                          value: e.key,
                          child: Text(
                            'SCENE 0${e.key + 1}  ${e.value}',
                            style: AppTextStyles.headerTextStyle(),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(width: 8),
              ]
            : [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: FilmProgressRail(
                      total: menuItems.length,
                      active: menuIndex,
                      labels: menuItems,
                      onSelect: (i) => scrollTo(index: i),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
      ),
      body: WaterBackground(
        child: ScrollablePositionedList.builder(
          itemCount: screensList.length,
          itemScrollController: _itemScrollController,
          itemPositionsListener: itemPositionsListener,
          scrollOffsetListener: scrollOffsetListener,
          itemBuilder: (context, index) {
            return screensList[index];
          },
        ),
      ),
    );
  }
}
