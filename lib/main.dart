// KL UniConnect - Student Campus App (single file: paste into DartPad or lib/main.dart)
// Flutter mini projects in ONE app:
//   1. Scaffold   2. Container dashboard   3. Form (service request)   4. Routes & Navigator
//
// Student : Satya Sukumar Pilli
// ID      : 2300030536
// University: KL
//
// Sections (search for the numbers):
//   [A] Design system     [B] Models + sample data     [C] Route names
//   [D] Reusable widgets  [E] Dashboard / Activities / Profile pages
//   [F] Route screens (Timetable, Services, Details, Events, Profile, 404)
//   [G] Service request FORM     [H] Main Scaffold (CampusShell)     [I] MaterialApp + routes

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================================
// THEME / APP_THEME
// Design system: colours, text styles and the card style used on every screen.
// ============================================================================
class AppColors {
  static const Color primary = Color(0xFF0B3C5D); // deep campus blue
  static const Color primaryLight = Color(0xFF1E6091);
  static const Color accent = Color(0xFFF5A623); // amber
  static const Color accentDark = Color(0xFF8A5300); // readable on warm tint
  static const Color tint = Color(0xFFEAF2F8); // supporting tint 1 (background)
  static const Color warmTint = Color(0xFFFFF4E0); // supporting tint 2
  static const Color successTint = Color(0xFFE6F4EA);
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFB3261E);
  static const Color dangerTint = Color(0xFFFDECEA);
  static const Color text = Color(0xFF1C2B36);
  static const Color muted = Color(0xFF52626F);
  static const Color border = Color(0xFFC9D8E4);
  static const Color whiteSoft = Color(0xCCFFFFFF);
  static const Color whiteFaint = Color(0x33FFFFFF);
}

class Styles {
  // Card style system: one radius, one shadow, one spacing unit.
  static const double radius = 16;
  static const double gap = 16;
  static final BorderRadius corners = BorderRadius.circular(radius);
  static const List<BoxShadow> shadow = [
    BoxShadow(color: Color(0x1A0B3C5D), blurRadius: 10, offset: Offset(0, 4)),
  ];

  // Three clearly different text styles.
  static const TextStyle heading = TextStyle(
      fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text);
  static const TextStyle subheading = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text);
  static const TextStyle body =
      TextStyle(fontSize: 14, height: 1.4, color: AppColors.muted);
}

// ============================================================================
// MODELS / STUDENT
// Student details (editable at run time from the Profile page).
// ============================================================================
/// Every student detail that can be edited from the Profile page / header.
enum StudentField {
  name,
  id,
  university,
  programme,
  faculty,
  semester,
  email,
  advisor,
  contact,
}

extension StudentFieldInfo on StudentField {
  String get label => switch (this) {
        StudentField.name => 'Full name',
        StudentField.id => 'Student ID',
        StudentField.university => 'University',
        StudentField.programme => 'Programme',
        StudentField.faculty => 'Faculty',
        StudentField.semester => 'Semester',
        StudentField.email => 'Email',
        StudentField.advisor => 'Academic advisor',
        StudentField.contact => 'Contact number',
      };

  TextInputType get keyboard => switch (this) {
        StudentField.email => TextInputType.emailAddress,
        StudentField.contact => TextInputType.phone,
        _ => TextInputType.text,
      };
}

class Student {
  // Starting values. They are plain (non-const) fields so the app can edit them.
  static String university = 'KL';
  static String name = 'Satya Sukumar Pilli';
  static String id = '2300030536';
  static String programme = 'B.Tech - Computer Science & Engineering';
  static String faculty = 'Faculty of Engineering & Technology';
  static String semester = 'Semester 5';
  static String email = '2300030536@kl.edu';
  static String advisor = 'Dr. A. Kumar';
  static String contact = '012-345 6789';

  static String get firstName => name.split(' ').first;

  /// First letter of the first and last word of the name, e.g. "SP".
  static String get initials {
    final words =
        name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  /// "KL" -> "KL University"; leaves names that already say "University".
  static String get universityLabel =>
      university.toLowerCase().contains('university')
          ? university
          : '$university University';

  static String valueOf(StudentField field) => switch (field) {
        StudentField.name => name,
        StudentField.id => id,
        StudentField.university => university,
        StudentField.programme => programme,
        StudentField.faculty => faculty,
        StudentField.semester => semester,
        StudentField.email => email,
        StudentField.advisor => advisor,
        StudentField.contact => contact,
      };

  static void update(StudentField field, String value) {
    switch (field) {
      case StudentField.name:
        name = value;
      case StudentField.id:
        id = value;
      case StudentField.university:
        university = value;
      case StudentField.programme:
        programme = value;
      case StudentField.faculty:
        faculty = value;
      case StudentField.semester:
        semester = value;
      case StudentField.email:
        email = value;
      case StudentField.advisor:
        advisor = value;
      case StudentField.contact:
        contact = value;
    }
  }
}

// ============================================================================
// MODELS / CAMPUS_DATA
// Sample data for the dashboard, activities and quick-access services.
// ============================================================================
class Activity {
  final String name;
  final String description;
  final String date;
  final String time;
  final String venue;
  final IconData icon;

  const Activity({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.icon,
  });

  Activity copyWith({
    String? name,
    String? description,
    String? date,
    String? time,
    String? venue,
    IconData? icon,
  }) {
    return Activity(
      name: name ?? this.name,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      icon: icon ?? this.icon,
    );
  }
}

const List<Activity> activities = [
  Activity(
    name: 'Robotics Club Demo Day',
    description: 'See student-built robots in action and meet the club team.',
    date: 'Sat, 3 Oct 2026',
    time: '10:00 AM',
    venue: 'Engineering Lab 2',
    icon: Icons.precision_manufacturing,
  ),
  Activity(
    name: 'Debate Society Trials',
    description: 'Open trials for the inter-university debate squad.',
    date: 'Mon, 5 Oct 2026',
    time: '4:00 PM',
    venue: 'Seminar Room B',
    icon: Icons.record_voice_over,
  ),
  Activity(
    name: 'Photography Walk',
    description: 'Campus photo walk with tips from senior club members.',
    date: 'Wed, 7 Oct 2026',
    time: '5:30 PM',
    venue: 'Main Garden',
    icon: Icons.photo_camera,
  ),
  Activity(
    name: 'Basketball Friendly',
    description: 'Casual matches between faculties. All skill levels welcome.',
    date: 'Fri, 9 Oct 2026',
    time: '6:00 PM',
    venue: 'Sports Centre',
    icon: Icons.sports_basketball,
  ),
  Activity(
    name: 'Entrepreneurship Pitch Night',
    description: 'Pitch your startup idea to a panel of local founders.',
    date: 'Tue, 13 Oct 2026',
    time: '7:00 PM',
    venue: 'Innovation Hub',
    icon: Icons.lightbulb,
  ),
  Activity(
    name: 'Volunteer Clean-up Drive',
    description: 'Join the Volunteer Society for a community clean-up.',
    date: 'Sat, 17 Oct 2026',
    time: '8:00 AM',
    venue: 'Main Gate',
    icon: Icons.volunteer_activism,
  ),
];

class Reminder {
  final String title;
  final String when;
  const Reminder(this.title, this.when);
}

class Service {
  final String label;
  final String caption;
  final IconData icon;
  final String message;
  const Service(this.label, this.caption, this.icon, this.message);

  Service copyWith({
    String? label,
    String? caption,
    IconData? icon,
    String? message,
  }) {
    return Service(
      label ?? this.label,
      caption ?? this.caption,
      icon ?? this.icon,
      message ?? this.message,
    );
  }
}

/// Dashboard "Academic snapshot" values (semester lives in [Student.semester]).
class Academic {
  const Academic({
    required this.cgpa,
    required this.credits,
    required this.attendance,
  });

  final String cgpa;
  final String credits;
  final double attendance; // percent, 0-100

  static const double minAttendance = 75;

  bool get onTrack => attendance >= minAttendance;

  String get attendanceText =>
      attendance.toStringAsFixed(attendance == attendance.roundToDouble() ? 0 : 1);
}

/// Dashboard "Campus announcement" card text.
class Announcement {
  const Announcement({required this.title, required this.body});
  final String title;
  final String body;
}

/// Dashboard "Student life" featured event.
class FeaturedEvent {
  const FeaturedEvent({
    required this.month,
    required this.day,
    required this.title,
    required this.time,
    required this.venue,
  });

  final String month;
  final String day;
  final String title;
  final String time;
  final String venue;
}

const List<Service> services = [
  Service('Timetable', 'Next: Flutter Lab, 9:00 AM', Icons.calendar_month,
      'Timetable: Flutter Lab at 9:00 AM in Lab 3'),
  Service('Results', 'Semester 4 published', Icons.assessment,
      'Results: Semester 4 results are available'),
  Service('Library', '2 books due Friday', Icons.local_library,
      'Library: 2 books are due this Friday'),
  Service('Fees', 'Fully paid', Icons.payments,
      'Fees: no outstanding balance'),
  Service('Shuttle', 'Next bus 8:15 AM', Icons.directions_bus,
      'Shuttle: next bus leaves at 8:15 AM from Block A'),
  Service('Helpdesk', 'IT and admin support', Icons.support_agent,
      'Helpdesk: opening a support ticket (sample)'),
];

const List<String> sampleNotifications = [
  'Semester registration closes Friday at 5:00 PM.',
  'Robotics Club Demo Day is this Saturday.',
  'Library: 2 books are due this Friday.',
];

// ============================================================================
// MODELS / CAMPUS_SERVICE
// Data models used by the Navigator screens: services, timetable and events.
// ============================================================================
/// A campus service. The selected object is passed to the Service Details
/// route as a route argument (Navigator.pushNamed(..., arguments: service)).
class CampusService {
  const CampusService({
    required this.name,
    required this.description,
    required this.location,
    required this.openingHours,
    required this.contact,
    required this.status,
    required this.icon,
    required this.color,
    required this.requestCategory,
  });

  final String name;
  final String description;
  final String location;
  final String openingHours;
  final String contact;
  final String status; // e.g. "Open now"
  final IconData icon;
  final Color color;

