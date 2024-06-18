class DeviceInfo {
  DeviceInfo({
    this.id,
    this.name,
    this.type,
    this.version,
  });

  String? id;
  String? name;
  String? type;
  String? version;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'version': version,
    };
  }
}
