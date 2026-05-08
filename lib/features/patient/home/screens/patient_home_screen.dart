import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=alex'),
            ),
            const SizedBox(width: 12),
            Text(
              'Acdital Healthcare',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color(0xFF004D99),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DASHBOARD',
              style: TextStyle(
                color: Color(0xFF006699),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Welcome back,\nAlexander',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your personalized health overview is ready. You have one appointment scheduled for tomorrow.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Action Cards
            _actionCard(
              'Book Appointment',
              'Schedule a visit with your primary care physician or specialist.',
              Icons.calendar_today_outlined,
              'Schedule Now',
            ),
            const SizedBox(height: 16),
            _actionCard(
              'My Records',
              'Securely access your lab results, medical history, and prescriptions.',
              Icons.folder_outlined,
              'View Records',
            ),
            const SizedBox(height: 32),

            // Upcoming Appointments
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Upcoming Appointments', style: theme.textTheme.titleLarge),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All', style: TextStyle(color: Color(0xFF006699))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _upcomingAppointmentCard(),
            const SizedBox(height: 24),
            
            // Health Stats
            Row(
              children: [
                Expanded(
                  child: _statCard('Resting Heart Rate', '68 BPM', 'Normal', Icons.favorite_border_rounded),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _statCard('Sleep Quality', '8h 12m', 'Excellent', Icons.bedtime_outlined),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Health Insights
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Health Insights', style: theme.textTheme.titleLarge),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text('Discover More', style: TextStyle(color: Color(0xFF006699))),
                      Icon(Icons.arrow_forward, size: 16, color: Color(0xFF006699)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _insightCard(
              '5 Daily habits for better cardiovascular health',
              'Wellness',
              'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?auto=format&fit=crop&q=80&w=500',
            ),
            _insightCard(
              'The connection between diet and mental focus',
              'Nutrition',
              'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=500',
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(String title, String subtitle, IconData icon, String actionText) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF006699)),
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(actionText, style: const TextStyle(color: Color(0xFF006699), fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF006699)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _upcomingAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F7F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Dr. Sarah Jenkins', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Text('Senior Cardiologist • General Checkup', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('Tomorrow, Oct 24', style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                const Text('09:30 AM', style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006699),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Check-in', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, String status, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF006699)),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(width: 4),
              Text(status, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _insightCard(String title, String category, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(category, style: const TextStyle(color: Color(0xFF006699), fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Small changes in your morning routine can significantly impact your long-term heart...', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}

