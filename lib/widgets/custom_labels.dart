import 'package:flutter/material.dart';

class CustomLabels extends StatelessWidget {
  const CustomLabels({
    Key? key,
    required this.ruta,
    required this.label1,
    required this.label2,
  }) : super(key: key);

  final String ruta, label1, label2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label1,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, ruta),
          child: Text(
            label2,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
