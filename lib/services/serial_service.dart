import 'dart:typed_data';

import 'package:guardian_app/utils/constants/commands.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:collection/collection.dart';

class SerialService {
  UsbPort? activePort;

  static const int _baudRate = 9600;

  Future<void> connectToArduino() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) throw 'No devices detected';

    UsbDevice? arduinoDevice = devices.firstWhereOrNull(
      (element) => element.manufacturerName!.contains('Arduino'),
    );

    if (arduinoDevice == null) throw 'Guardian device not detected';

    UsbPort? port = await arduinoDevice.create();
    bool openResult = await port!.open();
    if (!openResult) {
      throw 'Port to device could not be opened. Please try re-connecting the device';
    }

    await port.setDTR(true);
    await port.setRTS(true);

    port.setPortParameters(
      _baudRate,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    activePort = port;
  }

  Future<void> disconnectArduino() async {
    await activePort!.close();
    activePort = null;
  }

  void sendCommand(Commands command) {
    if (activePort != null) {
      activePort!.write(_getCommandMessage(command));
    } else {
      throw 'Port not open';
    }
  }

  Future<String?> makeTransaction(Commands command) async {
    if (activePort != null) {
      Transaction<String> transaction = Transaction.stringTerminated(
        activePort!.inputStream!,
        Uint8List.fromList(
          [13, 10],
        ),
      );

      return await transaction.transaction(
        activePort!,
        _getCommandMessage(command),
        const Duration(
          seconds: 1,
        ),
      );
    } else {
      throw 'Port not open';
    }
  }

  Uint8List _getCommandMessage(Commands command) {
    return Uint8List.fromList(
      [
        command.value!.codeUnitAt(0),
      ],
    );
  }
}
