class MenuJour {
  final String _day;
  final List<String> _tradition;
  final List<String> _vegetarien;

  const MenuJour(this._day, this._tradition, this._vegetarien);

  String get day => _day;
  List<String> get tradition => _tradition;
  List<String> get vegetarien => _vegetarien;

  factory MenuJour.fromJson(Map<String, dynamic> json) {
    return MenuJour(
      json.entries.first as String,
      json['tradition'],
      json['vegetarien'],
    );
  }
}
