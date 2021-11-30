import 'package:hive/hive.dart';
import 'package:keeper/keeper.dart';
import 'package:keeper_hive/keeper_hive.dart';

part 'authentication_service.g.dart';

KeepAsyncKey<bool> userLoggedIn() => HiveKeep('user').asyncKey('loggedIn');

class AuthenticationService = _AuthenticationService
    with _$AuthenticationServiceKeeper;

@kept
class _AuthenticationService {
  @AtAsync(userLoggedIn)
  KeepAsyncValue<bool> loggedIn = KeepAsyncValue(false);

  Future<void> login() async {
    await loggedIn.set(true);
    print('Logged in!');
  }

  Future<void> logout() async {
    await loggedIn.set(false);
    print('Logged out!');
  }
}

Future<void> toggleLogin(AuthenticationService service, bool loggedIn) {
  print('Was logged in: $loggedIn');
  return loggedIn ? service.logout() : service.login();
}

void main(List<String> args) {
  // Initialize Hive
  Hive.init('.keeper'); // for Flutter use Hive.initFlutter()

  // Create an instance of AuthenticationService and make some changes
  final service = AuthenticationService();
  service.loggedIn.get().then((loggedIn) => toggleLogin(service, loggedIn));
}
