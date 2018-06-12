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
#import <AppKit/NSOpenPanel.h>

@interface AppDelegate ()

@property (strong)  MainWindowCtr *mainWindow;

@property (nonatomic ,strong) NSStatusItem *myItem;
@property (nonatomic, strong)   NSTextField *showView;
@property (nonatomic, copy)   NSString *readStr;//文本内容
@property (nonatomic, assign)   long int startIndex;//显示文字起始位置
@property (nonatomic, assign)   NSInteger showLength;//显示文字长度
@property (nonatomic, assign)   CGFloat showWidth;//显示视图长度
@property (nonatomic, assign)   NSInteger fontSize;//显示字体大小
@property (nonatomic, assign)   NSInteger endShowStrLength;//最后显示文字长度


@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    _mainWindow = [[MainWindowCtr alloc] initWithWindowNibName:@"MainWindowCtr"];
//    //显示在屏幕中心
//    [[_mainWindow window] center];
//
//    //当前窗口显示
//    [_mainWindow.window orderFront:nil];
    [self setStatus];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)setStatus
{
    self.startIndex = 0;
    self.showLength = 2;
    self.showWidth = 400;
    self.fontSize = 14;
    self.readStr = @"哼，你可以试试，看看是谁杀谁！”冯凯毫不示弱的在二楼冷喝。秦烈和很多人都在下层，只能听到上面传来的争吵声，不能看到上面两人的状况。“安静。”一个不耐的声音，从更上面的楼层传来，声音浑厚有力，哼道：“如果不想遵守我的规矩，就都给我滚出去！”此言一出，冯凯和裴安的争吵声立即停了下来，两人还嗫嚅着，同声致歉：“潘老息怒。”“潘老，他是谁？”有初来的人低声询问。“潘老就是潘珏铭，是冰岩城这家器具阁分店的负责人，连碎冰府府主严文彦，和星云阁的阁主屠漠，都要给他几分面子，更何况冯凯和裴安了？”有知情者轻声解释。秦烈在人群中听着，默默看向通往上一层的楼梯口，暗自苦笑。他境界不够，身家也不阔绰，显然不够资格去上一层看看，沉吟了一下，趁着大家注意力都放在先前的事情上，他找到一名器具阁的女店员，拿出一块刻画了聚灵阵图的灵板，说道：“器具阁收灵材么？";
    
    // 创建NSStatusItem并添加到系统状态栏上
    self.myItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    // 设置NSStatusItem 的图片
    NSImage *image = [NSImage imageNamed:@"settings"];
    [self.myItem.button setImage: image];
    
    
    
    NSView *statusView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.showWidth, 20)];
    [self.myItem setView:statusView];
    
    self.showView = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, self.showWidth - 100, statusView.frame.size.height)];
    self.showView.stringValue = [self.readStr substringWithRange:NSMakeRange(self.startIndex, self.showLength)];
    self.showView.editable = NO;
    self.showView.bordered = NO;
    self.showView.alignment = NSTextAlignmentCenter;
    self.showView.backgroundColor = [NSColor orangeColor];
    self.showView.font = [NSFont systemFontOfSize:self.fontSize];
    self.showView.textColor = [NSColor whiteColor];
    [statusView addSubview:self.showView];
    
    
    NSButton *preBtn = [[NSButton alloc] initWithFrame:NSMakeRect(self.showView.frame.size.width, 0, 50, statusView.frame.size.height)];
    preBtn.title = @"  <<  ";
    [preBtn setAction:@selector(preAction)];
    [statusView addSubview:preBtn];
    
    NSButton *nextBtn = [[NSButton alloc] initWithFrame:NSMakeRect(preBtn.frame.origin.x + preBtn.frame.size.width, 0, 50, statusView.frame.size.height)];
    nextBtn.title = @"  >>  ";
    [nextBtn setAction:@selector(openFile)];
    [statusView addSubview:nextBtn];
    
}

// 显示popover方法
- (void)preAction
{
    if (self.startIndex != 0)
    {
        self.startIndex -= self.showLength;
        self.showView.stringValue = [self.readStr substringWithRange:NSMakeRange(self.startIndex, self.showLength)];
    }
}

// 显示popover方法
- (void)nextAction
{
    long int endIndex = self.startIndex + self.showLength;
    
    //起始位置不是文本最后一位则进入
    if (endIndex < self.readStr.length)
    {
        self.endShowStrLength = self.readStr.length - endIndex;
        
        self.startIndex = endIndex;
        
        //如果文本最后长度<10则表示即将展示的文字为最后一行
        if (self.endShowStrLength < self.showLength)
        {
            NSLog(@"文字进入了最后一行");
            self.showView.stringValue = [self.readStr substringWithRange:NSMakeRange(self.startIndex, self.endShowStrLength)];
        }
        else
        {
            self.showView.stringValue = [self.readStr substringWithRange:NSMakeRange(self.startIndex, self.showLength)];
        }
    }
}

- (void)openFile
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    
    [openPanel setTitle:@"Choose a File or Folder"];
    
    [openPanel setCanChooseDirectories:YES];
    
    NSInteger i=[openPanel runModal];
    
    if(i == NSModalResponseOK)
    {
        NSURL *fileUrl = [[openPanel URLs] objectAtIndex:0];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingFromURL:fileUrl error:nil];
        NSString *fileContext = [[NSString alloc] initWithData:fileHandle.readDataToEndOfFile encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",fileContext);
    }
}

@end