  /// Category pre-selected when the service request form is opened from here.
  final String requestCategory;
}

const List<CampusService> campusServices = [
  CampusService(
    name: 'Accommodation Office',
    description: 'Hostel allocation, room change requests, maintenance '
        'reports and visitor passes for on-campus residents.',
    location: 'Student Centre, Level 2',
    openingHours: '8:30 AM - 5:00 PM (Mon - Fri)',
    contact: 'housing@kl.edu',
    status: 'Open now',
    icon: Icons.home_work,
    color: Color(0xFF0B3C5D),
    requestCategory: 'Accommodation',
  ),
  CampusService(
    name: 'Central Library',
    description: 'Book loans, quiet study rooms, journals and printing. '
        'Group rooms can be booked up to three days ahead.',
    location: 'Library Block, Ground Floor',
    openingHours: '8:00 AM - 10:00 PM (Daily)',
    contact: 'library@kl.edu',
    status: 'Open now',
    icon: Icons.local_library,
    color: Color(0xFF1E6091),
    requestCategory: 'Library',
  ),
  CampusService(
    name: 'Counselling Centre',
    description: 'Free, confidential one-to-one sessions and workshops on '
        'study stress, time management and wellbeing.',
    location: 'Wellness Wing, Level 1',
    openingHours: '9:00 AM - 4:30 PM (Mon - Fri)',
    contact: 'counselling@kl.edu',
    status: 'Appointments only',
    icon: Icons.psychology,
    color: Color(0xFF2E7D32),
    requestCategory: 'Counselling',
  ),
  CampusService(
    name: 'IT Helpdesk',
    description: 'Wi-Fi access, student portal passwords, lab software and '
        'laptop support.',
    location: 'Engineering Block, Room E-012',
    openingHours: '9:00 AM - 6:00 PM (Mon - Sat)',
    contact: 'ithelp@kl.edu',
    status: 'Open now',
    icon: Icons.support_agent,
    color: Color(0xFF8A5300),
    requestCategory: 'IT Helpdesk',
  ),
  CampusService(
    name: 'Career Services',
    description: 'CV reviews, mock interviews, internship listings and '
        'employer meet-ups.',
    location: 'Innovation Hub, Level 3',
    openingHours: '10:00 AM - 5:00 PM (Mon - Fri)',
    contact: 'careers@kl.edu',
    status: 'Closed - opens 10:00 AM',
    icon: Icons.work,
    color: Color(0xFF6A1B9A),
    requestCategory: 'Career Services',
  ),
  CampusService(
    name: 'Campus Clinic',
    description: 'Basic health checks, first aid and referrals. Bring your '
        'student card.',
    location: 'Block C, Ground Floor',
    openingHours: '8:00 AM - 8:00 PM (Daily)',
    contact: 'clinic@kl.edu',
    status: 'Open now',
    icon: Icons.local_hospital,
    color: Color(0xFFB3261E),
    requestCategory: 'Campus Clinic',
  ),
];

/// One class in the weekly timetable.
class ClassEntry {
  const ClassEntry({
    required this.day,
    required this.time,
    required this.module,
    required this.room,
    this.isNext = false,
  });

  final String day;
  final String time;
  final String module;
  final String room;
  final bool isNext; // highlighted on the Timetable and shown on the dashboard
}

const List<ClassEntry> timetable = [
  ClassEntry(
    day: 'Mon',
    time: '10:00 AM - 12:00 PM',
    module: 'Database Systems',
    room: 'Room B-204',
  ),
  ClassEntry(
    day: 'Tue',
    time: '9:00 AM - 11:00 AM',
    module: 'Flutter Lab',
    room: 'Lab 3',
    isNext: true,
  ),
  ClassEntry(
    day: 'Wed',
    time: '2:00 PM - 4:00 PM',
    module: 'Computer Networks',
    room: 'Room A-110',
  ),
  ClassEntry(
    day: 'Thu',
    time: '11:00 AM - 12:00 PM',
    module: 'Software Engineering',
    room: 'Room B-301',
  ),
  ClassEntry(
    day: 'Fri',
    time: '9:00 AM - 10:00 AM',
    module: 'Operating Systems',
    room: 'Room A-105',
  ),
];

/// The class highlighted as "next" (falls back to the first class).
ClassEntry get nextClass =>
    timetable.firstWhere((c) => c.isNext, orElse: () => timetable.first);

/// A campus event. [registered] is mutable so the registration made on the
/// details route is still visible when the user comes back to the list.
class CampusEvent {
  CampusEvent({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.venue,
    required this.icon,
    this.registered = false,
  });

  final String title;
  final String description;
  final String date;
  final String time;
  final String venue;
  final IconData icon;
  bool registered;
}

final List<CampusEvent> campusEvents = [
  CampusEvent(
    title: 'Career Fair 2026',
    description: 'Meet 40+ employers, drop off your CV and join short '
        'on-the-spot interviews. Smart casual dress code.',
    date: 'Thu, 15 Oct 2026',
    time: '10:00 AM',
    venue: 'Main Hall',
    icon: Icons.business_center,
  ),
  CampusEvent(
    title: 'Inter-College Hackathon',
    description: '24-hour build challenge in teams of four. Mentors from '
        'industry will be on site and prizes go to the top three teams.',
    date: 'Sat, 24 Oct 2026',
    time: '9:00 AM',
    venue: 'Innovation Hub',
    icon: Icons.code,
  ),
  CampusEvent(
    title: 'Cultural Night',
    description: 'Music, dance and food stalls presented by student '
        'societies from every faculty.',
    date: 'Fri, 30 Oct 2026',
    time: '7:30 PM',
    venue: 'Open Air Theatre',
    icon: Icons.theater_comedy,
  ),
  CampusEvent(
    title: 'First Aid Training',
    description: 'A practical half-day course on CPR and basic first aid '
        'run by the Campus Clinic. Certificates are provided.',
    date: 'Wed, 4 Nov 2026',
    time: '2:00 PM',
    venue: 'Block C, Seminar Room',
    icon: Icons.health_and_safety,
  ),
];

// ============================================================================
// ROUTES / APP_ROUTES
// Route names are defined once here and reused for BOTH registration (main.dart)
// and navigation (Navigator.pushNamed), so a typo can never break a link.
// ============================================================================
class AppRoutes {
  static const home = '/';
  static const timetable = '/timetable';
  static const services = '/services';
  static const serviceDetail = '/service-detail'; // needs a CampusService argument
  static const events = '/events';
  static const profile = '/profile';
  static const requestForm = '/service-request';

  /// Route map used in the route report (README) and the unknown-route screen.
  static const all = <String>[
    home,
    timetable,
    services,
    serviceDetail,
    events,
    profile,
    requestForm,
  ];
}

// ============================================================================
// WIDGETS / COMMON_WIDGETS
// Reusable widgets shared by several screens.
// ============================================================================
/// Section heading used across pages.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text,
      {super.key, this.onEdit, this.editTooltip = 'Edit'});
  final String text;
  final VoidCallback? onEdit;
  final String editTooltip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 2),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: Styles.heading.copyWith(fontSize: 18)),
          ),
          if (onEdit != null)
            IconButton(
              tooltip: editTooltip,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.edit, size: 20, color: AppColors.primary),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}

/// Small coloured status badge (Container with border, radius and padding).
class StatusBadge extends StatelessWidget {
  const StatusBadge(this.label,
      {super.key,
      this.textColor = AppColors.accentDark,
      this.background = AppColors.warmTint,
      this.borderColor = AppColors.accent});

  final String label;
  final Color textColor;
  final Color background;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w700, color: textColor),
      ),
    );
  }
}

/// Reusable quick-access card. A Container provides size, decoration and
/// constraints; Material + InkWell on top give a visible tap ripple.
class CampusActionCard extends StatelessWidget {
  const CampusActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.caption,
    required this.background,
    required this.onTap,
    this.onEdit,
    this.width,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color background;
  final VoidCallback onTap;
  final VoidCallback? onEdit; // shows a small edit button when provided
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 110),
      decoration: BoxDecoration(
        color: background,
        borderRadius: Styles.corners,
        border: Border.all(color: AppColors.border),
        boxShadow: Styles.shadow,
      ),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: Styles.corners,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(label, style: Styles.subheading),
                    const SizedBox(height: 2),
                    Text(caption,
                        style: Styles.body.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ),
          if (onEdit != null)
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                tooltip: 'Edit $label',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit, size: 18, color: AppColors.muted),
                onPressed: onEdit,
              ),
            ),
        ],
      ),
    );
  }
}

/// Announcement card - tapping it changes its colour/badge (local setState).
class AnnouncementCard extends StatefulWidget {
  const AnnouncementCard({
    super.key,
    required this.title,
    required this.body,
    required this.onMessage,
  });
  final String title;
  final String body;
  final void Function(String message) onMessage;

  @override
  State<AnnouncementCard> createState() => _AnnouncementCardState();
}

class _AnnouncementCardState extends State<AnnouncementCard> {
  bool _noted = false;

