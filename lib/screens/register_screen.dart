import 'package:flutter/material.dart';

class RegistrationData {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  const RegistrationData({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  String get displayName => '$firstName $lastName';
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.onLogin});

  final VoidCallback? onLogin;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();

  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  InputDecoration _field(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  String? _validateName(String? value) {
    final name = (value ?? '').trim();
    if (name.isEmpty) return 'هذا الحقل مطلوب';
    if (RegExp(r'[0-9٠-٩۰-۹]').hasMatch(name)) return 'أدخل اسمًا بلا أرقام';
    return null;
  }

  void _submit() {
    final form = _formKey.currentState!;
    if (!form.validate()) return;
    form.save();

    Navigator.pop(
      context,
      RegistrationData(
        firstName: _firstName,
        lastName: _lastName,
        phone: _phone,
        email: _email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب'), centerTitle: true),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: _field('الاسم الأول'),
                      validator: _validateName,
                      onSaved: (value) => _firstName = value!.trim(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: _field('اسم العائلة'),
                      validator: _validateName,
                      onSaved: (value) => _lastName = value!.trim(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: _field('رقم الهاتف'),
                validator: (value) =>
                    RegExp(r'^[0-9٠-٩۰-۹]{9}$').hasMatch((value ?? '').trim())
                    ? null
                    : 'أدخل ٩ أرقام بدون رمز الدولة',
                onSaved: (value) => _phone = '+967${value!.trim()}',
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: _field('البريد الإلكتروني'),
                validator: (value) =>
                    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch((value ?? '').trim())
                    ? null
                    : 'أدخل بريدًا إلكترونيًا بصيغة صحيحة',
                onSaved: (value) => _email = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: _field('كلمة المرور'),
                validator: (value) {
                  final password = value ?? '';
                  if (password.length < 8 ||
                      !RegExp(r'[a-zA-Zء-ي]').hasMatch(password) ||
                      !RegExp(r'[0-9٠-٩۰-۹]').hasMatch(password)) {
                    return 'استخدم ٨ رموز على الأقل، بينها حرف ورقم';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: _field('تأكيد كلمة المرور'),
                validator: (value) {
                  if ((value ?? '').isEmpty) return 'أكّد كلمة المرور';
                  if (value != _password.text)
                    return 'كلمتا المرور غير متطابقتين';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _submit, child: const Text('إنشاء حساب')),
              if (widget.onLogin != null)
                TextButton(
                  onPressed: widget.onLogin,
                  child: const Text('لديك حساب؟ تسجيل الدخول'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
