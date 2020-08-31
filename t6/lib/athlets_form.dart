class AthletsForm {
  String name;
  String unit;
  String id;

  AthletsForm(this.name, this.unit, this.id);

  factory AthletsForm.fromJson(dynamic json) {
    return AthletsForm("${json['name']}", "${json['unit']}", "${json['id']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'name': name,
        'unit': unit,
        'id': id,
      };
}

class Today {
  String id;
  Today (this.id);

  Map toJson() => {
    'id': id,
  };

}