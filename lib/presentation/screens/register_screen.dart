import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forms_app/presentation/blocs/register/register_cubit.dart';
import 'package:forms_app/presentation/presentation.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Nuevo usuario'),
        ),
        body: BlocProvider(
          create: (context) => RegisterCubit(),
          child: const _RegisterView(),
        ));
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              FlutterLogo(size: 100),
              _RegisterForm(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final registerCubit = context.watch<RegisterCubit>();
    final username = registerCubit.state.username;
    final password = registerCubit.state.password;

    return Form(
        child: Column(
      children: [
        CustomTextFormField(
          label: 'Nombre de usuario',
          onChanged: registerCubit.usernameChanged,
          errorMessage:
              username.isPure || username.isValid ? null : 'Usuario no válido',
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          label: 'Correo electrónico',
          onChanged: (value) {
            registerCubit.emailChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo requqerido';
            if (value.trim().isEmpty) return 'Campo requqerido';
            final emailRegExp = RegExp(
              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
            );
            if (!emailRegExp.hasMatch(value)) return 'Formato inválido';
            return null;
          },
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          label: 'Contraseña',
          obscureText: true,
          onChanged: (value) {
            registerCubit.passwordChanged(value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) return 'Campo requqerido';
            if (value.trim().isEmpty) return 'Campo requqerido';
            if (value.length < 6) {
              return 'El usuario debe tener al menos 6 letras';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        FilledButton.tonalIcon(
          onPressed: () {
            registerCubit.onSubmit();
          },
          icon: const Icon(Icons.save),
          label: const Text('Crear usuario'),
        ),
      ],
    ));
  }
}
