import 'dart:ui';

import 'package:flame/components.dart';

import 'snackbar.dart';

class SnackbarController extends Component {
  List<Snackbar> snackbars = [];

  void addSnackbar({required String text}) {
    snackbars.add(Snackbar(text: text));
    add(snackbars.last);
  }

  void renderSnackbars(Canvas canvas) {
    for (Snackbar snackbar in snackbars) {
      snackbar.manualRender(canvas);
    }
  }

  void removeSnackbar(Snackbar snackbar) {
    snackbars.remove(snackbar);
    remove(snackbar);
  }
}
