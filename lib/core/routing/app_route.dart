
import 'package:go_router/go_router.dart';
import 'package:ppdb_app/presentation/page/home.dart';
import 'package:ppdb_app/presentation/page/login.dart';
import 'package:ppdb_app/presentation/page/register.dart';

part 'rout_name.dart';

final appRoute = [
 GoRoute(
    path: '/home',
    name: Routes.home,
    builder: (context, state) =>  HomePage(),
  ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: Routes.register,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
       path: "/forgot-password",
    name: Routes.forgotPassword,
    builder: (context, state) => LoginPage(),

    ),
];