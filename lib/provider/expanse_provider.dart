import 'package:flutter/foundation.dart';
import 'package:mass/models/expanse.dart';

import '../repository/expanse_repository.dart';

class ExpanseProvider extends ChangeNotifier{
  final ExpanseRepository _expanseRepository;
   bool _isLoading = false;
   List<Expanse> _expanseList = [];

  ExpanseProvider({required ExpanseRepository expanseRepository}):_expanseRepository = expanseRepository;

  bool get isLoading =>_isLoading;
  List<Expanse> get expanseList =>_expanseList;


 Future<void> fetchExpanseData() async{
     _isLoading = true;
     notifyListeners();
     try{
       _expanseList = await _expanseRepository.getExpanses();
       _isLoading = false;
       notifyListeners();
     }catch(error){
       throw 'error';
     }

  }

  addExpanse( Expanse expanse) async{
   await _expanseRepository.addExpanse(expanse);
   fetchExpanseData();
  }

  updateExpanse( Expanse expanse)async{
   await _expanseRepository.updateExpanse(expanse);
   fetchExpanseData();
  }

  deleteExpanse(int id)async{
   await _expanseRepository.deleteExpanse(id);
   fetchExpanseData();
  }



}