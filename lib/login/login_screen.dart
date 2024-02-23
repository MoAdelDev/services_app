import 'package:entertainment_services/core/widgets/default_button.dart';
import 'package:entertainment_services/core/widgets/default_progress_indicator.dart';
import 'package:entertainment_services/core/widgets/default_text_form_field.dart';
import 'package:entertainment_services/home/home_screen.dart';
import 'package:entertainment_services/login/cubit/login_cubit.dart';
import 'package:entertainment_services/login/cubit/login_state.dart';
import 'package:entertainment_services/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تسجيل الدخول بنجاح'),
              ),
            );
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.1,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.surface,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  fontSize: 40.0,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              DefaultTextFormField(
                                controller: _emailController,
                                labelText: 'البريد الإلكتروني',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.email,
                                errorText: 'ادخل البريد الإلكتروني',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              DefaultTextFormField(
                                controller: _passwordController,
                                labelText: 'كلمة المرور',
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                                prefixIcon: Icons.lock,
                                suffixIcon: isPasswordHidden
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                obscureText: isPasswordHidden,
                                onSuffixIcon: () {
                                  setState(() {
                                    isPasswordHidden = !isPasswordHidden;
                                  });
                                },
                                errorText: 'أدخل كلمة المرور',
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              state is LoginLoading
                                  ? const Center(
                                      child: DefaultProgressIndicator(),
                                    )
                                  : DefaultButton(
                                      text: 'تسجبل الدخول',
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().login(
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              );
                                        }
                                      },
                                    ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'أليس لديك حساب؟',
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        child: Text(
                                          'طلب تسجيل دخول',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
