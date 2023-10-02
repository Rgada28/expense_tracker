import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction_demo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../provider/transactions_provider.dart';

class AddNewTransactionScreen extends ConsumerStatefulWidget {
  const AddNewTransactionScreen({super.key});

  @override
  ConsumerState<AddNewTransactionScreen> createState() =>
      _AddNewTransactionScreenState();
}

class _AddNewTransactionScreenState
    extends ConsumerState<AddNewTransactionScreen> {
  DateFormat fomatter = DateFormat.yMd();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _amountTextEditingController = TextEditingController();
  DateTime? _selectedDate;
  bool isCashback = false;
  late String _selectedAccount;
  late String _selectedCategory;
  late String _selectedModeOfPayment;
  List<DropdownMenuEntry<String>> categories = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Category"),
    for (int i = 1; i < 6; i++)
      DropdownMenuEntry<String>(value: "$i", label: "Category $i")
  ];

  List<DropdownMenuEntry<String>> accounts = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Account"),
    for (int i = 1; i < 6; i++)
      DropdownMenuEntry<String>(value: "$i", label: "Account $i")
  ];

  List<DropdownMenuEntry<String>> merchants = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Merchant"),
    for (int i = 1; i < 6; i++)
      DropdownMenuEntry<String>(value: "Merchant $i", label: "Merchant $i")
  ];

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

  List<DropdownMenuEntry<String>> subMerchants = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Sub-Merchant"),
    for (int i = 1; i < 6; i++)
      DropdownMenuEntry<String>(
          value: "SubMerchant $i", label: "SubMerchant $i")
  ];

  List<DropdownMenuEntry<String>> paymentModes = [
    const DropdownMenuEntry<String>(
        value: "Not Selected", label: "Select Payment Mode"),
    for (int i = 1; i < 6; i++)
      DropdownMenuEntry<String>(value: "$i", label: "Payment Mode $i")
  ];

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //            int transactionId;
              // String merchant;
              // String? subMerchant;
              // int debit;
              // double amount;
              // double? cashback;
              // DateTime date;
              // double? ownShare;
              // String? description;
              // int categoryId;
              // int accountId;
              // String modeOfPayment;
              children: [
                TextFormField(
                    controller: _descriptionTextEditingController,
                    decoration:
                        const InputDecoration(label: Text("Description"))),
                DropdownMenu<String>(
                  dropdownMenuEntries: categories,
                  enableSearch: true,
                  label: const Text("Category"),
                  onSelected: (value) => _selectedCategory = value!,
                ),
                // DropdownMenu<String>(
                //   dropdownMenuEntries: merchants,
                //   enableSearch: true,
                //   label: const Text("Merchant"),
                // ),
                // DropdownMenu<String>(
                //   dropdownMenuEntries: subMerchants,
                //   enableSearch: true,
                //   label: const Text("Sub-Merchant"),
                // ),
                TextFormField(
                  controller: _amountTextEditingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(label: Text("Amount")),
                ),
                // Switch.adaptive(
                //     value: isCashback,
                //     onChanged: (value) {
                //       setState(() {
                //         isCashback = !isCashback;
                //       });
                //     }),
                // Visibility(
                //   visible: isCashback,
                //   child: Column(
                //     children: [
                //       TextFormField(
                //         keyboardType: TextInputType.number,
                //         decoration: const InputDecoration(
                //             label: Text("CashBack Amount")),
                //       ),
                //     ],
                //   ),
                // ),
                Text(
                  _selectedDate == null
                      ? "No Date is Selected"
                      : fomatter.format(_selectedDate!),
                ),
                IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.date_range),
                ),
                DropdownMenu<String>(
                  dropdownMenuEntries: accounts,
                  enableSearch: true,
                  label: const Text("Account"),
                  onSelected: (value) => _selectedAccount = value!,
                ),

                DropdownMenu<String>(
                  dropdownMenuEntries: paymentModes,
                  enableSearch: true,
                  label: const Text("Payment Modes"),
                  onSelected: (value) => _selectedModeOfPayment = value!,
                ),
                ElevatedButton(
                    onPressed: () {
                      saveTransaction();
                    },
                    child: const Text("Save"))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveTransaction() async {
    TransactionDemoProvider transactionDemoProvider = TransactionDemoProvider();
    AccountProvider accountProvider = AccountProvider();
    TransactionDemo transactionDemo = TransactionDemo(
        1,
        double.parse(_amountTextEditingController.value.text),
        _selectedDate!,
        _descriptionTextEditingController.value.text,
        int.parse(_selectedCategory),
        int.parse(_selectedAccount),
        int.parse(_selectedModeOfPayment));
    ref.watch(transactionsProvider).add(transactionDemo);
    String dbPath = await sql.getDatabasesPath();
    await accountProvider.open(path.join(dbPath, 'expense_tracker.db'));
    accountProvider.insert(Account(
        id: 1,
        name: "HDFC BANK",
        isLending: 0,
        balance: 21280,
        ));
    await transactionDemoProvider.open(path.join(dbPath, 'expense_tracker.db'));
    await transactionDemoProvider.insert(transactionDemo);
  }
}
