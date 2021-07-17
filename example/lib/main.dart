import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:datecs_printer/datecs_printer.dart';
import 'package:datecs_printer/src/datecs_column.dart';
import 'package:datecs_printer/src/datecs_generate.dart';
import 'package:datecs_printer/src/datecs_style.dart';
import 'package:datecs_printer/src/enums.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await DatecsPrinter.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<List<String>> testPrint() async {

    DatecsGenerate generate = new DatecsGenerate(DatecsPaper.mm80);
    generate.textPrint("Hello");
    generate.textPrint("byebye", style: DatecsStyle(
        size: DatecsSize.high,
        bold: true,
        align: DatecsAlign.center
    ));
    generate.row([
      DatecsColumn(
          text: "LEFT",
          width: 6,
          styles: DatecsStyle(
              bold: true,
              size: DatecsSize.high,
              align: DatecsAlign.left
          )
      ),
      DatecsColumn(
          text: "RIGHT",
          width: 6,
          styles: DatecsStyle(
              bold: true,
              align: DatecsAlign.right
          )
      ),
    ]);

    ByteData bytes = await rootBundle.load('assets/empty-box.png');
    var buffer = bytes.buffer;
    var m = base64Encode(Uint8List.view(buffer));

    //generate.image(m);
    generate.feed(1);

    return generate.args;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
          body: Column(
            children: [
              Center(
                child: Text('Running on: $_platformVersion\n'),
              ),
              RawMaterialButton(onPressed: () async {
                List<dynamic> val = await DatecsPrinter.getListBluetoothDevice;
                print(val);
              }, child: Text('Get List', style: TextStyle(color: Colors.white),), fillColor: Colors.blue,),
              RawMaterialButton(onPressed: () async {
                await DatecsPrinter.connectBluetooth("00:01:90:C4:AC:23");
              }, child: Text('  Connect Bluetooth  ', style: TextStyle(color: Colors.white),), fillColor: Colors.blue,),
              RawMaterialButton(onPressed: () async {
                await DatecsPrinter.printTest;
              }, child: Text('Test Print', style: TextStyle(color: Colors.white),), fillColor: Colors.blue,),
              RawMaterialButton(onPressed: () async {
                ByteData imageBytes = await rootBundle.load('assets/empty-box.png');
                Image img = Image.memory(imageBytes.buffer.asUint8List());
                await DatecsPrinter.printImage(img);
              }, child: Text('Print Image', style: TextStyle(color: Colors.white),), fillColor: Colors.blue,),
              RawMaterialButton(onPressed: () async {
                List<String> args = await testPrint();
                var result = await DatecsPrinter.printText(args);
                if(!result){
                  await DatecsPrinter.connectBluetooth("00:01:90:C4:AC:23");
                  var result = await DatecsPrinter.printText(args);
                }
              }, child: Text('Print Txt', style: TextStyle(color: Colors.white),), fillColor: Colors.blue,),
              Text('This is test print text', style: TextStyle(fontSize: 16),),
              SizedBox(height: 30,),
              RawMaterialButton(onPressed: () async {
                await DatecsPrinter.disconnect;
              }, child: Text('  Disconnect Bluetooth  ', style: TextStyle(color: Colors.white),), fillColor: Colors.blue,),
            ],
          )
      ),
    );
  }
}
