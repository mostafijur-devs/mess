
const String tableName = 'members';
const String columnId = 'id';
const String columnName = 'name';
const String columnEmail = 'email';
const String columnPassword = 'password';
const String columnPhone = 'phone';
const String columnPersonalAmount = 'personal_amount';

class Member{
  int? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  int? personalAmount;
  Member({this.id, this.name, this.email, this.password, this.phone, this.personalAmount});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json[columnId],
      name: json[columnName],
      email: json[columnEmail],
      password: json[columnPassword],
      phone: json[columnPhone],
      personalAmount: json[columnPersonalAmount],
    );

  }
  Map<String, dynamic> toJson() {
    return {
      columnId: id,
      columnName: name,
      columnEmail: email,
      columnPassword: password,
      columnPhone: phone,
      columnPersonalAmount: personalAmount,
    };
  }

}