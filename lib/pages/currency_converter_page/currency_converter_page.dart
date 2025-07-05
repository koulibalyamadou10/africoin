import 'package:flutter/material.dart';
import 'package:africoin/services/country_service.dart';
import 'package:africoin/models/country_model.dart';
import 'package:africoin/widgets/custom_appbar.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final TextEditingController _amountController = TextEditingController();
  Country? _fromCountry;
  Country? _toCountry;
  double _convertedAmount = 0.0;
  bool _isAfricoinToLocal = true;

  @override
  void initState() {
    super.initState();
    final countries = CountryService.supportedCountries;
    if (countries.isNotEmpty) {
      _fromCountry = countries.first;
      _toCountry = countries.length > 1 ? countries[1] : countries.first;
    }
  }

  void _convertCurrency() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() => _convertedAmount = 0.0);
      return;
    }

    if (_isAfricoinToLocal) {
      // AFRICOIN vers devise locale
      setState(() {
        _convertedAmount = CountryService.convertAfricoinToLocal(
          amount, 
          _toCountry?.code ?? 'CI'
        );
      });
    } else {
      // Devise locale vers AFRICOIN
      setState(() {
        _convertedAmount = CountryService.convertLocalToAfricoin(
          amount, 
          _fromCountry?.code ?? 'CI'
        );
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      _isAfricoinToLocal = !_isAfricoinToLocal;
      _amountController.clear();
      _convertedAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(title: 'Convertisseur de devises'),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Carte de conversion
            Container(
              padding: EdgeInsets.all(24),
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
                children: [
                  // Section "De"
                  _buildCurrencySection(
                    title: 'De',
                    isFrom: true,
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Bouton d'échange
                  GestureDetector(
                    onTap: _swapCurrencies,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.3)),
                      ),
                      child: Icon(
                        Icons.swap_vert,
                        color: Colors.orange,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Section "Vers"
                  _buildCurrencySection(
                    title: 'Vers',
                    isFrom: false,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Taux de change
            if (_fromCountry != null && _toCountry != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      _buildExchangeRateText(),
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            
            SizedBox(height: 24),
            
            // Tableau des taux
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
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
                      'Taux de change AFRICOIN',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: CountryService.supportedCountries.length,
                        itemBuilder: (context, index) {
                          final country = CountryService.supportedCountries[index];
                          return _buildRateItem(country);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySection({required String title, required bool isFrom}) {
    final isAfricoin = isFrom ? _isAfricoinToLocal : !_isAfricoinToLocal;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 12),
        
        if (isAfricoin) ...[
          // Section AFRICOIN
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'AC',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AFRICOIN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Monnaie panafricaine',
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
          ),
          SizedBox(height: 12),
          if (isFrom) ...[
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Montant en AFRICOIN',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'AC',
              ),
              onChanged: (_) => _convertCurrency(),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _convertedAmount.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'AC',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ] else ...[
          // Section devise locale
          DropdownButtonFormField<Country>(
            value: isFrom ? _fromCountry : _toCountry,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: CountryService.supportedCountries.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Row(
                  children: [
                    Text(
                      country.flag,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            country.name,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            country.currency,
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
              );
            }).toList(),
            onChanged: (country) {
              setState(() {
                if (isFrom) {
                  _fromCountry = country;
                } else {
                  _toCountry = country;
                }
                _convertCurrency();
              });
            },
          ),
          SizedBox(height: 12),
          if (isFrom) ...[
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Montant en ${_fromCountry?.currency ?? ''}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: _fromCountry?.currency ?? '',
              ),
              onChanged: (_) => _convertCurrency(),
            ),
          ] else ...[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _convertedAmount.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _toCountry?.currency ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  String _buildExchangeRateText() {
    if (_isAfricoinToLocal) {
      return '1 AC = ${_toCountry?.exchangeRate.toStringAsFixed(0)} ${_toCountry?.currency}';
    } else {
      return '1 ${_fromCountry?.currency} = ${(1 / (_fromCountry?.exchangeRate ?? 1)).toStringAsFixed(4)} AC';
    }
  }

  Widget _buildRateItem(Country country) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            country.flag,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  country.currency,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '1 AC = ${country.exchangeRate.toStringAsFixed(0)} ${country.currency}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}