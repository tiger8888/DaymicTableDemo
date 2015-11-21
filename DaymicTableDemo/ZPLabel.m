//
//  ZPLabel.m
//  DaymicTableDemo
//
//  Created by 陈浩 on 15/11/20.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import "ZPLabel.h"

@implementation ZPLabel

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    // If this is a multiline label, need to make sure
    // preferredMaxLayoutWidth always matches the frame width
    // (i.e. orientation change can mess this up)
    
    if (self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth) {
        self.preferredMaxLayoutWidth = self.bounds.size.width;
        [self setNeedsUpdateConstraints];
    }
}

@end
