
const String expanseTableName = 'expanses';
const String expanseColumnId = 'id';
const String expanseColumnMemberId = 'member_id';
const String expanseColumnAmount = 'amount';
const String expanseColumnCategory = 'category';
const String expanseColumnDescription = 'description';
const String expanseColumnDateTime = 'dateTime';

class Expanse {

  int? id;
  int? memberId;
  int? amount;
  String? category;
  String? description;
  DateTime? dateTime;

  Expanse({this.id, this.memberId, this.amount, this.category, this.description, this.dateTime});

  factory Expanse.fromJson(Map<String, dynamic> json) {
    return Expanse(
      id: json[expanseColumnId],
      memberId: json[expanseColumnMemberId],
      amount: json[expanseColumnAmount],
      category: json[expanseColumnCategory],
      description: json[expanseColumnDescription],
      dateTime: DateTime.parse(json[expanseColumnDateTime])

    );

  }
  Map<String, dynamic> toJson() {
    return {
      expanseColumnId: id,
      expanseColumnMemberId: memberId,
      expanseColumnAmount: amount,
      expanseColumnCategory: category,
      expanseColumnDescription: description,
      expanseColumnDateTime: dateTime?.toIso8601String()
    };
  }

}

