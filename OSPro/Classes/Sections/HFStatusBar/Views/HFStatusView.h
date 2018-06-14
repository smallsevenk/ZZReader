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

@property (nonatomic, strong)   NSView *statusView;
@property (nonatomic, strong)   NSTextField *showView;
@property (nonatomic, strong)   NSStatusBarButton  *settingBtn;
@property (nonatomic, strong)   SettingModel *setting;

#define NOTI_HOTKEY @"NOTI_HOTKEY"

+ (void)addStatusView;

@end
