class Account {
  int? id;
  String name;
  int isLending;
  double balance;
  Account({
    this.id,
    required this.name,
    required this.isLending,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isLending': isLending,
      'balance': balance,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      isLending: map['isLending'],
      balance: map['balance'],
    );
  }
}

