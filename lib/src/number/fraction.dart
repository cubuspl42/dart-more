library more.number.fraction;

/// A rational number.
class Fraction implements Comparable<Fraction> {
  /// The neutral additive element, that is `0`.
  static const Fraction zero = Fraction._(0, 1);

  /// The neutral multiplicative element, that is `1`.
  static const Fraction one = Fraction._(1, 1);

  /// Creates a fraction from a [numerator] and an optional [denominator].
  factory Fraction(int numerator, [int denominator = 1]) {
    if (numerator == null || denominator == null) {
      throw ArgumentError('Null numerator or denominator passed to fraction.');
    }
    if (denominator == 0) {
      throw ArgumentError('Denominator needs to be non-zero.');
    }
    var d = numerator.gcd(denominator).abs();
    if (denominator < 0) {
      d *= -1;
    }
    if (d != 1) {
      return Fraction._(numerator ~/ d, denominator ~/ d);
    }
    return Fraction._(numerator, denominator);
  }

  /// Creates an approximate fraction from a floating point [value].
  factory Fraction.fromDouble(num value, [num maxDenominator = 1e10]) {
    if (value.isInfinite || value.isNaN) {
      throw ArgumentError('$value cannot be represented as fraction');
    }
    final sign = value < 0.0 ? -1 : 1;
    value *= sign;
    var numerator1 = value.floor(), numerator2 = 1;
    var denominator1 = 1, denominator2 = 0;
    var integerPart = numerator1;
    var fractionPart = value - numerator1;
    while (fractionPart != 0) {
      final newValue = 1.0 / fractionPart;
      integerPart = newValue.floor();
      fractionPart = newValue - integerPart;
      var temporary = numerator2;
      numerator2 = numerator1;
      numerator1 = numerator1 * integerPart + temporary;
      temporary = denominator2;
      denominator2 = denominator1;
      denominator1 = integerPart * denominator1 + temporary;
      if (maxDenominator < denominator1) {
        if (numerator2 == 0.0) {
          return Fraction(sign * numerator1, denominator1);
        } else {
          return Fraction(sign * numerator2, denominator2);
        }
      }
    }
    return Fraction(sign * numerator1, denominator1);
  }

  /// Internal constructor for fractions.
  const Fraction._(this.a, this.b);

  /// Returns the numerator of the fraction.
  final int a;

  /// Alternative way to access the numerator of the fraction.
  num get numerator => a;

  /// Returns the denominator of the fraction.
  final int b;

  /// Alternative way to access the denominator of the fraction.
  num get denominator => b;

  /// Returns the negation of this fraction.
  Fraction operator -() => Fraction._(-a, b);

  /// Returns the sum of this fraction and [other].
  Fraction operator +(Fraction other) =>
      Fraction(a * other.b + other.a * b, b * other.b);

  /// Returns the difference of this fraction and [other].
  Fraction operator -(Fraction other) =>
      Fraction(a * other.b - other.a * b, b * other.b);

  /// Returns the multiplication of this fraction and [other].
  Fraction operator *(Fraction other) => Fraction(a * other.a, b * other.b);

  /// Returns the division of this fraction and [other].
  Fraction operator /(Fraction other) => Fraction(a * other.b, b * other.a);

  /// Tests if this fraction is not defined.
  bool get isNaN => false;

  /// Tests if this fraction is negative.
  bool get isNegative => a.isNegative;

  /// Tests if this fraction is infinite.
  bool get isInfinite => false;

  /// Returns he absolute value of this fraction.
  Fraction abs() => isNegative ? -this : this;

  /// Rounds this fraction to an integer.
  int round() => toDouble().round();

  /// Floors this fraction to an integer.
  int floor() => toDouble().floor();

  /// Ceils this fraction to an integer.
  int ceil() => toDouble().ceil();

  /// Truncates this fraction to an integer.
  int truncate() => toDouble().truncate();

  /// Converts this fraction to an integer.
  int toInt() => a ~/ b;

  /// Converts this fraction to a double.
  double toDouble() => a / b;

  /// Tests if this fraction is close to another fraction.
  bool closeTo(Fraction other, double epsilon) =>
      (toDouble() - other.toDouble()).abs() < epsilon;

  @override
  bool operator ==(Object other) =>
      other is Fraction && a == other.a && b == other.b;

  @override
  int get hashCode => (0x0007ffff & a.hashCode) << 10 ^ b.hashCode;

  @override
  int compareTo(Fraction other) => (a * other.b).compareTo(other.a * b);

  bool operator <(Fraction other) => compareTo(other) < 0;

  bool operator <=(Fraction other) => compareTo(other) <= 0;

  bool operator >=(Fraction other) => compareTo(other) >= 0;

  bool operator >(Fraction other) => compareTo(other) > 0;

  @override
  String toString() => b == 1 ? '$a' : '$a/$b';
}
