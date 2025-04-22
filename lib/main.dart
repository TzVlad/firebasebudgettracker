import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Tracker',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const Budgettracker(),
    );
  }
}

class Budgettracker extends StatefulWidget {
  const Budgettracker({super.key});

  @override
  State<Budgettracker> createState() => _BudgettrackerState();
}

class _BudgettrackerState extends State<Budgettracker> {
  final _startController = TextEditingController();
  final _incomeController = TextEditingController();
  final _expenseController = TextEditingController();

  double _balance = 0;

  void _setStartBudget() {
    final start = double.tryParse(_startController.text);
    if (start != null) {
      setState(() {
        _balance = start;
      });
      FirebaseFirestore.instance.collection('budget').doc('current').set({
        'balance': _balance,
      });
    }
  }

  void _addIncome() {
    final income = double.tryParse(_incomeController.text);
    if (income != null) {
      setState(() {
        _balance += income;
      });
      FirebaseFirestore.instance.collection('budget').doc('current').update({
        'balance': _balance,
      });
    }
  }

  void _addExpense() {
    final expense = double.tryParse(_expenseController.text);
    if (expense != null) {
      setState(() {
        _balance -= expense;
      });
      FirebaseFirestore.instance.collection('budget').doc('current').update({
        'balance': _balance,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('budget').doc('current').get().then((
      doc,
    ) {
      if (doc.exists && doc.data()!.containsKey('balance')) {
        setState(() {
          _balance = (doc.data()!['balance'] as num).toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _startController.dispose();
    _incomeController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Tracker')),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.black,
        child: Column(
          
          children: [
            Text(
              'Balance: \$${_balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
              selectionColor: Colors.cyanAccent,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _startController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color.fromARGB(255, 184, 175, 175)),
              decoration: const InputDecoration(
                hintText: 'starting budget',
                hintStyle: TextStyle(color: Color.fromARGB(190, 255, 255, 255)),
                filled: true,
                fillColor: Color.fromARGB(187, 19, 17, 17),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              onPressed: _setStartBudget,
              child: const Text('Start Budget'),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color.fromARGB(255, 184, 175, 175)),
              decoration: const InputDecoration(
                hintText: 'income',
                hintStyle: TextStyle(color: Color.fromARGB(190, 255, 255, 255)),
                filled: true,
                fillColor: Color.fromARGB(187, 19, 17, 17),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              onPressed: _addIncome,
              child: const Text('Add Income'),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _expenseController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color.fromARGB(255, 184, 175, 175)),
              decoration: const InputDecoration(
                hintText: 'expense',
                hintStyle: TextStyle(color: Color.fromARGB(190, 255, 255, 255)),
                filled: true,
                fillColor: Color.fromARGB(187, 19, 17, 17),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
              ),
              onPressed: _addExpense,
              child: const Text('Add expense'),
            ),
          ],
        ),
      ),
    );
  }
}
