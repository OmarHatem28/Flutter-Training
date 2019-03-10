import 'Info.dart';
import 'Character.dart';


class APIResponse {
  Info _info;
  List<Character> _character;

  APIResponse({Info info, List<Character> results}) {
    this._info = info;
    this._character = results;
  }

  Info get info => _info;
  set info(Info info) => _info = info;
  List<Character> get characters => _character;
  set characters(List<Character> results) => _character = results;

  APIResponse.fromJson(Map<String, dynamic> json) {
    _info = json['info'] != null ? new Info.fromJson(json['info']) : null;
    if (json['results'] != null) {
      _character = new List<Character>();
      json['results'].forEach((v) {
        _character.add(new Character.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._info != null) {
      data['info'] = this._info.toJson();
    }
    if (this._character != null) {
      data['results'] = this._character.map((v) => v.toJson()).toList();
    }
    return data;
  }
}