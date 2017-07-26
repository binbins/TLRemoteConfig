//
//  UIView+CornerRadius.m
//  ddemtion
//
//  Created by LingYunfenghan on 3/17/16.
//  Copyright © 2016 lingyfh. All rights reserved.
//

#import "UIView+CornerRadius.h"

@implementation UIView (CornerRadius)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

@end
