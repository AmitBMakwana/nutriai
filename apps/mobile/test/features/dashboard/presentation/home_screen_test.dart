import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nutriai/core/theme/theme.dart';
import 'package:nutriai/features/auth/domain/entities/user_entity.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_provider.dart';
import 'package:nutriai/features/auth/presentation/providers/auth_state.dart';
import 'package:nutriai/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nutriai/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:nutriai/features/dashboard/domain/repositories/dashboard_repository_interface.dart';
import 'package:nutriai/features/dashboard/presentation/screens/home_screen.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/calorie_ring.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/macro_card.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/meals_section.dart';
import 'package:nutriai/features/dashboard/presentation/widgets/water_card.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepo;

  const sampleDashboard = DashboardEntity(
    date: '2026-10-02',
    calories: CalorieSummaryEntity(
      target: 2100,
      consumed: 1300,
      remaining: 800,
      percentage: 61.9,
    ),
    macros: MacrosSummaryEntity(
      protein: MacroNutrientEntity(target: 160, consumed: 90, remaining: 70, percentage: 56.3),
      carbs: MacroNutrientEntity(target: 210, consumed: 130, remaining: 80, percentage: 61.9),
      fat: MacroNutrientEntity(target: 70, consumed: 42, remaining: 28, percentage: 60.0),
    ),
    water: WaterSummaryEntity(
      target: 2750,
      consumed: 1250,
      remaining: 1500,
      percentage: 45.5,
    ),
    meals: {
      'breakfast': MealGroupEntity(type: 'breakfast', calories: 450, protein: 30, carbs: 50, fat: 15, meals: []),
      'lunch': MealGroupEntity(type: 'lunch', calories: 650, protein: 45, carbs: 60, fat: 22, meals: []),
      'dinner': MealGroupEntity(type: 'dinner', calories: 0, protein: 0, carbs: 0, fat: 0, meals: []),
      'snack': MealGroupEntity(type: 'snack', calories: 200, protein: 15, carbs: 20, fat: 5, meals: []),
    },
  );

  setUp(() {
    mockRepo = MockDashboardRepository();
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(mockRepo),
        authNotifierProvider.overrideWith(_FakeAuthNotifier.new),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen Widget Tests', () {
    testWidgets('renders all dashboard sections when data is loaded', (tester) async {
      when(() => mockRepo.getDashboard(date: any(named: 'date')))
          .thenAnswer((_) async => sampleDashboard);

      await tester.pumpWidget(createWidgetUnderTest());

      // Loading state
      expect(find.byType(HomeScreen), findsOneWidget);

      // Settle async notifier
      await tester.pumpAndSettle();

      // Header greeting with user's name
      expect(find.textContaining('Alex 👋'), findsOneWidget);
      expect(find.text('Here is your nutrition overview'), findsOneWidget);

      // Calorie Ring
      expect(find.byType(CalorieRing), findsOneWidget);
      expect(find.text('800'), findsOneWidget);
      expect(find.text('kcal remaining'), findsOneWidget);

      // Three Macro Cards
      expect(find.byType(MacroRowSection), findsOneWidget);
      expect(find.text('Protein'), findsOneWidget);
      expect(find.text('Carbs'), findsOneWidget);
      expect(find.text('Fat'), findsOneWidget);

      // Water Card
      expect(find.byType(WaterCard), findsOneWidget);
      expect(find.text('Hydration'), findsOneWidget);
      expect(find.text('1250 ml'), findsOneWidget);

      // Meals Section
      expect(find.byType(MealsSection), findsOneWidget);
      expect(find.text('Today’s Meals'), findsOneWidget);

      // Floating Add Meal button
      expect(find.text('Add Meal'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('shows error view and allows retry when fetch fails', (tester) async {
      when(() => mockRepo.getDashboard(date: any(named: 'date')))
          .thenThrow(Exception('Failed to load dashboard data'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.textContaining('Failed to load dashboard data'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      // Mock succeeding on retry
      when(() => mockRepo.getDashboard(date: any(named: 'date')))
          .thenAnswer((_) async => sampleDashboard);

      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      expect(find.byType(CalorieRing), findsOneWidget);
    });
  });
}

class _FakeAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState.authenticated(
      user: UserEntity(
        id: 1,
        name: 'Alex Johnson',
        email: 'alex@example.com',
        isOnboardingCompleted: true,
      ),
    );
  }
}
