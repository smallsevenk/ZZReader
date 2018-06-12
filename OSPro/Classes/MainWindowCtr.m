//
//  MainWindowCtr.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "MainWindowCtr.h"
#import <AppKit/AppKit.h>

@interface MainWindowCtr ()
@property (nonatomic ,strong) NSStatusItem *myItem;
@property (nonatomic, strong)   NSTextField *contentTf;
@end



@implementation MainWindowCtr

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.window.title = @"测试";
    
    // 创建NSStatusItem并添加到系统状态栏上
    self.myItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    // 设置NSStatusItem 的图片
    NSImage *image = [NSImage imageNamed:@"settings"];
    [self.myItem.button setImage: image];
    
    NSView *statusView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 200, 30)];
//    [statusView setNeedsDisplay:YES];
//    [statusView.layer setBackgroundColor:[[NSColor redColor] CGColor]];
    [self.myItem setView:statusView];
    
    
    NSTextField *contentTf = [[NSTextField alloc]init];
    contentTf.editable = NO;
    contentTf.bordered = NO; //不显示边框
    contentTf.backgroundColor = [NSColor greenColor]; //控件背景色
    contentTf.textColor = [NSColor magentaColor];  //文字颜色
    contentTf.alignment = NSTextAlignmentRight; //水平显示方式
    contentTf.frame = NSMakeRect(0, 0, 100, 10);
    contentTf.stringValue = @"测试文字聚会就大戽水抗旱萨克的";  //现实的文字内容
    self.contentTf = contentTf;
    
    [statusView addSubview:contentTf];
    
    
    
    // 为NSStatusItem 添加点击事件
    self.myItem.target = self;
    self.myItem.button.action = @selector(showMyPopover:);
    
//    // 防止下面的block方法中造成循环引用
//    __weak typeof (self) weakSelf = self;
//    // 添加对鼠标左键进行事件监听
//    // 如果想对其他事件监听也进行监听，可以修改第一个枚举参数： NSEventMaskLeftMouseDown | 你要监听的其他枚举值
//    [NSEvent addGlobalMonitorForEventsMatchingMask:NSEventMaskLeftMouseDown handler:^(NSEvent * event) {
//        if (weakSelf.popover.isShown) {
//            // 关闭popover；
//            [weakSelf.popover close];
//        }
//    }];
}
// 显示popover方法
- (void)showMyPopover:(NSStatusBarButton *)button{
    self.myItem.toolTip = @"哈哈哈哈";
}

@end
