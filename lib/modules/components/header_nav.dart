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
        toolbarHeight: 130,
        flexibleSpace: _buildHeader(context, isSmallScreen),
      ),
      body: bodyContent,
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallScreen) {
    return Container(
      margin: const EdgeInsets.all(8),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (isSmallScreen)
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                if (!isSmallScreen) ...[
                  Image.asset('assets/image.png', height: 36),
                  const SizedBox(width: 8),
                  const Text(
                    'Academate',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 32),
                  _navItem(context, 'Dashboard', '/admission-dashboard'),
                  _navItem(context, 'Applications', '/applications'),
                  _dropdownNav(context),
                  _navItem(context, 'Cancelled Applications', '/cancelled-apps'),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      debugPrint('Logout clicked');
                      context.go('/');
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text('Logout', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ]
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.deepPurpleAccent),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text('10 June 2025', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
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
            child: const Text('Welcome Student', style: TextStyle(color: Colors.white, fontSize: 20)),
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
