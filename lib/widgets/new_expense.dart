import 'package:expense_tracker/database/db_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/provider/expenses_provider.dart'; // Will be GetX controller
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Added GetX import
import 'package:intl/intl.dart'; // Moved import to the top

// Moved formatter declaration to the top-level
final formatter = DateFormat.yMd();

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

  @override
  void initState() {
    super.initState();
    _selectedAccount = Account( id: -1, name: "Select Account", isLending: 0, balance: 0);
    accounts.add(_selectedAccount);
    populateAccountsDropDownMenu();
  }

  void populateAccountsDropDownMenu() async{
    accounts.addAll(await DbHelper.db.getAllAccounts());
    if (mounted) {
      setState(() {});
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
    final ExpensesController expensesController = Get.find<ExpensesController>();
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount < 0;
    
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null || 
        _selectedAccount.id == -1) {
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

    DbHelper.db.addAccountToDatabase(
        Account(name: "HDFC", isLending: 0, balance: 4000));
    DbHelper.db.addTransactionToDatabase(UTransaction(
        merchant: _titleController.text.trim(),
        debit: 1,
        amount: enteredAmount,
        date: _selectedDate!,
        categoryId: 1, 
        accountId: _selectedAccount.id!,
        modeOfPayment: "UPI"));

    expensesController.addExpense(Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
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
                                label: Text("Amount"), prefixText: "\$ "),
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
                        DropdownButton<Category>(
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
                        const SizedBox(width: 16), 
                        DropdownButton<Account>(
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
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "No Date is Selected"
                                    : formatter.format(_selectedDate!),
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
                                label: Text("Amount"), prefixText: "\$ "),
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
                                  : formatter.format(_selectedDate!),
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
                  if (width < 600)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButton<Account>(
                          isExpanded: true,
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
                  if (width < 600)
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
                  Row(
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
