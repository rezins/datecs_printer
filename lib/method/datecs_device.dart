class DatecsDevice {
  final String name;
  final String address;

  DatecsDevice(this.name, this.address);

  DatecsDevice.fromMap(Map map)
      : name = map['name'],
        address = map['address'];

  Map<String, dynamic> toMap() => {
    'name': this.name,
    'address': this.address,
  };

  operator ==(Object other) {
    return other is DatecsDevice && other.address == this.address;
  }

  @override
  int get hashCode => address.hashCode;

}