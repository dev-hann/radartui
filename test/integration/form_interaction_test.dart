import 'package:radartui/radartui_test.dart';
import 'package:test/test.dart';

void main() {
  group('Form rendering', () {
    testWidgets('Form renders TextField', (tester) async {
      final controller = TextEditingController();

      tester.pumpWidget(
        Form(
          child: TextField(controller: controller),
        ),
      );

      await tester.pumpAndSettle();

      tester.assertContains('│');
      tester.assertContains('─');
    });

    testWidgets('Form renders error text on validation failure', (tester) async {
      final formKey = GlobalKey();

      tester.pumpWidget(
        Form(
          key: formKey,
          child: FormField<String>(
            initialValue: '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Error!';
              }
              return null;
            },
            builder: (state) {
              return Column(
                children: [
                  const TextField(),
                  if (state.errorText != null)
                    Text(state.errorText!, style: const TextStyle(color: Color.red)),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formState = formKey.currentElement as StatefulElement;
      (formState.state as FormState).validate();
      await tester.pumpAndSettle();

      tester.assertContains('Error!');
    });
  });

  group('Form interaction', () {
    testWidgets('Form validate returns true for valid fields', (tester) async {
      final formKey = GlobalKey();
      final controller = TextEditingController();

      tester.pumpWidget(
        Form(
          key: formKey,
          child: Column(
            children: [
              FormField<String>(
                initialValue: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                builder: (state) {
                  return TextField(
                    controller: controller,
                    onChanged: (text) => state.setValue(text),
                  );
                },
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      tester.typeText('test');
      await tester.pumpAndSettle();

      final formState = formKey.currentElement as StatefulElement;
      final isValid = (formState.state as FormState).validate();
      expect(isValid, isTrue);
    });

    testWidgets('Form validate returns false for invalid fields', (tester) async {
      final formKey = GlobalKey();
      final controller = TextEditingController();

      tester.pumpWidget(
        Form(
          key: formKey,
          child: FormField<String>(
            initialValue: '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            builder: (state) {
              return TextField(
                controller: controller,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formState = formKey.currentElement as StatefulElement;
      final isValid = (formState.state as FormState).validate();
      expect(isValid, isFalse);
    });

    testWidgets('Form submit calls onSubmitted when valid', (tester) async {
      final formKey = GlobalKey();
      var submitted = false;
      final controller = TextEditingController();

      tester.pumpWidget(
        Form(
          key: formKey,
          onSubmitted: () => submitted = true,
          child: FormField<String>(
            initialValue: '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            builder: (state) {
              return TextField(
                controller: controller,
                onChanged: (text) => state.setValue(text),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      tester.typeText('test');
      await tester.pumpAndSettle();

      final formState = formKey.currentElement as StatefulElement;
      (formState.state as FormState).submit();
      await tester.pumpAndSettle();

      expect(submitted, isTrue);
    });

    testWidgets('Form submit does not call onSubmitted when invalid', (tester) async {
      final formKey = GlobalKey();
      var submitted = false;
      final controller = TextEditingController();

      tester.pumpWidget(
        Form(
          key: formKey,
          onSubmitted: () => submitted = true,
          child: FormField<String>(
            initialValue: '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
            builder: (state) {
              return TextField(
                controller: controller,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formState = formKey.currentElement as StatefulElement;
      (formState.state as FormState).submit();
      await tester.pumpAndSettle();

      expect(submitted, isFalse);
    });

    testWidgets('FormField<bool> works with Checkbox', (tester) async {
      var fieldValue = false;

      tester.pumpWidget(
        FormField<bool>(
          initialValue: false,
          builder: (state) {
            return Checkbox(
              value: state.value,
              onChanged: (v) {
                state.setValue(v ?? false);
                fieldValue = v ?? false;
              },
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      tester.sendSpace();
      await tester.pumpAndSettle();

      expect(fieldValue, isTrue);
    });

    testWidgets('FormField shows error text on validation', (tester) async {
      final formKey = GlobalKey();

      tester.pumpWidget(
        Form(
          key: formKey,
          child: FormField<String>(
            initialValue: '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
            builder: (state) {
              return Column(
                children: [
                  const TextField(),
                  if (state.errorText != null)
                    Text(state.errorText!, style: const TextStyle(color: Color.red)),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formState = formKey.currentElement as StatefulElement;
      (formState.state as FormState).validate();
      await tester.pumpAndSettle();

      expect(find.text('This field is required').exists, isTrue);
    });

    testWidgets('Form can be found by type', (tester) async {
      tester.pumpWidget(
        const Form(
          child: Text('Form'),
        ),
      );

      expect(find.byType<Form>().exists, isTrue);
    });
  });
}
