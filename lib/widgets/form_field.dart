import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String? Function(String?) onValidate;
  final String label;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextEditingController? textCtrl;

  const CustomFormField({
    super.key,
    required this.onValidate,
    required this.label,
    required this.isRequired,
    this.textCtrl,
    this.keyboardType,
  });

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
                    style: Theme.of(context).textTheme.bodyMedium,
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
            controller: textCtrl,
            keyboardType: keyboardType,
            validator: onValidate,
          ),
        ],
      ),
    );
  }
}
