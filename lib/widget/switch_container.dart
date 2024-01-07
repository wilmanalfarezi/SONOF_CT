import 'package:flutter/material.dart';

class SwitchContainer extends StatelessWidget {
  final ValueChanged<bool>? onChanged;
  final bool value;
  final String label;
  final String title;
  final bool isActive;

  const SwitchContainer({
    super.key,
    required this.onChanged,
    required this.value,
    required this.label,
    required this.title,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      shadowColor: Colors.black,
      color: isActive ? Colors.orange.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isActive ? Colors.orange : Colors.white,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        width: 175,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Switch(
                        activeColor: Colors.orange,
                        activeTrackColor: Colors.orange.shade200,
                        value: value,
                        onChanged: onChanged,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: CustomTextStyle.normalText,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: CustomTextStyle.boldText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextStyle {
  static const TextStyle boldText = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle normalText = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );
}
