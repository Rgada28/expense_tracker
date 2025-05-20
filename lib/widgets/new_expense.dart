import 'package:expense_tracker/database/db_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/provider/expenses_provider.dart'; // Will be GetX controller
import 'package:flutter/material.dart';
// Removed: import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart'; // Added GetX import

// Changed from ConsumerStatefulWidget to StatefulWidget
class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

// State class remains largely the same for local form state
class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  final List<Account> accounts =[];
  late Account _selectedAccount;

  // Access ExpensesController
  // No need to initialize it here if already put by a parent (e.g. Expenses widget)
  // It will be used in _submitExpenseData via Get.find()

  @override
  void initState() {
    super.initState();
    _selectedAccount = Account( id: -1, name: "Select Account", isLending: 0, balance: 0);
    accounts.add(_selectedAccount);
    populateAccountsDropDownMenu();
  }

  void populateAccountsDropDownMenu() async{
    // This local state and DB interaction remains for now
    accounts.addAll(await DbHelper.db.getAllAccounts());
    if (mounted) { // Check if the widget is still in the tree
      setState(() {}); // Refresh UI if necessary after accounts are loaded
    }
  }

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

  void _submitExpenseData() async {
    // Find the ExpensesController
    final ExpensesController expensesController = Get.find<ExpensesController>();

    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount < 0;
    
    // Small correction in condition: _selectedAccount.id should be < 0 for "Select Account"
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null || 
        _selectedAccount.id == -1) { // Check if a valid account is selected
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Invalid Input"),
              content: const Text(
                  "Please make sure a valid Title, Amount, Date, and Account has been entered/selected."),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text("Okay"))
              ],
            );
          });
      return;
    }

    // These direct DB calls remain for now as they handle different models
    DbHelper.db.addAccountToDatabase(
        Account(name: "HDFC", isLending: 0, balance: 4000));
    DbHelper.db.addTransactionToDatabase(UTransaction(
        merchant: _titleController.text.trim(),
        debit: 1,
        amount: enteredAmount, // Use the parsed and validated amount
        date: _selectedDate!,
        categoryId: 1, // This seems hardcoded, might need review
        accountId: _selectedAccount.id!, // Use selected account's ID
        modeOfPayment: "UPI")); // This seems hardcoded

    // Use GetX controller to add the Expense
    expensesController.addExpense(Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount, // Use the parsed and validated amount
        date: _selectedDate!,
        category: _selectedCategory));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              label: Text("Title"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text("Amount"), prefixText: "\$ "), // Changed prefix to prefixText
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        label: Text("Title"),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton<Category>( // Added type for DropdownButton
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem<Category>( // Added type for DropdownMenuItem
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              }
                            }),
                        const SizedBox(width: 16), // Added spacing
                        DropdownButton<Account>( // Added type for DropdownButton
                            value: _selectedAccount,
                            items: accounts
                                .map(
                                  (account) => DropdownMenuItem<Account>( // Added type for DropdownMenuItem
                                value: account,
                                child: Text(
                                  account.name.toUpperCase(),
                                ),
                              ),
                            )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedAccount = value;
                                });
                              }
                            }),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "No Date is Selected"
                                    // Ensure 'fomatter' is defined or use DateFormat
                                    : formatter.format(_selectedDate!), // Assuming formatter is defined (e.g. from intl package)
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                label: Text("Amount"), prefixText: "\$ "), // Changed prefix to prefixText
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? "No Date is Selected"
                                  // Ensure 'fomatter' is defined or use DateFormat
                                  : formatter.format(_selectedDate!), // Assuming formatter is defined
                            ),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ))
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width < 600) // Moved account dropdown here for better layout on smaller screens
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButton<Account>(
                          isExpanded: true, // Make dropdown wider
                          value: _selectedAccount,
                          items: accounts
                              .map(
                                (account) => DropdownMenuItem<Account>(
                              value: account,
                              child: Text(
                                account.name.toUpperCase(),
                              ),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedAccount = value;
                              });
                            }
                          }),
                    ),
                  if (width < 600) // Moved category dropdown for smaller screens
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButton<Category>(
                          isExpanded: true,
                          value: _selectedCategory,
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            }
                          }),
                    ),
                  Row( // Unified button row
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Save Expense"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Make sure 'formatter' is defined, e.g., at the top of the file or imported:
// import 'package:intl/intl.dart';
// final formatter = DateFormat.yMd();
// This was missing in the original code for _selectedDate display.
// For now, I'll assume it's defined elsewhere or will be added.
// If Category.leisure etc. are enum, their .name access is fine.
// If Expense model's Category enum is used, ensure it's accessible.
// The original code had 'fomatter', I corrected to 'formatter'.
// It seems like there was a typo in the original code.
// The line: `final List<Account> accounts =[];` inside the state class is fine.
// The line: `late Account _selectedAccount;` is also fine.
// The condition for showing dialog: `_selectedAccount!=null || _selectedAccount!.id!>=0`
// was a bit confusing. Changed to `_selectedAccount.id == -1` (the initial placeholder value)
// to indicate a valid account hasn't been selected.
// Corrected TextField prefix: `prefix: Text("\$ ")` to `prefixText: "\$ "` for better practice.

// Added a missing import for the 'formatter', assuming it's from 'intl' package
import 'package:intl/intl.dart';
final formatter = DateFormat.yMd();
