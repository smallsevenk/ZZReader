//
//  HFStatusView.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/14.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "HFStatusView.h"
#import "AppDelegate.h"
#import <AppKit/NSOpenPanel.h>//文件管理
#import <Carbon/Carbon.h>//快捷键
#import "SettingVC.h"
#import "SearchVC.h"

@implementation HFStatusView
#pragma mark —— share

static HFStatusView *_instance = nil;

+ (HFStatusView *) share
{
    
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[HFStatusView alloc] init];
        
    });
    
    return _instance;
}


- (instancetype)init
{
    if (self = [super init])
    {
        [self initializeStatus];
    }
    return self;
}


- (void)initializeStatus
{
    if ([SettingModel haveNovel])
    {
        self.setting = self.newSetting;
    }
    else
    {
        self.setting = [[SettingModel alloc] init];
        [SettingModel saveSetting:self.setting];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hotKeyNoti:) name:NOTI_HOTKEY object:nil];
    [self setHotKey];
    [self setStatus];
}



- (void)setStatus
{
    self.frame = NSMakeRect(0, 0, 100, 22);
    
    if (![self.setting.bgColor isEqualToString:@"无"])
    {
        [self setWantsLayer:YES];
        self.layer.backgroundColor = [SettingModel color:self.setting.bgColor].CGColor;
    }
    else
    {
        [self setWantsLayer:NO];
    }
    
    self.showView = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width - 17, 22)];
    self.showView.editable = NO;
    self.showView.bordered = NO;
    self.showView.alignment = NSTextAlignmentCenter;
    self.showView.backgroundColor = [NSColor clearColor];
    self.showView.font = [NSFont systemFontOfSize:self.setting.fontSize];
    self.showView.textColor = [SettingModel color:self.setting.textColor];
    [self addSubview:self.showView];
    
    NSImage *img = [NSImage imageNamed:@"setting"];
    self.settingBtn = [[NSStatusBarButton alloc] initWithFrame:NSMakeRect(self.showView.frame.size.width, (22 - img.size.height)/2, img.size.width, img.size.height)];
    self.settingBtn.image = img;
    [self addSubview:self.settingBtn];
    
    [self showText];
    
    if(self.setting.autoLine == 1)
    {
        [self nextPage];
    }
}

- (void)updateToNewSetting
{
    [self setWantsLayer:YES];
    if (![self.newSetting.bgColor isEqualToString:@"无"])
    {
        
        self.layer.backgroundColor = [SettingModel color:self.newSetting.bgColor].CGColor;
    }
    else
    {
        [self setWantsLayer:NO];
    }
    
    self.showView.font = [NSFont systemFontOfSize:self.newSetting.fontSize];
    self.showView.textColor = [SettingModel color:self.newSetting.textColor];
    
    long int endIndex = self.newSetting.startIndex + self.newSetting.showLength;
    if (endIndex < self.newSetting.novel.length)
    {
        SettingModel *s = self.newSetting;
        
        s.endShowStrLength = self.newSetting.novel.length - endIndex;
        [SettingModel saveSetting:s];
    }
    
    [self showText];
}

- (void)showText
{
    //如果文本最后长度<showLen则表示即将展示的文字为最后一行
    
    if(![SettingModel haveNovel])
    {
        self.showView.stringValue = @"请导入需要阅读的书籍";
    }
    else if(self.newSetting.endShowStrLength < self.newSetting.showLength)
    {
        self.showView.stringValue =  [self.newSetting.novel
                                      substringWithRange:NSMakeRange(self.newSetting.startIndex,
                                                                     self.newSetting.endShowStrLength)];
    }
    else
    {
        self.showView.stringValue =  [self.newSetting.novel
                                      substringWithRange:NSMakeRange(self.newSetting.startIndex,
                                                                     self.newSetting.showLength)];
    }
    
    NSLog(@"内容:%@",self.showView.stringValue);
    
    [self.showView sizeToFit];
    
    self.frame = NSMakeRect(0, 0, self.showView.frame.size.width + 30, 22);
    
    self.showView.frame = NSMakeRect(0,
                                     22 / 2 - self.showView.frame.size.height / 2,
                                     self.showView.frame.size.width,
                                     self.showView.frame.size.height);
    
    self.settingBtn.frame =  NSMakeRect(self.showView.frame.size.width + 5,
                                        self.settingBtn.frame.origin.y,
                                        self.settingBtn.frame.size.width,
                                        self.settingBtn.frame.size.height);
}

