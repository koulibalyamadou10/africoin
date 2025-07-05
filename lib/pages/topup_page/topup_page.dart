import 'package:flutter/material.dart';
import 'package:africoin/services/auth_service.dart';
import 'package:africoin/services/transaction_service.dart';
import 'package:africoin/services/country_service.dart';
import 'package:africoin/widgets/custom_appbar.dart';

class TopUpPage extends StatefulWidget {
  @override
  _TopUpPageState createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedPaymentMethod = 'mobile_money';
  bool _isLoading = false;
  double _africoinAmount = 0.0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'mobile_money',
      'name': 'Mobile Money',
      'icon': Icons.phone_android,
      'description': 'Orange Money, MTN Money, Moov Money',
    },
    {
      'id': 'bank_card',
      'name': 'Carte bancaire',
      'icon': Icons.credit_card,
      'description': 'Visa, Mastercard',
    },
    {
      'id': 'bank_transfer',
      'name': 'Virement bancaire',
      'icon': Icons.account_balance,
      'description': 'Virement depuis votre banque',
    },
    {
      'id': 'crypto',
      'name': 'Cryptomonnaie',
      'icon': Icons.currency_bitcoin,
      'description': 'Bitcoin, Ethereum, USDT',
    },
  ];

  void _calculateAfricoinAmount() {
    final localAmount = double.tryParse(_amountController.text);
    if (localAmount == null || localAmount <= 0) {
      setState(() => _africoinAmount = 0.0);
      return;
    }

    final user = AuthService.currentUser!;
    setState(() {
      _africoinAmount = CountryService.convertLocalToAfricoin(
        localAmount, 
        user.country
      );
    });
  }

  Future<void> _processTopUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = AuthService.currentUser!;
      final paymentMethod = _paymentMethods.firstWhere(
        (method) => method['id'] == _selectedPaymentMethod
      )['name'];

      await TransactionService.topUpAccount(
        userId: user.id,
        amount: _africoinAmount,
        paymentMethod: paymentMethod,
      );

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Rechargement réussi!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Votre compte a été rechargé avec succès.'),
                SizedBox(height: 8),
                Text(
                  '${_africoinAmount.toStringAsFixed(2)} AC ajoutés',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du rechargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;
    final country = CountryService.getCountryByName(user.country);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'Recharger le compte'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Solde actuel
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_balance_wallet, 
                         color: Colors.white, size: 32),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Solde actuel',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${user.afriCoinBalance.toStringAsFixed(2)} AC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            CountryService.formatCurrency(
                              user.localCurrencyBalance, 
                              country?.code ?? 'CI'
                            ),
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Montant à recharger
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Montant à recharger',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Montant en ${country?.currency ?? 'FCFA'}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: Icon(Icons.monetization_on),
                        suffixText: country?.currency ?? 'FCFA',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un montant';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Montant invalide';
                        }
                        if (amount < 1000) {
                          return 'Montant minimum: 1000 ${country?.currency ?? 'FCFA'}';
                        }
                        return null;
                      },
                      onChanged: (_) => _calculateAfricoinAmount(),
                    ),

                    if (_africoinAmount > 0) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vous recevrez:',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${_africoinAmount.toStringAsFixed(2)} AC',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Méthodes de paiement
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Méthode de paiement',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    ..._paymentMethods.map((method) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        child: RadioListTile<String>(
                          value: method['id'],
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() => _selectedPaymentMethod = value!);
                          },
                          title: Row(
                            children: [
                              Icon(method['icon'], color: Colors.orange),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      method['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      method['description'],
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          activeColor: Colors.orange,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

              Spacer(),

              // Bouton de rechargement
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processTopUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Recharger maintenant',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}