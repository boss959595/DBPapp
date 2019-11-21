class EquipmentModel {
  String idEq, key, name, type, group, unit, imageId, limit, total;

  EquipmentModel(this.idEq, this.key, this.name, this.type, this.group,
      this.unit, this.imageId, this.limit, this.total);

  EquipmentModel.formJSON(Map<String, dynamic> map) {
    idEq = map['id_eq'];
    key = map['key'];
    name = map['name'];
    type = map['type'];
    group = map['group'];
    unit = map['unit'];
    imageId = map['image_id'];
    limit = map['limit'];
    total = map['total'];
  }
}

class EquipmentElectricModel {
  String idEqEe,keyEqEe, sizeEqEe, setupEqEe, placeEqEe, totalEqEe,limitEqEe;

  EquipmentElectricModel(this.idEqEe,this.keyEqEe, this.sizeEqEe, this.setupEqEe,
      this.placeEqEe, this.totalEqEe,this.limitEqEe);

  EquipmentElectricModel.formJSON(Map<String, dynamic> map) {
    idEqEe = map['id_eq_ee'];
    keyEqEe = map['key_eq_ee'];
    sizeEqEe = map['size_eq_ee'];
    setupEqEe = map['setup_eq_ee'];
    placeEqEe = map['place_eq_ee'];
    totalEqEe = map['total_eq_ee'];
    limitEqEe = map['limit_eq_ee'];
  }
}
