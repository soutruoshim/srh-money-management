mixin Subscription {
  static String listenTransactions = '''
    subscription listenTransactions(\$wallet_id: Int = 10) {
      Transaction(where: {wallet_id: {_eq: \$wallet_id}}) {
        id
        balance
        category_id
        date
        note
        type
        wallet_id
        Category {
          id
          icon
          name
          parrent_id
          type
        }
      }
    }
  ''';
  static String listenWallets = '''
    subscription listenWallets(\$user_uuid: String = "") {
      Wallet(where: {user_uuid: {_eq: \$user_uuid}}) {
        id
        expense_balance
        income_balance
        name
        type_wallet_id
        user_uuid
        TypeWallet {
          id
          icon
          name
        }
      }
    }
''';
}
