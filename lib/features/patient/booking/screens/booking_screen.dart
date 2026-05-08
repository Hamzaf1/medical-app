import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/doctor_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final DoctorModel doctor;

  const BookingScreen({super.key, required this.doctor});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime _selectedDate = DateTime(2024, 10, 10);
  String _selectedSlot = '09:45 AM';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=sarah'),
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
            // Doctor Profile Card
            _doctorProfileCard(),
            const SizedBox(height: 32),

            // Date Selection
            Text('October 2024', style: theme.textTheme.titleLarge),
            const Text('Select your preferred date for the visit', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 16),
            _horizontalDatePicker(),
            const SizedBox(height: 32),

            // Available Slots
            Row(
              children: [
                Text('Available Slots', style: theme.textTheme.titleLarge),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Color(0xFF006699)),
                      const SizedBox(width: 4),
                      const Text('Thursday, Oct 10', style: TextStyle(color: Color(0xFF006699), fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const Text('Times shown in your local timezone', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 24),

            _slotSection('MORNING', ['08:30 AM', '09:00 AM', '09:45 AM', '11:15 AM'], Icons.wb_sunny_outlined),
            const SizedBox(height: 24),
            _slotSection('AFTERNOON', ['01:30 PM', '02:00 PM', '03:30 PM', '04:45 PM'], Icons.wb_cloudy_outlined),
            const SizedBox(height: 24),
            _slotSection('EVENING', ['06:00 PM', '06:30 PM', '07:15 PM'], Icons.nights_stay_outlined),
            const SizedBox(height: 100), // Space for bottom card
          ],
        ),
      ),
      bottomSheet: _bottomConfirmCard(),
    );
  }

  Widget _doctorProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=julian'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.verified, color: Colors.teal, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Cardiologist', style: TextStyle(color: Color(0xFF006699), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 4),
                    const Text('Dr. Julian Thorne', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('St. Mary\'s Medical Center', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoItem('EXPERIENCE', '12 Years'),
              _infoItem('RATING', '4.9 (2.4k)', isRating: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Consultation Fee', style: TextStyle(color: Colors.grey)),
              const Text('\$120.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Insurance Coverage', style: TextStyle(color: Colors.grey)),
              const Text('Accepted', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value, {bool isRating = false}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.1)),
        const SizedBox(height: 4),
        Row(
          children: [
            if (isRating) const Icon(Icons.star, color: Colors.orange, size: 16),
            if (isRating) const SizedBox(width: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _horizontalDatePicker() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 31,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == 10;
          return Container(
            width: 55,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF006699) : const Color(0xFFE3F2FD).withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                if (isSelected) const SizedBox(height: 4),
                if (isSelected) Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _slotSection(String title, List<String> slots, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 1.1, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slots.map((slot) => _slotChip(slot)).toList(),
        ),
      ],
    );
  }

  Widget _slotChip(String time) {
    final isSelected = time == _selectedSlot;
    final isInactive = time == '03:30 PM'; // Mock inactive state

    return InkWell(
      onTap: isInactive ? null : () => setState(() => _selectedSlot = time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF006699) : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          opacity: isInactive ? 0.5 : 1,
        ),
        child: Text(
          time,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isInactive ? Colors.grey : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _bottomConfirmCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF006699)),
              const SizedBox(width: 8),
              const Text('Selected Appointment', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Oct 10, 2024 at $_selectedSlot', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006699),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Confirm Booking', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
extension on Widget {
  Widget withOpacity(double opacity) => Opacity(opacity: opacity, child: this);
}

