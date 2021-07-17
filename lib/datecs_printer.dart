
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class DatecsPrinter {
  static const MethodChannel _channel = MethodChannel('datecs_printer');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<List<dynamic>> get getListBluetoothDevice async {
    final List<dynamic> list = await _channel.invokeMethod('getListBluetoothDevice');
    return list;
  }
  static Future<bool> connectBluetooth(String address) async {
    final bool result = await _channel.invokeMethod('connectBluetooth',{"address":address});
    print(result);
    return result;
  }

  static Future<void> get printTest async {
    final bool result = await _channel.invokeMethod('testPrint');
    return Future.value();
  }

  static Future<bool> printText(List<String> args) async {
    args.forEach((element) {
      print(element);
    });
    final bool result = await _channel.invokeMethod('printText',{"args":args});
    print(result);
    return result;
  }

  static Future<bool> printImage(Image img) async {
    final bool result = await _channel.invokeMethod('printImage',{"img":img});
    print(result);
    return result;
  }

  static Future<bool> get disconnect async{
    final bool result = await _channel.invokeMethod('disconnectBluetooth');
    return result;
  }
}