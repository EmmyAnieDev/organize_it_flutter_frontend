import 'package:go_router/go_router.dart';
import 'package:organizer_it/presentation/screens/landing_page/landing_page.dart';

import '../../presentation/screens/auth/sign_in.dart';
import '../../presentation/screens/auth/sign_up.dart';
import '../../presentation/screens/profile/profile.dart';
import '../../presentation/screens/tasks/add_task.dart';
import '../../presentation/screens/tasks/edit_task.dart';
import '../../presentation/screens/tasks/tasks.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/task-screen',
      builder: (context, state) => const TaskScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/add-task',
      builder: (context, state) => const AddTaskScreen(),
    ),
    GoRoute(
      path: '/edit-task',
      builder: (context, state) => const EditTaskScreen(),
    ),
  ],
);
