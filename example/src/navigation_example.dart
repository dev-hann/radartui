import 'dart:async';
import 'package:radartui/radartui.dart';
import 'package:radartui/src/scheduler/binding.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample();

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

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
  const HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription? _keySubscription;
  int selectedIndex = 0;
  final List<String> menuItems = ['Profile', 'Settings', 'About', 'Exit'];

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'ArrowUp' && selectedIndex > 0) {
        setState(() => selectedIndex--);
      } else if (key.key == 'ArrowDown' && selectedIndex < menuItems.length - 1) {
        setState(() => selectedIndex++);
      } else if (key.key == 'Enter') {
        _handleMenuSelection();
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
    super.dispose();
  }

  void _handleMenuSelection() {
    switch (selectedIndex) {
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
        // Exit - handled by parent
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
            height: 15,
            color: Color.brightBlack,
            padding: const EdgeInsets.all(1),
            child: Column(
              children: [
                const Text(
                  'Main Menu',
                  style: TextStyle(color: Color.cyan, bold: true),
                ),
                
                const SizedBox(height: 1),
                
                ...menuItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == selectedIndex;
                  
                  return Container(
                    width: 58,
                    color: isSelected ? Color.yellow : Color.transparent,
                    child: Row(
                      children: [
                        Text(
                          isSelected ? '> ' : '  ',
                          style: TextStyle(
                            color: isSelected ? Color.black : Color.white,
                            bold: true,
                          ),
                        ),
                        Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? Color.black : Color.white,
                            bold: isSelected,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
  const ProfilePage();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
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
  const SettingsPage();

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StreamSubscription? _keySubscription;
  bool darkMode = true;
  bool notifications = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        Navigator.pop(context);
      } else if (key.key == 'ArrowUp' && selectedIndex > 0) {
        setState(() => selectedIndex--);
      } else if (key.key == 'ArrowDown' && selectedIndex < 1) {
        setState(() => selectedIndex++);
      } else if (key.key == 'Enter' || key.key == ' ') {
        setState(() {
          if (selectedIndex == 0) {
            darkMode = !darkMode;
          } else {
            notifications = !notifications;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
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
  const AboutPage();

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _keySubscription = SchedulerBinding.instance.keyboard.keyEvents.listen((key) {
      if (key.key == 'Escape') {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _keySubscription?.cancel();
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