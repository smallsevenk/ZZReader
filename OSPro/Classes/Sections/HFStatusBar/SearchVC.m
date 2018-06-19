//
//  SearchVC.m
//  ZZReader
//
//  Created by smallsevenk on 2018/6/15.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "SearchVC.h"
#import "AppDelegate.h"
#import "SettingModel.h"
#import "HFStatusView.h"

@interface SearchVC ()<NSTextFieldDelegate>
@property (nonatomic, strong)   NSTextField *searchTf;
@property (nonatomic, assign)   CGFloat margin;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}


- (void)setUpView
{
    [AppDelegate share].mainWindow.window.title = @"查找";
    [self setMainViewRect:NSMakeRect(0, 0, 71.4*6, 40)];
    
    self.margin = (self.mainView.frame.size.height - 25)/2;
    
    NSImageView *imgView = [[NSImageView alloc] initWithFrame:self.mainView.frame];
    imgView.image = [NSImage imageNamed:@"setting_bg"];
    [self.view addSubview:imgView];
    [self.view addSubview:self.mainView];
    
    [self.view addSubview:self.searchTf];
    [self.searchTf becomeFirstResponder];
    
    if (@available(macOS 10.12, *)) {
        NSButton *btn = [NSButton buttonWithTitle:@"Search" target:self action:@selector(search:)];
        btn.frame = NSMakeRect(self.mainView.frame.size.width - self.margin - 70, self.margin, 70, 25);
        [self.mainView addSubview:btn];
    } else {
        // Fallback on earlier versions
    }
}

- (void)search:(NSButton *)btn
{
    SettingModel *s = [SettingModel settingInfo];
    
    NSString *tmpStr = s.novel;
    
    NSRange range;
    
    range = [tmpStr rangeOfString:self.searchTf.stringValue];
    
    if (range.location != NSNotFound)
    {
        [[AppDelegate share].mainWindow.window close];
        
        s.startIndex = range.location;
        [SettingModel saveSetting:s];
        [[HFStatusView share] updateToNewSetting];
    }
}

- (NSTextField *)searchTf
{
    if (!_searchTf)
    {
        _searchTf = [[NSTextField alloc] initWithFrame:NSMakeRect(self.margin, self.margin, self.mainView.frame.size.width - self.margin * 2 - 5 - 70, 25)];
        _searchTf.bordered = YES;
        _searchTf.font = [NSFont systemFontOfSize:16];
        _searchTf.placeholderString = @"请输入你要查找的内容";
    }
    
    return _searchTf;
}


@end
