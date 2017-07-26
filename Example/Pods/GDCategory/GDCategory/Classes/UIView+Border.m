//
//  UIView+Border.m
//  ddemtion
//
//  Created by yunfenghan Ling on 16/3/18.
//  Copyright © 2016年 lingyfh. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

@end
