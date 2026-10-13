import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kl_campus_app/main.dart';

/// A tall phone-sized surface so the whole Dashboard / form is on screen.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Taps the Dashboard navigation card with this title.
Future<void> openFromDashboard(WidgetTester tester, String title) async {
  await tester.tap(find.widgetWithText(NavigationCard, title));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // Registrations are kept in memory, so reset them between tests.
    for (final e in campusEvents) {
      e.registered = false;
    }
  });

  testWidgets('App launches and shows the dashboard', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('KL UniConnect'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Activities'), findsWidgets);
    expect(find.text('Profile'), findsWidgets);
  });

  group('Routes and Navigator', () {
    testWidgets('named route opens and Back pops to the SAME Dashboard',
        (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());

      await openFromDashboard(tester, 'Timetable');
      expect(find.text('This week'), findsOneWidget);
      expect(find.text('Next class'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('This week'), findsNothing);
      expect(find.text('Explore campus'), findsOneWidget);
    });

    testWidgets('service details receive the selected item and return a result',
        (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());

      await openFromDashboard(tester, 'Campus Services');
      expect(find.text('Find support on campus'), findsOneWidget);

      // Select the second service to prove the details are not hard-coded.
      await tester.tap(find.text('Central Library'));
      await tester.pumpAndSettle();
      expect(find.text('Library Block, Ground Floor'), findsOneWidget);
      expect(find.text('library@kl.edu'), findsOneWidget);

      // Returning a result shows feedback on the Services screen.
      await tester.tap(find.text('Request an appointment'));
      await tester.pumpAndSettle();
      expect(find.text('Find support on campus'), findsOneWidget);
      expect(find.text('Appointment request recorded for Central Library.'),
          findsOneWidget);
    });

    testWidgets('plain Return pops details without a result', (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());

      await openFromDashboard(tester, 'Campus Services');
      await tester.tap(find.text('Accommodation Office'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Return'));
      await tester.pumpAndSettle();
      expect(find.text('Find support on campus'), findsOneWidget);
      expect(find.textContaining('Appointment request recorded'), findsNothing);
    });

    testWidgets('event registration returns its state to the list',
        (tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());

      await openFromDashboard(tester, 'Campus Events');
      await tester.tap(find.text('Career Fair 2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Register now'));
      await tester.pumpAndSettle();

      expect(find.text('You are registered for Career Fair 2026.'),
          findsOneWidget);
      expect(find.text('Registered'), findsOneWidget);
    });

    testWidgets('unregistered route shows the 404 fallback with its name',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/not-a-real-page');
      await tester.pumpAndSettle();

      expect(find.text('404 - Page not found'), findsOneWidget);
      expect(find.textContaining('/not-a-real-page'), findsOneWidget);
    });

    testWidgets('service-detail without an argument falls back to 404',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.pushNamed('/service-detail'); // no CampusService passed
      await tester.pumpAndSettle();

      expect(find.text('404 - Page not found'), findsOneWidget);
    });
  });

  group('Service request form', () {
    Future<void> openForm(WidgetTester tester) async {
      useTallScreen(tester);
      await tester.pumpWidget(const MyApp());
      await openFromDashboard(tester, 'Service Request');
    }

    Future<void> type(WidgetTester tester, String label, String text) async {
      await tester.enterText(find.widgetWithText(TextFormField, label), text);
    }

    testWidgets('empty submit shows field errors and no success message',
        (tester) async {
      await openForm(tester);
      await tester.tap(find.text('Send request'));
      await tester.pumpAndSettle();

      expect(find.text('Enter your full name'), findsOneWidget);
      expect(find.text('Enter your student ID'), findsOneWidget);
      expect(find.text('Enter your campus email'), findsOneWidget);
      expect(find.text('Choose a service category'), findsOneWidget);
      expect(find.text('Select an urgency level'), findsOneWidget);
      expect(find.text('Tick the declaration before sending'), findsOneWidget);
      expect(find.text('Request sent'), findsNothing);
    });

    testWidgets('invalid email and ID give specific messages', (tester) async {
      await openForm(tester);
      await type(tester, 'Student ID', '123');
      await type(tester, 'Campus email', 'someone@gmail.com');
      await tester.tap(find.text('Send request'));
      await tester.pumpAndSettle();

      expect(find.text('Student ID must be exactly 10 digits, e.g. 2300030536'),
          findsOneWidget);
      expect(find.text('Use your campus email ending in @kl.edu'),
          findsOneWidget);
    });

    testWidgets('valid data submits, shows a summary, then returns',
        (tester) async {
      await openForm(tester);
      await type(tester, 'Full name', 'Satya Sukumar Pilli');
      await type(tester, 'Student ID', '2300030536');
      await type(tester, 'Campus email', '2300030536@kl.edu');

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Library').last);
      await tester.pumpAndSettle();
      // The extra field only appears for some categories.
      await type(tester, 'Book title or library card no.', 'LC-20917');

      await type(tester, 'Subject', 'Overdue fine question');
      await type(tester, 'Description',
          'I returned my books on time but the fine is still showing.');
      await tester.tap(find.text('Normal'));
      await tester.tap(find.text('Email'));
      await tester.pump();

      await tester.tap(find.text('Tap to choose a date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(find.text('11 of 11 required fields completed'), findsOneWidget);

      await tester.tap(find.text('Send request'));
      await tester.pumpAndSettle();
      expect(find.text('Request sent'), findsOneWidget);
      expect(find.textContaining('Reference: KL-REQ-'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
      expect(find.text('Explore campus'), findsOneWidget);
      expect(find.textContaining('sent - we will be in touch'), findsOneWidget);
    });

    testWidgets('Clear form resets fields and selections', (tester) async {
      await openForm(tester);
      await type(tester, 'Full name', 'Satya Sukumar Pilli');
      await tester.tap(find.text('Urgent'));
      await tester.pump();
      expect(find.text('2 of 10 required fields completed'), findsOneWidget);

      await tester.tap(find.text('Clear form'));
      await tester.pumpAndSettle();
      expect(find.text('0 of 10 required fields completed'), findsOneWidget);
      expect(find.text('Satya Sukumar Pilli'), findsNothing);
    });

    testWidgets('leaving with unsent input asks for confirmation',
        (tester) async {
      await openForm(tester);
      await type(tester, 'Subject', 'Wi-Fi problem');

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Discard this request?'), findsOneWidget);

      await tester.tap(find.text('Keep editing'));
      await tester.pumpAndSettle();
      expect(find.text('Campus Help Request'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(find.text('Explore campus'), findsOneWidget);
    });
  });
}