//上一页
- (void)lastPage
{
    SettingModel *s = self.newSetting;
    s.endShowStrLength =  s.showLength;
   
    
    if (self.newSetting.startIndex != 0)
    {
        s.startIndex -= s.showLength;
        [SettingModel saveSetting:s];
        [self showText];
    }
}

//下一页
- (void)nextPage
{
    SettingModel *s = self.newSetting;
    
    long int endIndex = s.startIndex + s.showLength;
    
    //起始位置不是文本最后一位则进入
    if (endIndex < s.novel.length)
    {
        s.endShowStrLength = s.novel.length - endIndex;
        s.startIndex = endIndex;
        [SettingModel saveSetting:s];
        
        [self showText];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(s.autoLineSec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (s.autoLine == 1)
            {
                [self nextPage];
            }
        });
    }
}



- (SettingModel *)newSetting
{
    _newSetting = [SettingModel settingInfo];
    
    return _newSetting;
}

#pragma mark —— Event

- (void)addMonitorForEvent
{
    HFStatusView *__weak weakSelf = self;
    [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskRightMouseUp handler:^NSEvent * _Nullable(NSEvent * event) {
        
        NSPoint p = [event locationInWindow];
        //判断坐标是否处于保护区内
        if(CGRectContainsPoint(self.settingBtn.frame, p))
        {
            //            weakSelf.popover = [[NSPopover alloc] init];
            //            /* 设置动画 */
            //            weakSelf.popover.behavior = NSPopoverBehaviorTransient;
            //            /* 设置外观 */
            //            weakSelf.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
            //            /* 设置展示视图 */
            //            weakSelf.popover.contentViewController = [[HFPopoverController alloc] init];
            //            /* 设置展示方位 */
            //            [weakSelf.popover showRelativeToRect:self.showView.bounds ofView:self.showView preferredEdge:NSRectEdgeMaxY];
            [weakSelf rightMouseDown:event];
        }
        return event;
    }];
}

-(void)rightMouseDown:(NSEvent *)event
{
    NSMenu *theMenu = [[NSMenu alloc] init];
    
    NSMenuItem *item1 = [[NSMenuItem alloc]init];
    item1.title = @"设置";
    item1.target = self;
    item1.action = @selector(toSetting:);
    
    [theMenu insertItem:item1 atIndex:0];
    [theMenu insertItemWithTitle:@"退出"action:@selector(exit)keyEquivalent:@""atIndex:1];
    
    [NSMenu popUpContextMenu:theMenu withEvent:event forView:self.settingBtn];
}

-(void)toSetting:(id)sender
{
    SettingModel *s = [SettingModel settingInfo];
    s.autoLine = 0;
    [SettingModel saveSetting:s];
    
    MainWindowCtr *mWindow = [AppDelegate share].mainWindow;
    [mWindow setContentViewController:[SettingVC new]];
    [mWindow.window center];
    [mWindow.window orderFront:nil];
} 

- (void)toSearch
{
    SettingModel *s = [SettingModel settingInfo];
    s.autoLine = 0;
    [SettingModel saveSetting:s];
    
    MainWindowCtr *mWindow = [AppDelegate share].mainWindow;
    [mWindow setContentViewController:[SearchVC new]];
    [mWindow.window center];
    [mWindow.window orderFront:nil];
}

