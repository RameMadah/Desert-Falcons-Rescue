class HelpRequestFetchModel {
  int? id;
  String? location;
  String? requestername;
  int? requeterMobile;
  String? requesterCar;
  String? incidentDesc;
  String? locLang;
  String? locLat;
  String? publishedAt;
  String? createdAt;
  String? updatedAt;
  bool? requestStatus;
  String? usersPermissionsUser;
  List<String?>? incidentAttachment;

  HelpRequestFetchModel(
      {this.id,
      this.location,
      this.requestername,
      this.requeterMobile,
      this.requesterCar,
      this.incidentDesc,
      this.locLang,
      this.locLat,
      this.publishedAt,
      this.createdAt,
      this.updatedAt,
      this.requestStatus,
      this.usersPermissionsUser,
      this.incidentAttachment});

  HelpRequestFetchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['Location'];
    requestername = json['Requestername'];
    requeterMobile = json['RequeterMobile'];
    requesterCar = json['RequesterCar'];
    incidentDesc = json['IncidentDesc'];
    locLang = json['LocLang'];
    locLat = json['LocLat'];
    publishedAt = json['published_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    requestStatus = json['RequestStatus'];
    incidentAttachment = json['IncidentAttachment'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Location'] = this.location;
    data['Requestername'] = this.requestername;
    data['RequeterMobile'] = this.requeterMobile;
    data['RequesterCar'] = this.requesterCar;
    data['IncidentDesc'] = this.incidentDesc;
    data['LocLang'] = this.locLang;
    data['LocLat'] = this.locLat;
    data['published_at'] = this.publishedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['RequestStatus'] = this.requestStatus;
    data['IncidentAttachment'] = this.incidentAttachment;
    return data;
  }
}
