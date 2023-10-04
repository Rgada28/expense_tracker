import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountsDialog extends StatefulWidget {
  const AccountsDialog(
      {super.key, required this.accounts, required this.onSelectAccount});

  final List<Account> accounts;
  final Function(Account selectedAccount) onSelectAccount;
  @override
  State<AccountsDialog> createState() => _AccountsDialogState();
}

class _AccountsDialogState extends State<AccountsDialog> {
  final List<Account> accounts = [];
  Account? _selected;
  @override
  void initState() {
    accounts.addAll(widget.accounts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Account"),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      actions: <Widget>[
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Add New'),
          onPressed: () {},
        ),
      ],
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: accounts.length,
                    itemBuilder: (BuildContext context, int index) {
                      Account currentElement = accounts[index];
                      return ListTile(
                        title: Text(currentElement.name),
                        trailing: _selected == currentElement
                            ? const Icon(Icons.done)
                            : null,
                        onTap: () {
                          setState(() {
                            _selected = currentElement;
                            widget.onSelectAccount(currentElement);
                            Navigator.pop(context);
                          });
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
