import 'package:flutter/material.dart';

import '../constants/colors.dart';

class BackTopBarButton extends StatelessWidget {
  const BackTopBarButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        color: blackColor,
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_back));
  }
}
