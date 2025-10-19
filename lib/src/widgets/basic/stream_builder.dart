import 'dart:async';
import '../framework.dart';
import 'async_snapshot.dart';
import 'async_widget_builder.dart';

/// Widget that builds itself based on the latest snapshot of interaction with a [Stream].
class StreamBuilder<T> extends StatefulWidget {
  /// Creates a new [StreamBuilder] that builds itself based on the latest
  /// snapshot of interaction with the specified [stream] and whose build
  /// strategy is given by [builder].
  const StreamBuilder({
    this.initialData,
    this.stream,
    required this.builder,
  });

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<T>? stream;

  /// The data that will be used to create the initial snapshot.
  final T? initialData;

  /// The build strategy currently used by this builder.
  final AsyncWidgetBuilder<T> builder;

  @override
  State<StreamBuilder<T>> createState() => _StreamBuilderState<T>();
}

class _StreamBuilderState<T> extends State<StreamBuilder<T>> {
  StreamSubscription<T>? _subscription;
  late AsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.initialData == null
        ? const AsyncSnapshot<Never>.nothing() as AsyncSnapshot<T>
        : AsyncSnapshot<T>.withData(ConnectionState.none, widget.initialData as T);
    _subscribe();
  }

  @override
  void didUpdateWidget(StreamBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      if (_subscription != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.stream != null) {
      _subscription = widget.stream!.listen(
        (T data) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withData(ConnectionState.active, data);
          });
        },
        onError: (Object error, StackTrace stackTrace) {
          setState(() {
            _snapshot = AsyncSnapshot<T>.withError(
              ConnectionState.active,
              error,
              stackTrace,
            );
          });
        },
        onDone: () {
          setState(() {
            _snapshot = _snapshot.inState(ConnectionState.done);
          });
        },
      );
      _snapshot = _snapshot.inState(ConnectionState.waiting);
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _snapshot);
  }
}