  @override
  Widget build(BuildContext context) {
    final Color accent = _noted ? AppColors.success : AppColors.accent;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: _noted ? AppColors.successTint : AppColors.warmTint,
        borderRadius: Styles.corners,
        border: Border.all(color: accent, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Styles.corners,
          onTap: () {
            setState(() => _noted = !_noted);
            widget.onMessage(_noted
                ? 'Announcement noted - we will remind you before the deadline'
                : 'Announcement marked as not noted');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_noted ? Icons.check_circle : Icons.campaign,
                    color: _noted ? AppColors.success : AppColors.accentDark,
                    size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:
                                Text(widget.title, style: Styles.subheading),
                          ),
                          _noted
                              ? const StatusBadge('Noted',
                                  textColor: AppColors.success,
                                  background: Colors.white,
                                  borderColor: AppColors.success)
                              : const StatusBadge('Due soon'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(widget.body, style: Styles.body),
                      const SizedBox(height: 8),
                      Text(
                        _noted ? 'Tap to undo' : 'Tap to mark as noted',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGETS / EDIT_DIALOG
// One reusable edit dialog used by every edit option.
// ============================================================================
/// One text field in the edit dialog.
class EditField {
  const EditField(
    this.label,
    this.initial, {
    this.hint,
    this.keyboard,
    this.maxLines = 1,
    this.required = true,
    this.validator,
  });

  final String label;
  final String initial;
  final String? hint;
  final TextInputType? keyboard;
  final int maxLines;
  final bool required;
  final String? Function(String value)? validator;
}

/// Trimmed values (same order as the fields) and the chosen icon, if any.
class EditResult {
  const EditResult(this.values, this.icon);
  final List<String> values;
  final IconData? icon;
}

/// Icons offered when editing a service or an activity.
const List<IconData> iconChoices = [
  Icons.calendar_month,
  Icons.assessment,
  Icons.local_library,
  Icons.payments,
  Icons.directions_bus,
  Icons.support_agent,
  Icons.restaurant,
  Icons.local_hospital,
  Icons.wifi,
  Icons.science,
  Icons.sports_soccer,
  Icons.work,
  Icons.event,
  Icons.groups,
  Icons.school,
  Icons.menu_book,
  Icons.precision_manufacturing,
  Icons.record_voice_over,
  Icons.photo_camera,
  Icons.sports_basketball,
  Icons.lightbulb,
  Icons.volunteer_activism,
];

String? Function(String) numberBetween(double min, double max) {
  return (String v) {
    final n = double.tryParse(v);
    if (n == null || n.isNaN || n < min || n > max) {
      return 'Enter a number from ${min.toStringAsFixed(0)} '
          'to ${max.toStringAsFixed(0)}';
    }
    return null;
  };
}

String? Function(String) integerBetween(int min, int max) {
  return (String v) {
    final n = int.tryParse(v);
    if (n == null || n < min || n > max) {
      return 'Enter a whole number from $min to $max';
    }
    return null;
  };
}

/// Shows the edit dialog. Returns null when cancelled.
/// Pass [icon] to also show an icon picker.
Future<EditResult?> showEditDialog(
  BuildContext context, {
  required String title,
  required List<EditField> fields,
  IconData? icon,
}) {
  return showDialog<EditResult>(
    context: context,
    builder: (_) => _EditDialog(title: title, fields: fields, icon: icon),
  );
}

class _EditDialog extends StatefulWidget {
  const _EditDialog({required this.title, required this.fields, this.icon});

  final String title;
  final List<EditField> fields;
  final IconData? icon;

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers = [
    for (final f in widget.fields) TextEditingController(text: f.initial),
  ];
  late IconData? _icon = widget.icon;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validate(EditField field, String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return field.required ? 'Required' : null;
    return field.validator?.call(value);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      EditResult([for (final c in _controllers) c.text.trim()], _icon),
    );
  }

  Widget _iconPicker(IconData current) {
    final choices = [if (!iconChoices.contains(current)) current, ...iconChoices];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final ic in choices)
          Semantics(
            button: true,
            selected: ic == _icon,
            label: 'Choose icon',
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => setState(() => _icon = ic),
              child: Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ic == _icon ? AppColors.primary : AppColors.tint,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ic == _icon ? AppColors.accent : AppColors.border,
                    width: ic == _icon ? 2 : 1,
                  ),
                ),
                child: Icon(ic,
                    color: ic == _icon ? Colors.white : AppColors.primary),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < widget.fields.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      controller: _controllers[i],
                      autofocus: i == 0,
                      keyboardType: widget.fields[i].keyboard,
                      maxLines: widget.fields[i].maxLines,
                      decoration: InputDecoration(
                        labelText: widget.fields[i].label,
                        hintText: widget.fields[i].hint,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => _validate(widget.fields[i], v),
                    ),
                  ),
                if (_icon != null) ...[
                  const SizedBox(height: 16),
                  const Text('Icon', style: Styles.subheading),
                  const SizedBox(height: 8),
                  _iconPicker(widget.icon!),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

// ============================================================================
// WIDGETS / STUDENT_EDIT
// Edit helpers for the student's details, shared by the Profile tab (inside the
// main Scaffold) and the Profile route. Each returns true when something saved.
// ============================================================================
Future<bool> editStudentField(BuildContext context, StudentField field) async {
  final result = await showEditDialog(
    context,
    title: 'Edit ${field.label}',
    fields: [
      EditField(
        field.label,
        Student.valueOf(field),
        keyboard: field.keyboard,
        validator: field == StudentField.email
            ? (v) => v.contains('@') ? null : 'Enter a valid email address'
            : null,
      ),
    ],
  );
  if (result == null) return false;
  Student.update(field, result.values.first);
  return true;
}

Future<bool> editStudentHeader(BuildContext context) async {
  final result = await showEditDialog(
    context,
    title: 'Edit profile details',
    fields: [
      EditField(StudentField.name.label, Student.name),
      EditField(StudentField.programme.label, Student.programme),
      EditField(StudentField.id.label, Student.id),
      EditField(StudentField.university.label, Student.university),
    ],
  );
  if (result == null) return false;
  final v = result.values;
  Student.name = v[0];
  Student.programme = v[1];
  Student.id = v[2];
  Student.university = v[3];
  return true;
}

// ============================================================================
// WIDGETS / CAMPUS_APP_BAR
// AppBar shared by every pushed route, so all screens keep one consistent style.
// ============================================================================
/// Pops the current route only when there is a route underneath it.
/// Navigator.canPop() makes the custom back button safe on the first route.
void popIfPossible(BuildContext context, [Object? result]) {
  if (Navigator.canPop(context)) {
    Navigator.pop(context, result); // reveals the previous route (no new Home)
  }
}

PreferredSizeWidget campusAppBar(
  BuildContext context,
  String title, {
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
    ),
    // Custom back control built on Navigator.canPop() (extension feature).
    leading: Navigator.canPop(context)
        ? IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back),
            // maybePop() respects PopScope, so a form can ask "discard?" first.
            onPressed: () => Navigator.maybePop(context),
          )
        : null,
    actions: actions,
  );
}

/// Runs one async action at a time. Ignoring taps while a route is already
/// open prevents rapid double-taps from pushing the same screen twice.
class TapGuard {
  bool _busy = false;

  Future<void> run(Future<void> Function() action) async {
    if (_busy) return;
    _busy = true;
    try {
      await action();
    } finally {
      _busy = false;
    }
  }
}

// ============================================================================
// WIDGETS / NAVIGATION_CARD
// Dashboard card that opens another route.
// ============================================================================
/// A Container card with an InkWell. The ripple shows the pressed state and
/// [TapGuard] ignores a second tap while the pushed route is still open.
class NavigationCard extends StatefulWidget {
  const NavigationCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onOpen,
    this.width,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Future<void> Function() onOpen;
  final double? width;

  @override
  State<NavigationCard> createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  final TapGuard _guard = TapGuard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      constraints: const BoxConstraints(minHeight: 96),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(color: AppColors.border),
        boxShadow: Styles.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Styles.corners,
          onTap: () => _guard.run(widget.onOpen),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.warmTint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent),
                  ),
                  child: Icon(widget.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: Styles.subheading.copyWith(fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(widget.subtitle,
                          style: Styles.body.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGETS / CAMPUS_FORM_FIELDS
// Reusable, consistently styled form controls for the Service Request form.
// Every control autovalidates on user interaction and shows readable error text
// (with an icon, so errors never rely on colour alone).
// ============================================================================
/// Field fill colour used by all inputs on the request form.
const Color kFieldFill = Color(0xFFF6F9FC);

/// One InputDecoration for every field: same radius, border, focus and error
/// styles, plus a prefix icon.
InputDecoration campusInputDecoration({
  required String label,
  required IconData icon,
  String? hint,
  String? errorText,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    errorText: errorText,
    errorMaxLines: 3,
    prefixIcon: Icon(icon, color: AppColors.primary),
    filled: true,
    fillColor: kFieldFill,
    border: border(AppColors.border),
    enabledBorder: border(AppColors.border),
    focusedBorder: border(AppColors.primary, 2),
    errorBorder: border(AppColors.danger, 1.5),
    focusedErrorBorder: border(AppColors.danger, 2),
    errorStyle: const TextStyle(
        color: AppColors.danger, fontWeight: FontWeight.w600, fontSize: 12.5),
  );
}

/// Small error line with an icon, used by the custom FormFields below.
Widget _errorLine(String message) {
  return Padding(
    padding: const EdgeInsets.only(top: 6, left: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, size: 16, color: AppColors.danger),
        const SizedBox(width: 6),
        Expanded(
          child: Text(message,
              style: const TextStyle(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5)),
        ),
      ],
    ),
  );
}

/// Reusable text input (advanced option: reusable CampusTextField widget).
class CampusTextField extends StatelessWidget {
  const CampusTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.onSaved,
    this.hint,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String? value) validator;
  final void Function(String? value)? onSaved;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final int? minLines;
  final int maxLines;

  /// When set, Flutter shows a live "typed/max" character counter.
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: campusInputDecoration(label: label, icon: icon, hint: hint),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 16, color: AppColors.text),
      // Errors appear after the user has interacted with the field.
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      onSaved: onSaved,
    );
  }
}

/// Reusable dropdown (advanced option: reusable CampusDropdown widget).
class CampusDropdown extends StatelessWidget {
  const CampusDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.validator,
    this.onSaved,
  });

  final String label;
  final IconData icon;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? Function(String? value) validator;
  final void Function(String? value)? onSaved;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      // ignore: deprecated_member_use
      value: value,
      isExpanded: true,
      decoration: campusInputDecoration(label: label, icon: icon),
      items: [
        for (final item in items)
          DropdownMenuItem<String>(
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}

/// Single-choice chips as a FormField, so validate/save/reset all work.
/// Do NOT pass an initialValue: reset() must return the field to "nothing chosen".
class CampusChoiceField extends FormField<String> {
  CampusChoiceField({
    super.key,
    required String label,
    required IconData icon,
    required List<String> options,
    required ValueChanged<String> onSelected,
    required FormFieldValidator<String> validator,
    FormFieldSetter<String>? onSaved,
    String Function(String selected)? helperFor,
  }) : super(
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<String> state) {
            final String? selected = state.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(label,
                        style: Styles.subheading.copyWith(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final option in options)
                      ChoiceChip(
                        label: Text(option),
                        selected: selected == option,
                        selectedColor: AppColors.primary,
                        backgroundColor: kFieldFill,
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                            color: selected == option
                                ? AppColors.primary
                                : AppColors.border),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected == option
                              ? Colors.white
                              : AppColors.text,
                        ),
                        onSelected: (_) {
                          state.didChange(option);
                          onSelected(option);
                        },
                      ),
                  ],
                ),
                if (helperFor != null && selected != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 4),
                    child: Text(helperFor(selected), style: Styles.body),
                  ),
                if (state.errorText != null) _errorLine(state.errorText!),
              ],
            );
          },
        );
}

/// Date input as a FormField that opens the date picker.
class CampusDateField extends FormField<DateTime> {
  CampusDateField({
    super.key,
    required String label,
    required String hint,
    required Future<DateTime?> Function(DateTime? current) onPick,
    required String Function(DateTime date) format,
    required FormFieldValidator<DateTime> validator,
    FormFieldSetter<DateTime>? onSaved,
    ValueChanged<DateTime>? onChanged,
  }) : super(
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<DateTime> state) {
            final DateTime? date = state.value;
            return Semantics(
              button: true,
              label: label,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final DateTime? picked = await onPick(date);
                  if (picked == null || !state.mounted) return;
                  state.didChange(picked);
                  onChanged?.call(picked);
                },
                child: InputDecorator(
                  decoration: campusInputDecoration(
                    label: label,
                    icon: Icons.event,
                    errorText: state.errorText,
                  ),
                  // The label always floats so it never overlaps the value.
                  isEmpty: false,
                  child: Text(
                    date == null ? hint : format(date),
                    style: TextStyle(
                      fontSize: 16,
                      color: date == null ? AppColors.muted : AppColors.text,
                    ),
                  ),
                ),
              ),
            );
          },
        );
}

