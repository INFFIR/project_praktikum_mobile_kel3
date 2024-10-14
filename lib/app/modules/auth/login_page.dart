import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/login/login_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_local_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/login_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/register_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/widgets/action_button.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/widgets/auth_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          right: 25,
          left: 25,
          bottom: 36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log in account',
              style: poppinsBlack.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Let’s log in your account',
              style: poppinsBlack.copyWith(
                fontSize: 16,
                color: colorBlack.withOpacity(0.4),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Form(
              key: _signInFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthTextField(
                    nameText: 'Email',
                    hintText: 'Enter your email address',
                    isObsecure: false,
                    isPassword: false,
                    controller: emailC,
                  ),
                  AuthTextField(
                    nameText: 'Password',
                    hintText: 'Enter your password',
                    isObsecure: true,
                    isPassword: true,
                    controller: passwordC,
                  ),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) async {
                      if (state is LoginLoaded) {
                        await AuthLocalDatasource().saveAuthData(state.model);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(
                                seconds: 1,
                              ),
                              content: Text(
                                  'Selamat datang ${state.model.user.username}'),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FirstPage(),
                            ),
                          );
                        }
                      }
                      if (state is LoginError) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(
                                seconds: 1,
                              ),
                              content: Text('Login gagal, check data anda'),
                            ),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ActionButton(
                        callback: () {
                          if (_signInFormKey.currentState!.validate()) {
                            final model = LoginRequestModel(
                              identifier: emailC.text,
                              password: passwordC.text,
                            );
                            context.read<LoginBloc>().add(
                                  DoLoginEvent(
                                    model: model,
                                  ),
                                );
                          }
                        },
                        color: colorBlack,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: poppinsWhite.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Divider(),
                  ),
                ),
                Text(
                  "Or",
                  style: poppinsBlack,
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Divider(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ActionButton(
              callback: () {},
              color: colorWhite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.g_translate_sharp),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Sign In with Google',
                    style: poppinsBlack.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ActionButton(
              callback: () {},
              color: const Color(0xff1877F2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.facebook,
                    color: colorWhite,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Sign In with Facebook',
                    style: poppinsWhite.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: poppinsBlack.copyWith(
                    color: colorBlack.withOpacity(0.4),
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign Up!',
                    style: poppinsBlack.copyWith(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
