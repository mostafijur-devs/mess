
const String memberTableName = 'members';
const String columnId = 'id';
const String columnName = 'name';
const String columnEmail = 'email';
const String columnPassword = 'password';
const String columnPhone = 'phone';
const String columnPersonalAmount = 'personal_amount';
const String memberColumnImage = 'member_image';

class Member{
  int? id;
  String? name;
  String? email;
  String? password;
  String? phone;
  int? personalAmount;
  String? memberImageUrl;
  Member({this.id, this.name, this.email, this.password, this.phone, this.personalAmount,this.memberImageUrl});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json[columnId],
      name: json[columnName],
      email: json[columnEmail],
      password: json[columnPassword],
      phone: json[columnPhone],
      personalAmount: json[columnPersonalAmount],
      memberImageUrl: json[memberColumnImage],

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
      memberColumnImage: memberImageUrl
    };
  }

}