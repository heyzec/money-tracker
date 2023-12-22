import 'package:flutter/material.dart';
import 'package:namer_app/widgets/cards/category_card.dart';

class CardInfo {
  String? text;
  String iconName;
  Color color;

  CardInfo({this.text, required this.iconName, required this.color});

  bool equals(other) {
    return text == other.text && iconName == other.iconName;
  }
}

class CardSelector extends StatefulWidget {
  final List<CardInfo> categories;
  final Function(CardInfo) onSelectCallback;

  CardSelector({
    required this.categories,
    required this.onSelectCallback,
  });

  @override
  State<CardSelector> createState() => _CardSelectorState();
}

class _CardSelectorState extends State<CardSelector> {
  CardInfo? selected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.from(
        widget.categories.map(
          (cardInfo) => CategoryCard(
            iconName: cardInfo.iconName,
            text: cardInfo.text,
            color: cardInfo.color,
            onPressed: () {
              setState(() {
                selected = cardInfo;
              });
              widget.onSelectCallback(cardInfo);
            },
            marked: selected != null && cardInfo.equals(selected),
          ),
        ),
      ),
    );
  }
}
