import 'package:get/get.dart';

class Speed {
  final double speed;
  final TimeUnit timeUnit;
  final DistanceUnit distanceUnit;

  const Speed(this.speed, this.distanceUnit, this.timeUnit);

  static Speed kmH(double speed) => Speed(speed, DistanceUnit.km, TimeUnit.h);
  static Speed kmM(double speed) => Speed(speed, DistanceUnit.km, TimeUnit.m);
  static Speed kmS(double speed) => Speed(speed, DistanceUnit.km, TimeUnit.s);
  static Speed mH(double speed) => Speed(speed, DistanceUnit.m, TimeUnit.h);
  static Speed mM(double speed) => Speed(speed, DistanceUnit.m, TimeUnit.m);
  static Speed mS(double speed) => Speed(speed, DistanceUnit.m, TimeUnit.s);

  static Speed? fromDuration({
    required Duration duration,
    required double distance,
    DistanceUnit distanceUnit = DistanceUnit.km,
  }) {
    if (duration.inHours > 0) {
      return Speed(distance / duration.inHours, distanceUnit, TimeUnit.h);
    } else if (duration.inMinutes > 0) {
      return Speed(distance / duration.inMinutes, distanceUnit, TimeUnit.m);
    } else if (duration.inSeconds > 0) {
      return Speed(distance / duration.inSeconds, distanceUnit, TimeUnit.s);
    }
    return null;
  }

  static Speed fromString(String str) {
    Exception exception() => Exception('Invalid speed');

    List<String> split = str.split(' ');
    if (split.length != 2) throw exception();

    double? speed = double.tryParse(split[0]);
    if (speed == null) throw exception();

    split = split[1].split('/');
    if (split.length != 2) throw exception();

    DistanceUnit? distanceUnit = DistanceUnit.fromString(split[0]);
    TimeUnit? timeUnit = TimeUnit.fromString(split[1]);
    if (distanceUnit == null || timeUnit == null) throw exception();

    return Speed(speed, distanceUnit, timeUnit);
  }

  @override
  String toString() =>
      '${speed.toStringAsPrecision(2)} $distanceUnit/$timeUnit';
}

enum TimeUnit {
  h,
  m,
  s;

  static Map<String, TimeUnit> all = {'H': h, 'M': m, 'S': s};

  static TimeUnit? fromString(String unit) => all[unit];

  @override
  String toString() => '$this'.camelCase!;
}

enum DistanceUnit {
  km,
  m;

  static Map<String, DistanceUnit> all = {'Km': km, 'M': m};

  static DistanceUnit? fromString(String unit) => all[unit];

  @override
  String toString() => '$this'.camelCase!;
}
