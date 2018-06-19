//
//  HFBaseController.h
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FlippedView.h"

@interface HFBaseController : NSViewController

@property (nonatomic, strong)   FlippedView *mainView;

- (void)setMainViewRect:(NSRect)rect;

@end
