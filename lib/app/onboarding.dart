import 'package:activity/activity.dart';
import 'package:flutter/material.dart';
import 'package:tuduus/main_controller.dart';
import 'package:tuduus/widgets/form_field.dart';
import 'package:tuduus/widgets/primary_button.dart';

class OnboardingView extends ActiveView<MainController> {
  static const routeName = "/onboarding";
  const OnboardingView({super.key, required super.activeController});

  @override
  ActiveState<ActiveView<ActiveController>, MainController> createActivity() =>
      _OnboardingViewState(activeController);
}

class _OnboardingViewState extends ActiveState<OnboardingView, MainController> {
  _OnboardingViewState(super.activeController);

  final TextEditingController _nameCtrl = TextEditingController();
  final _userForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset(
              'assets/images/tuduus-logo.png',
              height: 100,
              scale: 2.5,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Just do it, like Nike :)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                'Welcome to Tuduus',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Form(
              key: _userForm,
              child: CustomFormField(
                  onValidate: (value) {
                    if (value!.isEmpty) {
                      return 'Please tell us your name';
                    }
                    return null;
                  },
                  fieldCtrl: _nameCtrl,
                  label: 'What should we call you?',
                  isRequired: true),
            ),
            PrimaryButton(
              onPressed: () async {
                if (_userForm.currentState!.validate()) {
                  await activeController.handleOnboard(_nameCtrl.text);
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false);
                  }
                }
              },
              isLoading: false,
              label: "Get Started",
            ),
          ],
        ),
      ),
    );
  }
}
