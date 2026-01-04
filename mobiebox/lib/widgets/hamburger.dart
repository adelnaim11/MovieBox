import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  final bool isLoggedIn;
  final String? username;
  final String? role;

  final VoidCallback? onLoginLogout;
  final VoidCallback? onSettings;
  final VoidCallback? onHome;
  final VoidCallback? onTop;
  final VoidCallback? onAction;
  final VoidCallback? onComedy;
  final VoidCallback? onDrama;

  // 🔥 ADMIN SPECIFIC CALLBACKS
  final VoidCallback? onAddMovie;
  final VoidCallback? onManageMovies;
  final VoidCallback? onManageUsers;

  const HamburgerMenu({
    super.key,
    this.isLoggedIn = false,
    this.username,
    this.role,
    this.onLoginLogout,
    this.onSettings,
    this.onHome,
    this.onTop,
    this.onAction,
    this.onComedy,
    this.onDrama,
    this.onAddMovie,
    this.onManageMovies,
    this.onManageUsers,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: Column(
        children: [
          // HEADER
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isLoggedIn ? (username ?? "User") : "Guest",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LOGIN / LOGOUT
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // LOGIN / LOGOUT
                  ListTile(
                    leading: Icon(
                      isLoggedIn ? Icons.logout : Icons.login,
                      color: Colors.white,
                    ),
                    title: Text(
                      isLoggedIn ? "Logout" : "Login",
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (onLoginLogout != null) onLoginLogout!();
                    },
                  ),
                  const Divider(color: Colors.white24),

                  // BROWSE SECTION
                  _drawerItem(context, Icons.home, "Home", onHome),
                  _drawerItem(
                    context,
                    Icons.local_fire_department,
                    "Top Movies",
                    onTop,
                  ),

                  // ADMIN SECTION
                  if (role == 'admin') ...[
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 20, bottom: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "ADMIN DASHBOARD",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    _drawerItem(
                      context,
                      Icons.post_add,
                      "Add New Movie",
                      onAddMovie,
                    ),
                    _drawerItem(
                      context,
                      Icons.edit_note,
                      "Manage Movies",
                      onManageMovies,
                    ),
                    _drawerItem(
                      context,
                      Icons.people_outline,
                      "Manage Users",
                      onManageUsers,
                    ),
                    const Divider(color: Colors.white24),
                  ],

                  // GENRES SECTION
                  _drawerItem(context, Icons.flash_on, "Action", onAction),
                  _drawerItem(
                    context,
                    Icons.emoji_emotions,
                    "Comedy",
                    onComedy,
                  ),
                  _drawerItem(context, Icons.theater_comedy, "Drama", onDrama),
                ],
              ),
            ),
          ),

          // BOTTOM SECTION (Stays fixed at the bottom)
          const Divider(color: Colors.white24),
          _drawerItem(context, Icons.settings, "Settings", onSettings),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  static Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) onTap();
      },
    );
  }
}
