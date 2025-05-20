import 'package:expense_tracker/models/account.dart'; // Unused in the GetX part, but kept for now
import 'package:expense_tracker/models/transaction_demo.dart';
import 'package:flutter/material.dart';
// Removed: import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart'; // Added GetX import
import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path; // Not used in GetX part
// import 'package:sqflite/sqflite.dart' as sql; // Not used in GetX part

// Import the GetX controller
import '../provider/transactions_provider.dart';

// Changed from ConsumerStatefulWidget to StatefulWidget
class AddNewTransactionScreen extends StatefulWidget {
  const AddNewTransactionScreen({super.key});

  @override
  State<AddNewTransactionScreen> createState() =>
      _AddNewTransactionScreenState();
}

class _AddNewTransactionScreenState
    extends State<AddNewTransactionScreen> {
  // Note: Original code had 'fomatter', corrected to 'formatter' for consistency
  final DateFormat formatter = DateFormat.yMd(); 
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _amountTextEditingController =
      TextEditingController();
  DateTime? _selectedDate;
  // bool isCashback = false; // Commented out as it's not used in saveTransaction
  
  // Initialize with default values to avoid null issues before selection
  String _selectedAccount = "Not Selected";
  String _selectedCategory = "Not Selected";
  String _selectedModeOfPayment = "Not Selected";
  
  // Sample data for dropdowns - kept as is from original
  List<DropdownMenuEntry<String>> categories = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Category"),
    const DropdownMenuEntry<String>(value: "1", label: "Food"),
    const DropdownMenuEntry<String>(value: "2", label: "Travel"),
    const DropdownMenuEntry<String>(value: "3", label: "Shopping"),
    const DropdownMenuEntry<String>(value: "4", label: "Entertainment"),
    const DropdownMenuEntry<String>(value: "5", label: "Other"),
  ];

  List<DropdownMenuEntry<String>> accounts = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Account"),
    const DropdownMenuEntry<String>(value: "1", label: "HDFC Bank"),
    const DropdownMenuEntry<String>(value: "2", label: "SBI Bank"),
    const DropdownMenuEntry<String>(value: "3", label: "Cash"),
  ];

  // merchants and subMerchants are commented out in the original UI building, so kept as is.
  // List<DropdownMenuEntry<String>> merchants = [ ... ];
  // List<DropdownMenuEntry<String>> subMerchants = [ ... ];

  List<DropdownMenuEntry<String>> paymentModes = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Payment Mode"),
    const DropdownMenuEntry<String>(value: "1", label: "UPI"),
    const DropdownMenuEntry<String>(value: "2", label: "Credit Card"),
    const DropdownMenuEntry<String>(value: "3", label: "Debit Card"),
    const DropdownMenuEntry<String>(value: "4", label: "Net Banking"),
    const DropdownMenuEntry<String>(value: "5", label: "Cash"),
  ];

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }
  
  @override
  void dispose() {
    _descriptionTextEditingController.dispose();
    _amountTextEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add New Transaction"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView( // Added SingleChildScrollView to prevent overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                      controller: _descriptionTextEditingController,
                      decoration:
                          const InputDecoration(label: Text("Description")),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description.';
                        }
                        return null;
                      },
                  ),
                  const SizedBox(height: 8),
                  DropdownMenu<String>(
                    initialSelection: _selectedCategory,
                    dropdownMenuEntries: categories,
                    enableSearch: false, // Search might not be ideal for few items
                    label: const Text("Category"),
                    onSelected: (value) {
                      if (value != null) setState(() => _selectedCategory = value);
                    },
                     width: MediaQuery.of(context).size.width - 24, // Adjust width
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountTextEditingController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(label: Text("Amount"), prefixText: "\$ "),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter an amount.';
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return 'Please enter a valid positive amount.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? "No Date is Selected"
                              : formatter.format(_selectedDate!),
                        ),
                      ),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.date_range),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  DropdownMenu<String>(
                    initialSelection: _selectedAccount,
                    dropdownMenuEntries: accounts,
                    enableSearch: false,
                    label: const Text("Account"),
                    onSelected: (value) {
                       if (value != null) setState(() => _selectedAccount = value);
                    },
                    width: MediaQuery.of(context).size.width - 24,
                  ),
                  const SizedBox(height: 8),
                  DropdownMenu<String>(
                    initialSelection: _selectedModeOfPayment,
                    dropdownMenuEntries: paymentModes,
                    enableSearch: false,
                    label: const Text("Payment Mode"),
                    onSelected: (value) {
                      if (value != null) setState(() => _selectedModeOfPayment = value);
                    },
                    width: MediaQuery.of(context).size.width - 24,
                  ),
                  const SizedBox(height: 20),
                  Center( // Center the button
                    child: ElevatedButton(
                        onPressed: () {
                          saveTransaction();
                        },
                        child: const Text("Save Transaction")),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date.')),
        );
        return;
      }
      if (_selectedCategory == "Not Selected") {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category.')),
        );
        return;
      }
       if (_selectedAccount == "Not Selected") {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an account.')),
        );
        return;
      }
       if (_selectedModeOfPayment == "Not Selected") {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a payment mode.')),
        );
        return;
      }

      // Find the TransactionsController
      final TransactionsController transactionsController = Get.find<TransactionsController>();

      // Create TransactionDemo object
      // Assuming transactionId is auto-generated or handled by the controller/DB
      // For now, using a placeholder or relying on controller logic.
      // The original TransactionDemo constructor has many parameters.
      // For this example, I'm simplifying based on available form fields.
      // A more robust solution would involve a proper mapping or ensuring all fields are collected.
      
      // Placeholder for transactionId, ideally, this comes from a sequence or DB
      final int transactionId = DateTime.now().millisecondsSinceEpoch; 
      final double amount = double.parse(_amountTextEditingController.text);
      final String description = _descriptionTextEditingController.text;
      
      // These IDs are string from dropdown, need to parse to int if model expects int
      final int categoryId = int.tryParse(_selectedCategory) ?? 0; // Default to 0 if parse fails
      final int accountId = int.tryParse(_selectedAccount) ?? 0; // Default to 0
      final int modeOfPaymentId = int.tryParse(_selectedModeOfPayment) ?? 0; // Default to 0


      final newTransaction = TransactionDemo(
        transactionId, // This ID needs proper handling
        amount,
        _selectedDate!,
        description,
        categoryId, 
        accountId,
        modeOfPaymentId, // Assuming this maps to an int for modeOfPayment
        // Other fields like subMerchant, debit, cashback, ownShare might be needed
        // depending on the TransactionDemo model and controller logic.
        // For now, using available fields.
      );

      transactionsController.addExpense(newTransaction); // addExpense method in controller adds a TransactionDemo

      // Show success message and pop
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction Saved!')),
      );
      if (mounted) {
        Navigator.pop(context);
      }

    } else {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }
}
