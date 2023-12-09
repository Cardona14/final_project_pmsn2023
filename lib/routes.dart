import 'package:final_project_pmsn2023/screens/dash_events_screen.dart';
import 'package:final_project_pmsn2023/screens/home_screen.dart';
import 'package:final_project_pmsn2023/screens/login_screen.dart';
import 'package:final_project_pmsn2023/screens/new_invitation_screen.dart';
import 'package:final_project_pmsn2023/screens/onboarding.dart';
import 'package:final_project_pmsn2023/screens/settings_screen.dart';
import 'package:final_project_pmsn2023/screens/signup_screen.dart';
import 'package:final_project_pmsn2023/widgets/bottom_bar_widget.dart';
import 'package:flutter/material.dart';

Map<String,WidgetBuilder> getRoutes(){
  return <String, WidgetBuilder>{
    '/home': (BuildContext context) => const HomeScreen(),
    '/login': (BuildContext context) => const LoginScreen(),
    '/signup': (BuildContext context) => const SignUpScreen(),
    '/dash': (BuildContext context) => const GoogleBottomBar(),
    '/dash_events': (BuildContext context) => HomeDash(),
    '/invitation': (BuildContext context) => const InvitationScreen(),
    '/settings': (BuildContext context) => const SettingsScreen(),
    '/onbording': (BuildContext context) => const OnboardingPage1(),
  };
}