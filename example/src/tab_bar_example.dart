import 'dart:async';
import 'package:radartui/radartui.dart';

class TabBarExample extends StatefulWidget {
  const TabBarExample();

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

class _TabBarExampleState extends State<TabBarExample> {
  late TabController _tabController;
  StreamSubscription? _keySubscription;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3);
    _keySubscription = ServicesBinding.instance.keyboard.keyEvents.listen((
      key,
    ) {
      _handleKeyEvent(key);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _keySubscription?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent keyEvent) {
    if (keyEvent.code == KeyCode.escape) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          const Container(
            width: 50,
            height: 3,
            color: Color.blue,
            child: Center(
              child: Text(
                '📑 TabBar Example',
                style: TextStyle(color: Color.white, bold: true),
              ),
            ),
          ),
          const SizedBox(height: 2),
          DefaultTabController(
            controller: _tabController,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Tab 1'),
                    Tab(text: 'Tab 2'),
                    Tab(text: 'Tab 3'),
                  ],
                  indicatorColor: Color.green,
                  labelColor: Color.white,
                  unselectedLabelColor: Color.brightBlack,
                ),
                const SizedBox(height: 1),
                TabBarView(
                  controller: _tabController,
                  children: [
                    const Container(
                      width: 40,
                      height: 5,
                      color: Color.red,
                      child: Center(
                        child: Text(
                          'Content of Tab 1',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    const Container(
                      width: 40,
                      height: 5,
                      color: Color.green,
                      child: Center(
                        child: Text(
                          'Content of Tab 2',
                          style: TextStyle(color: Color.white),
                        ),
                      ),
                    ),
                    const Container(
                      width: 40,
                      height: 5,
                      color: Color.cyan,
                      child: Center(
                        child: Text(
                          'Content of Tab 3',
                          style: TextStyle(color: Color.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Press ESC to return to main menu',
            style: TextStyle(color: Color.yellow, italic: true),
          ),
        ],
      ),
    );
  }
}
