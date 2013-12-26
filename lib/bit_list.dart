// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_list;

import 'dart:collection';
import 'dart:typed_data';
import 'src/utils.dart';

/**
 * An space efficient fixed length [List] that stores boolean values.
 */
class BitList extends ListBase<bool> with FixedLengthListMixin<bool>  {

  static final _SET_MASK = new Uint32List.fromList([1, 2, 4, 8,
      16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384,
      32768, 65536, 131072, 262144, 524288, 1048576, 2097152,
      4194304, 8388608, 16777216, 33554432, 67108864, 134217728,
      268435456, 536870912, 1073741824, 2147483648]);
  static final _CLR_MASK = new Uint32List.fromList([-2, -3, -5,
      -9, -17, -33, -65, -129, -257, -513, -1025, -2049, -4097,
      -8193, -16385, -32769, -65537, -131073, -262145, -524289,
      -1048577, -2097153, -4194305, -8388609, -16777217,
      -33554433, -67108865, -134217729, -268435457, -536870913,
      -1073741825, -2147483649]);

  /**
   * Constructs a bit list of the given [length].
   */
  factory BitList(int length) {
    return new BitList._(new Uint32List((length + 31) >> 5), length);
  }

  /**
   * Constucts a new list from a given [BitList] or list of booleans.
   */
  factory BitList.fromList(List<bool> list) {
    var buffer = new Uint32List((list.length + 31) >> 5);
    if (list is BitList) {
      buffer.setAll(0, list._buffer);
    } else {
      for (var index = 0; index < list.length; index++) {
        if (list[index]) {
          buffer[index >> 5] |= _SET_MASK[index & 31];
        }
      }
    }
    return new BitList._(buffer, list.length);
  }

  final Uint32List _buffer;
  final int _length;

  BitList._(this._buffer, this._length);

  /**
   * Returns the number of bits in this object.
   */
  @override
  int get length => _length;

  /**
   * Returns the value of the bit with the given [index].
   */
  @override
  bool operator [] (int index) {
    if (0 <= index && index < length) {
      return (_buffer[index >> 5] & _SET_MASK[index & 31]) != 0;
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /**
   * Sets the [value] of the bit with the given [index].
   */
  @override
  void operator []= (int index, bool value) {
    if (0 <= index && index < length) {
      if (value) {
        _buffer[index >> 5] |= _SET_MASK[index & 31];
      } else {
        _buffer[index >> 5] &= _CLR_MASK[index & 31];
      }
    } else {
      throw new RangeError.range(index, 0, length);
    }
  }

  /**
   * Counts the number of bits that are set to [expected].
   */
  int count([bool expected = true]) {
    int tally = 0;
    for (var index = 0; index < _length; index++) {
      var actual = (_buffer[index >> 5] & _SET_MASK[index & 31]) != 0;
      if (actual == expected) {
        tally++;
      }
    }
    return tally;
  }

  /**
   * Returns a new [BitList] with all the bits of the receiver inverted.
   */
  BitList operator ~ () {
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = ~_buffer[i];
    }
    return result;
  }

  /**
   * Returns a new [BitList] with all the bits set that are set in the
   * receiver and in [other]. The receiver and [other] need to have
   * the same length, otherwise an exception is thrown.
   */
  BitList operator & (BitList other) {
    assert(_length == other._length);
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = _buffer[i] & other._buffer[i];
    }
    return result;
  }

  /**
   * Returns a new [BitList] with all the bits set that are either set in
   * the receiver or in [other]. The receiver and [other] need to have
   * the same length, otherwise an exception is thrown.
   */
  BitList operator | (BitList other) {
    assert(_length == other._length);
    var result = new BitList(_length);
    for (var i = 0; i < _buffer.length; i++) {
      result._buffer[i] = _buffer[i] | other._buffer[i];
    }
    return result;
  }

}