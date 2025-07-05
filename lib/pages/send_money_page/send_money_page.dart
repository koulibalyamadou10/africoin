import 'package:flutter/material.dart';
import 'package:africoin/services/auth_service.dart';
import 'package:africoin/models/transaction_model.dart';
import 'package:africoin/widgets/custom_appbar.dart';

// Écran d'envoi d'argent
class SendMoneyScreen extends StatefulWidget {
  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'Envoyer de l\'argent'),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Solde disponible
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Solde disponible',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${user.afriCoinBalance.toStringAsFixed(2)} AC',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Champ destinataire
              TextFormField(
                controller: _recipientController,
                decoration: InputDecoration(
                  labelText: 'Email ou téléphone du destinataire',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un destinataire';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Champ montant
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Montant (AFRICOIN)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.monetization_on),
                  suffixText: 'AC',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Montant invalide';
                  }
                  if (amount > user.afriCoinBalance) {
                    return 'Solde insuffisant';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              // Champ description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (optionnel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
              
              SizedBox(height: 32),
              
              // Bouton envoyer
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendMoney,
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
                          'Envoyer',
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

  Future<void> _sendMoney() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulation d'envoi
    await Future.delayed(Duration(seconds: 2));

    final amount = double.parse(_amountController.text);
    final user = AuthService.currentUser!;

    // Créer la transaction
    final transaction = Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fromUserId: user.id,
      toUserId: 'recipient_id', // En réalité, on rechercherait l'utilisateur
      amount: amount,
      date: DateTime.now(),
      type: TransactionType.send,
      status: TransactionStatus.completed,
      description: _descriptionController.text,
    );

    // Mettre à jour le solde
    user.afriCoinBalance -= amount;
    AuthService.transactions.add(transaction);

    setState(() => _isLoading = false);

    // Afficher confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Envoi réussi!'),
        content: Text('${amount.toStringAsFixed(2)} AC envoyés avec succès'),
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
}
