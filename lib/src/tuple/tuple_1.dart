library more.tuple.tuple_1;

import '../../tuple.dart';

/// Tuple with 1 element.
class Tuple1<T0> extends Tuple {
  final T0 value0;

  /// Const constructor.
  const Tuple1(this.value0);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple1<T> fromList<T>(List<T> list) {
    if (list.length != 1) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 1, but got ${list.length}.');
    }
    return Tuple1(list[0]);
  }

  @override
  int get length => 1;

  /// Returns a new tuple with index 0 replaced by [value].
  Tuple1<T> with0<T>(T value) => Tuple1(value);

  @override
  Tuple2<T, T0> addFirst<T>(T value) => addAt0(value);

  @override
  Tuple2<T0, T> addLast<T>(T value) => addAt1(value);

  /// Returns a new tuple with [value] added at index 0.
  Tuple2<T, T0> addAt0<T>(T value) => Tuple2(value, value0);

  /// Returns a new tuple with [value] added at index 1.
  Tuple2<T0, T> addAt1<T>(T value) => Tuple2(value0, value);

  @override
  Tuple0 removeFirst() => removeAt0();

  @override
  Tuple0 removeLast() => removeAt0();

  /// Returns a new tuple with index 0 removed.
  Tuple0 removeAt0() => const Tuple0();

  @override
  Iterable get iterable sync* {
    yield value0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Tuple1 && value0 == other.value0);

  @override
  int get hashCode => 523363758 ^ value0.hashCode;
}
