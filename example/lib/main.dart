import 'dart:convert';
import 'dart:typed_data';

import 'package:datecs_printer/datecs_printer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  List availableBluetoothDevices =[];
  DatecsDevice _device;
  bool connected;

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

  Future<List<String>> getTicketDatecs({bool withImage = false}) async{
    final generate = DatecsGenerate(DatecsPaper.mm80);

    if(withImage){
      ByteData bytes = await rootBundle.load('assets/empty-box.png');
      var buffer = bytes.buffer;
      var m = base64Encode(Uint8List.view(buffer));

      generate.image(m);
    }
    generate.feed(2);
    generate.textPrint("Demo Shop", style: DatecsStyle(
      bold: false,
      italic: false,
      underline: false,
      align: DatecsAlign.center,
      size: DatecsSize.high,
    ),);
    generate.textPrint(
        "18th Main Road, 2nd Phase, J. P. Nagar, Bengaluru, Karnataka 560078",
        style: DatecsStyle(align: DatecsAlign.center,bold: false,
          italic: false,
          underline: false,));
    generate.textPrint('Tel: +919591708470',
        style: DatecsStyle(align: DatecsAlign.center,bold: false,
          italic: false,
          underline: false,));

    generate.hr(char: "=");

    generate.row([
      DatecsColumn(
          text: 'No',
          width: 1,
          styles: DatecsStyle(align: DatecsAlign.left, bold: true)
      ),
      DatecsColumn(
          text: 'Item',
          width: 5,
          styles: DatecsStyle(align: DatecsAlign.left, bold: true)
      ),
      DatecsColumn(
          text: 'Price',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.center, bold: true)
      ),
      DatecsColumn(
          text: 'Qty',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.center, bold: true)
      ),
      DatecsColumn(
          text: 'Total',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.right, bold: true)
      ),

    ]);
    generate.hr();
    generate.row([
      DatecsColumn(
          text: '1',
          width: 1,
          styles: DatecsStyle(align: DatecsAlign.left, bold: true)
      ),
      DatecsColumn(
          text: 'Tea',
          width: 5,
          styles: DatecsStyle(align: DatecsAlign.left, bold: true)
      ),
      DatecsColumn(
          text: '10',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.center, bold: true)
      ),
      DatecsColumn(
          text: '1',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.center, bold: true)
      ),
      DatecsColumn(
          text: '10',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.right, bold: true)
      ),

    ]);

    generate.row([
      DatecsColumn(
          text: '2',
          width: 1,
          styles: DatecsStyle(align: DatecsAlign.left, bold: true)
      ),
      DatecsColumn(
          text: 'Sada Dosa',
          width: 5,
          styles: DatecsStyle(align: DatecsAlign.left, bold: true)
      ),
      DatecsColumn(
          text: '30',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.center, bold: true)
      ),
      DatecsColumn(
          text: '1',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.center, bold: true)
      ),
      DatecsColumn(
          text: '30',
          width: 2,
          styles: DatecsStyle(align: DatecsAlign.right, bold: true)
      ),

    ]);
    generate.feed(5);

    return generate.args;
  }

  _getListBluetooth()async{
    List<dynamic> list = await DatecsPrinter.getListBluetoothDevice;
    List<DatecsDevice> listOfDevice = [];
    for (var element in list) {
      var bluetooth = element as Map<dynamic, dynamic>;
      var name, address;
      bluetooth.forEach((key, value) {
        key == "name" ? name = value : address = value;
      });
      listOfDevice.add(DatecsDevice(name, address));
    }
    setState(() {
      availableBluetoothDevices = listOfDevice;
    });
  }

  List<DropdownMenuItem<DatecsDevice>> _getDeviceItems() {
    List<DropdownMenuItem<DatecsDevice>> items = [];
    if (availableBluetoothDevices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in availableBluetoothDevices) {
        items.add(DropdownMenuItem(
          child: Text(device.name, overflow: TextOverflow.ellipsis),
          value: DatecsDevice(device.name, device.address),
        ));
      }
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Datecs app'),
        ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Device:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 30,),
                    Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        items: _getDeviceItems(),
                        onChanged: (value) async {
                          setState(() {
                            _device = value;
                          });
                        }, //_disconnect
                        value: _device,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        _getListBluetooth();
                      },
                    ),

                  ],
                ),
                const SizedBox(height: 20,),
                FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    try{
                      var result = await DatecsPrinter.connectBluetooth(_device.address);
                      if(result){
                        Fluttertoast.showToast(msg: "Device connected");
                      }
                    }catch(e){
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: const Text(
                    'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20,),
                RawMaterialButton(
                  fillColor: Colors.blue,
                  onPressed: () async{
                    List<String> ticket = await getTicketDatecs(withImage: false);
                    var result = await DatecsPrinter.printText(ticket);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Test Print ', style: TextStyle(
                      color: Colors.white
                    ),
                    ),
                  )
                ),

                const SizedBox(height: 20,),
                RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: () async{
                      List<String> ticket = await getTicketDatecs(withImage: true);
                      var result = await DatecsPrinter.printText(ticket);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Test Print with Image', style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    )
                ),
                const SizedBox(height: 20,),
                RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: () async{
                      await DatecsPrinter.printTest;
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Test Print with Default Machine', style: TextStyle(
                          color: Colors.white
                      ),
                      ),
                    )
                ),
              ],
            ),
          )
      ),
    );
  }
}
