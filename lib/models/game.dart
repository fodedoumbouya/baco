class Game {
  List<String>? categories;
  String? explication;
  String? id;
  List<String>? motCles;
  String? question;
  List<int>? reponse;
  List<String>? reponsesProposEs;
  String? score;
  String? time;
  String? type;

  Game(
      {this.categories,
      this.explication,
      this.id,
      this.motCles,
      this.question,
      this.reponse,
      this.reponsesProposEs,
      this.score,
      this.time,
      this.type});

  Game.fromJson(Map<String, dynamic> json) {
    categories = json['categories'].cast<String>();
    explication = json['explication'];
    id = json['id'];
    motCles = json['mot-cles'].cast<String>();
    question = json['question'];
    reponse = json['reponse'].cast<int>();
    reponsesProposEs = json['reponses_proposées'].cast<String>();
    score = json['score'];
    time = json['time'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    data['explication'] = explication;
    data['id'] = id;
    data['mot-cles'] = motCles;
    data['question'] = question;
    data['reponse'] = reponse;
    data['reponses_proposées'] = reponsesProposEs;
    data['score'] = score;
    data['time'] = time;
    data['type'] = type;
    return data;
  }
}
