import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'buy_ticket_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic> _settings = {};
  String _ticketImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final data = await Supabase.instance.client
          .from('lottery_settings')
          .select()
          .single();
      setState(() {
        _settings = data;
        _ticketImageUrl = data['ticket_image_url'] ?? '';
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0: return _buildHome();
      case 1: return _buildAllDraws();
      case 2: return BuyTicketScreen(settings: _settings, imageUrl: _ticketImageUrl);
      case 3: return _buildMyTickets();
      case 4: return _buildProfile();
      default: return _buildHome();
    }
  }

  Widget _buildHome() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.menu, color: Colors.black),
              Column(
                children: [
                  Row(
                    children: [
                      Text('LUCKY ', style: TextStyle(color: Color(0xFF3B0099), fontWeight: FontWeight.w900, fontSize: 18)),
                      Text('★', style: TextStyle(color: Colors.orange, fontSize: 20)),
                      Text(' STAR', style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w900, fontSize: 18)),
                    ],
                  ),
                  Text('LOTTERY', style: TextStyle(color: Colors.red, fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C3BE8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('₹250.00', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const Icon(Icons.add_circle, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              // Banner
              _buildBanner(),
              const SizedBox(height: 16),
              // Quick actions
              _buildQuickActions(),
              const SizedBox(height: 16),
              // Upcoming Draw
              _buildUpcomingDraw(),
              const SizedBox(height: 16),
              // How it works
              _buildHowItWorks(),
              const SizedBox(height: 16),
              // Special offer
              _buildSpecialOffer(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1a0080), Color(0xFF003399)],
        ),
      ),
      child: Stack(
        children: [
          if (_ticketImageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: _ticketImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.3), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            top: 12, right: 12,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  const Text('Ticket No.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(_settings['ticket_prefix'] ?? 'L' + '15357',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12, left: 0, right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _currentIndex = 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Text('BUY TICKET NOW',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.confirmation_number, 'label': 'Buy Ticket', 'sub': 'Play Now', 'color': Color(0xFF6C3BE8)},
      {'icon': Icons.local_activity, 'label': 'My Tickets', 'sub': 'View Tickets', 'color': Color(0xFF1565C0)},
      {'icon': Icons.emoji_events, 'label': 'Results', 'sub': 'Check Results', 'color': Color(0xFF2E7D32)},
      {'icon': Icons.account_balance_wallet, 'label': 'Wallet', 'sub': 'Add Money', 'color': Color(0xFFE65100)},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((a) => Column(
          children: [
            CircleAvatar(
              backgroundColor: a['color'] as Color,
              radius: 28,
              child: Icon(a['icon'] as IconData, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 6),
            Text(a['label'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Text(a['sub'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildUpcomingDraw() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Upcoming Draw', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('View All >', style: TextStyle(color: Color(0xFF6C3BE8), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('LUCKY ', style: TextStyle(color: Color(0xFF3B0099), fontWeight: FontWeight.w900)),
                  Text('★', style: TextStyle(color: Colors.orange)),
                  Text(' STAR', style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w900)),
                ]),
                Text('LOTTERY', style: TextStyle(color: Colors.red, fontSize: 10, letterSpacing: 3)),
              ]),
              const Spacer(),
              Column(children: [
                const Text('Draw Date', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                  child: Text(_settings['draw_date'] ?? '15.06.2025',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ]),
              const SizedBox(width: 12),
              Column(children: [
                const Text('Draw Time', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Text(_settings['draw_time'] ?? '08:00 PM',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.pink.shade700)),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('First Prize', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Row(children: [
                  Text('₹', style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.w900)),
                  Text(_settings['prize_amount'] ?? '10',
                    style: const TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.w900)),
                  Text(' ${_settings['prize_label'] ?? 'LAKHS'}',
                    style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w900)),
                ]),
              ]),
              ElevatedButton(
                onPressed: () => setState(() => _currentIndex = 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C3BE8),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('PLAY NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {'icon': Icons.confirmation_number, 'label': 'Choose\na Lottery', 'color': Color(0xFF6C3BE8)},
      {'icon': Icons.account_balance_wallet, 'label': 'Buy\nTicket', 'color': Color(0xFF1565C0)},
      {'icon': Icons.hourglass_empty, 'label': 'Wait for\nthe Draw', 'color': Color(0xFF2E7D32)},
      {'icon': Icons.emoji_events, 'label': 'Win\nBig!', 'color': Color(0xFFE65100)},
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How It Works', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: steps.asMap().entries.map((e) => Row(
              children: [
                Column(children: [
                  Stack(children: [
                    CircleAvatar(backgroundColor: e.value['color'] as Color, radius: 24,
                      child: Icon(e.value['icon'] as IconData, color: Colors.white)),
                    Positioned(bottom: 0, right: 0,
                      child: CircleAvatar(backgroundColor: Colors.black, radius: 8,
                        child: Text('${e.key+1}', style: const TextStyle(color: Colors.white, fontSize: 8)))),
                  ]),
                  const SizedBox(height: 4),
                  Text(e.value['label'] as String, textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10)),
                ]),
                if (e.key < 3) const Text('- - -', style: TextStyle(color: Colors.grey)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialOffer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4A0080), Color(0xFF6C3BE8)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('🎁', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('SPECIAL OFFER', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 12)),
              const Text('Add ₹100 or more\n& get ₹10 Bonus!',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ]),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700)),
            child: const Text('ADD\nMONEY', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildAllDraws() {
    return const Center(child: Text('All Draws Coming Soon'));
  }

  Widget _buildMyTickets() {
    return const Center(child: Text('My Tickets Coming Soon'));
  }

  Widget _buildProfile() {
    return const Center(child: Text('Profile Coming Soon'));
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF6C3BE8),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All Draws'),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: 'Play Now'),
        BottomNavigationBarItem(icon: Icon(Icons.local_activity), label: 'My Tickets'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
