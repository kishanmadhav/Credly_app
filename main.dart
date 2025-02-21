import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';  // Import the UserModel
import 'login_page.dart';     // Import the login page

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: const CibilScoreApp(),
    ),
  );
}

class CibilScoreApp extends StatelessWidget {
  const CibilScoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CIBIL Score Improvement',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: Consumer<UserModel>(
        builder: (context, userModel, child) {
          return userModel.user == null ? LoginPage() : const CibilScoreForm();
        },
      ),
    );
  }
}

class ResponseModel {
  final String response;
  final DateTime timestamp;

  ResponseModel(this.response) : timestamp = DateTime.now();
}

class CibilScoreForm extends StatefulWidget {
  const CibilScoreForm({Key? key}) : super(key: key);

  @override
  _CibilScoreFormState createState() => _CibilScoreFormState();
}

class _CibilScoreFormState extends State<CibilScoreForm> {
  final _formKey = GlobalKey<FormState>();

  // User Inputs
  final _currentCibilController = TextEditingController();
  final _goalCibilController = TextEditingController();
  final _bankBalanceController = TextEditingController();
  final _monthlyIncomeController = TextEditingController();

  bool _hasLoan = false;
  bool _hasCreditCard = false;

  // Loan and Credit Card Details
  final _loanPrincipalController = TextEditingController();
  final _loanInterestController = TextEditingController();
  final _loanPaymentDateController = TextEditingController();
  final _loanTermController = TextEditingController();

  final _creditCardPrincipalController = TextEditingController();
  final _creditCardInterestController = TextEditingController();
  final _creditCardPaymentDateController = TextEditingController();
  final _creditCardTermController = TextEditingController();

  String? _aiResponse;
  String _followUpQuestion = '';
  List<ResponseModel> _previousResponses = []; // List to store responses

  @override
  void dispose() {
    // Clean up controllers
    _currentCibilController.dispose();
    _goalCibilController.dispose();
    _bankBalanceController.dispose();
    _monthlyIncomeController.dispose();
    _loanPrincipalController.dispose();
    _loanInterestController.dispose();
    _loanPaymentDateController.dispose();
    _loanTermController.dispose();
    _creditCardPrincipalController.dispose();
    _creditCardInterestController.dispose();
    _creditCardPaymentDateController.dispose();
    _creditCardTermController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Credly',
        style: TextStyle(color: Colors.blue, fontSize: 24),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildTextField(_currentCibilController, 'Current CIBIL Score', TextInputType.number),
                _buildTextField(_goalCibilController, 'Goal CIBIL Score', TextInputType.number),
                _buildTextField(_bankBalanceController, 'Bank Balance', TextInputType.number),
                _buildTextField(_monthlyIncomeController, 'Monthly Income', TextInputType.number),
                const SizedBox(height: 20),
                _buildCheckBoxTile('Do you have any ongoing loans?', _hasLoan, (bool? value) {
                  setState(() {
                    _hasLoan = value ?? false;
                  });
                }),
                if (_hasLoan) ..._buildLoanFields(),
                const SizedBox(height: 20),
                _buildCheckBoxTile('Do you have any credit cards?', _hasCreditCard, (bool? value) {
                  setState(() {
                    _hasCreditCard = value ?? false;
                  });
                }),
                if (_hasCreditCard) ..._buildCreditCardFields(),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _submitForm();
                    }
                  },
                  child: const Text(
                    'Get Recommendations',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewResponsesScreen(responses: _previousResponses),
                      ),
                    );
                  },
                  child: const Text(
                    'Review Previous Responses',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                // Back Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                if (_aiResponse != null) _buildAIResponse(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  List<Widget> _buildLoanFields() {
    return [
      _buildTextField(_loanPrincipalController, 'Loan Principal Amount', TextInputType.number),
      _buildTextField(_loanInterestController, 'Loan Interest Rate (%)', TextInputType.number),
      _buildTextField(_loanPaymentDateController, 'Loan EMI Payment Date (DD)', TextInputType.number),
      _buildTextField(_loanTermController, 'Loan Term (months)', TextInputType.number),
    ];
  }

  List<Widget> _buildCreditCardFields() {
    return [
      _buildTextField(_creditCardPrincipalController, 'Credit Card Outstanding Amount', TextInputType.number),
      _buildTextField(_creditCardInterestController, 'Credit Card Interest Rate (%)', TextInputType.number),
      _buildTextField(_creditCardPaymentDateController, 'Credit Card Payment Date (DD)', TextInputType.number),
      _buildTextField(_creditCardTermController, 'Credit Card Term (months)', TextInputType.number),
    ];
  }

  Widget _buildCheckBoxTile(String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.blueAccent,
    );
  }

  Widget _buildAIResponse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.grey[850],
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _aiResponse ?? 'No response available',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          onChanged: (value) {
            _followUpQuestion = value;
          },
          decoration: InputDecoration(
            labelText: 'Ask a follow-up question',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_followUpQuestion.isNotEmpty) {
              _submitFollowUpQuestion();
            }
          },
          child: const Text('Submit Follow-Up Question'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _submitForm();
          },
          child: const Text('Regenerate Response'),
        ),
      ],
    );
  }

  void _submitForm() async {
    String currentCibil = _currentCibilController.text;
    String goalCibil = _goalCibilController.text;
    String bankBalance = _bankBalanceController.text;
    String monthlyIncome = _monthlyIncomeController.text;

    // Compile the user input into a prompt
    String prompt = 'Current CIBIL Score: $currentCibil, '
        'Goal CIBIL Score: $goalCibil, '
        'Bank Balance: $bankBalance, '
        'Monthly Income: $monthlyIncome. '
        'Give recommendations to improve the CIBIL score.';

    await _generateResponse(prompt);
  }

  void _submitFollowUpQuestion() async {
    String prompt = 'Follow-up Question: $_followUpQuestion. Provide additional guidance.';

    await _generateResponse(prompt);
  }

  Future<void> _generateResponse(String prompt) async {
    try {
      const apiKey = 'AIzaSyDgyq7eeNi4bObHlHKAhg3k0PaEzOhZhpw';
      if (apiKey.isEmpty) {
        throw Exception('API Key is not set');
      }

      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        _aiResponse = response.text ?? 'No response available';
        _previousResponses.add(ResponseModel(_aiResponse!)); // Save the response
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

class ReviewResponsesScreen extends StatelessWidget {
  final List<ResponseModel> responses;

  ReviewResponsesScreen({required this.responses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Responses'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: responses.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey[850],
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                responses[index].response,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                responses[index].timestamp.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
