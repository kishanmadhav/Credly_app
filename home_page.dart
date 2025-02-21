import 'package:flutter/material.dart';
import 'main.dart';
import 'general_page.dart';
import 'investments_page.dart';
import 'loan_interest_page.dart'; // Import the new Loan Interest Page

class HomePage extends StatelessWidget {
  final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credly'),
        backgroundColor: Colors.blue.shade800, // Dark blue color for the app bar
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colors.black, // Black background
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Credly',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800, // Dark blue text
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Hello, $userName!', // Greeting user with their name
              style: TextStyle(
                fontSize: 24,
                color: Colors.blue.shade800, // Dark blue text
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'What would you like to do today?',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue, // Dark blue text
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade800, // Dark blue button color
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CibilScoreForm()), // Navigate to CIBIL score form
                );
              },
              child: const Text('Improve My CIBIL Score'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade800, // Dark blue button color
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeneralPage()), // Navigate to general practices
                );
              },
              child: const Text('View General Good CIBIL Score Practices'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade800, // Dark blue button color
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoanInterestPage()), // Navigate to Loan Interest Page
                );
              },
              child: const Text('View Loan Interest Rates'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue.shade800, // Dark blue button color
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvestmentsPage()), // Navigate to Investments Page
                );
              },
              child: const Text('View Top Performing Stocks'),
            ),
          ],
        ),
      ),
    );
  }
}
