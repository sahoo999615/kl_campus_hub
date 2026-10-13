# KL UniConnect - Student Campus App

One Flutter app that covers four mini projects: **Scaffold**, **Container**, **Form** and **Routes/Navigator**.

- Student: Satya Sukumar Pilli
- Student ID: 2300030536
- University: KL

## Run it

Needs Flutter 3.22 or newer (the form uses `PopScope.onPopInvokedWithResult`).

1. Install Flutter (https://docs.flutter.dev/get-started/install).
2. In this folder generate the platform folders:
   ```
   flutter create .
   ```
   **Then check that `lib/main.dart` is still the KL UniConnect file** (it starts with `// KL UniConnect`). If it
   shows the default counter app, copy `lib/main.dart` from this zip over it again.
3. Run:
   ```
   flutter pub get
   flutter run
   flutter test
   ```

## Project layout

Everything is in ONE file, `lib/main.dart` (so it also works pasted into DartPad). It is split into labelled
sections, one banner comment per former file:

| Section | Contents |
|---|---|
| Design system | `AppColors`, `Styles` |
| Models + sample data | `Student`, activities, `CampusService`, timetable (`ClassEntry`), `CampusEvent` |
| Route names | `AppRoutes` constants (used for registering AND navigating) |
| Reusable widgets | `StatusBadge`, `CampusActionCard`, `NavigationCard`, `campusAppBar`, edit dialog, `CampusTextField` / `CampusDropdown` / chips / date field |
| Pages | Dashboard (`HomePage`), `ActivitiesPage`, `ProfilePage` |
| Route screens | `TimetableScreen`, `ServicesScreen`, `ServiceDetailScreen`, `EventsScreen`, `EventDetailScreen`, `ProfileScreen`, `UnknownRouteScreen` |
| Form | `ServiceRequestFormScreen` |
| Shell | `CampusShell` (Scaffold, Drawer, BottomNavigationBar, FAB) |
| App | `MyApp` with `routes`, `onGenerateRoute`, `onUnknownRoute` |

## Project 1 and 2 - Scaffold and Container

Scaffold: AppBar (title, colour, 2 actions), Drawer (DrawerHeader + ListTiles with working actions),
BottomNavigationBar (3 items, `currentIndex`/`onTap`/`setState`), FloatingActionButton (adds a reminder),
SnackBars (with UNDO/VIEW actions).

Container: `MaterialApp`, `Scaffold`, `SafeArea`, `SingleChildScrollView`; 10+ Containers with width/height,
margin, padding, alignment, `BoxConstraints`, `BoxDecoration`, border, radius, shadow and gradient; reusable
`CampusActionCard`; InkWell taps with feedback; progress bar and status badges.

### Edit options (inside the app)

Every card, service and detail has an edit (pencil) button. Edits update the app immediately (kept in memory only).

| Where | What you can edit |
|-------|-------------------|
| Dashboard header | Name, programme, student ID, university |
| Academic snapshot | Semester, CGPA, credits, attendance % |
| Quick access (6 services) | Title, caption, tap message, icon |
| Campus announcement | Title and message |
| Student life | Event name, month, day, time, venue |
| My reminders | Text and time |
| Activities tab | Name, description, date, time, venue, icon |
| Profile tab and Profile page | Name, programme, ID, university, faculty, semester, advisor, email, contact |

## Project 3 - Form (Campus Help Request)

Open it from the Dashboard (**Service Request**), the drawer, or **Send a written request** on a service's details page.

| Brief requirement | Where in the code |
|---|---|
| `GlobalKey<FormState>`, `autovalidateMode: onUserInteraction` | `_formKey`, `Form(...)` in `ServiceRequestFormScreen` |
| 8+ inputs, 4+ `TextFormField`, 3+ control types | name, ID, email, phone, subject, description, extra field (text); category (dropdown); urgency + contact (chips); date picker; declaration (checkbox) |
| Validation messages | `_validateName`, `_validateStudentId` (10 digits), `_validateEmail` (`@kl.edu`), `_validatePhone` (9-13 digits, optional `+`; required for Phone call/SMS), `_validateDetails` (20-300 chars), `_validateDate` (not in the past), `_validateDeclaration` |
| Submit = `validate()` then `save()` | `_submit()` |
| Reset clears everything, including non-field state | `_resetForm()` (controllers, dropdown, chips, date, checkbox) |
| Success feedback with summary + reference | `_buildSummaryDialog()` (`KL-REQ-xxxx`), then a SnackBar on the previous screen |
| Keyboard + small screens | `keyboardType`, `textInputAction`, scrollable body (a `SingleChildScrollView` so every field stays mounted for `validate()`/`save()`) |
| Controllers disposed | `dispose()` |

Advanced options chosen (3 needed, 5 done): extra field shown by category (Accommodation / IT Helpdesk / Library),
live character counter on the description, reusable `CampusTextField` / `CampusDropdown`, summary dialog,
required-fields progress bar. Bonus: confirmation before leaving an unsent form (`PopScope`).

## Project 4 - Routes and Navigator

### Route map

| Route name | Widget | Opened by |
|---|---|---|
| `/` (initial) | `CampusShell` (Dashboard) | app start |
| `/timetable` | `TimetableScreen` | Dashboard card or drawer, `Navigator.pushNamed` |
| `/services` | `ServicesScreen` | Dashboard card or drawer, `Navigator.pushNamed` |
| `/service-detail` | `ServiceDetailScreen` | tap a service, `pushNamed` with a `CampusService` argument (built in `onGenerateRoute`) |
| `/events` | `EventsScreen` | Dashboard card or drawer, `Navigator.pushNamed` |
| (direct) | `EventDetailScreen` | tap an event, `Navigator.push(MaterialPageRoute(...))` |
| `/profile` | `ProfileScreen` | Dashboard card or drawer, `Navigator.pushNamed` |
| `/service-request` | `ServiceRequestFormScreen` | Dashboard card, drawer; also direct push from Service Details |
| anything else | `UnknownRouteScreen` | `onUnknownRoute` (Help Centre > "Try a broken link") |

### Short explanation

The Dashboard is the first route and stays at the bottom of the stack. Each card pushes a screen on top with
`Navigator.pushNamed`, and Back or **Return** calls `Navigator.pop`, so the existing Dashboard is revealed again
(no second copy is created). Tapping a service passes that `CampusService` as a route argument, and
`onGenerateRoute` checks its type before building the details screen. The details screen returns `'requested'` with
`Navigator.pop(context, result)`; Services awaits it and shows a SnackBar (after checking `mounted`). Event details
return `true`/`false` for the registration the same way. Extensions: animated `PageRouteBuilder` transition, `Hero`
icon, `Navigator.canPop()` back button, event details route with an object argument, and a 404 screen showing the
unknown route name.

### Test plan (T1-T10)

Automated tests in `test/widget_test.dart` cover T1-T8 (launch, named routes, details arguments, Back/Return,
returned result, direct route, unknown route) and the form test cases (empty submit, invalid ID/email, valid
submit, reset, discard confirmation). Taps on cards and tiles are protected by a `TapGuard`, so rapid double-taps
open a route only once (T10). Screens use scroll views so a narrow window does not overflow (T9).

## Change the starting values

The first values shown on the Dashboard are in the `Student` class and the sample-data lists in `lib/main.dart`, plus the
`_CampusShellState` fields (`_academic`, `_announcement`, `_event`, `_reminders`). Services, timetable and events for
the routes are the `campusServices`, `timetable` and `campusEvents` lists.
