class HelpRequestModel {
  late String location;
  late String requestername;
  late String requeterMobile;
  late String requesterCar;
  late String incidentDesc;
  late String locLang;
  late String locLat;

  HelpRequestModel(this.location, this.requestername, this.requeterMobile,
      this.requesterCar, this.incidentDesc, this.locLang, this.locLat);

  HelpRequestModel.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    requestername = json['Requestername'];
    requeterMobile = json['RequeterMobile'];
    requesterCar = json['RequesterCar'];
    incidentDesc = json['IncidentDesc'];
    locLang = json['LocLang'];
    locLat = json['LocLat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Location'] = this.location;
    data['Requestername'] = this.requestername;
    data['RequeterMobile'] = this.requeterMobile;
    data['RequesterCar'] = this.requesterCar;
    data['IncidentDesc'] = this.incidentDesc;
    data['LocLang'] = this.locLang;
    data['LocLat'] = this.locLat;
    return data;
  }
}
