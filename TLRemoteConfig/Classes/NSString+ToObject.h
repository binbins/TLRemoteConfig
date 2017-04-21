//
//  NSString+ToObject.h
//  Pods
//
//  Created by 张帆 on 17/3/14.
//
//

#import <Foundation/Foundation.h>

@interface NSString (ToObject)

- (NSDictionary *)toNSDictionary;

- (NSArray *)toNSArray;

- (BOOL)toBOOL;

@end
