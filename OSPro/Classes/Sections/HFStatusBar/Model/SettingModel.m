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
        self.showLength = 20;
        self.endShowStrLength = self.showLength;
        self.textColor  = @"黑";
        self.bgColor = @"无";
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

+ (void)removeSetting
{
    if ([SettingModel removeFile:kSavaFullPath(@"setting.plist")])
    {
        NSLog(@"删除配置文件成功");
    }
}

+(BOOL)removeFile:(NSString*)filePath
{
    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExist)
    {
        NSLog(@"isExist = No");
        return YES;
    }else
    {
        BOOL result= [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        
        return result;
    }
}

+ (BOOL)haveNovel
{
    SettingModel *setting = [self settingInfo];
    return (setting.novel.length > 0);//沙盒里面 用户名
}

+ (NSColor *)color:(NSString *)colorStr
{
    //  @"黑",@"白",@"红",@"黄",@"绿",@"蓝",@"橙",@"紫",@"无"
    if ([colorStr isEqualToString:@"黑"])
    {
        return [NSColor blackColor];
    }
    else if ([colorStr isEqualToString:@"白"])
    {
        return [NSColor whiteColor];
    }
    else if ([colorStr isEqualToString:@"红"])
    {
        return [NSColor redColor];
    }
    else if ([colorStr isEqualToString:@"黄"])
    {
        return [NSColor yellowColor];
    }
    else if ([colorStr isEqualToString:@"绿"])
    {
        return [NSColor greenColor];
    }
    else if ([colorStr isEqualToString:@"蓝"])
    {
        return [NSColor blueColor];
    }
    else if ([colorStr isEqualToString:@"橙"])
    {
        return [NSColor orangeColor];
    }
    else if ([colorStr isEqualToString:@"紫"])
    {
        return [NSColor purpleColor];
    }
    else{
        return [NSColor clearColor];
    }
}

+ (NSString *)colorString:(NSColor *)color
{
    //  @"黑",@"白",@"红",@"黄",@"绿",@"蓝",@"橙",@"紫",@"无"
    if (color == [NSColor blackColor])
    {
        return @"黑";
    }
    else if (color == [NSColor whiteColor])
    {
        return @"白";
    }
    else if (color == [NSColor redColor])
    {
        return @"红";
    }
    else if (color == [NSColor yellowColor])
    {
        return @"黄";
    }
    else if (color == [NSColor greenColor])
    {
        return @"绿";
    }
    else if (color == [NSColor blueColor])
    {
        return @"蓝";
    }
    else if (color == [NSColor orangeColor])
    {
        return @"橙";
    }
    else if (color == [NSColor purpleColor])
    {
        return @"紫";
    }
    else
    {
        return @"无";
    }
}


@end
