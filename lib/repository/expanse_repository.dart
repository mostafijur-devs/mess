import 'package:mass/models/expanse.dart';

abstract class ExpanseRepository {

  Future<List<Expanse>>getExpanses();
  Future<void>addExpanse(Expanse expanse);
  Future<void>deleteExpanse(int id);
  Future<void>updateExpanse(Expanse expanse);

}