class Bank {
  String? bankNameFull;
  String? bankName;
  int? bankCode;
  String? accNum;
  Bank({this.bankNameFull, this.bankName, this.bankCode, this.accNum});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        bankNameFull: json['bankNameFull'] ?? '',
        bankName: json['bankName'] ?? '',
        bankCode: json['bankCode'] ?? 0,
        accNum: json['accNum'] ?? '',
      );
}
