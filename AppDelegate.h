//
//  AppDelegate.h
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowCtr.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong)  MainWindowCtr *mainWindow;
@property (nonatomic ,strong)   NSStatusItem *myItem;

+ (AppDelegate*)share;

@end

