import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

class BuyTicketScreen extends StatefulWidget {
  final Map<String, dynamic> settings;
  final String imageUrl;
  const BuyTicketScreen({super.key, required this.settings, required this.imageUrl});
  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _searchController = TextEditingController();
  List<String> _tickets = [];
  int _currentPage = 0;
  String _selectedTicket = '';

  @override
  void initState() {
    super.initState();
    _generateTickets();
  }

  void _generateTickets() {
    final prefix = widget.settings['ticket_prefix'] ?? 'L';
    final random = Random();
    _tickets = List.generate(50, (i) => '$prefix${10000 + random.nextInt(90000)}');
    _selectedTicket = _tickets[0];
  }

  void _addNewTicket() {
    final prefix = widget.settings['ticket_prefix'] ?? 'L';
    final random = Random();
    setState(() {
      _tickets.add('$prefix${10000 + random.nextInt(90000)}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final price = widget.settings['ticket_price'] ?? '10';
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Buy Ticket', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFF6C3BE8), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              const Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Text('₹250.00', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Icon(Icons.add_circle, color: Colors.white, size: 16),
            ]),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4)]),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search by Ticket No.',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        setState(() {
                          if (!_tickets.contains(val)) _tickets.insert(0, val);
                          _selectedTicket = val;
                          _currentPage = 0;
                          _pageController.jumpToPage(0);
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF6C3BE8))),
                child: Row(children: [
                  const Icon(Icons.qr_code_scanner, color: Color(0xFF6C3BE8), size: 16),
                  const SizedBox(width: 4),
                  const Text('Scan', style: TextStyle(color: Color(0xFF6C3BE8), fontWeight: FontWeight.bold)),
                ]),
              ),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Align(alignment: Alignment.centerLeft,
              child: Text('Enter any ticket number to view', style: TextStyle(color: Colors.grey, fontSize: 12))),
          ),
          // Ticket slider
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() {
                _currentPage = i;
                _selectedTicket = _tickets[i % _tickets.length];
              }),
              itemBuilder: (context, index) {
                final ticketNum = _tickets[index % _tickets.length];
                return _buildTicketCard(ticketNum, index);
              },
            ),
          ),
          // Bottom info
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    child: Column(children: [
                      const Text('Total Tickets', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const Text('∞', style: TextStyle(color: Color(0xFF6C3BE8), fontSize: 28, fontWeight: FontWeight.bold)),
                      const Text('Unlimited', style: TextStyle(color: Color(0xFF6C3BE8), fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  Container(width: 1, height: 60, color: Colors.grey.shade200),
                  Expanded(
                    child: Column(children: [
                      const Text('Total Amount', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text('₹$price.00', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Selected Ticket', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(_selectedTicket, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  ]),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ticket $_selectedTicket selected!')));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C3BE8),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Row(children: const [
                      Text('BUY NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ]),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(String ticketNum, int index) {
    final settings = widget.settings;
    final prize = settings['prize_amount'] ?? '10';
    final label = settings['prize_label'] ?? 'LAKHS';
    final drawDate = settings['draw_date'] ?? '15.06.2025';
    final drawTime = settings['draw_time'] ?? '08:00 PM';
    final price = settings['ticket_price'] ?? '10';

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                // Ticket image background
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.fill,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : _buildTicketFallback(prize, label, drawDate, drawTime, price),
                ),
                // Ticket number overlay - positioned where the box is on image
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(ticketNum,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                        fontFamily: 'monospace',
                        color: Colors.black,
                      )),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Ticket ${(index % _tickets.length) + 1} of Unlimited',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        // Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == _currentPage % 7 ? 10 : 7,
            height: i == _currentPage % 7 ? 10 : 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == _currentPage % 7 ? const Color(0xFF6C3BE8) : Colors.grey.shade300,
            ),
          )),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTicketFallback(String prize, String label, String drawDate, String drawTime, String price) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: [
        Container(color: Colors.red, padding: const EdgeInsets.all(4),
          child: const Text('★ LUCKY STAR LOTTERY ★ LUCKY STAR LOTTERY ★',
            style: TextStyle(color: Colors.white, fontSize: 8), maxLines: 1)),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0xFF87CEEB), Color(0xFF228B22)],
              ),
            ),
            child: Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('LUCKY ', style: TextStyle(color: Color(0xFF1a0080), fontWeight: FontWeight.w900, fontSize: 22)),
                  Text('★', style: TextStyle(color: Colors.orange, fontSize: 24)),
                  Text(' STAR', style: TextStyle(color: Color(0xFF1a0080), fontWeight: FontWeight.w900, fontSize: 22)),
                ]),
                Text('LOTTERY', style: TextStyle(color: Colors.red, letterSpacing: 6, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  color: const Color(0xFF003399),
                  child: const Text('FIRST PRIZE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 3))),
                const SizedBox(height: 8),
                Text('₹$prize $label', style: const TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.w900)),
              ]),
            ),
          ),
        ),
      ])

mkdir -p android/app/src/main && cat > android/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    <application
        android:label="Lucky Star Lottery"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data android:name="io.flutter.embedding.android.NormalTheme" android:resource="@style/NormalTheme"/>
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <meta-data android:name="flutterEmbedding" android:value="2"/>
    </application>
</manifest>
