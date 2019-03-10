


class Character {
  int _id;
  String _name;
  String _status;
  String _species;
  String _type;
  String _gender;
  String _image;
  List<String> _episode;
  String _url;
  String _created;

  Character(
      {int id,
        String name,
        String status,
        String species,
        String type,
        String gender,
        String image,
        List<String> episode,
        String url,
        String created}) {
    this._id = id;
    this._name = name;
    this._status = status;
    this._species = species;
    this._type = type;
    this._gender = gender;
    this._image = image;
    this._episode = episode;
    this._url = url;
    this._created = created;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get status => _status;
  set status(String status) => _status = status;
  String get species => _species;
  set species(String species) => _species = species;
  String get type => _type;
  set type(String type) => _type = type;
  String get gender => _gender;
  set gender(String gender) => _gender = gender;
  String get image => _image;
  set image(String image) => _image = image;
  List<String> get episode => _episode;
  set episode(List<String> episode) => _episode = episode;
  String get url => _url;
  set url(String url) => _url = url;
  String get created => _created;
  set created(String created) => _created = created;

  Character.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'];
    _species = json['species'];
    _type = json['type'];
    _gender = json['gender'];
    _image = json['image'];
    _episode = json['episode'].cast<String>();
    _url = json['url'];
    _created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['status'] = this._status;
    data['species'] = this._species;
    data['type'] = this._type;
    data['gender'] = this._gender;
    data['image'] = this._image;
    data['episode'] = this._episode;
    data['url'] = this._url;
    data['created'] = this._created;
    return data;
  }
}