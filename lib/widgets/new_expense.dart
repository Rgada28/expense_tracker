import 'package:expense_tracker/database/db_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/user_transaction.dart';
import 'package:expense_tracker/provider/expenses_provider.dart';
import 'package:expense_tracker/widgets/accounts_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewExpense extends ConsumerStatefulWidget {
  const NewExpense({super.key});

  @override
  ConsumerState<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends ConsumerState<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  final List<Account> accounts = [];
  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();
    populateAccountsDropDownMenu();
  }

  void populateAccountsDropDownMenu() async {
    accounts.addAll(await DbHelper.db.getAllAccounts());
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() => _selectedDate = pickedDate);
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount < 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null ||
        _selectedAccount != null) {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Invalid Input"),
              content: const Text(
                  "Please make sure a valid Title, Amount or Date has been entered or an Account has been selected"),
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
    DbHelper.db.addTransactionToDatabase(UserTransaction(
        merchant: _titleController.text.trim(),
        debit: 1,
        amount: enteredAmount,
        date: _selectedDate!,
        categoryId: 1,
        accountId: 1,
        modeOfPayment: "UPI"));
    ref.watch(expensesProvider.notifier).addExpense(Expense(
        title: _titleController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));

    Navigator.pop(context);
  }

  void _selectAccountsDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return AccountsDialog(
            accounts: accounts,
            onSelectAccount: selectedAccount,
          );
        });
    return;
  }

  void selectedAccount(Account account) {
    setState(() {
      _selectedAccount = account;
    });
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
                                label: Text("Amount"), prefix: Text("\$ ")),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
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
                        const SizedBox(
                          width: 100,
                        ),
                        TextButton(
                            onPressed: _selectAccountsDialogue,
                            child: Text(_selectedAccount == null
                                ? "Select Account"
                                : "Selected Account")),
                        Text(_selectedAccount == null
                            ? "Please select an account"
                            : _selectedAccount!.name),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "No Date is Selected"
                                    : fomatter.format(_selectedDate!),
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
                                label: Text("Amount"), prefix: Text("\$ ")),
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
                                  : fomatter.format(_selectedDate!),
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
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
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
                  else
                    Column(
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: _selectAccountsDialogue,
                                child: Text(_selectedAccount == null
                                    ? "Select Account"
                                    : "Selected Account")),
                            Text(_selectedAccount == null
                                ? "Please select an account"
                                : _selectedAccount!.name),
                          ],
                        ),
                        Row(
                          children: [
                            DropdownButton(
                                value: _selectedCategory,
                                items: Category.values
                                    .map(
                                      (category) => DropdownMenuItem(
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
                            const Spacer(),
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
