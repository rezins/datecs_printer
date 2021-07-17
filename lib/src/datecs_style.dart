import 'enums.dart';

class DatecsStyle{
  final bool bold;
  final bool underline;
  final bool italic;
  final bool wide;
  final DatecsAlign align;
  final DatecsSize size;

  DatecsStyle({this.bold, this.underline, this.italic, this.wide = false,this.align, this.size});

  const DatecsStyle.defaults({
    this.bold: false,
    this.underline: false,
    this.italic: false,
    this.wide: false,
    this.align: DatecsAlign.left,
    this.size: DatecsSize.normal
  });

  DatecsStyle copyWith({
    bool bold,
    bool underline,
    bool italic,
    bool wide,
    bool br,
    bool reset,
    DatecsAlign align,
    DatecsSize size,
  }) {
    return DatecsStyle(
      bold: bold ?? this.bold,
      underline: bold ?? this.underline,
      italic: italic ?? this.italic,
      wide: wide ?? this.wide,
      align: align ?? this.align,
      size: size ?? this.size
    );
  }

}