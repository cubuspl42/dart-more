library more.tuple.tuple_0;

import '../../tuple.dart';

/// Tuple with 0 elements.
class Tuple0 extends Tuple {
  /// Const constructor.
  const Tuple0();

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple0 fromList<T>(List<T> list) {
    if (list.isNotEmpty) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 0, but got ${list.length}.');
    }
    return const Tuple0();
  }

  @override
  int get length => 0;

  @override
  Tuple1<T> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple1<T> addLast<T>(T value) => addAt0(value);

  /// Returns a new tuple with [value] added at index 0.
  Tuple1<T> addAt0<T>(T value) => Tuple1(value);

  @override
  Tuple removeFirst() => throw StateError('Too few');

  @override
  Tuple removeLast() => throw StateError('Too few');

  @override
  Iterable get iterable sync* {}

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Tuple0);

  @override
  int get hashCode => 2895809587;
}
