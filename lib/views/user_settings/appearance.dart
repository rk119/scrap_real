// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/views/user_settings/user_settings.dart';
import 'package:scrap_real/widgets/buttons/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  // final user = FirebaseAuth.instance.currentUser!;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  File? image; // image used as the user's profile

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserSettingsPage()),
                  );
                }),
                CustomHeader(headerText: "Appearance"),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(Icons.dark_mode),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomSubheader(
                        headerText: "Enable Dark Theme",
                        headerSize: 16,
                        headerColor: Colors.grey,
                        headerAlignment: TextAlign.left,
                      ),
                    ),
                    Switch.adaptive(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) {
                        final provider =
                            Provider.of<ThemeProvider>(context, listen: false);
                        provider.toggleTheme(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
