import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/role_selection_screen.dart';
import '../../features/patient/home/screens/patient_main_screen.dart';
import '../../features/doctor/dashboard/screens/doctor_main_screen.dart';
import '../../features/patient/booking/screens/booking_screen.dart';
import '../../features/shared/models/doctor_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final currentUserState = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isAuth) {
        return isLoggingIn ? null : '/login';
      }

      if (currentUserState.isLoading) {
        return null;
      }

      final user = currentUserState.value;

      if (user != null) {
        if (user.role == UserRole.unknown) {
          if (state.matchedLocation != '/role-selection') {
            return '/role-selection';
          }
          return null;
        }

        if (isLoggingIn || state.matchedLocation == '/role-selection') {
          if (user.role == UserRole.patient) {
            return '/patient-home';
          } else if (user.role == UserRole.doctor) {
            return '/doctor-dashboard';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/role-selection',
        pageBuilder: (context, state) {
          final user = ref.read(authStateProvider).value;
          return CustomTransitionPage(
            key: state.pageKey,
            child: RoleSelectionScreen(uid: user?.uid ?? ''),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
          );
        },
      ),
      GoRoute(
        path: '/patient-home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const PatientMainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/doctor-dashboard',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const DoctorMainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/book-appointment',
        pageBuilder: (context, state) {
          final doctor = state.extra as DoctorModel;
          return CustomTransitionPage(
            key: state.pageKey,
            child: BookingScreen(doctor: doctor),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
});
