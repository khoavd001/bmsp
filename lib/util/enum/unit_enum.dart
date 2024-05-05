enum UnitEnum {
  voltage,
  current,
  frequency,
  speed,
  flowWater,
  volume,
  pressure,
  waterLevel;

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
      case waterLevel:
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
      case waterLevel:
        return 'Water Level';
      default:
        return '';
    }
  }
}
