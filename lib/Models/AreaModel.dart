class AreaModel {
  int? id;
  String? areaNameAr;
  String? areaNameEn;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;

  AreaModel(
      {this.id,
      this.areaNameAr,
      this.areaNameEn,
      this.publishedAt,
      this.createdAt,
      this.updatedAt});

  AreaModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    areaNameAr = json['AreaNameAr'];
    areaNameEn = json['AreaNameEn'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['AreaNameAr'] = this.areaNameAr;
    data['AreaNameEn'] = this.areaNameEn;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
