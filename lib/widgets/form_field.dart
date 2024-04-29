import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String? Function(String?) onValidate;
  final String label;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextEditingController fieldCtrl;
  final int maxLines;

  const CustomFormField(
      {super.key,
      required this.onValidate,
      required this.label,
      required this.isRequired,
      required this.fieldCtrl,
      this.keyboardType,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: isRequired ? ' *' : '',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            controller: fieldCtrl,
            keyboardType: keyboardType,
            validator: onValidate,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}
