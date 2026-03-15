import 'custom_text_button.dart';

class BackButton extends CustomTextButton {
  BackButton({super.text = 'BACK', super.position, super.key}) : super(onPressed: (game, world) => game.router.pushReplacementNamed('mainMenu'));
}