//退出
- (void)exit
{
    [[NSApplication sharedApplication] terminate:nil];
}


#pragma mark —— 快捷键

- (void)hotKeyNoti:(NSNotification *)noti
{
    NSInteger hotKeyID = [[noti.userInfo objectForKey:@"hotKeyID"] intValue];
    SettingModel *s = self.newSetting;
    
    switch (hotKeyID)
    {
        case kVK_LeftArrow://上一行
        {
            if (self.newSetting.autoLine == 0)
            {
                [self lastPage];
            }
        }
            break;
        case kVK_RightArrow://下一行
        {
            if (self.newSetting.autoLine == 0)
            {
                [self nextPage];
            }
        }
            break;
        case kVK_UpArrow://字体变小
        {
            if (self.newSetting.fontSize > 8)
            {
                s.fontSize -= 1;
                [SettingModel saveSetting:s];
                [self updateToNewSetting];
            }
        }
            break;
        case kVK_DownArrow://字体变大
        {
            if (self.newSetting.fontSize < 32)
            {
                s.fontSize += 1;
                [SettingModel saveSetting:s];
                [self updateToNewSetting];
            }
        }
            break;
        case kVK_Escape://注销快捷键
        {
            [self exit];
            //            [self unRegistHotKey];
        }
            break;
        case kVK_Space://自动阅读启用/关闭
        {
            [[AppDelegate share].mainWindow.window close];
            s.autoLine = s.autoLine == 1?0:1;
            [SettingModel saveSetting:s];
            
            [self nextPage];
        }
            break;
        case kVK_ANSI_F://查找书籍
        {
            [[AppDelegate share].mainWindow.window close];
            s.autoLine = s.autoLine == 1?0:1;
            [SettingModel saveSetting:s];
            [self toSearch];
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
    [self hotKeyUpdate:kVK_LeftArrow];// isRegist:YES];
    [self hotKeyUpdate:kVK_RightArrow];// isRegist:YES];
    [self hotKeyUpdate:kVK_DownArrow];// isRegist:YES];
    [self hotKeyUpdate:kVK_UpArrow];// isRegist:YES];
    [self hotKeyUpdate:kVK_Escape];// isRegist:YES];
    [self hotKeyUpdate:kVK_Space];// isRegist:YES];
    [self hotKeyUpdate:kVK_ANSI_F];// isRegist:YES];
}

//-(void)unRegistHotKey
//{
//    [self hotKeyUpdate:kVK_LeftArrow isRegist:NO];
//    [self hotKeyUpdate:kVK_RightArrow isRegist:NO];
//    [self hotKeyUpdate:kVK_Delete isRegist:NO];
//    [self hotKeyUpdate:kVK_Return isRegist:NO];
//}

-(void)hotKeyUpdate:(NSInteger)keyCode //isRegist:(BOOL)isRegist
{
    EventHotKeyRef       gMyHotKeyRef;
    EventHotKeyID        gMyHotKeyID;
    EventTypeSpec        eventType;
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    InstallApplicationEventHandler(&GlobalHotKeyHandler,1,&eventType,NULL,NULL);
    gMyHotKeyID.signature = 'zick';
    gMyHotKeyID.id = keyCode;
    if (keyCode == kVK_ANSI_F)
    {
        RegisterEventHotKey(keyCode, cmdKey+optionKey, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    }
    else if (keyCode == kVK_Space)
    {
        RegisterEventHotKey(keyCode, cmdKey, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    }
    else
    {
//        UnregisterEventHotKey(gMyHotKeyRef);
        RegisterEventHotKey(keyCode, 0, gMyHotKeyID,GetApplicationEventTarget(), 0, &gMyHotKeyRef);
    }
    
    
    
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

-(void)pressNum:(NSString *)numStr
{
    NSLog(@" 按下 commnd + %@",numStr);
}

- (BOOL)acceptsFirstResponder{
    return YES;
}


@end
