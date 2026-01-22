import { BusinessError } from '@ohos.base';
import Logger from '../utils/Logger';

// 账户记录类型
enum RecordType {
  INCOME = 'income',
  EXPENSE = 'expense'
}

// 账户记录接口
interface AccountRecord {
  id: string;
  type: RecordType;
  amount: number;
  category: string;
  description: string;
  date: string;
  timestamp: number;
  currency: string;
}

// 统计信息接口
interface StatisticsInfo {
  totalIncome: number;
  totalExpenses: number;
  balance: number;
  monthlyData: Map<string, { income: number, expenses: number }>;
  categoryData: Map<string, number>;
}

// 账户管理类
class AccountManager {
  private records: AccountRecord[] = [];
  private tag: string = 'AccountManager';

  // 添加记录
  addRecord(record: AccountRecord): void {
    try {
      this.records.push(record);
      Logger.info(this.tag, 'Record added: %{public}s', JSON.stringify(record));
    } catch (error) {
      Logger.error(this.tag, 'Failed to add record: %{public}s', (error as BusinessError).message);
    }
  }

  // 删除记录
  deleteRecord(id: string): boolean {
    try {
      const initialLength = this.records.length;
      this.records = this.records.filter(record => record.id !== id);
      const deleted = initialLength !== this.records.length;
      if (deleted) {
        Logger.info(this.tag, 'Record deleted: %{public}s', id);
      }
      return deleted;
    } catch (error) {
      Logger.error(this.tag, 'Failed to delete record: %{public}s', (error as BusinessError).message);
      return false;
    }
  }

  // 更新记录
  updateRecord(id: string, updatedRecord: Partial<AccountRecord>): boolean {
    try {
      const index = this.records.findIndex(record => record.id === id);
      if (index !== -1) {
        this.records[index] = { ...this.records[index], ...updatedRecord };
        Logger.info(this.tag, 'Record updated: %{public}s', id);
        return true;
      }
      return false;
    } catch (error) {
      Logger.error(this.tag, 'Failed to update record: %{public}s', (error as BusinessError).message);
      return false;
    }
  }

  // 获取所有记录
  getAllRecords(): AccountRecord[] {
    return [...this.records].sort((a, b) => b.timestamp - a.timestamp);
  }

  // 获取收入记录
  getIncomeRecords(): AccountRecord[] {
    return this.records.filter(record => record.type === RecordType.INCOME)
      .sort((a, b) => b.timestamp - a.timestamp);
  }

  // 获取支出记录
  getExpenseRecords(): AccountRecord[] {
    return this.records.filter(record => record.type === RecordType.EXPENSE)
      .sort((a, b) => b.timestamp - a.timestamp);
  }

  // 获取月统计
  getMonthlyStatistics(month: string): { income: number, expenses: number } {
    const monthRecords = this.records.filter(record => 
      record.date.startsWith(month)
    );
    
    const income = monthRecords
      .filter(record => record.type === RecordType.INCOME)
      .reduce((sum, record) => sum + record.amount, 0);
    
    const expenses = monthRecords
      .filter(record => record.type === RecordType.EXPENSE)
      .reduce((sum, record) => sum + record.amount, 0);
    
    return { income, expenses };
  }

  // 获取分类统计
  getCategoryStatistics(type: RecordType): Map<string, number> {
    const categoryMap = new Map<string, number>();
    
    this.records
      .filter(record => record.type === type)
      .forEach(record => {
        const current = categoryMap.get(record.category) || 0;
        categoryMap.set(record.category, current + record.amount);
      });
    
    return categoryMap;
  }

  // 获取总统计信息
  getStatistics(): StatisticsInfo {
    const totalIncome = this.getIncomeRecords()
      .reduce((sum, record) => sum + record.amount, 0);
    
    const totalExpenses = this.getExpenseRecords()
      .reduce((sum, record) => sum + record.amount, 0);
    
    const balance = totalIncome - totalExpenses;
    
    // 月度数据
    const monthlyData = new Map<string, { income: number, expenses: number }>();
    const months = new Set(this.records.map(record => record.date.substring(0, 7)));
    months.forEach(month => {
      monthlyData.set(month, this.getMonthlyStatistics(month));
    });
    
    // 分类数据
    const categoryData = new Map<string, number>();
    const allCategories = new Set(this.records.map(record => record.category));
    allCategories.forEach(category => {
      const amount = this.records
        .filter(record => record.category === category)
        .reduce((sum, record) => sum + record.amount, 0);
      categoryData.set(category, amount);
    });
    
    return {
      totalIncome,
      totalExpenses,
      balance,
      monthlyData,
      categoryData
    };
  }

  // 清空所有记录
  clearAllRecords(): void {
    this.records = [];
    Logger.info(this.tag, 'All records cleared');
  }

  // 获取记录数量
  getRecordCount(): number {
    return this.records.length;
  }

  // 根据ID查找记录
  findRecordById(id: string): AccountRecord | undefined {
    return this.records.find(record => record.id === id);
  }
}

export { AccountManager, AccountRecord, RecordType, StatisticsInfo };