import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Logger from '../utils/Logger';

export default class EntryAbility extends UIAbility {
  private tag: string = 'EntryAbility';

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(this.tag, 'EntryAbility onCreate, want: %{public}s', JSON.stringify(want));
  }

  onDestroy(): void {
    Logger.info(this.tag, 'EntryAbility onDestroy');
  }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    Logger.info(this.tag, 'EntryAbility onWindowStageCreate');

    try {
      // 获取主窗口
      const mainWindow = await windowStage.getMainWindow();
      
      // 设置窗口属性 - 适配鸿蒙6.0.2 API
      await mainWindow.setWindowLayoutFullScreen(true);
      await mainWindow.setFullScreen(false);
      
      // 设置系统栏 - 使用最新的API
      await mainWindow.setWindowSystemBarEnable(['status', 'navigation']);
      await mainWindow.setWindowSystemBarProperties({
        statusBarColor: '#FFFFFFFF',
        statusBarContentColor: '#FF000000',
        navigationBarColor: '#FFFFFFFF',
        navigationBarContentColor: '#FF000000'
      });
      
      Logger.info(this.tag, 'Main window properties set successfully');
    } catch (err) {
      Logger.error(this.tag, 'Failed to set window properties: %{public}s', err.message);
    }

    // 加载主页面
    windowStage.loadContent('pages/Index', (err) => {
      if (err) {
        Logger.error(this.tag, 'Failed to load content: %{public}s', err.message);
        return;
      }
      Logger.info(this.tag, 'Content loaded successfully');
    });
  }

  onWindowStageDestroy(): void {
    Logger.info(this.tag, 'EntryAbility onWindowStageDestroy');
  }

  onForeground(): void {
    Logger.info(this.tag, 'EntryAbility onForeground');
  }

  onBackground(): void {
    Logger.info(this.tag, 'EntryAbility onBackground');
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    Logger.info(this.tag, 'EntryAbility onNewWant, want: %{public}s', JSON.stringify(want));
  }
}