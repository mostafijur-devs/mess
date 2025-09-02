import 'package:flutter/foundation.dart';
import 'package:mass/repository/member_repository.dart';

import '../models/member.dart';

class MemberProvider extends ChangeNotifier {
  final MemberRepository _memberRepository;

  List<Member> _members = [];
  bool _isLoading = false;

  MemberProvider({required MemberRepository memberRepository})
    : _memberRepository = memberRepository;

  List<Member> get members => _members;

  bool get isLoading => _isLoading;

  fetchMember() async {
    _isLoading = true;
    notifyListeners();
    try {
      _members = await _memberRepository.getMember();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Member data error throw $e');
      }
      print('Member data error throw $e');
    }
  }

  addMembers(Member member) async {
    await _memberRepository.addMember(member);
    fetchMember();
  }

  updateMember(Member member) async {
    await _memberRepository.updateMember(member);
    fetchMember();
  }

  deleteMember(int id) async {
    await _memberRepository.deleteMember(id);
    fetchMember();
  }
}
