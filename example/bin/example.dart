import 'package:radartui/model/key.dart';
import 'package:radartui/radartui.dart';
import 'package:radartui/state/state.dart';
import 'package:radartui/widget/button.dart';
import 'package:radartui/widget/row.dart';
import 'package:radartui/widget/text_field.dart';
import 'package:radartui/view/view.dart';

void main(List<String> arguments) {
  Radartui.runApp(
    MyApp(),
    onKey: (key) {
      switch (key.label) {
        case "q":
          Radartui.exitApp();
          break;
      }
    },
  );
}

class MyState extends State {
  MyState({
    required this.text,
    required this.textFieldController,
    required this.scrollController,
    required this.buttonController,
  });
  final String text;
  final TextEditingController textFieldController;
  final ScrollController scrollController;
  final ButtonController buttonController;

  MyState copyWith({
    String? text,
    TextEditingController? controller,
    ScrollController? scrollController,
    ButtonController? buttonController,
  }) {
    return MyState(
      text: text ?? this.text,
      textFieldController: controller ?? this.textFieldController,
      scrollController: scrollController ?? this.scrollController,
      buttonController: buttonController ?? this.buttonController,
    );
  }
}

class MyApp extends View<MyState> {
  @override
  void initState() {
    super.initState();
    update(
      MyState(
        text: "Hello",
        buttonController: ButtonController(
          onTap: () {
            final text = state?.textFieldController.text;
            update(state?.copyWith(text: text));
          },
        ),
        textFieldController: TextEditingController(),
        scrollController: ScrollController(
          onSelect: (index, item) {
            update(state?.copyWith(text: item));
          },
          items: [
            "item1",
            "item2",
            "item3",
            "item4",
            "item5",
            "item6",
            "item7",
            "item8",
            "item9",
            "item10",
            "item11",
            "item12",
            "item13",
            "item14",
            "item15",
            "item16",
            "item17",
          ],
        ),
      ),
    );
  }

  @override
  void onKey(Key key) {
    super.onKey(key);
    switch (state?.currentFocusID) {
      case "textField":
        state?.textFieldController.onKey(key);
        break;
      case "button":
        state?.buttonController.onKey(key);
        break;
      case "list_view":
        state?.scrollController.onKey(key);
        break;
    }
    if (key.label == "\t") {
      state?.nextFocus();
    }
  }

  @override
  Widget build() {
    if (state == null) {
      return Text("Loading...");
    }
    return Column(
      children: [
        Text(state!.text),
        ListView(
          focusID: 'list_view',
          scrollController: state!.scrollController,
        ),
        Row(
          children: [
            TextField(
              controller: state!.textFieldController,
              focusID: "textField",
            ),
            Button(
              controller: state!.buttonController,
              label: "Send",
              focusID: "button",
            ),
          ],
        ),
      ],
    );
  }
}
