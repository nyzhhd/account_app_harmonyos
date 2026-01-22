import { AccountManager, AccountRecord, RecordType, StatisticsInfo } from '../model/AccountModel';
import Logger from '../utils/Logger';
import SampleData from '../utils/SampleData';

@Component
export struct Index {
  @State accountManager: AccountManager = new AccountManager();
  @State currentTab: number = 0;
  @State showAddDialog: boolean = false;
  @State statistics: StatisticsInfo = {
    totalIncome: 0,
    totalExpenses: 0,
    balance: 0,
    monthlyData: new Map(),
    categoryData: new Map()
  };
  @State isInitialized: boolean = false;

  private tag: string = 'Index';

  aboutToAppear(): void {
    if (!this.isInitialized) {
      this.initializeData();
    }
    this.updateStatistics();
    Logger.info(this.tag, 'Index page appeared');
  }

  initializeData(): void {
    SampleData.initializeSampleData(this.accountManager);
    this.isInitialized = true;
  }

  updateStatistics(): void {
    this.statistics = this.accountManager.getStatistics();
  }

  @Builder
  buildHeader() {
    Column() {
      Text('Account Manager')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1A1A1A')

      Row() {
        Column() {
          Text('Balance')
            .fontSize(14)
            .fontColor('#666666')
          Text(`¥${this.statistics.balance.toFixed(2)}`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.statistics.balance >= 0 ? '#52C41A' : '#FF4D4F')
        }
        .layoutWeight(1)

        Column() {
          Text('Income')
            .fontSize(14)
            .fontColor('#666666')
          Text(`¥${this.statistics.totalIncome.toFixed(2)}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#52C41A')
        }
        .layoutWeight(1)

        Column() {
          Text('Expenses')
            .fontSize(14)
            .fontColor('#666666')
          Text(`¥${this.statistics.totalExpenses.toFixed(2)}`)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FF4D4F')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
    }
    .width('100%')
    .padding({ left: 24, right: 24, top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  buildTabBar() {
    Row() {
      Button('Overview')
        .layoutWeight(1)
        .backgroundColor(this.currentTab === 0 ? '#1890FF' : '#F5F5F5')
        .fontColor(this.currentTab === 0 ? '#FFFFFF' : '#666666')
        .borderRadius(8)
        .onClick(() => {
          this.currentTab = 0;
        })

      Button('Income')
        .layoutWeight(1)
        .backgroundColor(this.currentTab === 1 ? '#52C41A' : '#F5F5F5')
        .fontColor(this.currentTab === 1 ? '#FFFFFF' : '#666666')
        .borderRadius(8)
        .onClick(() => {
          this.currentTab = 1;
        })

      Button('Expenses')
        .layoutWeight(1)
        .backgroundColor(this.currentTab === 2 ? '#FF4D4F' : '#F5F5F5')
        .fontColor(this.currentTab === 2 ? '#FFFFFF' : '#666666')
        .borderRadius(8)
        .onClick(() => {
          this.currentTab = 2;
        })
    }
    .width('100%')
    .padding({ left: 24, right: 24, top: 8, bottom: 8 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  buildContent() {
    Column() {
      if (this.currentTab === 0) {
        this.buildOverview()
      } else if (this.currentTab === 1) {
        this.buildIncomeList()
      } else {
        this.buildExpenseList()
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  buildOverview() {
    Column() {
      if (this.accountManager.getAllRecords().length === 0) {
        this.buildEmptyState()
      } else {
        List({ space: 12 }) {
          ForEach(Array.from(this.statistics.monthlyData.entries()), (item: [string, any]) => {
            ListItem() {
              Row() {
                Column() {
                  Text(item[0])
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1A1A1A')
                  Text(`Income: ¥${item[1].income.toFixed(2)} | Expenses: ¥${item[1].expenses.toFixed(2)}`)
                    .fontSize(12)
                    .fontColor('#666666')
                }
                .layoutWeight(1)

                Text(`¥${(item[1].income - item[1].expenses).toFixed(2)}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor((item[1].income - item[1].expenses) >= 0 ? '#52C41A' : '#FF4D4F')
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 24, right: 24 })
      }
    }
  }

  @Builder
  buildIncomeList() {
    Column() {
      if (this.accountManager.getIncomeRecords().length === 0) {
        this.buildEmptyState('No income records')
      } else {
        List({ space: 8 }) {
          ForEach(this.accountManager.getIncomeRecords(), (record: AccountRecord) => {
            ListItem() {
              Row() {
                Column() {
                  Text(record.category)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1A1A1A')
                  Text(record.description)
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(record.date)
                    .fontSize(10)
                    .fontColor('#999999')
                }
                .layoutWeight(1)

                Text(`+¥${record.amount.toFixed(2)}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#52C41A')
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 24, right: 24 })
      }
    }
  }

  @Builder
  buildExpenseList() {
    Column() {
      if (this.accountManager.getExpenseRecords().length === 0) {
        this.buildEmptyState('No expense records')
      } else {
        List({ space: 8 }) {
          ForEach(this.accountManager.getExpenseRecords(), (record: AccountRecord) => {
            ListItem() {
              Row() {
                Column() {
                  Text(record.category)
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1A1A1A')
                  Text(record.description)
                    .fontSize(12)
                    .fontColor('#666666')
                  Text(record.date)
                    .fontSize(10)
                    .fontColor('#999999')
                }
                .layoutWeight(1)

                Text(`-¥${record.amount.toFixed(2)}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FF4D4F')
              }
              .width('100%')
              .padding(16)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 24, right: 24 })
      }
    }
  }

  @Builder
  buildEmptyState(message: string = 'No records yet') {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(120)
        .height(120)
      Text(message)
        .fontSize(16)
        .fontColor('#999999')
        .margin({ top: 16 })
    }
    .width('100%')
    .height(300)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildFloatingActionButton() {
    Button('+')
      .width(56)
      .height(56)
      .backgroundColor('#1890FF')
      .fontSize(24)
      .fontColor('#FFFFFF')
      .borderRadius(28)
      .shadow({ radius: 8, color: '#000000', offsetX: 0, offsetY: 2 })
      .onClick(() => {
        this.showAddDialog = true;
      })
      .position({ x: '85%', y: '85%' })
  }

  build() {
    Column() {
      // Header
      this.buildHeader()

      // Tab Bar
      this.buildTabBar()

      // Content
      this.buildContent()

      // Floating Action Button
      this.buildFloatingActionButton()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}