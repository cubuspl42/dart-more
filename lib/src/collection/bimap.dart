library more.collection.bimap;

import 'dart:collection';

/// A bi-map associates keys with values and values with keys.
///
/// Bi-maps behave like maps from key to values, but can efficiently provide an
/// inverse bi-map that maps values to keys. Also certain operations, such as
/// [containsValue] are much more efficient than with traditional maps.
class BiMap<K, V> extends MapMixin<K, V> {
  /// Creates an empty bi-map.
  factory BiMap() => BiMap<K, V>._({}, {});

  /// Creates an empty identity bi-map.
  factory BiMap.identity() => BiMap<K, V>._(Map.identity(), Map.identity());

  /// Creates bi-map from another map.
  factory BiMap.from(Map<K, V> other) {
    if (other is BiMap<K, V>) {
      return BiMap<K, V>._(
          Map<K, V>.from(other._forward), Map<V, K>.from(other._backward));
    } else {
      return BiMap<K, V>()..addAll(other);
    }
  }

  /// Creates a bi-map from an iterable (and possible transformation functions).
  factory BiMap.fromIterable(Iterable iterable,
      {K key(element), V value(element)}) {
    return BiMap<K, V>.fromIterables(
        key == null ? iterable.cast<K>() : iterable.map(key),
        value == null ? iterable.cast<V>() : iterable.map(value));
  }

  /// Creates a bi-map from two equal length iterables.
  factory BiMap.fromIterables(Iterable<K> keys, Iterable<V> values) {
    var result = BiMap<K, V>();
    var keyIterator = keys.iterator, valueIterator = values.iterator;
    var moreKeys = keyIterator.moveNext(),
        moreValues = valueIterator.moveNext();
    while (moreKeys && moreValues) {
      result[keyIterator.current] = valueIterator.current;
      moreKeys = keyIterator.moveNext();
      moreValues = valueIterator.moveNext();
    }
    if (moreKeys || moreValues) {
      throw ArgumentError('Keys and values iterables have different length.');
    }
    return result;
  }

  final Map<K, V> _forward;
  final Map<V, K> _backward;

  BiMap._(this._forward, this._backward);

  /// Returns the inverse bi-map onto the same data.
  BiMap<V, K> get inverse => BiMap._(_backward, _forward);

  /// Returns a forward map onto the same data. This accessor effectively
  /// returns this object, but cast-down to a [Map].
  Map<K, V> get forward => this;

  /// Returns a backward map onto the same data. This accessor effectively
  /// returns the same as [BiMap.inverse], but case-down to a [Map].
  Map<V, K> get backward => inverse;

  @override
  V operator [](Object key) => _forward[key];

  @override
  void operator []=(K key, V value) {
    _remove(key, _forward, _backward);
    _remove(value, _backward, _forward);
    _forward[key] = value;
    _backward[value] = key;
  }

  @override
  V putIfAbsent(K key, V ifAbsent()) {
    if (containsKey(key)) {
      return this[key];
    } else {
      var value = ifAbsent();
      this[key] = value;
      return value;
    }
  }

  @override
  V remove(Object key) {
    var value = _forward[key];
    _remove(key, _forward, _backward);
    return value;
  }

  void _remove(Object key, Map forward, Map backward) {
    if (forward.containsKey(key)) {
      _remove(forward.remove(key), backward, forward);
    }
  }

  @override
  void clear() {
    _forward.clear();
    _backward.clear();
  }

  @override
  bool containsKey(Object key) => _forward.containsKey(key);

  @override
  bool containsValue(Object value) => _backward.containsKey(value);

  @override
  void forEach(void f(K key, V value)) => _forward.forEach(f);

  @override
  bool get isEmpty => _forward.isEmpty;

  @override
  bool get isNotEmpty => _forward.isNotEmpty;

  @override
  int get length => _forward.length;

  @override
  Iterable<K> get keys => _forward.keys;

  @override
  Iterable<V> get values => _backward.keys;
}
