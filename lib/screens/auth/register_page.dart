import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:trivo/screens/auth/login_page.dart';
import 'package:trivo/screens/auth/widgets/background.dart';
import 'package:trivo/utils/app_func.dart';

import '../../components/app_button_round.dart';
import '../../components/app_input.dart';
import '../../components/app_text.dart';
import '../../utils/app_const.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final emailController = TextEditingController();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();
  var selectedCountryKey;

  bool isObscure = true;
  bool isLoading = false;
  final key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Background(
              child: _buildRegisterWidget(),
            ),
          ],
        ),
      ),
    );
  }

  _buildRegisterWidget() {

    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppText(
              "Inscription",
              size: 32,
              isNormal: true,
              weight: FontWeight.bold,
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            AppInput2(
                hasSuffix: true,
                controller: prenomController,
                hint: "Votre prénom",
                validator:
                ValidationBuilder(requiredMessage: "Champ requis").build()),
            const SizedBox(
              height: 15,
            ),
            AppInput2(
                hasSuffix: true,
                controller: nomController,
                hint: "Votre nom",
                validator:
                ValidationBuilder(requiredMessage: "Champ requis").build()),
            const SizedBox(
              height: 15,
            ),
            AppInput2(
                hasSuffix: true,
                controller: emailController,
                hint: "Email",
                validator:
                ValidationBuilder(requiredMessage: "Champ requis").email("Email requis").build()),
            const SizedBox(
              height: 20,
            ),
            AppInput2(
                hasSuffix: true,
                suffixIcon: IconButton(onPressed: (){setState(() {
                  isObscure = !isObscure;
                });}, icon: Icon(isObscure?Icons.remove_red_eye:Icons.password)),
                controller: passwordController,
                hint: "Mot de passe",
                isObscure: isObscure,
                validator: ValidationBuilder(requiredMessage: "Champ requis").build()),
            const SizedBox(
              height: 20,
            ),
            AppInput2(
                hasSuffix: true,
                suffixIcon: IconButton(onPressed: (){setState(() {
                  isObscure = !isObscure;
                });}, icon: Icon(isObscure?Icons.remove_red_eye:Icons.password)),
                controller: password2Controller,
                hint: "Confirmer mot de passe",
                isObscure: isObscure,
                validator: ValidationBuilder(requiredMessage: "Champ requis").build()),
            const SizedBox(
              height: 15,
            ),
            Divider(),
            const SizedBox(
              height: 40,
            ),

            AppButtonRound(
              "S'inscrire",
              isLoading: isLoading,
              backgroundColor: AppColor.primary,
              onTap: () async {
                if(!key.currentState!.validate()) {
                  return;
                }
                if(passwordController.text.trim()!=password2Controller.text.trim())
                 {  showFlushBar(context, "Info", "Les deux mots de passe ne correspondent pas...");
                  return;
                }
                if(!isLoading){
                  setState(() {
                    isLoading = true;
                  });

                  // if(error.isEmpty){
                  //   navigateToNextPage(context, const HomePage(), back: false);
                  // }else{
                  //   showFlushBar(context, "Echec de l'inscription", error);
                  // }
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text.rich(
                  TextSpan(
                      text: "J'ai déjà un compte?  ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Se connecter",
                          recognizer: TapGestureRecognizer()..onTap = () {
                            navigateToNextPageWithTransition(context, const LoginPage(), back: false);
                          },
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ])),
            ),
          ],
        ),
      ),
    );
  }
}
