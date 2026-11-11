import 'package:flutter/material.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    _showMessage('هذا الحساب غير موجود');
  }

  Future<void> _openRegister() async {
    final account = await Navigator.push<RegistrationData>(
      context,
      MaterialPageRoute<RegistrationData>(
        builder: (registerContext) =>
            RegisterScreen(onLogin: () => Navigator.pop(registerContext)),
      ),
    );

    if (!mounted || account == null) return;
    Navigator.pop(context, account);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول'), centerTitle: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final email = (value ?? '').trim();
                  if (email.isEmpty) return 'أدخل البريد الإلكتروني';
                  if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                    return 'أدخل بريدًا إلكترونيًا بصيغة صحيحة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _login(),
                decoration: const InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) return 'أدخل كلمة المرور';
                  return null;
                },
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => _showMessage(
                    'استعادة كلمة المرور غير متاحة في النسخة التجريبية',
                  ),
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ),
              FilledButton(
                onPressed: _login,
                child: const Text('تسجيل الدخول'),
              ),
              Center(
                child: TextButton(
                  onPressed: _openRegister,
                  child: const Text('ليس لديك حساب؟ إنشاء حساب'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
