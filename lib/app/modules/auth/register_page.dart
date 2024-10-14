import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/bloc/register/register_bloc.dart';
import 'package:project_praktikum_mobile_kel3/app/common/global_data.dart';
import 'package:project_praktikum_mobile_kel3/app/data/datasources/auth_local_datasource.dart';
import 'package:project_praktikum_mobile_kel3/app/data/models/request/register_request_model.dart';
import 'package:project_praktikum_mobile_kel3/app/first_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/login_page.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/widgets/action_button.dart';
import 'package:project_praktikum_mobile_kel3/app/modules/auth/widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerKey = GlobalKey<FormState>();
  final TextEditingController fullnameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: SingleChildScrollView(
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
                'Create an account',
                style: poppinsBlack.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Let’s create your account',
                style: poppinsBlack.copyWith(
                  fontSize: 16,
                  color: colorBlack.withOpacity(0.4),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Form(
                key: _registerKey,
                child: Column(
                  children: [
                    AuthTextField(
                      nameText: 'Full name',
                      hintText: 'Enter your full name',
                      isObsecure: false,
                      isPassword: false,
                      controller: fullnameC,
                    ),
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
                    BlocConsumer<RegisterBloc, RegisterState>(
                      listener: (context, state) {
                        state.maybeWhen(
                            orElse: () {},
                            error: (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Nama atau email sudah terdaftar'),
                                ),
                              );
                            },
                            loaded: (model) async {
                              await AuthLocalDatasource().saveAuthData(model);
                              if (mounted) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(
                                  builder: (context) {
                                    return const FirstPage();
                                  },
                                ));
                              }
                            });
                      },
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () {
                            return ActionButton(
                              callback: () {
                                if (_registerKey.currentState!.validate()) {
                                  final requestModel = RegisterRequestModel(
                                    username: fullnameC.text,
                                    email: emailC.text,
                                    password: passwordC.text,
                                  );
                                  context.read<RegisterBloc>().add(
                                      RegisterEvent.register(requestModel));
                                }
                              },
                              color: colorBlack,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Sign Up',
                                    style: poppinsWhite.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          loading: () => const Center(
                            child: CircularProgressIndicator(),
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
              Row(children: <Widget>[
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Divider(),
                )),
                Text(
                  "Or",
                  style: poppinsBlack,
                ),
                const Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Divider(),
                )),
              ]),
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
                      'Sign Up with Facebook',
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
                      'Sign Up with Facebook',
                      style: poppinsWhite.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
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
        ),
      )),
    );
  }
}
