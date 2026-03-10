import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is stateful so it can rebuild with a new theme when dark mode toggles
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  void _onDarkModeChanged(bool value) {
    setState(() => _darkMode = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Switch Widget Demo',
      debugShowCheckedModeBanner: false,
      // Swap between light and dark theme based on the toggle
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: SettingsScreen(
        darkMode: _darkMode,
        onDarkModeChanged: _onDarkModeChanged,
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _locationAccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          // ─── SECTION: APPEARANCE ───────────────────────────────────────────
          const _SectionHeader(title: 'Appearance'),

          // Property 1 — activeTrackColor
          // Controls the color of the track when the Switch is ON.
          // Useful for matching your app's brand color.
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('activeTrackColor: Colors.indigo'),
            trailing: Switch(
              value: widget.darkMode,
              activeTrackColor: Colors.indigo, // Property 1
              onChanged: widget.onDarkModeChanged,
            ),
          ),

          const Divider(indent: 16, endIndent: 16),

          // ─── SECTION: NOTIFICATIONS ────────────────────────────────────────
          const _SectionHeader(title: 'Notifications'),

          // Property 2 — thumbColor
          // Controls the color of the circular thumb (the sliding dot).
          // Can be styled independently from the track — handy for accessibility.
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Push Notifications'),
            subtitle: const Text('thumbColor: white (ON) / orange (OFF)'),
            trailing: Switch(
              value: _notifications,
              activeTrackColor: Colors.green,
              thumbColor: WidgetStateProperty.resolveWith<Color>(
                (states) {
                  // Property 2 — thumb turns orange when switch is OFF
                  if (!states.contains(WidgetState.selected)) {
                    return Colors.orange;
                  }
                  return Colors.white;
                },
              ),
              onChanged: (val) => setState(() => _notifications = val),
            ),
          ),

          // Status card — reacts to the notifications toggle
          if (_notifications)
            const _StatusCard(
              icon: Icons.check_circle_outline,
              message: 'You will receive push notifications.',
              color: Colors.green,
            )
          else
            const _StatusCard(
              icon: Icons.notifications_off_outlined,
              message: 'Notifications are off. You may miss updates.',
              color: Colors.orange,
            ),

          const Divider(indent: 16, endIndent: 16),

          // ─── SECTION: PRIVACY ──────────────────────────────────────────────
          const _SectionHeader(title: 'Privacy'),

          // Property 3 — trackOutlineColor
          // Draws a visible border around the track in both ON and OFF states.
          // Improves contrast on light backgrounds (accessibility win).
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Location Access'),
            subtitle: const Text('trackOutlineColor: Colors.teal'),
            trailing: Switch(
              value: _locationAccess,
              activeTrackColor: Colors.teal,
              trackOutlineColor:
                  WidgetStateProperty.all(Colors.teal), // Property 3
              onChanged: (val) => setState(() => _locationAccess = val),
            ),
          ),

          // Status card — reacts to the location toggle
          if (_locationAccess)
            const _StatusCard(
              icon: Icons.location_on,
              message: 'App can access your location.',
              color: Colors.teal,
            )
          else
            const _StatusCard(
              icon: Icons.location_off_outlined,
              message: 'Location access is off.',
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}

// Reusable status card shown below each toggle
class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _StatusCard({
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(color: color, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// Simple reusable section header widget
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
