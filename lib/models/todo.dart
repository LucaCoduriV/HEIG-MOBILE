class Todo {
  late String _title;
  late String _description;
  late bool _completed;
  late DateTime? _date;

  Todo(String title, String description, bool completed, DateTime date) {
    _title = title;
    _description = description;
    _completed = completed;
    _date = date;
  }

  @override
  String toString() {
    return "$_title $_description $_completed $_date";
  }
}
