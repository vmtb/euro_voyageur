import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:trivo/screens/auth/register_page.dart';
import 'package:trivo/screens/auth/widgets/background.dart';
import 'package:trivo/utils/app_func.dart';

import '../../components/app_button_round.dart';
import '../../components/app_input.dart';
import '../../components/app_text.dart';
import '../../utils/app_const.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
              child: _buildLoginWidget(),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoginWidget() {
    return Form(
      key: key,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppText(
              "Connectez-vous:",
              size: 32,
              isNormal: true,
              weight: FontWeight.bold,
            ),
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
              height: 40,
            ),
            AppButtonRound(
              "Se connecter",
              isLoading: isLoading,
              backgroundColor: AppColor.primary,
              onTap: () async {
                if(!key.currentState!.validate()) {
                  return;
                }
                if(!isLoading){
                  setState(() {
                    isLoading = true;
                  });
                  // String error = await ref.read(userController).loginUser(emailController.text.trim(), passwordController.text.trim());
                  // if(error.isEmpty){
                  //   navigateToNextPage(context, const HomePage(), back: false);
                  // }else{
                  //   showFlushBar(context, "Echec de la connexion", error);
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
                      text: "Vous n'avez pas un compte?  ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Créer un compte",
                          recognizer: TapGestureRecognizer()..onTap = () {
                            navigateToNextPageWithTransition(context, const RegisterPage(), back: true);
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