/// Card with a heading, used to group related fields.
class FormSectionCard extends StatelessWidget {
  const FormSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Styles.gap),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(color: AppColors.border),
        boxShadow: Styles.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accentDark),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: Styles.heading.copyWith(fontSize: 18)),
              ),
            ],
          ),
          const Divider(height: 24),
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(height: 14),
            children[i],
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// SCREENS / ACTIVITIES_PAGE
// Activities tab.
// ============================================================================
class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({
    super.key,
    required this.activities,
    required this.favourites,
    required this.registered,
    required this.onFavourite,
    required this.onRegister,
    required this.onEdit,
  });

  final List<Activity> activities;
  final Set<int> favourites;
  final Set<int> registered;
  final void Function(int index) onFavourite;
  final void Function(int index) onRegister;
  final void Function(int index) onEdit;

  Widget _info(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: Styles.body.copyWith(fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: activities.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Campus Activities', style: Styles.heading),
                const SizedBox(height: 4),
                Text(
                  '${registered.length} registered  |  ${favourites.length} favourites',
                  style: Styles.body,
                ),
              ],
            ),
          );
        }

        final int i = index - 1;
        final Activity a = activities[i];
        final bool isFav = favourites.contains(i);
        final bool isRegistered = registered.contains(i);

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: Styles.corners,
            side: BorderSide(
              color: isRegistered ? AppColors.success : AppColors.border,
              width: isRegistered ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.tint,
                      child: Icon(a.icon, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(a.name, style: Styles.subheading)),
                    IconButton(
                      tooltip: 'Edit ${a.name}',
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.primary),
                      onPressed: () => onEdit(i),
                    ),
                    IconButton(
                      tooltip: isFav ? 'Remove favourite' : 'Add to favourites',
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppColors.muted,
                      ),
                      onPressed: () => onFavourite(i),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(a.description, style: Styles.body),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    _info(Icons.event, a.date),
                    _info(Icons.schedule, a.time),
                    _info(Icons.location_on, a.venue),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: isRegistered
                      ? OutlinedButton.icon(
                          onPressed: () => onRegister(i),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            foregroundColor: AppColors.success,
                            side: const BorderSide(color: AppColors.success),
                          ),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Registered'),
                        )
                      : ElevatedButton.icon(
                          onPressed: () => onRegister(i),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(48, 48),
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.how_to_reg),
                          label: const Text('Register'),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// SCREENS / PROFILE_PAGE
