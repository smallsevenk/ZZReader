//
//  HFBaseController.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "HFBaseController.h"
#import "AppDelegate.h"

@interface HFBaseController ()

@end

@implementation HFBaseController
@synthesize mainView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpViews];
}

- (void)setUpViews
{
    mainView = [[FlippedView alloc] initWithFrame:self.view.frame];
    mainView.layer.backgroundColor = [[NSColor orangeColor] CGColor];
    mainView.needsDisplay = YES; 
    [self.view addSubview:mainView];
}

- (void)setMainViewRect:(NSRect)rect
{
    self.view.frame = rect;
    self.mainView.frame = rect;
}

@end
