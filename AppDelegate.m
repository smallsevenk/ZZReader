//
//  AppDelegate.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindowCtr.h"
#import "StatusButton.h"
#import <AppKit/NSOpenPanel.h>//文件管理
#import <Carbon/Carbon.h>//快捷键
#import "HFPopoverController.h"
#import "SettingModel.h"

@interface AppDelegate ()

@property (strong)  MainWindowCtr *mainWindow;
@property (nonatomic, strong)  HFPopoverController *hfPopVc;
@property (nonatomic, strong)  NSPopover *popover;

@property (nonatomic ,strong)   NSStatusItem *myItem;
@property (nonatomic, strong)   NSTextField *showView;

@property (nonatomic, strong)   SettingModel *setting;

#define NOTI_HOTKEY @"NOTI_HOTKEY"

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    _mainWindow = [[MainWindowCtr alloc] initWithWindowNibName:@"MainWindowCtr"];
//    //显示在屏幕中心
//    [[_mainWindow window] center];
//    //当前窗口显示
//    [_mainWindow.window orderFront:nil];
    
    
    [self initializeApp];
}


- (void)initializeApp
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotKeyNoti:) name:NOTI_HOTKEY object:nil];
    [self setHotKey];
    [self setStatus];
}


#pragma mark —— 快捷键

- (void)hotKeyNoti:(NSNotification *)noti
{
    NSInteger hotKeyID = [[noti.userInfo objectForKey:@"hotKeyID"] intValue];
    
    switch (hotKeyID)
    {
        case kVK_LeftArrow://上一行
        {
            [self lastLine];
        }
            break;
        case kVK_RightArrow://下一行
        {
            [self nextLine];
        }
            break;
        case kVK_Delete://注销快捷键
        {
            [self exit];
//            [self unRegistHotKey];
        }
            break;
        case kVK_Space://注册快捷键
        {
            [self registHotKey];
        }
            break;
        case kVK_Return://导入书籍
        {
            [self openPanel];
        }
            break;
        default:
            break;
    }
}
    

OSStatus GlobalHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,
                             void *userData)
{
    EventHotKeyID hkCom;
    GetEventParameter(theEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,
                      sizeof(hkCom),NULL,&hkCom);
    unsigned int hotKeyId = hkCom.id;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HOTKEY object:nil userInfo:@{@"hotKeyID": @(hotKeyId)}];

    return noErr;
}

- (void)setHotKey
{
    [self registHotKey];
    [self addMonitorForEvent];
}



/**
 * 添加全局的快捷键
 **/
-(void)registHotKey
{
    [self hotKeyUpdate:kVK_LeftArrow isRegist:YES];
    [self hotKeyUpdate:kVK_RightArrow isRegist:YES];
    [self hotKeyUpdate:kVK_Delete isRegist:YES];
//    [self hotKeyUpdate:kVK_Space isRegist:YES];
    [self hotKeyUpdate:kVK_Return isRegist:YES];
}

-(void)unRegistHotKey
{
    [self hotKeyUpdate:kVK_LeftArrow isRegist:NO];
    [self hotKeyUpdate:kVK_RightArrow isRegist:NO];
    [self hotKeyUpdate:kVK_Delete isRegist:NO];
    [self hotKeyUpdate:kVK_Return isRegist:NO];
}

