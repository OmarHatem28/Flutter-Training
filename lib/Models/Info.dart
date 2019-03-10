


class Info {
  int _count;
  int _pages;
  String _next;
  String _prev;

  Info({int count, int pages, String next, String prev}) {
    this._count = count;
    this._pages = pages;
    this._next = next;
    this._prev = prev;
  }

  int get count => _count;
  set count(int count) => _count = count;
  int get pages => _pages;
  set pages(int pages) => _pages = pages;
  String get next => _next;
  set next(String next) => _next = next;
  String get prev => _prev;
  set prev(String prev) => _prev = prev;

  Info.fromJson(Map<String, dynamic> json) {
    _count = json['count'];
    _pages = json['pages'];
    _next = json['next'];
    _prev = json['prev'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this._count;
    data['pages'] = this._pages;
    data['next'] = this._next;
    data['prev'] = this._prev;
    return data;
  }
}