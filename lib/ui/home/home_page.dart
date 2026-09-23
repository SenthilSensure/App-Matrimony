import 'package:app_matrimony/ui/chat/profile_chat_page.dart';
import 'package:app_matrimony/ui/notification/notification_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/base_page.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_messages.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_text_style.dart';
import '../login/login_page.dart';
import '../profile/profile_page.dart';

/// Temporary placeholder model until the real Match/Search API is ready.
class _MatchPreview {
  final String name;
  final int age;
  final String location;
  final String occupation;

  const _MatchPreview(this.name, this.age, this.location, this.occupation);
}

class HomePage extends BasePage {
  static const id = 'HomePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> with BasicPage {
  int _navIndex = 0;

  // Placeholder data — replace with real API response later.
  final List<_MatchPreview> _newMatches = const [
    _MatchPreview('Priya S.', 26, 'Coimbatore', 'Software Engineer'),
    _MatchPreview('Divya R.', 28, 'Chennai', 'Doctor'),
    _MatchPreview('Aishwarya K.', 25, 'Madurai', 'Teacher'),
    _MatchPreview('Meena V.', 27, 'Salem', 'Bank Manager'),
  ];

  final List<_MatchPreview> _recentlyJoined = const [
    _MatchPreview('Kavya M.', 24, 'Trichy', 'Designer'),
    _MatchPreview('Swathi P.', 29, 'Erode', 'HR Manager'),
    _MatchPreview('Nithya J.', 26, 'Dharapuram', 'Architect'),
  ];

  @override
  Color bgColor() => AppColors.backgroundColor;

