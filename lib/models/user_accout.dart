class UserAccoutModel {
  // Field
  String idAcc, user, pass, level;

  // Construster
  UserAccoutModel(this.idAcc, this.user, this.pass, this.level);

  UserAccoutModel.fromJSON(Map<String, dynamic> map) {
    idAcc = map['id_acc'];
    user = map['user'];
    pass = map['pass'];
    level = map['level'];
  }
}
