
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoanInterestPage extends StatefulWidget {
  @override
  _LoanInterestPageState createState() => _LoanInterestPageState();
}

class _LoanInterestPageState extends State<LoanInterestPage> {
  String _interestRates = 'Select a country to see interest rates';

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchInterestRates(String country) async {
    // Create the API URL based on the selected country
    String apiUrl = 'https://api.api-ninjas.com/v1/interestrate?country=$country';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-Api-Key': 'iFKwn5Atu/3YgSL9CzhtRA==bU0MYdWQJVZqGzmu', // Include your actual API key
        },
      );

      print('Response status: ${response.statusCode}'); // Debugging line
      print('Response body: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['central_bank_rates'] != null && data['central_bank_rates'].isNotEmpty) {
          // Extract and format the interest rates
          List<dynamic> rates = data['central_bank_rates'];
          StringBuffer ratesBuffer = StringBuffer();
          for (var rate in rates) {
            ratesBuffer.writeln(
              '${rate['central_bank']} in ${rate['country']} has an interest rate of ${rate['rate_pct']}% (Last updated: ${rate['last_updated']})',
            );
          }
          setState(() {
            _interestRates = ratesBuffer.toString();
          });
        } else {
          setState(() {
            _interestRates = 'No interest rates available for $country.';
          });
        }
      } else {
        throw Exception('Failed to load interest rates for $country');
      }
    } catch (error) {
      setState(() {
        _interestRates = 'Error fetching interest rates: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Interest Rates'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the interest rates
            SingleChildScrollView(
              child: Text(
                _interestRates,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            // Buttons for each country
            ElevatedButton(
              onPressed: () => _fetchInterestRates('china'),
              child: const Text('Get Interest Rates for China'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _fetchInterestRates('czech republic'),
              child: const Text('Get Interest Rates for Czech Republic'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _fetchInterestRates('united kingdom'),
              child: const Text('Get Interest Rates for United Kingdom'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _fetchInterestRates('denmark'),
              child: const Text('Get Interest Rates for Denmark'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _fetchInterestRates('new mexico'),
              child: const Text('Get Interest Rates for New Mexico'),
            ),
          ],
        ),
      ),
    );
  }
}
       