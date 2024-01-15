class DemandeValidationModel {
  int? id;
  String? requestIdentify;
  String? sourceDemande;
  String? createdAt;
  String? typeDemande;
  String? status;
  int? user;

  DemandeValidationModel(
      {this.id,
      this.requestIdentify,
      this.sourceDemande,
      this.createdAt,
      this.typeDemande,
      this.status,
      this.user});

  DemandeValidationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestIdentify = json['request_identify'];
    sourceDemande = json['source_demande'];
    createdAt = json['created_at'];
    typeDemande = json['type_demande'];
    status = json['Status'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['request_identify'] = this.requestIdentify;
    data['source_demande'] = this.sourceDemande;
    data['created_at'] = this.createdAt;
    data['type_demande'] = this.typeDemande;
    data['Status'] = this.status;
    data['user'] = this.user;
    return data;
  }
}
