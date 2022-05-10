import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/random_user.dart';
import '../repositories/user_repository.dart';

// this file handles the business logic, calling the corresponding repository
class Authentication {
  UserRepository repository = Get.find();

  Future<bool> get init async => await repository.init();

  Future<void> addUser(email, password) async =>
      await repository.storeUserInfo(User(email: email, password: password));

  // if login is ok then data is stored on shared prefs
  Future<bool> login(storeUser, email, password) async {
    List<User> users = [];
    users = await repository.getAllUsers();
    var usuario = users.firstWhereOrNull(
        (element) => element.email == email && element.password == password);
    if (usuario == null) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Future<bool> signup(user, password) async {
    List<User> users = [];
    users = await repository.getAllUsers();
    var usuario = users.where((element) => element.email == user).toList();
    if (usuario.isEmpty) {
      await repository.signup(User(email: user, password: password));
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  Future<void> logout() async {
    return await repository.logout();
  }

  Future<User> getStoredUser() async {
    return await repository.getStoredUser().onError((error, stackTrace) {
      return User(email: "", password: "");
    });
  }

  Future<void> clearStoredUser() async {
    await repository.clearStoredUser();
  }

  clearAll() async {
    await repository.clearAll();
  }

  Future<bool> isStoringUser() async {
    return await repository.isStoringUser();
  }
}
