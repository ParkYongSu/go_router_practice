import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/layout/default_layout.dart';
import 'package:go_router_practice/provider/router_provider.dart';
import 'package:go_router_practice/screen/three_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              context.go("/one");
            },
            child: Text(
              "one screen (GO)"
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.goNamed(ThreeScreen.routeName);
            },
            child: Text(
                "threen screen (GO NAMED)"
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go("hihi");
            },
            child: Text(
                "error screen (Error)"
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go("/login");
            },
            child: Text(
                "Login Screen"
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(userProvider.notifier).logout();
            },
            child: Text(
                "logout"
            ),
          ),
        ],
      ),
    );
  }
}
