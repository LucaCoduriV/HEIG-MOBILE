import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/theme.dart' as theme;

/// Bouton qui permet d'accéder à la page des notes d'une branche.
///
/// La [moyenne] et le [title] sont affichés sur le bouton.
class BrancheButton extends StatelessWidget {
  final String title;
  final double moyenne;
  final void Function() onPress;
  const BrancheButton(
      {Key? key,
      required this.title,
      required this.moyenne,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildButton(context);
  }

  Widget buildButton(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: buildButtonContent(context),
      ),
    );
  }

  Widget buildButtonContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Row(children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      moyenne < 4 ? Colors.red.shade100 : Colors.green.shade200,
                ),
              ),
              const SizedBox(width: 5),
              Text('Moyenne: $moyenne',
                  style: const TextStyle(fontWeight: FontWeight.w300))
            ]),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Provider.of<theme.ThemeProvider>(context).mode ==
                      ThemeMode.light
                  ? Colors.black
                  : Colors.white,
            ),
          ],
        )
      ],
    );
  }
}
