import '../framework.dart';
import 'async_snapshot.dart';

/// Signature for strategies that build widgets based on asynchronous interaction.
typedef AsyncWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot);
