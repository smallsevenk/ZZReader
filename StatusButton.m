//
//  StatusButton.m
//  OSPro
//
//  Created by smallsevenk on 2018/6/11.
//  Copyright © 2018年 HappinessFamily. All rights reserved.
//

#import "StatusButton.h"

@implementation StatusButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    //背景颜色
    
    [[NSColor clearColor] set];
    
    NSRectFill(self.bounds);
    
    //绘制文字
    if (_ttext != nil)
    {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        
                
        [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
        
                
        [paraStyle setAlignment:NSCenterTextAlignment];
        
                
        //[paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
        
                
        NSDictionary *attrButton = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Verdana" size:14], NSFontAttributeName, [NSColor blackColor], NSForegroundColorAttributeName, paraStyle, NSParagraphStyleAttributeName, nil];
        
                
        NSAttributedString * btnString = [[NSAttributedString alloc] initWithString:_ttext attributes:attrButton];
        
                
        [btnString drawInRect:NSMakeRect(0, 4, self.frame.size.width, self.frame.size.height)];
        
                
            
    }
}

@end
