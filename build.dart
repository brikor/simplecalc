import 'package:polymer/builder.dart';

main(args) {
  build(entryPoints: ['web/simplecalc.html'],
        options: parseOptions(args));
}