  @override
  PreferredSizeWidget? appBar() {
    return AppBar(
      title: Text(
        AppStrings.txtAppName,
        style: AppTextStyle.white(18, FontWeight.bold),
      ),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          icon: const Icon(
            Icons.notifications_outlined,
            color: AppColors.white,
          ),
          onPressed: _openNotifications,
        ),
        IconButton(
          tooltip: AppStrings.txtLogout,
          icon: const Icon(Icons.logout, color: AppColors.white),
          onPressed: _onLogout,
        ),
      ],
    );
  }

  @override
  Widget body() {
    return kIsWeb ? _uiWeb() : _uiMobile();
  }

  @override
  Widget? bottomNav() {
    if (kIsWeb) return null;
    return BottomNavigationBar(
      currentIndex: _navIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: _onBottomNavTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppStrings.txtHome,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: AppStrings.txtSearch,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: AppStrings.txtInterestsReceived,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: AppStrings.txtChat,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: AppStrings.txtProfile,
        ),
      ],
    );
  }

  void _onBottomNavTapped(int index) {
    switch (index) {
      case 0:
        setState(() => _navIndex = 0);
        break;
      case 1:
        _openSearch();
        break;
      case 2:
        _openInterests();
        break;
      case 3:
        _openChat();
        break;
      case 4:
        _openProfile();
        break;
    }
  }

  @override
  Widget? floatingActionButton() {
    return FloatingActionButton(
      onPressed: () => {
        Get.toNamed(ProfileChatPage.id)
      },
      backgroundColor: AppColors.primaryColor,
      tooltip: AppStrings.txtChat,
      child: const Icon(Icons.chat, color: AppColors.white),
    );
  }

  // ---------------------------------------------------------------------------
  // WEB LAYOUT — NavigationRail + wide dashboard + grid of matches
  // ---------------------------------------------------------------------------
  Widget _uiWeb() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _navIndex,
          onDestinationSelected: (i) {
            setState(() => _navIndex = i);
            if (i != 0) _comingSoon();
          },
          labelType: NavigationRailLabelType.all,
          backgroundColor: AppColors.white,
          selectedIconTheme: IconThemeData(color: AppColors.primaryColor),
          selectedLabelTextStyle: AppTextStyle.primary(12, FontWeight.w600),
          unselectedLabelTextStyle: AppTextStyle.grey(12, FontWeight.normal),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: Text(AppStrings.txtHome),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.search),
              label: Text(AppStrings.txtSearch),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.favorite_border),
              label: Text(AppStrings.txtInterestsReceived),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.chat_bubble_outline),
              label: Text(AppStrings.txtChat),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person_outline),
              label: Text(AppStrings.txtProfile),
            ),
          ],
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _welcomeHeader(),
                  hSpace(24),
                  _profileCompletionCard(),
                  hSpace(28),
                  _statsRowWeb(),
                  hSpace(32),
                  _sectionTitle(AppStrings.txtNewMatches),
                  hSpace(16),
                  _matchGrid(_newMatches),
                  hSpace(32),
                  _sectionTitle(AppStrings.txtRecentlyJoined),
                  hSpace(16),
                  _matchGrid(_recentlyJoined),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // MOBILE LAYOUT — vertical scroll + horizontal carousels
  // ---------------------------------------------------------------------------
  Widget _uiMobile() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _welcomeHeader(),
          hSpace(20),
          _profileCompletionCard(),
          hSpace(24),
          _statsRowMobile(),
          hSpace(28),
          _sectionTitle(AppStrings.txtNewMatches),
          hSpace(14),
          _matchCarousel(_newMatches),
          hSpace(28),
          _sectionTitle(AppStrings.txtRecentlyJoined),
          hSpace(14),
          _matchCarousel(_recentlyJoined),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED WIDGETS
  // ---------------------------------------------------------------------------
  Widget _welcomeHeader() {
    final String name = pref.getUser?.name ?? 'there';
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: _openProfile,
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryColor,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: AppTextStyle.white(20, FontWeight.bold),
            ),
          ),
          wSpace(14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.txtWelcomeBackUser,
                style: AppTextStyle.grey(13, FontWeight.normal),
              ),
              Text(name, style: AppTextStyle.black(19, FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileCompletionCard() {
    const double completion =
        0.35; // TODO: replace with real profile % from API
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.txtCompleteProfile,
                  style: AppTextStyle.white(16, FontWeight.bold),
                ),
                hSpace(6),
                Text(
                  AppStrings.txtCompleteProfileDesc,
                  style: AppTextStyle.white(13, FontWeight.normal),
                ),
                hSpace(12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: completion,
                    minHeight: 8,
                    backgroundColor: AppColors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(
                      AppColors.accentColor,
                    ),
                  ),
                ),
                hSpace(6),
                Text(
                  '${(completion * 100).toInt()}% completed',
                  style: AppTextStyle.white(12, FontWeight.normal),
                ),
              ],
            ),
          ),
          wSpace(12),
          ElevatedButton(
            onPressed: _openProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: Text(
              AppStrings.txtCompleteNow,
              style: AppTextStyle.primary(13, FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsRowMobile() {
    final stats = _stats();
    return Row(
      children: stats
          .map((s) => Expanded(child: _statChip(s.$1, s.$2, s.$3)))
          .toList(),
    );
  }

  Widget _statsRowWeb() {
    final stats = _stats();
    return Row(
      children: stats
          .map((s) => Expanded(child: _statCardWeb(s.$1, s.$2, s.$3)))
          .toList(),
    );
  }

  List<(IconData, String, String)> _stats() => const [
    (Icons.favorite_outline, '0', AppStrings.txtNewMatches),
    (Icons.remove_red_eye_outlined, '0', AppStrings.txtProfileViews),
    (Icons.mail_outline, '0', AppStrings.txtInterestsReceived),
    (Icons.bookmark_border, '0', AppStrings.txtShortlisted),
  ];

  Widget _statChip(IconData icon, String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 20),
          hSpace(6),
          Text(value, style: AppTextStyle.black(15, FontWeight.bold)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.grey(10, FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _statCardWeb(IconData icon, String value, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.softPink,
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          wSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyle.black(18, FontWeight.bold)),
              Text(label, style: AppTextStyle.grey(12, FontWeight.normal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          height: 18,
          width: 4,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        wSpace(10),
        Text(title, style: AppTextStyle.black(17, FontWeight.bold)),
      ],
    );
  }

  Widget _matchCarousel(List<_MatchPreview> matches) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: matches.length,
        separatorBuilder: (_, __) => wSpace(12),
        itemBuilder: (context, i) => _matchCard(matches[i], width: 150),
      ),
    );
  }

  Widget _matchGrid(List<_MatchPreview> matches) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.62, // was 0.72 — taller cells, more breathing room
      ),
      itemBuilder: (context, i) => _matchCard(matches[i]),
    );
  }

  Widget _matchCard(_MatchPreview m, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flexible image area — shrinks/grows with available space
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.softPink,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.person, size: 32, color: AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${m.name}, ${m.age}',
            style: AppTextStyle.black(12, FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            m.occupation,
            style: AppTextStyle.grey(10, FontWeight.normal),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            m.location,
            style: AppTextStyle.grey(10, FontWeight.normal),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            height: 28,
            child: OutlinedButton(
              onPressed: () => _viewMatchProfile(m),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primaryColor),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                AppStrings.txtViewProfile,
                style: AppTextStyle.primary(11, FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIONS
  // ---------------------------------------------------------------------------
  void _openProfile() {
    Get.toNamed(ProfilePage.id);
  }

  void _openNotifications() {
    Get.toNamed(NotificationPage.id);
  }

  void _openSearch() {

  }

  void _openInterests() {

  }

  void _openChat() {

  }

  void _viewMatchProfile(_MatchPreview match) {
    successToast('Viewing profile for ${match.name}');
  }


  Future<void> _onLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // If your pref.callLogout() is asynchronous, await it:
      // await pref.callLogout();
      pref.callLogout();
      Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.id, (route) => false);
    } else {
      // optional: show a toast or do nothing
      // successToast('Logout cancelled');
    }
  }

  void _comingSoon() => successToast(AppStrings.txtComingSoon);
}
