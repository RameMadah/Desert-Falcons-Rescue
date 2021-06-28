class RescuerRegisterationModel {
  String? username;
  String? email;
  String? password;
  bool? confirmed;
  bool? blocked;
  String? role;
  String? resecername;
  String? carModel;
  String? mobile;
  String? city;
  String? rescurePhoto;

  RescuerRegisterationModel(
      {this.username,
      this.email,
      this.password,
      this.confirmed,
      this.blocked,
      this.role,
      this.resecername,
      this.carModel,
      this.mobile,
      this.city,
      this.rescurePhoto});

  RescuerRegisterationModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
    confirmed = json['confirmed'];
    blocked = json['blocked'];
    role = json['role'];
    resecername = json['Resecername'];
    carModel = json['CarModel'];
    mobile = json['Mobile'];
    city = json['City'];
    rescurePhoto = json['RescurePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmed'] = this.confirmed;
    data['blocked'] = this.blocked;
    data['role'] = this.role;
    data['Resecername'] = this.resecername;
    data['CarModel'] = this.carModel;
    data['Mobile'] = this.mobile;
    data['City'] = this.city;
    return data;
  }
}
