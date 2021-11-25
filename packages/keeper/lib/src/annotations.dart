import 'package:keeper/src/keys.dart';

class MakeKept {
  const MakeKept._();
}

const kept = MakeKept._();

class At {
  final KeepKey Function() key;
  const At(this.key);
}

class AtAsync {
  final KeepAsyncKey Function() key;
  const AtAsync(this.key);
}
