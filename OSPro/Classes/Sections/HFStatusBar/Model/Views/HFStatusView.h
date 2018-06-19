//
//  HFStatusView.h
//  OSPro
//
//  Created by smallsevenk on 2018/6/14.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SettingModel.h"

@interface HFStatusView : NSView

@property (nonatomic, strong)   NSTextField *showView;
@property (nonatomic, strong)   NSStatusBarButton  *settingBtn;
@property (nonatomic, strong)   SettingModel *setting;
@property (nonatomic, strong)   SettingModel *newSetting;
@property (nonatomic, assign)   id monitor;

#define NOTI_AUTOLINE @"NOTI_AUTOLINE"
#define NOTI_HOTKEY @"NOTI_HOTKEY"

+ (HFStatusView *) share;

//更新至最新配置
- (void)updateToNewSetting;

- (void)nextPage;

@end
