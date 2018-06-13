//
//  SettingVC.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/13.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "SettingVC.h"
#import "SettingModel.h"

@interface SettingVC ()
<NSTableViewDelegate,NSTableViewDataSource>


@property (nonatomic, strong)   NSTableView *tbView;
@property (nonatomic, strong)   NSArray *dataArr;
@property (nonatomic, strong)   SettingModel *setting;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)setUpView
{
    self.setting = [SettingModel settingInfo];
    
    NSArray *colorArr = [[NSArray alloc] initWithObjects:@"黑",@"白",@"红",@"黄",@"绿",@"蓝",@"橙",@"紫",@"无", nil];
    NSArray *sizeArr = [[NSArray alloc] initWithObjects:@"12",@"13",@"14",@"15",@"16", nil];
    NSArray *lenArr = [[NSArray alloc] initWithObjects:@"10",@"15",@"20",@"25",@"30", nil];
    
    NSArray *titleArr = [[NSArray alloc] initWithObjects:@"字体大小",@"文字颜色",@"背景颜色",@"每屏字数", nil];
    NSArray *valueArr = [[NSArray alloc] initWithObjects:sizeArr,colorArr,colorArr,lenArr, nil];
    
    for (int i = 0; i < titleArr.count; i++)
    {
        NSTextField *titleTf = [[NSTextField alloc] initWithFrame:NSZeroRect];
        titleTf.editable = NO;
        titleTf.bordered = NO;
        [titleTf setNeedsDisplay:YES];
        titleTf.font = [NSFont systemFontOfSize:14];
        titleTf.backgroundColor = [NSColor clearColor];
        titleTf.stringValue = titleArr[i];
//        [titleTf sizeToFit];
        titleTf.frame = NSMakeRect(10, 10 * (i + 1) + 25 * i, 70, 25 );
        [self.mainView addSubview:titleTf];
        
        NSComboBox *cb1 = [[NSComboBox alloc] initWithFrame:NSMakeRect(titleTf.frame.size.width + 10, titleTf.frame.origin.y - 5, 50, 25)];
        cb1.font = [NSFont systemFontOfSize:12];
//        [cb1 setAlignment:NSTextAlignmentJustified];
        [cb1 addItemsWithObjectValues:valueArr[i]];
        [self.mainView addSubview:cb1];
        
        NSInteger idx = 0;
        
        switch (i) {
            case 0:
            {
                idx = [sizeArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.setting.fontSize]];
            }
                break;
            case 1:
            {
                idx = [colorArr indexOfObject:self.setting.textColor];
            }
                break;
            case 2:
            {
                idx = [colorArr indexOfObject:self.setting.bgColor];
            }
                break;
            case 3:
            {
                idx = [lenArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.setting.showLength]];
            }
                break;
                
            default:
                break;
        }
        
        [cb1 selectItemAtIndex:idx];
    }
}



#pragma mark —— TableView

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataArr.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([tableColumn.identifier isEqualToString:@"title"])
    {
        return self.dataArr[row];
    }
    else if ([tableColumn.identifier isEqualToString:@"value"])
    {
        return @"这就是值";
    }
    else
    {
        return @"";
    }
}

- (NSTableView *)tbView
{
    if (!_tbView)
    {
        _tbView = [[NSTableView alloc] initWithFrame:self.mainView.bounds];
        _tbView.needsDisplay = YES;
        _tbView.layer.backgroundColor = [NSColor redColor].CGColor;
        
        NSTableColumn * titleCol = [[NSTableColumn alloc] initWithIdentifier:@"title"];
        titleCol.width = _tbView.frame.size.width / 2;
        [_tbView addTableColumn:titleCol];
        
        NSTableColumn * valueCol = [[NSTableColumn alloc] initWithIdentifier:@"value"];
        valueCol.width = _tbView.frame.size.width / 2;
        [_tbView addTableColumn:valueCol];
        
        _tbView.delegate = self;
        _tbView.dataSource = self;
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
