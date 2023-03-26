import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/model/user_model.dart';
import 'package:go_router_practice/screen/error_screen.dart';
import 'package:go_router_practice/screen/home_screen.dart';
import 'package:go_router_practice/screen/login_screen.dart';
import 'package:go_router_practice/screen/one_screen.dart';
import 'package:go_router_practice/screen/three_screen.dart';
import 'package:go_router_practice/screen/two_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authProvider = _AuthNotifier(ref: ref);

  return GoRouter(
    initialLocation: "/login",
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error.toString());
    },
    routes: authProvider._routes,
    redirect: authProvider._redirectLogic,
    refreshListenable: authProvider,
  );
});

class _AuthNotifier extends ChangeNotifier {
  final Ref ref;

  _AuthNotifier({required this.ref}) {
    ref.listen<UserModel?>(
      userProvider,
      (previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      },
    );
  }

  Future<String?> _redirectLogic(_, GoRouterState state) async {
    final user = ref.read(userProvider);
    const loginPath = "/login";
    final loggingIn = state.location == loginPath;

    if (user == null) {
      return loggingIn ? null : loginPath;
    }

    if (loggingIn) return "/";

    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: "/",
          builder: (_, state) => HomeScreen(),
          routes: [
            GoRoute(
              path: "one",
              builder: (_, state) => OneScreen(),
              routes: [
                GoRoute(
                  path: "two",
                  builder: (_, state) => TwoScreen(),
                  routes: [
                    GoRoute(
                      path: "three",
                      name: ThreeScreen.routeName,
                      builder: (_, state) => ThreeScreen(),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        GoRoute(
          path: "/login",
          builder: (_, state) => LoginScreen(),
        ),
      ];
}

final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
    (ref) => UserStateNotifier());

class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  void login({required String name}) {
    state = UserModel(name: name);
  }

  void logout() {
    state = null;
  }
}
