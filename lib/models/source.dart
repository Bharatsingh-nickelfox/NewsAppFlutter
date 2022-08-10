class Source {
  final String? id;
  final String? name;

  Source(this.id, this.name);

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(map['id'], map['name']);
  }
}
