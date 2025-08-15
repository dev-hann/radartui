import 'package:radartui/radartui.dart';

class ManualTest extends StatefulWidget {
  const ManualTest();

  @override
  State<StatefulWidget> createState() {
    return _ManualTestState();
  }
}

class _ManualTestState extends State<ManualTest> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Manual Test');
  }
}
