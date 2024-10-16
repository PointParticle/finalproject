import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank ATM',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
        ),
      ),
      home: SendMoneyPage(),
    );
  }
}

class SendMoneyPage extends StatefulWidget {
  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController recipientController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedPaymentMethod;
  bool isFavorite = false;

  String? _recipientError;
  String? _amountError;
  bool successMessageVisible = false;

  void _sendMoney() {
    setState(() {
      _recipientError = validateRecipient(recipientController.text);
      _amountError = validateAmount(amountController.text);

      // Only show success message if validation passes
      if (_recipientError == null && _amountError == null) {
        // Simulate sending money
        successMessageVisible = true;

        // Hide the success message after a delay
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            successMessageVisible = false;
          });
        });

        // Clear fields after a successful transaction
        recipientController.clear();
        amountController.clear();
        selectedPaymentMethod = null;
        isFavorite = false;
      }
    });
  }

  String? validateRecipient(String value) {
    if (value.isEmpty) {
      return 'Recipient name cannot be empty';
    }
    return null;
  }

  String? validateAmount(String value) {
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Please enter a positive amount';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Money'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: recipientController,
              decoration: InputDecoration(
                labelText: 'Recipient Name',
                errorText: _recipientError,
              ),
            ),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                errorText: _amountError,
              ),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              hint: Text('Select Payment Method'),
              items: <String>['Bank Transfer', 'Mobile Payment', 'Credit Card']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue!;
                });
              },
            ),
            SwitchListTile(
              title: Text('Mark as Favorite'),
              value: isFavorite,
              onChanged: (bool value) {
                setState(() {
                  isFavorite = value;
                });
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Send Money',
              onPressed: _sendMoney,
            ),
            SizedBox(height: 20),
            AnimatedOpacity(
              opacity: successMessageVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: Text(
                'Transaction Successful!',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        textStyle: TextStyle(fontSize: 16),
      ),
      child: Text(text),
    );
  }
}
