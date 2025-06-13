import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/booking.dart';
import '../../models/property.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class BookingReportsScreen extends StatefulWidget {
  const BookingReportsScreen({super.key});

  @override
  State<BookingReportsScreen> createState() => _BookingReportsScreenState();
}

class _BookingReportsScreenState extends State<BookingReportsScreen> {
  List<Booking> _allBookings = [];
  List<Property> _allProperties = [];
  List<User> _allUsers = [];
  bool _isLoading = true;
  String? _error;

  // Report data
  int _totalBookings = 0;
  int _activeBookings = 0;
  int _completedBookings = 0;
  int _upcomingBookings = 0;
  double _totalRevenue = 0;
  final Map<String, int> _bookingsByProperty = {};
  final Map<String, int> _bookingsByMonth = {};

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load all data
      final bookings = await ApiService.getBookings();
      final properties = await ApiService.getProperties();
      final users = await ApiService.getUsers();

      setState(() {
        _allBookings = bookings;
        _allProperties = properties;
        _allUsers = users;
      });

      _calculateReportMetrics();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _calculateReportMetrics() {
    final now = DateTime.now();

    _totalBookings = _allBookings.length;
    _activeBookings = 0;
    _completedBookings = 0;
    _upcomingBookings = 0;
    _totalRevenue = 0;
    _bookingsByProperty.clear();
    _bookingsByMonth.clear();

    for (final booking in _allBookings) {
      // Calculate booking status
      if (now.isBefore(booking.checkInDate)) {
        _upcomingBookings++;
      } else if (now.isAfter(booking.checkOutDate)) {
        _completedBookings++;
      } else {
        _activeBookings++;
      }

      // Calculate revenue (estimate based on property price and duration)
      final property = _allProperties.firstWhere(
        (p) => p.propertyId == booking.propertyId,
        orElse: () => Property(
          name: 'Unknown',
          description: '',
          type: '',
          size: '',
          location: '',
          price: 0,
        ),
      );

      final dailyRate = property.price / 30; // Assuming monthly price
      final revenue = dailyRate * booking.durationInDays;
      _totalRevenue += revenue;

      // Group by property
      final propertyName =
          booking.propertyName ?? 'Property #${booking.propertyId}';
      _bookingsByProperty[propertyName] =
          (_bookingsByProperty[propertyName] ?? 0) + 1;

      // Group by month
      final monthKey = DateFormat('MMM yyyy').format(booking.checkInDate);
      _bookingsByMonth[monthKey] = (_bookingsByMonth[monthKey] ?? 0) + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReportData,
          ),
        ],
      ),
      body: RefreshIndicator(onRefresh: _loadReportData, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading reports',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadReportData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          Text(
            'Booking Overview',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildOverviewCards(),
          const SizedBox(height: 32),

          // Revenue Card
          Text(
            'Revenue Analytics',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRevenueCard(),
          const SizedBox(height: 32),

          // Property Performance
          Text(
            'Property Performance',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPropertyPerformance(),
          const SizedBox(height: 32),

          // Monthly Trends
          Text(
            'Monthly Booking Trends',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildMonthlyTrends(),
          const SizedBox(height: 32),

          // Recent Bookings
          Text(
            'Recent Bookings',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRecentBookings(),
          const SizedBox(height: 50),
        ]
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ReportCard(
                title: 'Total Bookings',
                value: _totalBookings.toString(),
                icon: Icons.book,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ReportCard(
                title: 'Active',
                value: _activeBookings.toString(),
                icon: Icons.play_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ReportCard(
                title: 'Upcoming',
                value: _upcomingBookings.toString(),
                icon: Icons.schedule,
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ReportCard(
                title: 'Completed',
                value: _completedBookings.toString(),
                icon: Icons.check_circle,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRevenueCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.attach_money,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Total Revenue',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${_totalRevenue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Average Revenue per Booking: \$${_totalBookings > 0 ? (_totalRevenue / _totalBookings).toStringAsFixed(2) : '0.00'}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyPerformance() {
    if (_bookingsByProperty.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No booking data available'),
        ),
      );
    }

    final sortedProperties = _bookingsByProperty.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookings by Property',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...sortedProperties.take(5).map((entry) {
              final percentage = (_totalBookings > 0)
                  ? (entry.value / _totalBookings * 100)
                  : 0.0;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${entry.value} bookings (${percentage.toStringAsFixed(1)}%)',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrends() {
    if (_bookingsByMonth.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No monthly data available'),
        ),
      );
    }

    final sortedMonths = _bookingsByMonth.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Booking Distribution',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...sortedMonths.map((entry) {
              final maxBookings = sortedMonths
                  .map((e) => e.value)
                  .reduce((a, b) => a > b ? a : b);
              final percentage = maxBookings > 0
                  ? (entry.value / maxBookings)
                  : 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${entry.value} bookings',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentBookings() {
    final recentBookings = _allBookings.take(5).toList();

    if (recentBookings.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('No recent bookings'),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Bookings',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...recentBookings.map((booking) {
              final status = _getBookingStatus(booking);
              final statusColor = _getStatusColor(status);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.propertyName ??
                                'Property #${booking.propertyId}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${DateFormat('MMM dd').format(booking.checkInDate)} - ${DateFormat('MMM dd, yyyy').format(booking.checkOutDate)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _getBookingStatus(Booking booking) {
    final now = DateTime.now();
    if (now.isBefore(booking.checkInDate)) {
      return 'Upcoming';
    } else if (now.isAfter(booking.checkOutDate)) {
      return 'Completed';
    } else {
      return 'Active';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Upcoming':
        return Colors.blue;
      case 'Active':
        return Colors.green;
      case 'Completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
