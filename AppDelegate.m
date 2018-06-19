//
//  AppDelegate.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "AppDelegate.h"
#import "HFStatusView.h"
#import "SettingVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate*)share
{
    return (AppDelegate*)[NSApplication sharedApplication].delegate;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{ 
    self.mainWindow = [[MainWindowCtr alloc] initWithWindowNibName:@"MainWindowCtr"];
    self.myItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.myItem setView:[HFStatusView share]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
 
}


@end
