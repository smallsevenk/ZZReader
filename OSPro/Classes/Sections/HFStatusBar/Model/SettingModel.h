//
//  SettingModel.h
//  OSPro
//
//  Created by smallsevenk on 2018/6/12.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
#import <Cocoa/Cocoa.h> 

@interface SettingModel : NSObject<NSCoding>

typedef NS_ENUM(NSInteger, SettingType) {
    SettingType_fontSize = 0,//字体大小
    SettingType_textColor = 1  ,//字体颜色
    SettingType_bgColor = 2  ,//文字背景色
    SettingType_showLen = 3 ,//文字长度
    SettingType_autoLine = 4,//自动换行间隔
};  

@property (nonatomic, copy)     NSString *filePath;
@property (nonatomic, copy)     NSString *novel;//文本内容
@property (nonatomic, assign)   long int startIndex;//显示文字起始位置
@property (nonatomic, assign)   NSInteger showLength;//显示文字长度
//@property (nonatomic, assign)   CGFloat showWidth;//显示视图长度
@property (nonatomic, assign)   NSInteger fontSize;//显示字体大小
@property (nonatomic, strong)   NSString *textColor;//显示文字颜色
@property (nonatomic, strong)   NSString *bgColor;//显示文字背景色
@property (nonatomic, assign)   NSInteger endShowStrLength;//最后显示文字长度
@property (nonatomic, assign)   NSInteger isOpen;  //是否打开导入页面 1:打开 0:关闭
@property (nonatomic, assign)   NSInteger autoLine;//自动换行 1:自动 0:手动
@property (nonatomic, assign)   NSInteger autoLineSec;//自动换行秒数
@property (nonatomic, strong)   NSColor *statusColor;

+ (SettingModel *)settingInfo;

//保存设置信息
+ (BOOL)saveSetting:(SettingModel *)setting;

//删除配置文件
+ (void)removeSetting;

+ (BOOL)haveNovel;

+ (NSColor *)color:(NSString *)colorStr;

+ (NSString *)colorString:(NSColor *)color;

@end
