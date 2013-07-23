//
//  ZSTextField.m
//  ZSAlertViewDemo
//
//  Created by 1010@comp on 13-7-20.
//  Copyright (c) 2013年 ZRX. All rights reserved.
//

#import "ZSTextField.h"

@implementation ZSTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *backgroundImage = [UIImage imageNamed:@"textfield_background.png"];
        UIEdgeInsets imgInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        backgroundImage = [backgroundImage resizableImageWithCapInsets:imgInsets];
        
        self.background = backgroundImage;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 16.0f, bounds.origin.y + 10.f, bounds.size.width - 32.f, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + 16.0f, bounds.origin.y + 10.f, bounds.size.width - 32.f, bounds.size.height);
}

@end

