//
//  UIView+BaseViewController.m
//  Pods
//
//  Created by yunfenghan Ling on 7/5/16.
//
//

#import "UIView+BaseViewController.h"

@implementation UIView (BaseViewController)

- (UIViewController *)baseViewController {
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
