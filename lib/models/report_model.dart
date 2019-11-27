class ReportModel {
  String idEe,
      dateEe,
      keyRe,
      userRe,
      nameRe,
      groupRe,
      typeRe,
      unitRe,
      totalRe,
      processRe,
      statusRe,noRe,becauseRe;

  ReportModel(
      this.idEe,
      this.dateEe,
      this.keyRe,
      this.userRe,
      this.nameRe,
      this.groupRe,
      this.typeRe,
      this.unitRe,
      this.totalRe,
      this.processRe,
      this.statusRe,this.noRe,this.becauseRe);

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
    statusRe = map['status_re'];
    noRe = map['no_re'];
    becauseRe = map['because_re'];
  }
}

class ReportElectricModel {
  String idRpEe,
      dateRpEe,
      keyRpEe,
      userRpEe,
      sizeRpEe,
      setupRpEe,
      placeRpEe,
      totalRpEe,
      processRpEe,
      statusReEe;

  ReportElectricModel(
      this.idRpEe,
      this.dateRpEe,
      this.keyRpEe,
      this.userRpEe,
      this.sizeRpEe,
      this.setupRpEe,
      this.placeRpEe,
      this.totalRpEe,
      this.processRpEe,
      this.statusReEe);

  ReportElectricModel.formJSON(Map<String, dynamic> map) {
    idRpEe = map['id_rp_ee'];
    dateRpEe = map['date_rp_ee'];
    keyRpEe = map['key_rp_ee'];
    userRpEe = map['user_rp_ee'];
    sizeRpEe = map['size_rp_ee'];
    setupRpEe = map['setup_rp_ee'];
    placeRpEe = map['place_rp_ee'];
    totalRpEe = map['total_rp_ee'];
    processRpEe = map['process_rp_ee'];
    statusReEe = map['status_rp_ee'];
  }
}
