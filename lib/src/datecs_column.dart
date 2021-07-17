import 'datecs_style.dart';

class DatecsColumn{

  String text;
  int width;
  DatecsStyle styles;

  DatecsColumn(
  {
    this.text = '',
    this.width = 2,
    this.styles = const DatecsStyle.defaults()
  }){
    if (width < 1 || width > 12) {
      throw Exception('Column width must be between 1..12');
    }
  }
}