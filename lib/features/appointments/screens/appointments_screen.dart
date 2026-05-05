import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/appointments_provider.dart';
import '../../shared/models/appointment_model.dart';
import '../../auth/domain/models/user_model.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../shared/widgets/shimmer_appointment_card.dart';
import '../../shared/widgets/empty_state_widget.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appointmentsAsync = ref.watch(appointmentsProvider);
    final currentUserState = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.secondary,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withOpacity(0.6),
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: currentUserState.isLoading 
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: 4,
              itemBuilder: (context, index) => const ShimmerAppointmentCard(),
            )
          : appointmentsAsync.when(
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: 4,
                itemBuilder: (context, index) => const ShimmerAppointmentCard(),
              ),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (appointments) {
                final upcoming = appointments.where((a) => a.status == AppointmentStatus.upcoming).toList();
                final completed = appointments.where((a) => a.status == AppointmentStatus.completed).toList();
                final cancelled = appointments.where((a) => a.status == AppointmentStatus.cancelled).toList();

                final isDoctor = currentUserState.value?.role == UserRole.doctor;

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAppointmentList(upcoming, isDoctor, 'No upcoming appointments.', Icons.calendar_today),
                    _buildAppointmentList(completed, isDoctor, 'No completed appointments yet.', Icons.history),
                    _buildAppointmentList(cancelled, isDoctor, 'No cancelled appointments.', Icons.event_busy),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildAppointmentList(List<AppointmentModel> appointments, bool isDoctor, String emptyMessage, IconData emptyIcon) {
    if (appointments.isEmpty) {
      return EmptyStateWidget(
        icon: emptyIcon,
        title: 'All Clear',
        message: emptyMessage,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index], isDoctor: isDoctor);
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final bool isDoctor; // If true, shows patient details instead of doctor details

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDoctor ? 'Patient ID: ${appointment.patientId.substring(0, 5)}...' : appointment.doctorName,
                        style: theme.textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (!isDoctor) ...[
                        const SizedBox(height: 4),
                        Text(
                          appointment.specialty,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                _buildStatusChip(theme),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: theme.textTheme.bodySmall?.color),
                const SizedBox(width: 8),
                Text(
                  dateFormat.format(appointment.dateTime),
                  style: theme.textTheme.bodyLarge,
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 18, color: theme.textTheme.bodySmall?.color),
                const SizedBox(width: 8),
                Text(
                  timeFormat.format(appointment.dateTime),
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    Color chipColor;
    String label;

    switch (appointment.status) {
      case AppointmentStatus.upcoming:
        chipColor = theme.colorScheme.secondary;
        label = 'Upcoming';
        break;
      case AppointmentStatus.completed:
        chipColor = Colors.green;
        label = 'Completed';
        break;
      case AppointmentStatus.cancelled:
        chipColor = Colors.redAccent;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
