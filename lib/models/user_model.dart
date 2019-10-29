class UserModel {
  String employeeId, name, department, section, division, email, phone;

  UserModel(this.name, this.department, this.division, this.email,
      this.employeeId, this.phone, this.section);

  UserModel.fromJson(Map<String, dynamic> map) {
    employeeId = map['employee_id'];
    name = map['name'];
    department = map['department'];
    section = map['section'];
    division = map['division'];
    email = map['email'];
    phone = map['phone'];
  }
}