-(void)hotKeyUpdate:(NSInteger)keyCode isRegist:(BOOL)isRegist
{
    EventHotKeyRef       gMyHotKeyRef;
    EventHotKeyID        gMyHotKeyID;
    EventTypeSpec        eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    InstallApplicationEventHandler(&GlobalHotKeyHandler,1,&eventType,NULL,NULL);
    gMyHotKeyID.signature = 'zick';
    gMyHotKeyID.id = keyCode;
    if (isRegist)
    {
        RegisterEventHotKey(keyCode, 0, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    }
    else
    {
        UnregisterEventHotKey(gMyHotKeyRef);
    }
    
    // RegisterEventHotKey(keyCode, cmdKey+optionKey, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}


#pragma mark —— 基于NSResponder的回调

//需要捕获command + 1234567890事件
- (void)keyDown:(NSEvent *)theEvent{
//    NSString *key = [theEvent charactersIgnoringModifiers];
//    if([self.numKeyStrArray containsObject:key]){
//        if([theEvent modifierFlags] & NSEventModifierFlagCommand){//command+num
//            [self pressNum:key];
//        }
//    }
//    [super keyDown:theEvent];
}

-(void)keyUp:(NSEvent *)theEvent {
    
}

-(void)pressNum:(NSString *)numStr{
    NSLog(@" 按下 commnd + %@",numStr);
}

- (BOOL)acceptsFirstResponder{
    return YES;
}

//--------------------------------------------


- (void)setStatus
{
    if ([SettingModel haveNovel])
    {
        self.setting = [SettingModel settingInfo];
    }
    else
    {
        self.setting = [[SettingModel alloc] init];
    }
    
    self.myItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    
    self.showView = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 0, 20)];
    self.showView.editable = NO;
    self.showView.bordered = NO;
    self.showView.alignment = NSTextAlignmentCenter;
    self.showView.backgroundColor = self.setting.bgColor;
    self.showView.font = [NSFont systemFontOfSize:self.setting.fontSize];
    self.showView.textColor = self.setting.textColor;
    [self showText];
    [self.myItem setView:self.showView];
    
//    NSStatusBarButton *settingBtn = [[NSStatusBarButton alloc] initWithFrame:NSMakeRect(self.showView.frame.size.width, 3, 17, 17)];
//    settingBtn.image = [NSImage imageNamed:@"setting"];
//    [self addRightClick:settingBtn];
//    [statusView addSubview:settingBtn];
}

- (void)showText
{
    //如果文本最后长度<showLen则表示即将展示的文字为最后一行
    
    if(![SettingModel haveNovel])
    {
        self.showView.stringValue = @"请导入需要阅读的书籍";
    }
    else if(self.setting.endShowStrLength < self.setting.showLength)
    {
        self.showView.stringValue =  [self.setting.novel substringWithRange:NSMakeRange(self.setting.startIndex, self.setting.endShowStrLength)];
    }
    else
    {
        self.showView.stringValue =  [self.setting.novel substringWithRange:NSMakeRange(self.setting.startIndex, self.setting.showLength)];
    }
    NSLog(@"内容:%@",self.showView.stringValue);
    [self.showView sizeToFit];
    self.showView.frame = NSMakeRect(0, 0, self.showView.frame.size.width, 20);

}


- (void)lastLine
{
    self.setting.endShowStrLength =  self.setting.showLength;
    if (self.setting.startIndex != 0)
    {
        self.setting.startIndex -= self.setting.showLength;
        [self showText];
    }
}


- (void)nextLine
{
    long int endIndex = self.setting.startIndex + self.setting.showLength;
    
    //起始位置不是文本最后一位则进入
    if (endIndex < self.setting.novel.length)
    {
        self.setting.endShowStrLength = self.setting.novel.length - endIndex;
        
        self.setting.startIndex = endIndex;
        
        [self showText];
    }
}

//导入阅读内容
- (void)openPanel
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setTitle:@"Choose a File or Folder"];
    
    [openPanel setCanChooseDirectories:YES];
    
    NSInteger i=[openPanel runModal];
    
    if(i == NSModalResponseOK)
    {
        NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:nil];
        NSString *str = [[[NSString alloc] initWithData:fileHandle.readDataToEndOfFile encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        self.setting.novel = str;
        [self showText];
    }
}



#pragma mark —— Popover

- (void)addMonitorForEvent
{
    AppDelegate *__weak weakSelf = self;
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskRightMouseUp handler:^NSEvent * _Nullable(NSEvent * event) {
        
        NSPoint p = [event locationInWindow];
        //判断坐标是否处于保护区内
        if(CGRectContainsPoint(self.showView.frame, p))
        {
            weakSelf.popover = [[NSPopover alloc] init];
            /* 设置动画 */
            weakSelf.popover.behavior = NSPopoverBehaviorTransient;
            /* 设置外观 */
            weakSelf.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
            /* 设置展示视图 */
            weakSelf.popover.contentViewController = [[HFPopoverController alloc] init];
            /* 设置展示方位 */
            [weakSelf.popover showRelativeToRect:self.showView.bounds ofView:self.showView preferredEdge:NSRectEdgeMaxY];
        }
        return event;
    }];
}



//打开软件
- (void)showClock
{
    //    [NSApp activateIgnoringOtherApps:YES];
    //    [self.mainWindow makeKeyAndOrderFront:nil];
    //    [self.mainWindow performSelector:@selector(orderFront:) withObject:nil afterDelay:0.1];
    //
    // 关于软件
    //    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://tanhao.sinaapp.com"]];
}

//退出
- (void)exit
{
    [SettingModel saveSetting:self.setting];
    [[NSApplication sharedApplication] terminate:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
 
}


@end
