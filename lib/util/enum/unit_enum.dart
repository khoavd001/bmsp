enum UnitEnum {
  voltage,
  current,
  frequency,
  speed,
  flowWater,
  volume,
  pressure,
  power;

  String get imageString {
    switch (this) {
      case voltage:
        return 'assets/images/voltage.png';
      case current:
        return 'assets/images/current.png';
      case frequency:
        return 'assets/images/frequency.png';
      case speed:
        return 'assets/images/speed.png';
      case flowWater:
        return 'assets/images/flow_water.png';
      case volume:
        return 'assets/images/volume_water.png';
      case pressure:
        return 'assets/images/pressure.png';
      case power:
        return 'assets/images/level_water.png';
      default:
        return '';
    }
  }

  String get nameString {
    switch (this) {
      case voltage:
        return 'Voltage';
      case current:
        return 'Current';
      case frequency:
        return 'Frequency';
      case speed:
        return 'Speed';
      case flowWater:
        return 'Flow Water';
      case volume:
        return 'Volume';
      case pressure:
        return 'Pressure';
      case power:
        return 'Power';
      default:
        return '';
    }
  }

  String get fetchString {
    switch (this) {
      case voltage:
        return 'Voltage';
      case current:
        return 'Curent';
      case frequency:
        return 'Frequency';
      case speed:
        return 'RPM';
      case flowWater:
        return 'Flow Water';
      case volume:
        return 'Volume';
      case pressure:
        return 'PID-Feedback';
      case power:
        return 'Power';
      default:
        return 'Curent';
    }
  }

  int get divideNumber {
    switch (this) {
      case voltage:
        return 100;
      case current:
        return 1;
      case frequency:
        return 10;
      case speed:
        return 1000;
      case flowWater:
        return 1;
      case volume:
        return 1;
      case pressure:
        return 1;
      case power:
        return 10;
      default:
        return 1;
    }
  }

  String get unitString {
    switch (this) {
      case voltage:
        return 'V';
      case current:
        return 'A';
      case frequency:
        return 'HZ';
      case speed:
        return 'RPM';
      case flowWater:
        return 'l/m';
      case volume:
        return 'l';
      case pressure:
        return 'bar';
      case power:
        return 'kW';
      default:
        return '';
    }
  }
}
