//
//  SettingVC.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/13.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "SettingVC.h"
#import "SettingModel.h"
#import "HFStatusView.h"
#import "AppDelegate.h"

@interface SettingVC ()
<NSComboBoxDelegate>

@property (nonatomic, strong)   SettingModel *setting;
@property (nonatomic, strong)   NSArray *valueArr;
@property (nonatomic, strong)   NSComboBox *autoCb;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self setUpView];
}


- (void)setUpView
{
     [AppDelegate share].mainWindow.window.title = @"设置";
    [self setMainViewRect:NSMakeRect(0, 0, 71.4*6, 48.8*6)];
    
    self.setting = [SettingModel settingInfo];
    NSImageView *imgView = [[NSImageView alloc] initWithFrame:self.mainView.frame];
    imgView.image = [NSImage imageNamed:@"setting_bg"];
    [self.view addSubview:imgView];
    [self.view addSubview:self.mainView];
    
    NSMutableArray *sizeTempArr = [NSMutableArray new];
    for (int i = 8; i <= 32; i++)
    {
        [sizeTempArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSArray *colorArr = [[NSArray alloc] initWithObjects:@"黑",@"白",@"红",@"黄",@"绿",@"蓝",@"橙",@"紫",@"无", nil];
    NSArray *sizeArr = [[NSArray alloc] initWithArray:sizeTempArr];
    NSArray *lenArr = [[NSArray alloc] initWithObjects:@"10",@"15",@"20",@"25",@"30", nil];
    NSArray *autoArr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    NSArray *titleArr = [[NSArray alloc] initWithObjects:@"字体大小",@"文字颜色",@"背景颜色",@"每屏字数",@"换行间隔",nil];
    self.valueArr  = [[NSArray alloc] initWithObjects:sizeArr,colorArr,colorArr,lenArr,autoArr, nil];
    
    for (int i = 0; i < titleArr.count; i++)
    {
        NSTextField *titleTf = [[NSTextField alloc] initWithFrame:NSZeroRect];
        titleTf.editable = NO;
        titleTf.bordered = NO;
        [titleTf setNeedsDisplay:YES];
        titleTf.font = [NSFont systemFontOfSize:16];
        titleTf.backgroundColor = [NSColor clearColor];
        titleTf.textColor = [NSColor blackColor];
        titleTf.stringValue = titleArr[i];
        titleTf.alignment = NSTextAlignmentLeft;
        titleTf.frame = NSMakeRect(100, 20 * (i + 1) + 25 * i, 110, 25 );
        [self.mainView addSubview:titleTf];
        
        NSComboBox *cb = [[NSComboBox alloc] initWithFrame:NSMakeRect(titleTf.frame.origin.x + titleTf.frame.size.width, titleTf.frame.origin.y - 3, 100, 25)];
        cb.font = [NSFont systemFontOfSize:12];
        cb.alignment = NSTextAlignmentCenter;
        cb.tag = i;
        [cb addItemsWithObjectValues:self.valueArr[i]];
        [cb setEditable:NO];
        cb.delegate = self;
        [self.mainView addSubview:cb];
        
        NSInteger idx = 0;
        
        switch (i)
        {
            case SettingType_fontSize://字体大小
            {
                idx = [sizeArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.setting.fontSize]];
            }
                break;
            case SettingType_textColor://文字颜色
            {
                idx = [colorArr indexOfObject:self.setting.textColor];
            }
                break;
            case SettingType_bgColor://背景颜色
            {
                idx = [colorArr indexOfObject:self.setting.bgColor];
            }
                break;
            case SettingType_showLen://每屏字数
            {
                idx = [lenArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.setting.showLength]];
            }
                break;
            case SettingType_autoLine://每屏字数
            {
//                self.autoCb = cb;
//                if (self.setting.autoLine == 1)
//                {
//                    self.autoCb.enabled = YES;
//                }
//                else
//                {
//                    self.autoCb.enabled = NO;
//                }
                idx = [autoArr indexOfObject:[NSString stringWithFormat:@"%ld",(long)self.setting.autoLineSec]];
            }
                break;
                
            default:
                break;
        }
        
        [cb selectItemAtIndex:idx];
        
        NSButton *autoLineBtn = [[NSButton alloc] initWithFrame:NSMakeRect(100, self.mainView.frame.size.height - 30 - 15, 90, 30)];
        [autoLineBtn setTitle:@"自动阅读"];
        [autoLineBtn.layer setMasksToBounds:YES];
        [autoLineBtn.layer setCornerRadius:5];
        [autoLineBtn setButtonType:NSButtonTypeSwitch];
        autoLineBtn.font = [NSFont systemFontOfSize:14];
        [autoLineBtn setAction:@selector(switchReaderType:)];
        if (self.setting.autoLine == 1)
        {
            [autoLineBtn setState:NSControlStateValueOn];
        }
        [self.mainView addSubview:autoLineBtn];
        
        NSButton *importBtn = [[NSButton alloc] initWithFrame:NSMakeRect(autoLineBtn.frame.size.width + autoLineBtn.frame.origin.x + 10, self.mainView.frame.size.height - 30 - 15, 90, 30)];
        [importBtn setTitle:@"导入text"];
        [importBtn.layer setMasksToBounds:YES];
        [importBtn.layer setCornerRadius:5];
        importBtn.font = [NSFont systemFontOfSize:14];
        [importBtn setAction:@selector(openPanel)];
        [self.mainView addSubview:importBtn];
        
        NSButton *resetBtn = [[NSButton alloc] initWithFrame:NSMakeRect(self.mainView.frame.size.width - 90 - 30, self.mainView.frame.size.height - 30 - 15, 90, 30)];
        [resetBtn setTitle:@"重置"];
        [resetBtn.layer setMasksToBounds:YES];
        [resetBtn.layer setCornerRadius:5];
        resetBtn.font = [NSFont systemFontOfSize:14];
        [resetBtn setAction:@selector(reset)];
        [self.mainView addSubview:resetBtn];
    }
}

