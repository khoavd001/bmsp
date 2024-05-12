import 'package:bmsp/rsc/color_manager.dart';
import 'package:flutter/material.dart';

class Controller extends StatelessWidget {
  const Controller({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            decoration: InputDecoration(
          labelText: "Enter Email",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: AppColors.primary2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: AppColors.primary2,
              width: 2.0,
            ),
          ),
        ))
      ],
    );
  }
}
