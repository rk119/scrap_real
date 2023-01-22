import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scrap_real/themes/theme_provider.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/settings_views/user_settings.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({Key? key}) : super(key: key);

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final provider = Provider.of<ThemeProvider>(context, listen: false);

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
                      builder: (context) => const UserSettingsPage(),
                    ),
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
                        provider.toggleTheme(value);
                        CustomSnackBar.snackBarAlert(
                          context,
                          "Theme Updated!",
                        );
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
