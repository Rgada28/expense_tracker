import 'package:expense_tracker/database/db_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AddNewAccountScreen extends StatefulWidget {
  const AddNewAccountScreen({super.key});

  @override
  State<AddNewAccountScreen> createState() => _AddNewAccountScreenState();
}

class _AddNewAccountScreenState extends State<AddNewAccountScreen> {
  GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  bool isLendingAccount = false;
  String? name;
  double? balance;
  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  bool saveAccount() {
    if (formKey.currentState!.validate()) {
      //TODO add the account to accounts list using state Management
      formKey.currentState!.save();
      DbHelper.db.addAccountToDatabase(Account(
          name: nameController.text.trim(),
          isLending: isLendingAccount ? 1 : 0,
          balance: double.parse(balanceController.text.trim())));
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add new Account"),
          actions: [
            IconButton(
                onPressed: () {
                  saveAccount() ? Navigator.pop(context) : null;
                },
                icon: const Icon(Icons.done))
          ],
        ),
        body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    maxLength: 50,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        label: const Text("Account Name"),
                        hintText: "HDFC Bank Savings Account"),
                    validator: ((value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length < 3) {
                        return "Account Name cannot be less then 3 characters";
                      }
                      return null;
                    }),
                    onSaved: (newValue) {
                      name = newValue!.trim();
                    },
                  ),
                  TextFormField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15)),
                        label: const Text("Balance"),
                        hintText: "4000.0"),
                    validator: ((value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          double.parse(value.trim()) < 0) {
                        return "Balance cannot be empty or negative";
                      }
                      return null;
                    }),
                    onSaved: (newValue) {
                      balance = double.parse(newValue!.trim());
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text("is Lending Account"),
                      const SizedBox(
                        width: 5,
                      ),
                      //TODO Add an info button to explain what is a Lending account
                      Switch.adaptive(
                          value: isLendingAccount,
                          onChanged: (value) {
                            setState(() {
                              isLendingAccount = value;
                            });
                          }),
                    ],
                  )
                ],
              ),
            )));
  }
}
