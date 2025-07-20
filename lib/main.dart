import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fruite_salad_shop/cubits/cart_cubit/cart_cubit_cubit.dart';
import 'package:fruite_salad_shop/cubits/favourite_cubit/favourite_cubit_cubit.dart';
import 'package:fruite_salad_shop/cubits/auth_cubit/auth_cubit.dart';
import 'package:fruite_salad_shop/firebase_options.dart';
import 'package:fruite_salad_shop/utils/keys.dart';
import 'package:fruite_salad_shop/views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Keys.stripePublishableKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CartCubit()),
        BlocProvider(create: (context) => FavoriteCubit()),
        BlocProvider(create: (context) => AuthCubit()), // ✅ أضفنا AuthCubit
      ],
      child: const FruitSaladShop(),
    ),
  );
}

class FruitSaladShop extends StatelessWidget {
  const FruitSaladShop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
