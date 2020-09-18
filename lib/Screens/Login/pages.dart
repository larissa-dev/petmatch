import 'package:petmatch/Screens/Login/styles.dart';
import 'package:flutter/material.dart';

final pages = [
  new PageViewModel(firstPage, "Descubra pets para adotar ao seu redor"),
  new PageViewModel(secondPage, "Descubra um crush para o seu pet acasalar"),
  new PageViewModel(thirdPage, "Encontre seu pet desaparecido"),
  new PageViewModel(fourthPage, "Deslize para a direita para curtir, deslize para a esquerda para rejeitar. Interaja através de um chat "),
];

class Pagee extends StatelessWidget {
  final PageViewModel viewModel;

  Pagee({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        new Text(
          viewModel.text,
          style: new TextStyle(
              color: Colors.white, fontSize: 21.0, fontFamily: "Poppins"),
          textAlign: TextAlign.center,
        ),
       new Image(image: viewModel.img),

      ],
    );
  }
}

class PageViewModel {
  final ImageProvider img;
  final String text;
  PageViewModel(this.img, this.text);
}
