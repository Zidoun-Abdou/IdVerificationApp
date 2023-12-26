class DemandeValidationModel {
  String? id;
  String? requestSource;
  String? createdAt;
  String? typeRequest;
  String? status;
  String? idWhowiyati;

  DemandeValidationModel(
      {this.id,
      this.requestSource,
      this.createdAt,
      this.typeRequest,
      this.status,
      this.idWhowiyati});

  DemandeValidationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestSource = json['request_source'];
    createdAt = json['created_at'];
    typeRequest = json['type_request'];
    status = json['status'];
    idWhowiyati = json['id_whowiyati'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_source'] = this.requestSource;
    data['created_at'] = this.createdAt;
    data['type_request'] = this.typeRequest;
    data['status'] = this.status;
    data['id_whowiyati'] = this.idWhowiyati;
    return data;
  }
}
