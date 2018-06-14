//
//  AppDelegate.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "AppDelegate.h"
#import "HFStatusView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate*)share
{
    return (AppDelegate*)[NSApplication sharedApplication].delegate;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    _mainWindow = [[MainWindowCtr alloc] initWithWindowNibName:@"MainWindowCtr"];
//    //显示在屏幕中心
//    [[_mainWindow window] center];
//    //当前窗口显示
//    [_mainWindow.window orderFront:nil];
    
    [HFStatusView addStatusView];
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
 
}


@end
