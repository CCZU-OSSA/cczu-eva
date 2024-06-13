import 'package:cczu_eva/client.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function(EVAClient client)? onSuccess;
  const LoginPage({super.key, this.onSuccess});

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  late TextEditingController username;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const ListTile(
              title: Text("登录"),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextField(
                controller: username,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "学号"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "密码"),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: FilledButton(
                onPressed: () {
                  var client = EVAClient(
                      username: username.text, password: password.text);
                  client.login().then((value) {
                    if (value && widget.onSuccess != null) {
                      widget.onSuccess!(client);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("账户/密码错误"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  });
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text("登录"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
