import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvestmentsPage extends StatefulWidget {
  @override
  _InvestmentsPageState createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> {
  String _selectedStockInfo = 'Select a stock to view its details';
  final List<String> _stockTickers = [
    'AAPL', 'TSLA', 'GOOGL', 'AMZN', 'MSFT',
    'NFLX', 'NVDA', 'FB', 'BABA', 'V',
    'JPM', 'DIS', 'MA', 'VZ', 'UNH',
    'HD', 'PYPL', 'PFE', 'BAC', 'KO',
    'PG', 'NKE', 'ADBE', 'CRM', 'MRK',
    'CSCO', 'INTC', 'PEP', 'XOM', 'WMT',
    'ORCL', 'T', 'CVX', 'WFC', 'MCD',
    'BA', 'C', 'LLY', 'AMD', 'ABBV',
    'CMCSA', 'QCOM', 'HON', 'RTX', 'MDT',
    'UNP', 'MMM', 'IBM', 'AXP', 'GS'
  ]; // List of 50 stock tickers

  Future<void> _fetchStock(String ticker) async {
    const apiKey = 'iFKwn5Atu/3YgSL9CzhtRA==bU0MYdWQJVZqGzmu'; // Replace with your API key
    final url = 'https://api.api-ninjas.com/v1/stockprice?ticker=$ticker';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'X-Api-Key': apiKey, // Replace with your actual API key
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _selectedStockInfo = '''
Stock: ${data['name']} (${data['ticker']})
Price: ₹${data['price']}
Exchange: ${data['exchange']}
Last Updated: ${data['updated']}
''';
        });
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (error) {
      setState(() {
        _selectedStockInfo = 'Error fetching stock data: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top Performing Stocks',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: StockSearchDelegate(
                  _stockTickers,
                  _fetchStock,
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Center(
              child: Text(
                'Credly',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 buttons per row
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 2.0,
                ),
                itemCount: _stockTickers.length,
                itemBuilder: (context, index) {
                  final ticker = _stockTickers[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue.shade800,
                    ),
                    onPressed: () {
                      _fetchStock(ticker); // Fetch stock data on button press
                    },
                    child: Text(ticker),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _selectedStockInfo,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// SearchDelegate class to handle stock search functionality
class StockSearchDelegate extends SearchDelegate {
  final List<String> stockTickers;
  final Function(String) onSelectedStock;

  StockSearchDelegate(this.stockTickers, this.onSelectedStock);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search input
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (stockTickers.contains(query.toUpperCase())) {
      onSelectedStock(query.toUpperCase()); // Fetch stock data for the selected stock
      close(context, query); // Close the search bar after selecting
      return Center(child: Text('Fetching data for $query...'));
    } else {
      return Center(child: Text('No results found'));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = stockTickers
        .where((ticker) => ticker.startsWith(query.toUpperCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion; // Update the query with the selected stock
            showResults(context); // Show results
          },
        );
      },
    );
  }
}
