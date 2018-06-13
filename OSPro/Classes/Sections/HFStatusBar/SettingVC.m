//
//  SettingVC.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/13.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()
<NSTableViewDelegate,NSTableViewDataSource>


@property (nonatomic, strong)   NSTableView *tbView;
@property (nonatomic, strong)   NSArray *dataArr;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)setUpView
{
    NSStatusBarButton *btn = [[NSStatusBarButton alloc] initWithFrame:NSMakeRect(100, 100, 100, 40)];
    
    //    [self addRightClick:settingBtn];
    [self.view addSubview:btn];
    self.view.layer.backgroundColor = [[NSColor redColor] CGColor];
    self.view.frame = NSMakeRect(0, 0, 300, 600);
    [self.view addSubview:self.tbView];
    
}

#pragma mark —— TableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataArr.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return self.dataArr[row];
}


- (NSTableView *)tbView
{
    if (!_tbView)
    {
        _tbView = [[NSTableView alloc] initWithFrame:self.view.frame];
        self.tbView.delegate = self;
        self.tbView.dataSource = self;
    }
    
    return _tbView;
}

- (NSArray *)dataArr
{
    if (!_dataArr)
    {
        _dataArr = [[NSArray alloc] initWithObjects:@"字体大小",@"文字颜色",@"背景色",@"字数/屏", nil];
    }
    
    return _dataArr;
}

@end
