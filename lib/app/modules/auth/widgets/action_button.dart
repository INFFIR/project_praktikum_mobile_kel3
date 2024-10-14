import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ActionButton extends StatelessWidget {
  VoidCallback callback;
  Color color;
  Widget child;

  ActionButton({
    Key? key,
    required this.callback,
    required this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0,
          ),
          color: color,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
