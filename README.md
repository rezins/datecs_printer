# datecs_printer

[![Pub Version](https://img.shields.io/pub/v/datecs_printer)](https://pub.dev/packages/datecs_printer)

* First thing first, this plugin I made only for Android purpose so not available for IOS platform, Web and Desktop.
* Second, I also create printer utils that can make easier to use. 
* Thrid, PRs are welcome.

### Reported Working Printer Models

These models were reported as working as expected:

<sub>(if you notice another model please let us know by opening a issue and reporting)</sub>

- DATECS DPP 250
- DATECS DPP 350
- DATECS DPP 450
- EPSON TM P80
- Bixolon SPP-R210
- MPT-3 (JP Printer)
- MPT-III (LEOPARDO A7)
- MPT-II (58mm)
- DAPPER DP-HT201 58mm
- RG-MTP80B
- Black Copper MINI Thermal Printer BC-P58B
- MHT-P5801 (58mm)

## Use simple receipt
```dart
Future<List<String>> getTicketDatecs({bool withImage}) async{
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
```

## Print a receipt
```dart
List<String> ticket = await getTicketDatecs(withImage: true);
var result = await DatecsPrinter.printText(ticket);
```
For a complete example, check the demo project inside examplem forder

# Test Print
<img src="https://github.com/rezins/datecs_printer/blob/main/example/assets/datecs_receipt.jpg?raw=true" alt="test receipt" height="800" width="800"/>
