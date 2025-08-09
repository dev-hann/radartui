import 'dart:async';
import 'package:radartui/radartui.dart';

class NavigationExample extends StatelessWidget {
  const NavigationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _focusNode = FocusNode();
  final List<String> menuItems = ['Profile', 'Settings', 'About', 'Exit'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.focusController.scope.addNode(_focusNode);
      _focusNode.requestFocus();
      _focusNode.onKeyEvent = _handleKeyEvent;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event.key == 'Escape') {
      // This is the root of the Navigator, so pop does nothing.
      // In a real app, this might exit the app or pop the navigator itself.
    }
  }

  void _handleMenuSelection(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/profile');
        break;
      case 1:
        Navigator.pushNamed(context, '/settings');
        break;
      case 2:
        Navigator.pushNamed(context, '/about');
        break;
      case 3:
        // In a real app, this would likely trigger an exit confirmation.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 60,
            color: Color.blue,
            child: const Center(
              child: Text(
                '🧭 RadarTUI Navigation Demo 🧭',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Main Menu',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 1),
                ListView(
                  focusNode: _focusNode,
                  items: menuItems,
                  onItemSelected: (index, item) => _handleMenuSelection(index),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.green,
            child: const Text(
              'Use ↑↓ arrows to navigate, Enter to select, ESC to go back',
              style: TextStyle(color: Color.black),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.focusController.scope.addNode(_focusNode);
      _focusNode.requestFocus();
      _focusNode.onKeyEvent = (event) {
        if (event.key == 'Escape') {
          Navigator.pop(context);
        }
      };
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 60,
            color: Color.magenta,
            child: const Center(
              child: Text(
                '👤 User Profile',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            height: 12,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: const Column(
              children: [
                Row(
                  children: [
                    Text('Name: ', style: TextStyle(color: Color.cyan, bold: true)),
                    Text('John Doe', style: TextStyle(color: Color.white)),
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Email: ', style: TextStyle(color: Color.cyan, bold: true)),
                    Text('john.doe@example.com', style: TextStyle(color: Color.white)),
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Role: ', style: TextStyle(color: Color.cyan, bold: true)),
                    Text('Administrator', style: TextStyle(color: Color.yellow)),
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Status: ', style: TextStyle(color: Color.cyan, bold: true)),
                    Text('Active', style: TextStyle(color: Color.green)),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                  style: TextStyle(color: Color.brightBlack),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.yellow,
            child: const Text(
              'Press ESC to go back to main menu',
              style: TextStyle(color: Color.black),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _focusNode = FocusNode();
  bool darkMode = true;
  bool notifications = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.focusController.scope.addNode(_focusNode);
      _focusNode.requestFocus();
      _focusNode.onKeyEvent = _handleKeyEvent;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    final items = ['Dark Mode', 'Notifications'];
    setState(() {
      switch (event.key) {
        case 'Escape':
          Navigator.pop(context);
          break;
        case 'ArrowUp':
          if (selectedIndex > 0) selectedIndex--;
          break;
        case 'ArrowDown':
          if (selectedIndex < items.length - 1) selectedIndex++;
          break;
        case 'Enter':
        case ' ':
          if (selectedIndex == 0) darkMode = !darkMode;
          if (selectedIndex == 1) notifications = !notifications;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 60,
            color: Color.red,
            child: const Center(
              child: Text(
                '⚙️  Settings',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            height: 10,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Application Settings',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                const SizedBox(height: 2),
                // Using a manual list here to show a different style
                Container(
                  width: 58,
                  color: selectedIndex == 0 ? Color.yellow : Color.transparent,
                  child: Row(
                    children: [
                      Text(
                        selectedIndex == 0 ? '> ' : '  ',
                        style: TextStyle(
                          color: selectedIndex == 0 ? Color.black : Color.white,
                          bold: true,
                        ),
                      ),
                      Text(
                        'Dark Mode: ',
                        style: TextStyle(
                          color: selectedIndex == 0 ? Color.black : Color.white,
                        ),
                      ),
                      Text(
                        darkMode ? '[ON]' : '[OFF]',
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? Color.black
                              : (darkMode ? Color.green : Color.red),
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                Container(
                  width: 58,
                  color: selectedIndex == 1 ? Color.yellow : Color.transparent,
                  child: Row(
                    children: [
                      Text(
                        selectedIndex == 1 ? '> ' : '  ',
                        style: TextStyle(
                          color: selectedIndex == 1 ? Color.black : Color.white,
                          bold: true,
                        ),
                      ),
                      Text(
                        'Notifications: ',
                        style: TextStyle(
                          color: selectedIndex == 1 ? Color.black : Color.white,
                        ),
                      ),
                      Text(
                        notifications ? '[ON]' : '[OFF]',
                        style: TextStyle(
                          color: selectedIndex == 1
                              ? Color.black
                              : (notifications ? Color.green : Color.red),
                          bold: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.yellow,
            child: const Text(
              'Use ↑↓ to navigate, Enter/Space to toggle, ESC to go back',
              style: TextStyle(color: Color.black),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.focusController.scope.addNode(_focusNode);
      _focusNode.requestFocus();
      _focusNode.onKeyEvent = (event) {
        if (event.key == 'Escape') {
          Navigator.pop(context);
        }
      };
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          Container(
            width: 60,
            color: Color.cyan,
            child: const Center(
              child: Text(
                'ℹ️  About RadarTUI',
                style: TextStyle(color: Color.black, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            height: 15,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: const Column(
              children: [
                Text(
                  'RadarTUI Framework',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Version: ', style: TextStyle(color: Color.yellow)),
                    Text('1.0.0', style: TextStyle(color: Color.white)),
                  ],
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text('Framework: ', style: TextStyle(color: Color.yellow)),
                    Text('Flutter-like TUI for Dart', style: TextStyle(color: Color.white)),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Features:',
                  style: TextStyle(color: Color.magenta, bold: true),
                ),
                Text('• Declarative Widget System', style: TextStyle(color: Color.white)),
                Text('• State Management', style: TextStyle(color: Color.white)),
                Text('• Efficient Terminal Rendering', style: TextStyle(color: Color.white)),
                Text('• Keyboard Input Handling', style: TextStyle(color: Color.white)),
                Text('• Navigation & Routing', style: TextStyle(color: Color.white)),
                SizedBox(height: 1),
                Text(
                  'Built with ❤️ for terminal applications',
                  style: TextStyle(color: Color.brightBlack),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 60,
            color: Color.yellow,
            child: const Text(
              'Press ESC to go back to main menu',
              style: TextStyle(color: Color.black),
            ),
          ),
        ],
      ),
    );
  }
}
