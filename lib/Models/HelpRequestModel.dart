class HelpRequestModel {
  late String location;
  late String requestername;
  late String requeterMobile;
  late String locLang;
  late String locLat;
  late int requestArea;

  HelpRequestModel(this.location, this.requestername, this.requeterMobile,
      this.locLang, this.locLat, this.requestArea);

  HelpRequestModel.fromJson(Map<String, dynamic> json) {
    location = json['Location'];
    requestername = json['Requestername'];
    requeterMobile = json['RequeterMobile'];
    locLang = json['LocLang'];
    locLat = json['LocLat'];
    requestArea = json['request_area'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Location'] = this.location;
    data['Requestername'] = this.requestername;
    data['RequeterMobile'] = this.requeterMobile;
    data['LocLang'] = this.locLang;
    data['LocLat'] = this.locLat;
    data['request_area'] = this.requestArea;
    return data;
  }
}
