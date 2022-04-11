class CustomerModel {
  String id = "";
  String name = "";
  String phone = "";
  String? cnic;
  String? ntn;
  String? emi;
  String? area;
  String? address;
  int type = 0;

  CustomerModel(
      {required this.id,
        required this.name,
        required this.phone,
        this.cnic,
        this.ntn,
        this.emi,
        this.area,
        this.address,
        required this.type});

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    cnic = json['cnic'];
    ntn = json['ntn'];
    emi = json['emi'];
    area = json['area'];
    address = json['address'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['cnic'] = this.cnic;
    data['ntn'] = this.ntn;
    data['emi'] = this.emi;
    data['area'] = this.area;
    data['address'] = this.address;
    data['type'] = this.type;
    return data;
  }
}

