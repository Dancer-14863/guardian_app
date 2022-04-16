enum Commands {
  handshake,
  disconnect,
  getDistance,
  getPressureStatus,
  buzzerOn,
  buzzerOff,
  alarmLightOn,
  alarmLightOff,
  waterGunOn,
  waterGunOff,
  waterGunPos1,
  waterGunPos2,
  waterGunPos3,
  waterGunPos4,
}

extension CommandsExtension on Commands {
  static const Map<Commands, String> commandValueMap = {
    Commands.handshake: 'a',
    Commands.disconnect: 'b',
    Commands.getDistance: 'c',
    Commands.getPressureStatus: 'd',
    Commands.buzzerOn: 'e',
    Commands.buzzerOff: 'f',
    Commands.alarmLightOn: 'g',
    Commands.alarmLightOff: 'h',
    Commands.waterGunOn: 'i',
    Commands.waterGunOff: 'j',
    Commands.waterGunPos1: 'k',
    Commands.waterGunPos2: 'l',
    Commands.waterGunPos3: 'm',
    Commands.waterGunPos4: 'n',
  };

  String? get value {
    return commandValueMap[this];
  }
}
