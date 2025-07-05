import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:africoin/pages/profil_page/profil_page.dart';
import 'package:africoin/pages/qr_scanner_page/qr_scanner_page.dart';
import 'package:africoin/pages/receive_money_page/receive_money_page.dart';
import 'package:africoin/pages/send_money_page/send_money_page.dart';
import 'package:africoin/pages/transaction_history_page.dart';

// Modèles de données
class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final String date;
  final IconData icon;
  final Color iconColor;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.iconColor,
    required this.type,
  });
}

enum TransactionType { income, expense, transfer }

// Composant pour le header avec balance - Version moderne
class BalanceHeader extends StatelessWidget {
  final double balance;
  final VoidCallback? onProfileTap;

  const BalanceHeader({Key? key, required this.balance, this.onProfileTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Solde disponible',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${balance.toStringAsFixed(2)} FCFA',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/1-sf.png'),
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceInfo('Revenus', '+125,000 FCFA', Colors.green),
                  _buildBalanceInfo('Dépenses', '-45,000 FCFA', Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// Composant pour les actions rapides - Version moderne
class QuickActions extends StatelessWidget {
  final VoidCallback? onSend;
  final VoidCallback? onRequest;
  final VoidCallback? onLoan;
  final VoidCallback? onTopup;

  const QuickActions({
    Key? key,
    this.onSend,
    this.onRequest,
    this.onLoan,
    this.onTopup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions rapides',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a1a1a),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                QuickActionButton(
                  icon: Icons.send_rounded,
                  label: 'Envoyer',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  onTap: onSend,
                ),
                QuickActionButton(
                  icon: Icons.qr_code_scanner_rounded,
                  label: 'Scanner',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
                  ),
                  onTap: onRequest,
                ),
                QuickActionButton(
                  icon: Icons.account_balance_rounded,
                  label: 'Prêt',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  onTap: onLoan,
                ),
                QuickActionButton(
                  icon: Icons.add_circle_rounded,
                  label: 'Recharger',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                  ),
                  onTap: onTopup,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour un bouton d'action rapide - Version moderne
class QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback? onTap;

  const QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.gradient,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour la section des transactions récentes - Version moderne
class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback? onSeeAll;

  const RecentTransactions({
    Key? key,
    required this.transactions,
    this.onSeeAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transactions récentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Voir tout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TransactionFilters(),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children:
                        transactions
                            .map(
                              (transaction) =>
                                  TransactionItem(transaction: transaction),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Composant pour les filtres de transactions - Version moderne
class TransactionFilters extends StatefulWidget {
  @override
  _TransactionFiltersState createState() => _TransactionFiltersState();
}

class _TransactionFiltersState extends State<TransactionFilters> {
  String selectedFilter = 'Tout';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilterChip(
          label: 'Tout',
          selected: selectedFilter == 'Tout',
          onTap: () => setState(() => selectedFilter = 'Tout'),
        ),
        const SizedBox(width: 12),
        FilterChip(
          label: 'Revenus',
          selected: selectedFilter == 'Revenus',
          onTap: () => setState(() => selectedFilter = 'Revenus'),
        ),
        const SizedBox(width: 12),
        FilterChip(
          label: 'Dépenses',
          selected: selectedFilter == 'Dépenses',
          onTap: () => setState(() => selectedFilter = 'Dépenses'),
        ),
      ],
    );
  }
}

// Composant pour une puce de filtre - Version moderne
class FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const FilterChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  )
                  : null,
          color: selected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF667eea).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// Composant pour un élément de transaction - Version moderne
class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({Key? key, required this.transaction})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  transaction.iconColor.withOpacity(0.2),
                  transaction.iconColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: transaction.iconColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              transaction.icon,
              color: transaction.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1a1a1a),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount >= 0 ? '+' : ''}${transaction.amount.toStringAsFixed(0)} FCFA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction.amount >= 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                transaction.date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Composant pour la barre de navigation - Version moderne
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Accueil', 0),
              _buildNavItem(Icons.history_rounded, 'Historique', 1),
              _buildCenterButton(),
              _buildNavItem(Icons.chat_rounded, 'Chat', 3),
              _buildNavItem(Icons.settings_rounded, 'Paramètres', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        onTap(index);
        _navigateToPage(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF667eea) : Colors.grey[400],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF667eea) : Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0: // Accueil - reste sur dashboard
        break;
      case 1: // Historique
        Get.to(
          () => TransactionHistoryScreen(),
          transition: Transition.rightToLeft,
        );
        break;
      case 3: // Scanner QR
        Get.to(() => QRScannerScreen(), transition: Transition.rightToLeft);
        break;
      case 4: // Profil
        Get.to(() => ProfileScreen(), transition: Transition.rightToLeft);
        break;
    }
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: () => _showActionMenu(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667eea).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  void _showActionMenu() {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionItem(
                      icon: Icons.send_rounded,
                      label: 'Envoyer',
                      color: const Color(0xFF667eea),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(
                          () => SendMoneyScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                    _buildActionItem(
                      icon: Icons.qr_code_rounded,
                      label: 'Recevoir',
                      color: const Color(0xFF43e97b),
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(
                          () => ReceiveMoneyScreen(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1a1a1a),
            ),
          ),
        ],
      ),
    );
  }
}

// Page principale
class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Épicerie',
      subtitle: 'Achat au marché',
      amount: -5000,
      date: 'Aujourd\'hui',
      icon: Icons.shopping_cart_rounded,
      iconColor: const Color(0xFFff6b6b),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '2',
      title: 'Transport',
      subtitle: 'Taxi Uber',
      amount: -1500,
      date: 'Aujourd\'hui',
      icon: Icons.directions_car_rounded,
      iconColor: const Color(0xFF4ecdc4),
      type: TransactionType.expense,
    ),
    Transaction(
      id: '3',
      title: 'Paiement reçu',
      subtitle: 'De André Kouassi',
      amount: 25000,
      date: 'Hier',
      icon: Icons.payment_rounded,
      iconColor: const Color(0xFF45b7d1),
      type: TransactionType.income,
    ),
    Transaction(
      id: '4',
      title: 'Transfert',
      subtitle: 'Vers compte épargne',
      amount: -10000,
      date: 'Hier',
      icon: Icons.account_balance_rounded,
      iconColor: const Color(0xFF96ceb4),
      type: TransactionType.transfer,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: Column(
        children: [
          BalanceHeader(
            balance: 125000,
            onProfileTap: () {
              print('Profile tapped');
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  QuickActions(
                    onSend: () => print('Send tapped'),
                    onRequest: () => print('Request tapped'),
                    onLoan: () => print('Loan tapped'),
                    onTopup: () => print('Topup tapped'),
                  ),
                  const SizedBox(height: 16),
                  RecentTransactions(
                    transactions: _transactions,
                    onSeeAll: () => print('See all tapped'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
