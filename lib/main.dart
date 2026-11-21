import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'models/sanctuary_mode.dart';
import 'theme/app_theme.dart';
import 'screens/splash_mode_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoorSanctuaryApp());
}

/// Global ScrollBehavior enabling mouse drag, touch, trackpad and stylus on desktop & web
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class NoorSanctuaryApp extends StatefulWidget {
  const NoorSanctuaryApp({super.key});

  @override
  State<NoorSanctuaryApp> createState() => _NoorSanctuaryAppState();
}

enum AppFlowState {
  splashMode,
  login,
  register,
  mainSanctuary,
}

class _NoorSanctuaryAppState extends State<NoorSanctuaryApp> {
  AppFlowState _flowState = AppFlowState.splashMode;
  SanctuaryMode _currentMode = SanctuaryMode.general;

  void _onModeSelected(SanctuaryMode mode) {
    setState(() {
      _currentMode = mode;
    });
  }

  void _startJourney() {
    setState(() {
      _flowState = AppFlowState.mainSanctuary;
    });
  }

  void _goToLogin() {
    setState(() {
      _flowState = AppFlowState.login;
    });
  }

  void _goToRegister() {
    setState(() {
      _flowState = AppFlowState.register;
    });
  }

  void _goToSplash() {
    setState(() {
      _flowState = AppFlowState.splashMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor Sanctuary - Islamic Lifestyle Ecosystem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      home: _buildCurrentScreen(),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_flowState) {
      case AppFlowState.splashMode:
        return SplashModeScreen(
          initialMode: _currentMode,
          onModeSelected: _onModeSelected,
          onStartJourney: _startJourney,
          onLogin: _goToLogin,
        );
      case AppFlowState.login:
        return LoginScreen(
          onLoginSuccess: _startJourney,
          onLoginSuccessWithMode: (mode) {
            _onModeSelected(mode);
            _startJourney();
          },
          onGoToRegister: _goToRegister,
          onBack: _goToSplash,
        );
      case AppFlowState.register:
        return RegisterScreen(
          onRegisterSuccess: _startJourney,
          onGoToLogin: _goToLogin,
          onBack: _goToLogin,
        );
      case AppFlowState.mainSanctuary:
        return MainScaffold(
          mode: _currentMode,
          onSwitchMode: _goToSplash,
          onModeChanged: (newMode) {
            setState(() {
              _currentMode = newMode;
            });
          },
          onLogout: _goToSplash,
        );
    }
  }
}