- (void)comboBoxSelectionIsChanging:(NSNotification *)notification
{
    NSComboBox *cb = notification.object;
    
    NSInteger idx = cb.indexOfSelectedItem;
    NSString *cbValue = self.valueArr[cb.tag][idx];
    SettingModel *s = [SettingModel settingInfo];
    
    switch (cb.tag)
    {
        case SettingType_fontSize://字体大小
        {
            s.fontSize = [cbValue integerValue];
        }
            break;
        case SettingType_textColor://文字颜色
        {
            s.textColor = cbValue;
        }
            break;
        case SettingType_bgColor://背景颜色
        {
            s.bgColor = cbValue;
        }
            break;
        case SettingType_showLen://每屏字数
        {
            s.showLength = [cbValue integerValue];
        }
            break;
        case SettingType_autoLine://每屏字数
        {
            s.autoLineSec = [cbValue integerValue];
        }
            break;
            
        default:
            break;
    }
    
    [SettingModel saveSetting:s];
    [[HFStatusView share] updateToNewSetting];
}

//自动换行
- (void)switchReaderType:(NSButton *)btn
{
    SettingModel *s = [SettingModel settingInfo];
    s.autoLine = btn.state;
    [SettingModel saveSetting:s];
    
    if (s.autoLine == 1)
    {
        self.autoCb.enabled = YES;
        [[HFStatusView share] nextPage];
    }
    else
    {
        self.autoCb.enabled = NO;
    }
}


//导入阅读内容
- (void)openPanel
{
    SettingModel *s = [SettingModel settingInfo];
    if(s.isOpen == 1) return;
    
    s.isOpen = 1;
    
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
        
        s.novel = str;
        s.autoLine = 0;
        s.isOpen = 0;
        [SettingModel saveSetting:s];
        [[HFStatusView share] updateToNewSetting];
        [[AppDelegate share].mainWindow.window close];
    }
    else
    {
        s.isOpen = 0;
        [SettingModel saveSetting:s];
    }
    
}

//重置
- (void)reset
{
    NSAlert *alert = [NSAlert new];
    [alert addButtonWithTitle:@"确定"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:@"确定重置你的ZZReader?"];
    [alert setInformativeText:@"重置会重置您的偏好设置并清除您的阅读记录!"];
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode)
    {
        if(returnCode == NSAlertFirstButtonReturn)
        {
            [SettingModel saveSetting:[SettingModel new]];
            [[HFStatusView share] updateToNewSetting];
            [[AppDelegate share].mainWindow close];
        } 
    }];
    
} 


@end
