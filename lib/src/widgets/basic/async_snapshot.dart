/// The state of connection to an asynchronous computation.
enum ConnectionState {
  /// Not currently connected to any asynchronous computation.
  none,

  /// Connected to an asynchronous computation and awaiting interaction.
  waiting,

  /// Connected to an active asynchronous computation.
  active,

  /// Connected to a terminated asynchronous computation.
  done,
}

/// Immutable representation of the most recent interaction with an asynchronous computation.
class AsyncSnapshot<T> {
  /// Creates an [AsyncSnapshot] with the specified [connectionState],
  /// and optionally either [data] or [error] with an optional [stackTrace].
  const AsyncSnapshot._(
    this.connectionState,
    this.data,
    this.error,
    this.stackTrace,
  );

  /// Creates an [AsyncSnapshot] in [ConnectionState.none] with null data and error.
  const AsyncSnapshot.nothing()
      : this._(ConnectionState.none, null, null, null);

  /// Creates an [AsyncSnapshot] in [ConnectionState.waiting] with null data and error.
  const AsyncSnapshot.waiting()
      : this._(ConnectionState.waiting, null, null, null);

  /// Creates an [AsyncSnapshot] in the specified [state] and with the specified [data].
  const AsyncSnapshot.withData(ConnectionState state, T data)
      : this._(state, data, null, null);

  /// Creates an [AsyncSnapshot] in the specified [state] with the specified [error]
  /// and optional [stackTrace].
  const AsyncSnapshot.withError(
    ConnectionState state,
    Object error, [
    StackTrace? stackTrace,
  ]) : this._(state, null, error, stackTrace);

  /// Current state of connection to the asynchronous computation.
  final ConnectionState connectionState;

  /// The latest data received by the asynchronous computation.
  final T? data;

  /// The latest error object received by the asynchronous computation.
  final Object? error;

  /// The latest stack trace object received by the asynchronous computation.
  final StackTrace? stackTrace;

  /// Returns whether this snapshot contains a non-null [data] value.
  bool get hasData => data != null;

  /// Returns whether this snapshot contains a non-null [error] value.
  bool get hasError => error != null;

  /// Returns a snapshot like this one, but in the specified [state].
  AsyncSnapshot<T> inState(ConnectionState state) =>
      AsyncSnapshot<T>._(state, data, error, stackTrace);

  @override
  String toString() {
    return 'AsyncSnapshot<$T>($connectionState, $data, $error, $stackTrace)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AsyncSnapshot<T> &&
        other.connectionState == connectionState &&
        other.data == data &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => Object.hash(connectionState, data, error, stackTrace);
}
