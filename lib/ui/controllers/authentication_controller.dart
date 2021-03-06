import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/random_user.dart';
import '../../domain/use_case/authentication.dart';

// the controller does not have business logic, it sends the request to the corresponding use case
class AuthenticationController extends GetxController {
  final _logged = false.obs;
  final _storeUser = false.obs;
  final _storeUserEmail = "".obs;
  final _storeUserPassword = "".obs;

  final Authentication _authentication = Get.find<Authentication>();

  AuthenticationController() {
    initializeLoggedState();
  }

  // it updated logged according to the data on sharedPrefs
  void initializeLoggedState() async {
    logged = await _authentication.init;
  }

  String get storeUserPassword => _storeUserPassword.value;
  String get storeUserEmail => _storeUserEmail.value;
  bool get storeUser => _storeUser.value;

  // it returns _logged, if it is true it calls getStoredUser
  bool get logged {
    return _logged.value;
  }

  // besides updating _storeUser, if false it clears stored data
  set storeUser(bool mode) {
    _storeUser.value = mode;
  }

  // updates _logged
  set logged(bool mode) {
    _logged.value = mode;
  }

  set storeUserEmail(String x) {
    _storeUserEmail.value = x;
  }

  set storeUserPassword(String x) {
    _storeUserPassword.value = x;
  }

  // this method should clean the user data on sharedPrefs and controller
  Future<void> clearStoredUser() async {
    await _authentication.clearStoredUser();
  }

  // this method gets the stored user on sharedPrefs and updates the data on
  // the controller
  Future<void> getStoredUser() async {
    User user = await _authentication.getStoredUser();
    storeUserEmail = user.email;
    storeUserPassword = user.password;
    logInfo(
        'AuthenticationController getStoredUser and got <${user.email}> <${user.password}>');
  }

  // this method clears all stored data
  clearAll() async {
    await _authentication.clearAll();
  }

  // used to send login data, if user data is ok and if storeUser is true
  // it also stores the user on controller
  Future<bool> login(user, password) async {
    var auth = await _authentication.login(storeUser, user, password);
    if (auth) {
      if (storeUser) {
        await _authentication.addUser(user, password);
      }
      logged = true;
    } else {
      logged = false;
    }
    return Future.value(logged);
  }

  // used to send signup data
  Future<bool> signup(user, password) async {
    return Future.value(_authentication.signup(user, password));
  }

  // used to logout the current user
  void logout() async {
    if (!storeUser) {
      await _authentication.clearStoredUser();
    }
    logged = false;
  }
}
