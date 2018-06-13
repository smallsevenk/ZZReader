//
//  SettingCol.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/13.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "SettingCol.h"

@implementation SettingCol


- (id)initWithIdentifier:(NSUserInterfaceItemIdentifier)identifier
{
    if(self = [super initWithIdentifier:identifier])
    {
        self.titleTf = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 0, 0 )];
        self.titleTf.editable = NO;
        self.titleTf.bordered = NO;
        [self setDataCell:self.titleTf];
        self.valueTf = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 0, 0 )];
        [self setDataCell:self.valueTf];
        
    }
    
    return self;
}

@end