// Profile tab.
// ============================================================================
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.registeredCount,
    required this.favouriteCount,
    required this.reminderCount,
    required this.onEditField,
    required this.onEditHeader,
    this.showStats = true,
    this.footer,
  });

  final int registeredCount;
  final int favouriteCount;
  final int reminderCount;
  final void Function(StudentField field) onEditField;
  final VoidCallback onEditHeader;

  /// The Profile route hides the dashboard counters and adds a [footer].
  final bool showStats;
  final Widget? footer;

  Widget _stat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Styles.corners,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(value, style: Styles.heading.copyWith(fontSize: 20)),
            Text(label, style: Styles.body.copyWith(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _detail(IconData icon, StudentField field) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(field.label, style: Styles.body.copyWith(fontSize: 12)),
      subtitle: Text(Student.valueOf(field), style: Styles.subheading),
      trailing: IconButton(
        tooltip: 'Edit ${field.label}',
        icon: const Icon(Icons.edit, color: AppColors.primary),
        onPressed: () => onEditField(field),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 96),
        child: Column(
          children: [
            Container(
              width: 104,
              height: 104,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent, width: 4),
                boxShadow: Styles.shadow,
              ),
              child: Text(
                Student.initials,
                style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Text(Student.name,
                style: Styles.heading, textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(Student.programme,
                style: Styles.body, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const StatusBadge('Active student',
                textColor: AppColors.success,
                background: AppColors.successTint,
                borderColor: AppColors.success),
            TextButton.icon(
              onPressed: onEditHeader,
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit name & programme'),
            ),
            const SizedBox(height: 12),
            if (showStats)
              Row(
                children: [
                  _stat(Icons.how_to_reg, '$registeredCount', 'Registered'),
                  _stat(Icons.favorite, '$favouriteCount', 'Favourites'),
                  _stat(Icons.alarm, '$reminderCount', 'Reminders'),
                ],
              ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: Styles.corners,
                side: const BorderSide(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _detail(Icons.badge, StudentField.id),
                  const Divider(height: 1),
                  _detail(Icons.apartment, StudentField.university),
                  const Divider(height: 1),
                  _detail(Icons.account_balance, StudentField.faculty),
                  const Divider(height: 1),
                  _detail(Icons.school, StudentField.semester),
                  const Divider(height: 1),
                  _detail(Icons.person_pin, StudentField.advisor),
                  const Divider(height: 1),
                  _detail(Icons.email, StudentField.email),
                  const Divider(height: 1),
                  _detail(Icons.phone, StudentField.contact),
                ],
              ),
            ),
            if (footer != null) ...[
              const SizedBox(height: 16),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / HOME_PAGE
// Dashboard tab (Container-focused).
// ============================================================================
class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.reminders,
    required this.services,
    required this.academic,
    required this.announcement,
    required this.event,
    required this.onMessage,
    required this.onOpenActivities,
    required this.onOpenRoute,
    required this.onDeleteReminder,
    required this.onEditReminder,
    required this.onEditService,
    required this.onEditAcademic,
    required this.onEditAnnouncement,
    required this.onEditEvent,
    required this.onEditHeader,
  });

  final List<Reminder> reminders;
  final List<Service> services;
  final Academic academic;
  final Announcement announcement;
  final FeaturedEvent event;
  final void Function(String message) onMessage;
  final VoidCallback onOpenActivities;

  /// Opens a named route (the shell pushes it on top of the Dashboard).
  final Future<void> Function(String routeName) onOpenRoute;
  final void Function(int index) onDeleteReminder;
  final void Function(int index) onEditReminder;
  final void Function(int index) onEditService;
  final VoidCallback onEditAcademic;
  final VoidCallback onEditAnnouncement;
  final VoidCallback onEditEvent;
  final VoidCallback onEditHeader;

  // Header: app identity + greeting + profile.
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Styles.radius + 8),
        boxShadow: Styles.shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              Student.initials,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${Student.firstName}!',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  Student.programme,
                  style:
                      const TextStyle(fontSize: 13, color: AppColors.whiteSoft),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.whiteFaint,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'ID ${Student.id}  |  ${Student.university}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit profile details',
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: onEditHeader,
          ),
        ],
      ),
    );
  }

  Widget _indicator(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26),
          const SizedBox(height: 6),
          Text(value,
              style: Styles.heading.copyWith(fontSize: 20),
              textAlign: TextAlign.center),
          Text(label,
              style: Styles.body.copyWith(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Academic snapshot: three indicators + attendance progress bar.
  Widget _academicSnapshot() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(color: AppColors.border),
        boxShadow: Styles.shadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _indicator(
                  Icons.school, 'Semester', Student.semester.split(' ').last),
              _indicator(Icons.star, 'CGPA', academic.cgpa),
              _indicator(Icons.menu_book, 'Credits', academic.credits),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Attendance', style: Styles.subheading),
              academic.onTrack
                  ? const StatusBadge('On track',
                      textColor: AppColors.success,
                      background: AppColors.successTint,
                      borderColor: AppColors.success)
                  : const StatusBadge('Below minimum',
                      textColor: AppColors.danger,
                      background: AppColors.dangerTint,
                      borderColor: AppColors.danger),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (academic.attendance / 100).clamp(0.0, 1.0).toDouble(),
              minHeight: 10,
              backgroundColor: AppColors.tint,
              color: academic.onTrack ? AppColors.primary : AppColors.danger,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
                '${academic.attendanceText}% (minimum required: '
                '${Academic.minAttendance.toStringAsFixed(0)}%)',
                style:
                    const TextStyle(fontSize: 12, color: AppColors.muted)),
          ),
        ],
      ),
    );
  }

  // Summary card: the next class from the timetable. Tapping opens Timetable.
  Widget _nextClassCard() {
    final ClassEntry c = nextClass;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.warmTint,
        borderRadius: Styles.corners,
        border: Border.all(color: AppColors.accent, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Styles.corners,
          onTap: () => onOpenRoute(AppRoutes.timetable),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const Icon(Icons.access_time_filled,
                    color: AppColors.accentDark, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Next class: ${c.module}',
                          style: Styles.subheading),
                      const SizedBox(height: 2),
                      Text('${c.day}  |  ${c.time}  |  ${c.room}',
                          style: Styles.body.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigation cards: each one opens a named route with Navigator.pushNamed.
  Widget _campusAreas() {
    return Column(
      children: [
        _nextClassCard(),
        for (final item in <(IconData, String, String, String)>[
          (Icons.schedule, 'Timetable', 'Your weekly classes and rooms',
              AppRoutes.timetable),
          (Icons.apartment, 'Campus Services',
              'Accommodation, library, counselling and more', AppRoutes.services),
          (Icons.event, 'Campus Events', 'Career fair, hackathon, cultural night',
              AppRoutes.events),
          (Icons.support_agent, 'Service Request',
              'Send a help request to a campus team', AppRoutes.requestForm),
          (Icons.badge, 'Student Profile', 'View and edit your details',
              AppRoutes.profile),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NavigationCard(
              icon: item.$1,
              title: item.$2,
              subtitle: item.$3,
              onOpen: () => onOpenRoute(item.$4),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // Quick access: 2-column Wrap of reusable cards.
  Widget _quickAccess() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 12;
        final double cardWidth = (constraints.maxWidth - spacing) / 2;
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (int i = 0; i < services.length; i++)
                CampusActionCard(
                  width: cardWidth,
                  icon: services[i].icon,
                  label: services[i].label,
                  caption: services[i].caption,
                  background: i.isEven ? Colors.white : AppColors.warmTint,
                  onTap: () => onMessage(services[i].message),
                  onEdit: () => onEditService(i),
                ),
            ],
          ),
        );
      },
    );
  }

  // Student life: featured event with date tile.
  Widget _eventCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(color: AppColors.border),
        boxShadow: Styles.shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(event.month,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent)),
                Text(event.day,
                    style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: Styles.subheading),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(event.time,
                          style: Styles.body, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on,
                        size: 16, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(event.venue,
                          style: Styles.body, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const StatusBadge('Open',
                        textColor: AppColors.success,
                        background: AppColors.successTint,
                        borderColor: AppColors.success),
                    const Spacer(),
                    TextButton(
                      onPressed: onOpenActivities,
                      child: const Text('See all'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reminderList() {
    if (reminders.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Styles.corners,
          border: Border.all(color: AppColors.border),
        ),
        child: const Text(
          'No reminders yet. Tap the + Reminder button to add one.',
          style: Styles.body,
        ),
      );
    }
    return Column(
      children: [
        for (int i = 0; i < reminders.length; i++)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(left: 14, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Styles.corners,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.alarm, color: AppColors.accentDark),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reminders[i].title, style: Styles.subheading),
                      Text(reminders[i].when,
                          style: Styles.body.copyWith(fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit reminder',
                  icon: const Icon(Icons.edit_outlined),
                  color: AppColors.primary,
                  onPressed: () => onEditReminder(i),
                ),
                IconButton(
                  tooltip: 'Delete reminder',
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.muted,
                  onPressed: () => onDeleteReminder(i),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SectionTitle('Academic snapshot',
                onEdit: onEditAcademic,
                editTooltip: 'Edit academic snapshot'),
            _academicSnapshot(),
            const SectionTitle('Explore campus'),
            _campusAreas(),
            const SectionTitle('Quick access'),
            _quickAccess(),
            SectionTitle('Campus announcement',
                onEdit: onEditAnnouncement, editTooltip: 'Edit announcement'),
            AnnouncementCard(
              title: announcement.title,
              body: announcement.body,
              onMessage: onMessage,
            ),
            SectionTitle('Student life',
                onEdit: onEditEvent, editTooltip: 'Edit featured event'),
            _eventCard(),
            const SectionTitle('My reminders'),
            _reminderList(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / PROFILE_SCREEN
// Route: AppRoutes.profile (named route). Back returns to the previous route.
// ============================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _eventAlerts = true; // simple "settings" action using setState()

  Future<void> _edit(Future<bool> Function() editor, String message) async {
    final saved = await editor();
    if (!mounted || !saved) return;
    setState(() {}); // Student values changed: rebuild with the new details
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: campusAppBar(context, 'Student Profile'),
      body: ProfilePage(
        registeredCount: 0,
        favouriteCount: 0,
        reminderCount: 0,
        showStats: false,
        onEditField: (StudentField field) =>
            _edit(() => editStudentField(context, field), '${field.label} updated'),
        onEditHeader: () =>
            _edit(() => editStudentHeader(context), 'Profile updated'),
        footer: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: Styles.corners,
            border: Border.all(color: AppColors.border),
          ),
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_active,
                color: AppColors.primary),
            title: const Text('Event reminders', style: Styles.subheading),
            subtitle: const Text('Get a reminder the day before events you '
                'registered for.',
                style: Styles.body),
            value: _eventAlerts,
            onChanged: (value) {
              setState(() => _eventAlerts = value);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(value
                        ? 'Event reminders turned on'
                        : 'Event reminders turned off'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / TIMETABLE_SCREEN
// Route: AppRoutes.timetable (named route). Back pops to the Dashboard.
// ============================================================================
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  Widget _classCard(ClassEntry c) {
    final bool next = c.isNext;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // The next class is highlighted with the warm tint and an accent border.
        color: next ? AppColors.warmTint : Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(
            color: next ? AppColors.accent : AppColors.border,
            width: next ? 1.5 : 1),
        boxShadow: Styles.shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              c.day,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.module, style: Styles.subheading),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(c.time,
                          style: Styles.body, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.meeting_room,
                        size: 16, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Text(c.room, style: Styles.body),
                  ],
                ),
              ],
            ),
          ),
          if (next) const StatusBadge('Next class'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: campusAppBar(context, 'Timetable'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('This week', style: Styles.heading),
            const SizedBox(height: 4),
            Text('${timetable.length} classes  |  Semester 5', style: Styles.body),
            const SizedBox(height: 14),
            for (final c in timetable) _classCard(c),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
                // Pops the Timetable route so the existing Dashboard is revealed.
                onPressed: () => popIfPossible(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Return to dashboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / SERVICES_SCREEN
// Route: AppRoutes.services (named route).
// Selecting a tile pushes Service Details and waits for its returned result.
// ============================================================================
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final TapGuard _guard = TapGuard();
  final Set<String> _requested = {}; // services with a recorded appointment

  Future<void> _openDetails(CampusService service) {
    return _guard.run(() async {
      // Named route + argument: the selected object travels to the details route.
      final result = await Navigator.pushNamed(
        context,
        AppRoutes.serviceDetail,
        arguments: service,
      );
      // Never use the context after an await without checking mounted.
      if (!mounted) return;
      if (result == 'requested') {
        setState(() => _requested.add(service.name));
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content:
                  Text('Appointment request recorded for ${service.name}.'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.success,
            ),
          );
      }
    });
  }

  Widget _tile(CampusService s) {
    final bool requested = _requested.contains(s.name);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(
            color: requested ? AppColors.success : AppColors.border,
            width: requested ? 1.5 : 1),
        boxShadow: Styles.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Styles.corners,
          onTap: () => _openDetails(s),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Hero: this icon flies into the details screen.
                Hero(
                  tag: 'service-icon-${s.name}',
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: s.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(s.icon, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: Styles.subheading),
                      const SizedBox(height: 2),
                      Text(s.description,
                          style: Styles.body.copyWith(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      if (requested)
                        const StatusBadge('Appointment requested',
                            textColor: AppColors.success,
                            background: AppColors.successTint,
                            borderColor: AppColors.success)
                      else
                        Text(s.status,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: campusAppBar(context, 'Campus Services'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Find support on campus', style: Styles.heading),
            const SizedBox(height: 4),
            const Text('Tap a service to see its location, hours and contact.',
                style: Styles.body),
            const SizedBox(height: 14),
            for (final s in campusServices) _tile(s),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / SERVICE_DETAIL_SCREEN
// Route: AppRoutes.serviceDetail. Receives a CampusService as its argument and
// returns 'requested' (Navigator.pop(context, result)) to the Services screen.
// ============================================================================
class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.service});

  final CampusService service;

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Styles.body.copyWith(fontSize: 12)),
                Text(value, style: Styles.subheading),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openRequestForm(BuildContext context) async {
    final reference = await Navigator.push<String>(
      context,
      MaterialPageRoute<String>(
        builder: (_) => ServiceRequestFormScreen(
            initialCategory: service.requestCategory),
      ),
    );
    // The form returns its reference number when a request was sent.
    if (!context.mounted || reference == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Request $reference sent to ${service.name}.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool open = service.status.toLowerCase().startsWith('open');
    return Scaffold(
      appBar: campusAppBar(context, service.name),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [service.color, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(Styles.radius + 8),
                  boxShadow: Styles.shadow,
                ),
                child: Row(
                  children: [
                    Hero(
                      tag: 'service-icon-${service.name}',
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(service.icon,
                            color: AppColors.primary, size: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                          const SizedBox(height: 8),
                          StatusBadge(
                            service.status,
                            textColor:
                                open ? AppColors.success : AppColors.accentDark,
                            background:
                                open ? AppColors.successTint : AppColors.warmTint,
                            borderColor:
                                open ? AppColors.success : AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('About this service', style: Styles.heading),
              const SizedBox(height: 6),
              Text(service.description, style: Styles.body),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: Styles.corners,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _infoRow(Icons.location_on, 'Location', service.location),
                    const Divider(height: 1),
                    _infoRow(Icons.schedule, 'Opening hours',
                        service.openingHours),
                    const Divider(height: 1),
                    _infoRow(Icons.email, 'Contact', service.contact),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    backgroundColor: AppColors.primary,
                  ),
                  // Returns a result to the previous route (Services).
                  onPressed: () => popIfPossible(context, 'requested'),
                  icon: const Icon(Icons.event_available),
                  label: const Text('Request an appointment'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 52)),
                  // Direct route (Navigator.push + MaterialPageRoute) with data.
                  onPressed: () => _openRequestForm(context),
                  icon: const Icon(Icons.assignment),
                  label: const Text('Send a written request'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
                  // Return: pops this route; Services becomes visible again.
                  onPressed: () => popIfPossible(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Return'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / EVENT_DETAIL_SCREEN
// Event Details route (opened with a direct MaterialPageRoute).
// Returns the new registration state (true/false) to the Events screen.
// Plain return / system Back returns null, meaning "no change".
// ============================================================================
class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final CampusEvent event;

  Widget _row(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: Styles.subheading)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = event;
    final bool registered = e.registered;
    return Scaffold(
      appBar: campusAppBar(context, 'Event details'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(Styles.radius + 8),
                  boxShadow: Styles.shadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(e.icon, color: AppColors.primary, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(e.title,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              registered
                  ? const StatusBadge('You are registered',
                      textColor: AppColors.success,
                      background: AppColors.successTint,
                      borderColor: AppColors.success)
                  : const StatusBadge('Open for registration'),
              const SizedBox(height: 12),
              _row(Icons.event, e.date),
              _row(Icons.schedule, e.time),
              _row(Icons.location_on, e.venue),
              const SizedBox(height: 12),
              Text(e.description, style: Styles.body),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    backgroundColor:
                        registered ? AppColors.danger : AppColors.primary,
                  ),
                  // Returns the NEW registration state to the Events screen,
                  // which updates itself and shows a SnackBar.
                  onPressed: () => popIfPossible(context, !registered),
                  icon: Icon(registered ? Icons.cancel : Icons.how_to_reg),
                  label: Text(
                      registered ? 'Cancel registration' : 'Register now'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size(48, 52)),
                  // No result: the Events screen keeps its previous state.
                  onPressed: () => popIfPossible(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Return'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / EVENTS_SCREEN
// Route: AppRoutes.events (named route).
// Opens EventDetailScreen with a direct Navigator.push(MaterialPageRoute).
// ============================================================================
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TapGuard _guard = TapGuard();

  Future<void> _openEvent(CampusEvent event) {
    return _guard.run(() async {
      // Direct route: the selected CampusEvent object is passed to the details
      // screen through its constructor.
      final registered = await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (_) => EventDetailScreen(event: event),
        ),
      );
      if (!mounted || registered == null) return;
      setState(() => event.registered = registered);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(registered
                ? 'You are registered for ${event.title}.'
                : 'Registration cancelled: ${event.title}.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
          ),
        );
    });
  }

  Widget _eventTile(CampusEvent e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Styles.corners,
        border: Border.all(
            color: e.registered ? AppColors.success : AppColors.border,
            width: e.registered ? 1.5 : 1),
        boxShadow: Styles.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: Styles.corners,
          onTap: () => _openEvent(e),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.tint,
                  child: Icon(e.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.title, style: Styles.subheading),
                      const SizedBox(height: 4),
                      Text('${e.date}  |  ${e.time}',
                          style: Styles.body.copyWith(fontSize: 13)),
                      Text(e.venue, style: Styles.body.copyWith(fontSize: 13)),
                      const SizedBox(height: 8),
                      e.registered
                          ? const StatusBadge('Registered',
                              textColor: AppColors.success,
                              background: AppColors.successTint,
                              borderColor: AppColors.success)
                          : const StatusBadge('Open for registration'),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int registeredCount = campusEvents.where((e) => e.registered).length;
    return Scaffold(
      appBar: campusAppBar(context, 'Campus Events'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Upcoming events', style: Styles.heading),
            const SizedBox(height: 4),
            Text('${campusEvents.length} events  |  $registeredCount registered',
                style: Styles.body),
            const SizedBox(height: 14),
            for (final e in campusEvents) _eventTile(e),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / UNKNOWN_ROUTE_SCREEN
// 404-style fallback used by MaterialApp.onUnknownRoute. Shows the route name
// that could not be opened and a way back.
// ============================================================================
class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key, this.routeName});

  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: campusAppBar(context, 'Page not found'),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.dangerTint,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.explore_off,
                      size: 48, color: AppColors.danger),
                ),
                const SizedBox(height: 20),
                const Text('404 - Page not found', style: Styles.heading),
                const SizedBox(height: 8),
                Text(
                  'The route "${routeName ?? 'unknown'}" is not registered in '
                  'KL UniConnect.',
                  style: Styles.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, 52),
                    backgroundColor: AppColors.primary,
                  ),
                  // Pops this fallback screen, revealing the previous route.
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / SERVICE_REQUEST_FORM_SCREEN
// Route: AppRoutes.requestForm. A validated campus service request form.
// 
// Form concepts used: GlobalKey<FormState>, autovalidateMode, validate(),
// save() (only after validate passes), reset(), TextFormField,
// DropdownButtonFormField, custom FormFields (chips, date, checkbox).
// 
// Advanced options chosen (3 required, 5 implemented):
// 1. Extra field shown/hidden by service category
// 2. Live character counter + max length on the description
// 3. Reusable CampusTextField / CampusDropdown widgets
// 4. Submission summary dialog with a request reference
// 5. Progress indicator for completed required fields
// ============================================================================
/// Extra input that appears only for some categories (advanced option 1).
class _ExtraField {
  const _ExtraField(this.label, this.hint, this.icon);
  final String label;
  final String hint;
  final IconData icon;
}

class ServiceRequestFormScreen extends StatefulWidget {
  const ServiceRequestFormScreen({super.key, this.initialCategory});

  /// Pre-selected category when opened from a Service Details screen.
  final String? initialCategory;

  @override
  State<ServiceRequestFormScreen> createState() =>
      _ServiceRequestFormScreenState();
}

class _ServiceRequestFormScreenState extends State<ServiceRequestFormScreen> {
  // ---- customization: choices offered by the form ----
  static const List<String> _categories = [
    'Accommodation',
    'Library',
    'Counselling',
    'IT Helpdesk',
    'Career Services',
    'Campus Clinic',
    'Facilities & Maintenance',
  ];
  static const List<String> _urgencyLevels = ['Low', 'Normal', 'High', 'Urgent'];
  static const Map<String, String> _responseTimes = {
    'Low': 'We aim to reply within 5 working days.',
    'Normal': 'We aim to reply within 2 working days.',
    'High': 'We aim to reply within 1 working day.',
    'Urgent': 'We aim to reply within 4 hours.',
  };
  static const List<String> _contactMethods = [
    'Email',
    'Phone call',
    'SMS',
    'In person',
  ];
  static const Map<String, _ExtraField> _extraFields = {
    'Accommodation': _ExtraField(
        'Hostel block and room', 'e.g. Block C, Room 214', Icons.meeting_room),
    'IT Helpdesk':
        _ExtraField('Device or asset tag', 'e.g. LAP-3321', Icons.laptop),
    'Library': _ExtraField(
        'Book title or library card no.', 'e.g. LC-20917', Icons.menu_book),
  };
  static const int _maxDetails = 300;
  static const int _minDetails = 20;
  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun', //
  ];
  static const List<String> _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static int _requestCounter = 1042; // makes each reference number different

  // ---- form key + controllers (disposed in dispose()) ----
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scroll = ScrollController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _studentId = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _subject = TextEditingController();
  final TextEditingController _details = TextEditingController();
  final TextEditingController _extra = TextEditingController();
  late final List<TextEditingController> _controllers = [
    _name, _studentId, _email, _phone, _subject, _details, _extra, //
  ];

  // ---- values that live outside the text fields (also cleared by reset) ----
  String? _category;
  String? _urgency;
  String? _contact;
  DateTime? _date;
  bool _agreed = false;
  bool _submitted = false;

  /// Filled by the onSaved callbacks when save() runs (label -> value).
  final Map<String, String> _saved = {};

  @override
  void initState() {
    super.initState();
    if (_categories.contains(widget.initialCategory)) {
      _category = widget.initialCategory;
    }
    // Rebuild on every keystroke so the progress bar and "unsaved" state update.
    for (final c in _controllers) {
      c.addListener(_onInputChanged);
    }
  }

  void _onInputChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    // Every TextEditingController must be disposed.
    for (final c in _controllers) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Validators: each message says what is wrong and what format is expected.
  // ---------------------------------------------------------------------------
  String? _validateName(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter your full name';
    if (v.split(RegExp(r'\s+')).length < 2) {
      return 'Enter first and last name, e.g. Satya Pilli';
    }
    return null;
  }

  String? _validateStudentId(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter your student ID';
    if (!RegExp(r'^\d{10}$').hasMatch(v)) {
      return 'Student ID must be exactly 10 digits, e.g. 2300030536';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter your campus email';
    if (!RegExp(r'^[\w.+-]+@kl\.edu$', caseSensitive: false).hasMatch(v)) {
      return 'Use your campus email ending in @kl.edu';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (v.isEmpty) {
      // Optional, unless the student asked to be contacted by phone or SMS.
      if (_contact == 'Phone call' || _contact == 'SMS') {
        return 'Add a phone number so we can reach you by $_contact';
      }
      return null;
    }
    if (!RegExp(r'^\+?\d{9,13}$').hasMatch(v)) {
      return 'Phone must be 9-13 digits with an optional leading +';
    }
    return null;
  }

  String? _validateCategory(String? value) =>
      value == null ? 'Choose a service category' : null;

  String? _validateExtra(String? value) {
    final v = (value ?? '').trim();
    if (v.length < 3) {
      return 'Enter the ${_extraFields[_category]?.label.toLowerCase() ?? 'detail'} '
          '(at least 3 characters)';
    }
    return null;
  }

  String? _validateSubject(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Enter a short subject for your request';
    if (v.length < 5) return 'Subject needs at least 5 characters';
    return null;
  }

  String? _validateDetails(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Describe what you need help with';
    if (v.length < _minDetails) {
      return 'Please write at least $_minDetails characters '
          '(${v.length} so far)';
    }
    if (v.length > _maxDetails) {
      return 'Please keep the description under $_maxDetails characters';
    }
    return null;
  }

  String? _validateUrgency(String? value) =>
      value == null ? 'Select an urgency level' : null;

  String? _validateContact(String? value) =>
      value == null ? 'Select how we should contact you' : null;

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String? _validateDate(DateTime? value) {
    if (value == null) return 'Choose a preferred response date';
    final picked = DateTime(value.year, value.month, value.day);
    if (picked.isBefore(_today)) return 'The date cannot be in the past';
    return null;
  }

  String? _validateDeclaration(bool? value) =>
      value == true ? null : 'Tick the declaration before sending';

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  String _formatDate(DateTime d) =>
      '${_weekdays[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

  Future<DateTime?> _pickDate(DateTime? current) {
    final today = _today;
    // initialDate must never be earlier than firstDate.
    final initial =
        (current != null && !current.isBefore(today)) ? current : today;
    return showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: today.add(const Duration(days: 60)),
      helpText: 'Preferred response date',
    );
  }

  _ExtraField? get _extraConfig => _extraFields[_category];

  /// Required inputs that are filled in (drives the progress indicator).
  List<bool> get _requiredStatus => [
        _name.text.trim().isNotEmpty,
        _studentId.text.trim().isNotEmpty,
        _email.text.trim().isNotEmpty,
        _category != null,
        if (_extraConfig != null) _extra.text.trim().isNotEmpty,
        _subject.text.trim().isNotEmpty,
        _details.text.trim().isNotEmpty,
        _urgency != null,
        _contact != null,
        _date != null,
        _agreed,
      ];

  /// True when the student typed or chose something and has not sent it yet.
  bool get _hasUnsentInput =>
      !_submitted &&
      (_controllers.any((c) => c.text.trim().isNotEmpty) ||
          _category != null ||
          _urgency != null ||
          _contact != null ||
          _date != null ||
          _agreed);

  void _showSnack(String message, {Color color = AppColors.primary}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
        ),
      );
  }

  void _fillFromProfile() {
    _name.text = Student.name;
    _studentId.text = Student.id;
    _email.text = Student.email;
    _phone.text = Student.contact;
    _showSnack('Details filled from your profile');
  }

  // ---------------------------------------------------------------------------
  // Submit / reset
  // ---------------------------------------------------------------------------
  Future<void> _submit() async {
    final form = _formKey.currentState!;
    // 1) validate first ...
    if (!form.validate()) {
      _showSnack('Please fix the highlighted fields and try again',
          color: AppColors.danger);
      return; // stay on the form; valid data is kept
    }
    // 2) ... and only then save (runs every onSaved callback).
    _saved.clear();
    form.save();

    final String reference = 'KL-REQ-${_requestCounter++}';
    final String firstName = (_saved['Name'] ?? '').split(' ').first;
    final String team = _saved['Category'] ?? 'campus';

    setState(() => _submitted = true);
    final bool startNew = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => _buildSummaryDialog(ctx, reference, firstName, team),
        ) ??
        false;
    if (!mounted) return;
    if (startNew) {
      _resetForm();
    } else {
      // Return the reference to the previous route so it can confirm it too.
      popIfPossible(context, reference);
    }
  }

  void _resetForm() {
    // reset() clears every FormField (text, dropdown, chips, date, checkbox) ...
    _formKey.currentState?.reset();
    // ... and we clear the state values that live outside the fields.
    for (final c in _controllers) {
      c.clear();
    }
    setState(() {
      _category = null;
      _urgency = null;
      _contact = null;
      _date = null;
      _agreed = false;
      _submitted = false;
      _saved.clear();
    });
    if (_scroll.hasClients) {
      _scroll.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Future<bool> _confirmDiscard() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard this request?'),
        content: const Text(
            'You have information that has not been sent. If you leave now it '
            'will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  // ---------------------------------------------------------------------------
  // UI pieces
  // ---------------------------------------------------------------------------
  Widget _buildSummaryDialog(
      BuildContext ctx, String reference, String firstName, String team) {
    final urgency = _saved['Urgency'] ?? '';
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 32),
          SizedBox(width: 10),
          Expanded(child: Text('Request sent')),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thanks, $firstName! The $team team has your request and will '
                'reply by ${(_saved['Contact method'] ?? '').toLowerCase()}. '
                '${_responseTimes[urgency] ?? ''}',
                style: Styles.body,
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.successTint,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.success),
                ),
                child: Text('Reference: $reference',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: AppColors.success)),
              ),
              const SizedBox(height: 12),
              for (final entry in _saved.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.text),
                        ),
                        TextSpan(text: entry.value),
                      ],
                      style: Styles.body,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('New request'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final status = _requiredStatus;
    final int done = status.where((s) => s).length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: Styles.gap),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Styles.radius + 8),
        boxShadow: Styles.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent,
                    color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Campus Help Request',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Tell the right campus team what you need. Fields marked as '
            'required must be completed before sending.',
            style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.whiteSoft),
          ),
          const SizedBox(height: 14),
          // Advanced option 5: progress of completed required fields.
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: done / status.length,
              minHeight: 8,
              backgroundColor: AppColors.whiteFaint,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$done of ${status.length} required fields completed',
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDeclaration() {
    return FormField<bool>(
      initialValue: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _validateDeclaration,
      onSaved: (v) => _saved['Declaration'] = 'Confirmed',
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kFieldFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: state.hasError ? AppColors.danger : AppColors.border,
                    width: state.hasError ? 1.5 : 1),
              ),
              child: CheckboxListTile(
                value: state.value ?? false,
                activeColor: AppColors.primary,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'I confirm the information above is correct and I agree to '
                  'be contacted about this request.',
                  style: TextStyle(fontSize: 14, color: AppColors.text),
                ),
                onChanged: (v) {
                  state.didChange(v);
                  setState(() => _agreed = v ?? false);
                },
              ),
            ),
            if (state.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 16, color: AppColors.danger),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(state.errorText!,
                          style: const TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5)),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final extra = _extraConfig;
    return PopScope(
      // Extension: confirmation before leaving an unfinished form. System Back
      // and the AppBar back button both go through this check.
      canPop: !_hasUnsentInput,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final leave = await _confirmDiscard();
        if (leave && mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: campusAppBar(context, 'Service Request'),
        body: SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // SingleChildScrollView (not a lazy ListView) keeps EVERY field
            // mounted, so validate() and save() always reach all of them.
            child: SingleChildScrollView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),

                  // ---- Student details ----
                  FormSectionCard(
                    title: 'Student details',
                    icon: Icons.badge,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                              minimumSize: const Size(48, 48)),
                          onPressed: _fillFromProfile,
                          icon: const Icon(Icons.person_search),
                          label: const Text('Use my profile details'),
                        ),
                      ),
                      CampusTextField(
                        controller: _name,
                        label: 'Full name',
                        hint: 'e.g. Satya Sukumar Pilli',
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                        validator: _validateName,
                        onSaved: (v) => _saved['Name'] = v!.trim(),
                      ),
                      CampusTextField(
                        controller: _studentId,
                        label: 'Student ID',
                        hint: '10 digits, e.g. 2300030536',
                        icon: Icons.numbers,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: _validateStudentId,
                        onSaved: (v) => _saved['Student ID'] = v!.trim(),
                      ),
                      CampusTextField(
                        controller: _email,
                        label: 'Campus email',
                        hint: 'id@kl.edu',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        onSaved: (v) => _saved['Email'] = v!.trim(),
                      ),
                      CampusTextField(
                        controller: _phone,
                        label: 'Phone (optional)',
                        hint: 'e.g. 012-345 6789',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: _validatePhone,
                        onSaved: (v) => _saved['Phone'] =
                            (v == null || v.trim().isEmpty) ? 'Not given' : v.trim(),
                      ),
                    ],
                  ),

                  // ---- Request details ----
                  FormSectionCard(
                    title: 'Request details',
                    icon: Icons.assignment,
                    children: [
                      CampusDropdown(
                        label: 'Service category',
                        icon: Icons.category,
                        items: _categories,
                        value: _category,
                        validator: _validateCategory,
                        onChanged: (v) {
                          _extra.clear(); // old answer belongs to another category
                          setState(() => _category = v);
                        },
                        onSaved: (v) => _saved['Category'] = v ?? '',
                      ),
                      // Advanced option 1: shown only for some categories.
                      if (extra != null)
                        CampusTextField(
                          key: ValueKey<String>('extra-$_category'),
                          controller: _extra,
                          label: extra.label,
                          hint: extra.hint,
                          icon: extra.icon,
                          validator: _validateExtra,
                          onSaved: (v) => _saved[extra.label] = v!.trim(),
                        ),
                      CampusTextField(
                        controller: _subject,
                        label: 'Subject',
                        hint: 'e.g. Wi-Fi drops in the hostel',
                        icon: Icons.title,
                        maxLength: 60,
                        validator: _validateSubject,
                        onSaved: (v) => _saved['Subject'] = v!.trim(),
                      ),
                      // Advanced option 2: maxLength shows a live "n/300" counter.
                      CampusTextField(
                        controller: _details,
                        label: 'Description',
                        hint: 'What happened? What help do you need?',
                        icon: Icons.notes,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 4,
                        maxLines: 6,
                        maxLength: _maxDetails,
                        validator: _validateDetails,
                        onSaved: (v) => _saved['Description'] = v!.trim(),
                      ),
                      CampusChoiceField(
                        label: 'Urgency',
                        icon: Icons.priority_high,
                        options: _urgencyLevels,
                        validator: _validateUrgency,
                        onSelected: (v) => setState(() => _urgency = v),
                        helperFor: (v) => _responseTimes[v] ?? '',
                        onSaved: (v) => _saved['Urgency'] = v ?? '',
                      ),
                    ],
                  ),

                  // ---- Preferences ----
                  FormSectionCard(
                    title: 'Preferences',
                    icon: Icons.tune,
                    children: [
                      CampusChoiceField(
                        label: 'Preferred contact method',
                        icon: Icons.contact_phone,
                        options: _contactMethods,
                        validator: _validateContact,
                        // Phone becomes required for call/SMS (checked on submit).
                        onSelected: (v) => setState(() => _contact = v),
                        onSaved: (v) => _saved['Contact method'] = v ?? '',
                      ),
                      CampusDateField(
                        label: 'Preferred response date',
                        hint: 'Tap to choose a date',
                        onPick: _pickDate,
                        format: _formatDate,
                        validator: _validateDate,
                        onChanged: (d) => setState(() => _date = d),
                        onSaved: (d) =>
                            _saved['Preferred date'] = d == null ? '' : _formatDate(d),
                      ),
                    ],
                  ),

                  // ---- Confirmation + actions ----
                  FormSectionCard(
                    title: 'Confirmation',
                    icon: Icons.verified_user,
                    children: [
                      _buildDeclaration(),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(48, 52),
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                              ),
                              onPressed: _resetForm,
                              icon: const Icon(Icons.restart_alt),
                              label: const Text('Clear form'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(48, 52),
                                backgroundColor: AppColors.primary,
                              ),
                              onPressed: _submit,
                              icon: const Icon(Icons.send),
                              label: const Text('Send request'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREENS / CAMPUS_SHELL
// Main Scaffold: AppBar, Drawer, body, BottomNavigationBar, FAB, SnackBars.
// ============================================================================
class CampusShell extends StatefulWidget {
  const CampusShell({super.key});

  @override
  State<CampusShell> createState() => _CampusShellState();
}

class _CampusShellState extends State<CampusShell> {
  // ---- state managed with setState() ----
  int _currentIndex = 0;
  int _unread = sampleNotifications.length;
  final Set<int> _favourites = {};
  final Set<int> _registered = {};
  final List<Reminder> _reminders = [
    const Reminder('Submit Flutter mini project', 'Due Friday, 10:00 AM'),
  ];

  // Editable copies of the sample data (the top-level lists hold the defaults).
  final List<Service> _services = List<Service>.of(services);
  final List<Activity> _activities = List<Activity>.of(activities);
  Academic _academic =
      const Academic(cgpa: '8.4', credits: '86', attendance: 92);
  Announcement _announcement = const Announcement(
    title: 'Registration closing',
    body: 'Complete your Semester 5 course registration on the student '
        'portal before Friday, 2 Oct 2026, 5:00 PM.',
  );
  FeaturedEvent _event = const FeaturedEvent(
    month: 'OCT',
    day: '03',
    title: 'Robotics Club Demo Day',
    time: '10:00 AM',
    venue: 'Eng. Lab 2',
  );

  // ---- helpers ----
  void _showMessage(String message, {SnackBarAction? action}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
        action: action,
      ),
    );
  }

  void _selectTab(int index) => setState(() => _currentIndex = index);

  /// Opens a named route on top of the Dashboard (Navigator.pushNamed). The
  /// Dashboard stays underneath, so Back reveals it again - no new copy.
  Future<void> _openRoute(String routeName) async {
    final result = await Navigator.pushNamed(context, routeName);
    // Check mounted before using the context after an await.
    if (!mounted) return;
    // The request form returns its reference number when a request was sent.
    if (result is String && result.startsWith('KL-REQ-')) {
      _showMessage('Request $result sent - we will be in touch');
    }
  }

  void _toggleFavourite(int index) {
    setState(() {
      if (!_favourites.add(index)) {
        _favourites.remove(index);
      }
    });
    final added = _favourites.contains(index);
    _showMessage(added
        ? '${_activities[index].name} added to favourites'
        : '${_activities[index].name} removed from favourites');
  }

  void _toggleRegistration(int index) {
    final wasRegistered = _registered.contains(index);
    setState(() {
      if (wasRegistered) {
        _registered.remove(index);
      } else {
        _registered.add(index);
      }
    });
    _showMessage(
      wasRegistered
          ? 'Registration cancelled: ${_activities[index].name}'
          : 'Successfully registered: ${_activities[index].name}',
      action: SnackBarAction(
        label: 'UNDO',
        textColor: AppColors.accent,
        onPressed: () {
          setState(() {
            if (wasRegistered) {
              _registered.add(index);
            } else {
              _registered.remove(index);
            }
          });
        },
      ),
    );
  }

  void _deleteReminder(int index) {
    final removed = _reminders[index];
    setState(() => _reminders.removeAt(index));
    _showMessage(
      'Reminder deleted: ${removed.title}',
      action: SnackBarAction(
        label: 'UNDO',
        textColor: AppColors.accent,
        onPressed: () => setState(() => _reminders.insert(index, removed)),
      ),
    );
  }

  Future<void> _showAddReminderDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New reminder'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'e.g. Submit lab report',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (!mounted || result == null || result.isEmpty) return;
    setState(() => _reminders.insert(0, Reminder(result, 'Added just now')));
    _showMessage(
      'Reminder created: $result',
      action: SnackBarAction(
        label: 'VIEW',
        textColor: AppColors.accent,
        onPressed: () => _selectTab(0),
      ),
    );
  }

  // ---- edit options: every service, card and detail can be edited ----
  Future<void> _editStudentField(StudentField field) async {
    final saved = await editStudentField(context, field);
    if (!mounted || !saved) return;
    setState(() {}); // Student values are shared, so just rebuild
    _showMessage('${field.label} updated');
  }

  Future<void> _editHeader() async {
    final saved = await editStudentHeader(context);
    if (!mounted || !saved) return;
    setState(() {});
    _showMessage('Profile updated');
  }

  Future<void> _editAcademic() async {
    final result = await showEditDialog(
      context,
      title: 'Edit academic snapshot',
      fields: [
        EditField('Semester', Student.semester, hint: 'e.g. Semester 5'),
        EditField('CGPA', _academic.cgpa,
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            validator: numberBetween(0, 10)),
        EditField('Credits', _academic.credits,
            keyboard: TextInputType.number, validator: integerBetween(0, 500)),
        EditField('Attendance (%)', _academic.attendanceText,
            keyboard: const TextInputType.numberWithOptions(decimal: true),
            validator: numberBetween(0, 100)),
      ],
    );
    if (!mounted || result == null) return;
    final v = result.values;
    setState(() {
      Student.semester = v[0];
      _academic = Academic(
        cgpa: v[1],
        credits: v[2],
        attendance: double.parse(v[3]),
      );
    });
    _showMessage('Academic snapshot updated');
  }

  Future<void> _editService(int index) async {
    final s = _services[index];
    final result = await showEditDialog(
      context,
      title: 'Edit ${s.label}',
      icon: s.icon,
      fields: [
        EditField('Title', s.label),
        EditField('Caption (shown on the card)', s.caption),
        EditField('Message (shown when tapped)', s.message, maxLines: 2),
      ],
    );
    if (!mounted || result == null) return;
    final v = result.values;
    setState(() {
      _services[index] = s.copyWith(
        label: v[0],
        caption: v[1],
        message: v[2],
        icon: result.icon,
      );
    });
    _showMessage('Service updated: ${v[0]}');
  }

  Future<void> _editAnnouncement() async {
    final result = await showEditDialog(
      context,
      title: 'Edit announcement',
      fields: [
        EditField('Title', _announcement.title),
        EditField('Message', _announcement.body, maxLines: 4),
      ],
    );
    if (!mounted || result == null) return;
    setState(() {
      _announcement =
          Announcement(title: result.values[0], body: result.values[1]);
    });
    _showMessage('Announcement updated');
  }

  Future<void> _editEvent() async {
    final e = _event;
    final result = await showEditDialog(
      context,
      title: 'Edit featured event',
      fields: [
        EditField('Event name', e.title),
        EditField('Month', e.month,
            hint: 'e.g. OCT',
            validator: (v) =>
                v.length <= 4 ? null : 'Use a short month name (max 4 letters)'),
        EditField('Day', e.day,
            keyboard: TextInputType.number, validator: integerBetween(1, 31)),
        EditField('Time', e.time, hint: 'e.g. 10:00 AM'),
        EditField('Venue', e.venue),
      ],
    );
    if (!mounted || result == null) return;
    final v = result.values;
    setState(() {
      _event = FeaturedEvent(
        title: v[0],
        month: v[1].toUpperCase(),
        day: int.parse(v[2]).toString().padLeft(2, '0'),
        time: v[3],
        venue: v[4],
      );
    });
    _showMessage('Featured event updated');
  }

  Future<void> _editReminder(int index) async {
    final r = _reminders[index];
    final result = await showEditDialog(
      context,
      title: 'Edit reminder',
      fields: [
        EditField('Reminder', r.title),
        EditField('When', r.when, hint: 'e.g. Due Friday, 10:00 AM'),
      ],
    );
    if (!mounted || result == null) return;
    setState(() {
      _reminders[index] = Reminder(result.values[0], result.values[1]);
    });
    _showMessage('Reminder updated');
  }

  Future<void> _editActivity(int index) async {
    final a = _activities[index];
    final result = await showEditDialog(
      context,
      title: 'Edit activity',
      icon: a.icon,
      fields: [
        EditField('Name', a.name),
        EditField('Description', a.description, maxLines: 3),
        EditField('Date', a.date, hint: 'e.g. Sat, 3 Oct 2026'),
        EditField('Time', a.time, hint: 'e.g. 10:00 AM'),
        EditField('Venue', a.venue),
      ],
    );
    if (!mounted || result == null) return;
    final v = result.values;
    setState(() {
      _activities[index] = a.copyWith(
        name: v[0],
        description: v[1],
        date: v[2],
        time: v[3],
        venue: v[4],
        icon: result.icon,
      );
    });
    _showMessage('Activity updated: ${v[0]}');
  }

  void _openNotifications() {
    setState(() => _unread = 0);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: Styles.heading),
            const SizedBox(height: 8),
            for (final n in sampleNotifications)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_active_outlined,
                    color: AppColors.primary),
                title: Text(n, style: Styles.body),
              ),
          ],
        ),
      ),
    );
  }

  void _showCalendar() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Academic calendar'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('2 Oct - Course registration closes', style: Styles.body),
            SizedBox(height: 8),
            Text('19 Oct - Mid-semester exams begin', style: Styles.body),
            SizedBox(height: 8),
            Text('30 Oct - Mid-semester break', style: Styles.body),
            SizedBox(height: 8),
            Text('14 Dec - Final exams begin', style: Styles.body),
            SizedBox(height: 12),
            Text('Sample dates for demonstration.',
                style: TextStyle(fontSize: 12, color: AppColors.muted)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Help centre'),
        content: const Text(
          'Use the bottom bar to switch between Dashboard, Activities and '
          'Profile. Tap the + Reminder button to add a reminder, and tap a '
          'service card for quick information. Use the menu to open the '
          'Timetable, Campus Services, Events and Service Request pages.',
          style: Styles.body,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Opens an unregistered route to show the 404 fallback screen.
              Navigator.pushNamed(context, '/old-campus-map');
            },
            child: const Text('Try a broken link'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }

  // ---- drawer ----
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap,
      {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: Styles.subheading),
      trailing: trailing,
      onTap: () {
        Navigator.pop(context); // close the drawer first
        onTap();
      },
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: AppColors.accent,
                  child: Text(
                    Student.initials,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Student.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${Student.id}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.whiteSoft),
                      ),
                      Text(
                        Student.universityLabel,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.whiteSoft),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.person, 'My Profile', () => _selectTab(2)),
          _drawerItem(Icons.groups, 'Campus Activities', () => _selectTab(1)),
          _drawerItem(Icons.schedule, 'Timetable',
              () => _openRoute(AppRoutes.timetable)),
          _drawerItem(Icons.apartment, 'Campus Services',
              () => _openRoute(AppRoutes.services)),
          _drawerItem(Icons.event, 'Campus Events',
              () => _openRoute(AppRoutes.events)),
          _drawerItem(Icons.support_agent, 'Service Request',
              () => _openRoute(AppRoutes.requestForm)),
          _drawerItem(Icons.badge, 'Student Profile page',
              () => _openRoute(AppRoutes.profile)),
          _drawerItem(
              Icons.calendar_month, 'Academic Calendar', _showCalendar),
          _drawerItem(
            Icons.mail,
            'Messages',
            _openNotifications,
            trailing: _unread > 0
                ? Badge(label: Text('$_unread'))
                : const SizedBox.shrink(),
          ),
          const Divider(),
          _drawerItem(Icons.help_outline, 'Help Centre', _showHelp),
          _drawerItem(
            Icons.info_outline,
            'About KL',
            () => showAboutDialog(
              context: context,
              applicationName: 'KL UniConnect',
              applicationVersion: '1.0.0',
              applicationIcon:
                  const Icon(Icons.school, color: AppColors.primary, size: 36),
              children: const [
                Text(
                  'A Student Campus App for KL, built with Flutter for the '
                  'Scaffold, Container, Form and Routes/Navigator mini projects.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- page selection ----
  Widget _buildPage() {
    switch (_currentIndex) {
      case 1:
        return ActivitiesPage(
          activities: _activities,
          favourites: _favourites,
          registered: _registered,
          onFavourite: _toggleFavourite,
          onRegister: _toggleRegistration,
          onEdit: _editActivity,
        );
      case 2:
        return ProfilePage(
          registeredCount: _registered.length,
          favouriteCount: _favourites.length,
          reminderCount: _reminders.length,
          onEditField: _editStudentField,
          onEditHeader: _editHeader,
        );
      default:
        return HomePage(
          reminders: _reminders,
          services: _services,
          academic: _academic,
          announcement: _announcement,
          event: _event,
          onMessage: _showMessage,
          onOpenActivities: () => _selectTab(1),
          onOpenRoute: _openRoute,
          onDeleteReminder: _deleteReminder,
          onEditReminder: _editReminder,
          onEditService: _editService,
          onEditAcademic: _editAcademic,
          onEditAnnouncement: _editAnnouncement,
          onEditEvent: _editEvent,
          onEditHeader: _editHeader,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KL UniConnect',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            tooltip: 'Academic calendar',
            icon: const Icon(Icons.calendar_month),
            onPressed: _showCalendar,
          ),
          IconButton(
            tooltip: 'Notifications',
            icon: Badge(
              isLabelVisible: _unread > 0,
              label: Text('$_unread'),
              child: const Icon(Icons.notifications),
            ),
            onPressed: _openNotifications,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey<int>(_currentIndex),
          child: _buildPage(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddReminderDialog,
        tooltip: 'Add a reminder',
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.primary,
        icon: const Icon(Icons.add_alarm),
        label: const Text('Reminder',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectTab,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.muted,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        iconSize: 26,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Activities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// MAIN: MaterialApp, theme, named routes, onGenerateRoute, onUnknownRoute
// ============================================================================
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KL UniConnect',
      debugShowCheckedModeBanner: false,
      // One theme for every route: screens never restyle themselves.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        scaffoldBackgroundColor: AppColors.tint,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
        ),
      ),

      // The Dashboard is registered ONCE (in routes) and used as the first
      // route. `home:` is not set, so '/' is never defined twice.
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (_) => const CampusShell(),
        AppRoutes.timetable: (_) => const TimetableScreen(),
        AppRoutes.services: (_) => const ServicesScreen(),
        AppRoutes.events: (_) => const EventsScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.requestForm: (_) => const ServiceRequestFormScreen(),
      },

      // Routes that need an argument are built here. The selected
      // CampusService arrives in settings.arguments.
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.serviceDetail) {
          final args = settings.arguments;
          // Wrong or missing argument: return null so onUnknownRoute handles it.
          if (args is! CampusService) return null;
          // Extension: custom animated transition with PageRouteBuilder.
          return PageRouteBuilder<Object?>(
            settings: settings,
            transitionDuration: const Duration(milliseconds: 350),
            reverseTransitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, animation, secondaryAnimation) =>
                ServiceDetailScreen(service: args),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final slide = Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeOutCubic));
              return SlideTransition(
                position: animation.drive(slide),
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        }
        return null;
      },

      // Fallback for any route name that is not registered.
      onUnknownRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => UnknownRouteScreen(routeName: settings.name),
      ),
    );
  }
}
