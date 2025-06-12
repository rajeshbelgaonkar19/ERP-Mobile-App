import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeaderNav extends StatelessWidget {
  final Widget bodyContent;
  const HeaderNav({super.key, required this.bodyContent});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: isSmallScreen ? _buildDrawer(context) : null,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: isSmallScreen ? 120 : 90, // Reduced height
        automaticallyImplyLeading: false,
        flexibleSpace: _buildHeader(context, isSmallScreen),
      ),
      body: bodyContent,
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    final double headerHeight = isSmallScreen ? 120 : 90;
    return SizedBox(
      height: headerHeight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF160747), Color(0xFF2A1070)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: isSmallScreen ? 60 : 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isSmallScreen)
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    Image.asset('assets/image.png', height: 32),
                    const SizedBox(width: 6),
                    const Text(
                      'Academate',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (!isSmallScreen) ...[
                      const SizedBox(width: 20),
                      _navItem(context, 'Dashboard', '/admission-dashboard'),
                      _navItem(context, 'Applications', '/applications'),
                      _dropdownNav(context),
                      _navItem(context, 'Cancelled Applications', '/cancelled-apps'),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/'),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text('Logout', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Colors.deepPurpleAccent),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Admission',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 15, color: Colors.white),
                        SizedBox(width: 4),
                        Text('10 June 2025', style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: () => context.go(route),
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _dropdownNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xFF2A1070),
          iconEnabledColor: Colors.white,
          value: 'Admission Master',
          style: const TextStyle(color: Colors.white),
          items: const [
            DropdownMenuItem(
              value: 'Admission Master',
              child: Text('Admission Master', style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: 'Start Admission',
              child: Text('Start Admission', style: TextStyle(color: Colors.white)),
            ),
            DropdownMenuItem(
              value: 'Add CAP Application',
              child: Text('Add CAP Application', style: TextStyle(color: Colors.white)),
            ),
          ],
          onChanged: (value) {
            if (value == 'Start Admission') {
              context.go('/student-admission');
            } else if (value == 'Add CAP Application') {
              context.go('/cap-application');
            }
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF160747), Color(0xFF2A1070)],
              ),
            ),
            child: const Text('Welcome Student', style: TextStyle(color: Colors.white, fontSize: 30)),
          ),
          _drawerItem(context, 'Dashboard', '/admission-dashboard'),
          _drawerItem(context, 'Applications', '/applications'),
          ExpansionTile(
            title: const Text('Admission Master'),
            children: [
              _drawerItem(context, 'Start Admission', '/student-admission'),
              _drawerItem(context, 'Add CAP Application', '/cap-application'),
            ],
          ),
          _drawerItem(context, 'Cancelled Applications', '/cancelled-apps'),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () => context.go('/'),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        context.go(route);
        Navigator.pop(context);
      },
    );
  }
}