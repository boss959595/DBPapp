class ReportModel {
  String idEe, dateEe, keyRe, userRe,nameRe, groupRe, typeRe, unitRe, totalRe, processRe;

  ReportModel(this.idEe, this.dateEe, this.keyRe, this.userRe,this.nameRe, this.groupRe,
      this.typeRe, this.unitRe, this.totalRe, this.processRe);

  ReportModel.formJSON(Map<String, dynamic> map) {
    idEe = map['id_re'];
    dateEe = map['date_re'];
    keyRe = map['key_re'];
    userRe = map['user_re'];
    nameRe = map['name_re'];
    groupRe = map['group_re'];
    typeRe = map['type_re'];
    unitRe = map['unit_re'];
    totalRe = map['total_re'];
    processRe = map['process_re'];
  }
}
