class WorkModel {
  final String? location;
  final String? device_id;
  final int? timestamp;
  final Map<String, double>? values;

  WorkModel({
    this.location,
    this.device_id,
    this.timestamp,
    this.values,
  });

  factory WorkModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      print('Warning: recevied null json');
      return WorkModel();
    }

    print("Parsing Json: $json");

    Map<String, double>? convertedValues;
    if (json['values'] != null) {
      convertedValues = {};
      try {
        (json['values'] as Map<String, dynamic>).forEach((key, value) {
          if (value != null) {
            if (value is int) {
              convertedValues![key] = value.toDouble();
            } else if (value is double) {
              convertedValues![key] = value;
            } else if (value is String) {
              try {
                convertedValues![key] = double.parse(value) ?? 0.0;
              } catch (e) {
                print("Could not parse value for $key : $value");
              }
            }
          }
        });
      } catch (e) {
        print('Error converting values: $e');
        convertedValues = null;
      }
    }

    return WorkModel(
      location: json['location']?.toString(),
      device_id: json['device_id']?.toString(),
      timestamp: json['timestamp'] is int ? json['timestamp'] : null,
      values: convertedValues,
    );
  }

  @override
  String toString() {
    return 'WorkModel(location: $location, device_id: $device_id, timestamp: $timestamp, values: $values)';
  }
}
