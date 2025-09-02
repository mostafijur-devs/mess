import 'package:mass/models/member.dart';

abstract class MemberRepository{

  Future<List<Member>> getMember();
  Future<void> addMember(Member member);
  Future<void> deleteMember(int id);
  Future<void> updateMember(Member member);
}