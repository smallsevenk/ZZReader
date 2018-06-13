//
//  SettingModel.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/12.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "SettingModel.h"


#define kSavaFullPath(SuffixFile) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:SuffixFile]

@implementation SettingModel

MJExtensionCodingImplementation

- (instancetype)init
{
    if (self = [super init]) {
        self.startIndex = 0;
        self.showLength = DEFAULT_SHOW_LENGTH;
        self.textColor  = [NSColor orangeColor];
        self.bgColor = [NSColor clearColor];
        self.fontSize = 14;
        self.novel = @"";
    }
    
    return self;
}


+ (SettingModel *)settingInfo
{
    SettingModel *setting = [NSKeyedUnarchiver unarchiveObjectWithFile:kSavaFullPath(@"setting.plist")];
    return setting;
}


//保存设置信息
+ (BOOL)saveSetting:(SettingModel *)setting
{
    //保存数据到沙盒里面
    BOOL result = [NSKeyedArchiver archiveRootObject:setting toFile:kSavaFullPath(@"setting.plist")];
    return result;
    
}

+ (BOOL)haveNovel
{
    SettingModel *setting = [self settingInfo];
    return (setting.novel.length > 0);//沙盒里面 用户名
}

@end
