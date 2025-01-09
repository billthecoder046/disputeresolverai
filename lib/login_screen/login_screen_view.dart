import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'login_screen_logic.dart';

class Login_screenPage extends StatelessWidget {
  Login_screenPage({Key? key}) : super(key: key);

  final Login_screenLogic logic = Get.put(Login_screenLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Obx(() {
        if (logic.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/pngegg (1).png'),
              ),
              TextFormField(
                controller: logic.emailCon,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Gap(16),
              Obx(() => TextFormField(
                controller: logic.passCon,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      logic.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      logic.togglePasswordVisibility();
                    },
                  ),
                ),
                obscureText: logic.isPasswordHidden.value,
              )),
              const Gap(24),
              ElevatedButton(
                onPressed: () {
                  logic.signUser();
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
