import 'package:entertainment_services/core/widgets/default_button.dart';
import 'package:entertainment_services/core/widgets/default_progress_indicator.dart';
import 'package:entertainment_services/core/widgets/default_text_form_field.dart';
import 'package:entertainment_services/home/home_screen.dart';
import 'package:entertainment_services/register/cubit/register_cubit.dart';
import 'package:entertainment_services/register/cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isPasswordHidden = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
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
          } else if (state is RegisterError) {
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
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.03,
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
                                'تسجيل حساب جديد',
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
                                controller: _nameController,
                                labelText: 'الاسم',
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.person,
                                errorText: 'أدخل الاسم',
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              DefaultTextFormField(
                                controller: _phoneController,
                                labelText: 'رقم الهاتف',
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icons.phone,
                                errorText: 'أدخل رقمك',
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
                              state is RegisterLoading
                                  ? const Center(
                                      child: DefaultProgressIndicator(),
                                    )
                                  : DefaultButton(
                                      text: 'تسجيل الحساب',
                                      onPressed: () {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<RegisterCubit>()
                                              .register(
                                                name: _nameController.text,
                                                phone: _phoneController.text,
                                                email: _emailController.text,
                                                password:
                                                    _passwordController.text,
                                              );
                                        }
                                      },
                                    ),
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
