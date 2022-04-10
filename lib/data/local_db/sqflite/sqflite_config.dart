class SqfliteDbConfig {
  static const String transactionsTableName = 'transactions';
  static const String categoriesTableName = 'categories';
}

enum SqfliteTransactionsTableColumns {
  uuid,
  title,
  amount,
  date,
  categoryUuid,
  type
}
enum SqfliteTransactionType { expense, income }
enum SqfliteCategoriesTableColumns { uuid, name, color }

extension TransactionCategoriesTableColumnsCodes
    on SqfliteCategoriesTableColumns {
  String get code {
    switch (this) {
      case SqfliteCategoriesTableColumns.uuid:
        return 'uuid';
      case SqfliteCategoriesTableColumns.name:
        return 'name';
      case SqfliteCategoriesTableColumns.color:
        return 'color';
    }
  }
}

extension TransactionsTableColumnsCodes on SqfliteTransactionsTableColumns {
  String get code {
    switch (this) {
      case SqfliteTransactionsTableColumns.uuid:
        return 'uuid';
      case SqfliteTransactionsTableColumns.title:
        return 'title';
      case SqfliteTransactionsTableColumns.amount:
        return 'amount';
      case SqfliteTransactionsTableColumns.date:
        return 'date';
      case SqfliteTransactionsTableColumns.categoryUuid:
        return 'category_uuid';
      case SqfliteTransactionsTableColumns.type:
        return 'type';
    }
  }
}

extension SqfliteTransactionTypeFactory on SqfliteTransactionType {
  static SqfliteTransactionType fromCode(String? code) {
    if (code == SqfliteTransactionType.income.name) {
      return SqfliteTransactionType.income;
    } else {
      return SqfliteTransactionType.expense;
    }
  }
}
