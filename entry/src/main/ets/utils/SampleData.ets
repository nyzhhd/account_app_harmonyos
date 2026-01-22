import { AccountManager, AccountRecord, RecordType } from '../model/AccountModel';
import Logger from './Logger';

class SampleData {
  private static readonly tag: string = 'SampleData';

  static initializeSampleData(accountManager: AccountManager): void {
    try {
      // 清空现有数据
      accountManager.clearAllRecords();

      // 添加示例收入记录
      const incomeRecords: AccountRecord[] = [
        {
          id: 'income_1',
          type: RecordType.INCOME,
          amount: 15000,
          category: 'Salary',
          description: 'Monthly salary',
          date: '2024-01-15',
          timestamp: Date.now() - 30 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        },
        {
          id: 'income_2',
          type: RecordType.INCOME,
          amount: 5000,
          category: 'Bonus',
          description: 'Year-end bonus',
          date: '2024-01-20',
          timestamp: Date.now() - 25 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        },
        {
          id: 'income_3',
          type: RecordType.INCOME,
          amount: 2000,
          category: 'Part-time',
          description: 'Freelance work',
          date: '2024-01-25',
          timestamp: Date.now() - 20 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        }
      ];

      // 添加示例支出记录
      const expenseRecords: AccountRecord[] = [
        {
          id: 'expense_1',
          type: RecordType.EXPENSE,
          amount: 3000,
          category: 'Housing',
          description: 'Monthly rent',
          date: '2024-01-01',
          timestamp: Date.now() - 45 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        },
        {
          id: 'expense_2',
          type: RecordType.EXPENSE,
          amount: 1500,
          category: 'Transportation',
          description: 'Gas and public transport',
          date: '2024-01-05',
          timestamp: Date.now() - 40 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        },
        {
          id: 'expense_3',
          type: RecordType.EXPENSE,
          amount: 2000,
          category: 'Diet',
          description: 'Groceries and dining',
          date: '2024-01-10',
          timestamp: Date.now() - 35 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        },
        {
          id: 'expense_4',
          type: RecordType.EXPENSE,
          amount: 800,
          category: 'Entertainment',
          description: 'Movie and activities',
          date: '2024-01-15',
          timestamp: Date.now() - 30 * 24 * 60 * 60 * 1000,
          currency: 'CNY'
        }
      ];

      // 添加所有记录
      incomeRecords.forEach(record => accountManager.addRecord(record));
      expenseRecords.forEach(record => accountManager.addRecord(record));

      Logger.info(this.tag, 'Sample data initialized successfully');
    } catch (error) {
      Logger.error(this.tag, 'Failed to initialize sample data: %{public}s', error.message);
    }
  }
}

export default SampleData;