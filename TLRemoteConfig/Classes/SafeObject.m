//
//  SafeObject.m
//  Pods
//
//  Created by 张帆 on 17/3/20.
//
//

#import "SafeObject.h"

@implementation SafeObject


+ (BOOL)objIsNull:(id)obj {
    return (obj == nil || [obj isEqual:[NSNull null]]) ? YES : NO;
}

+ (int)safeInt:(NSDictionary *)dict objectForKey:(NSString *)key {
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return -1;
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"(字典）key非法");
        return -1;
    }
    
    id value = [dict objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return ((NSString *)value).intValue;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {
        return ((NSNumber *)value).intValue;
    }
    return -1;
}

+ (NSString *)safeString:(NSDictionary *)dict objectForKey:(NSString *)key {
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return @"";
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（string）key非法");
        return @"";
    }
    
    NSString *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSString class]]) {
        return value;
    }
    return @"";
}

+ (NSDictionary *)safeDictionary:(NSDictionary *)dict objectForKey:(NSString *)key {
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return @{};
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（字典）key非法");
        return @{};
    }
    
    NSDictionary *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return @{};
}

+ (BOOL)safeBool:(NSDictionary *)dict objectForKey:(NSString *)key {
    
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return NO;
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（bool）key非法");
        return NO;
    }
    
    NSString *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSString class]]) {
        return value.boolValue;
    }
    return NO;
}

+ (float)safeFloat:(NSDictionary *)dict objectForKey:(NSString *)key {
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return -1.0f;
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"(float）key非法");
        return -1.0f;
    }
    
    id value = [dict objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return ((NSString *)value).floatValue;
    }
    
    if ([value isKindOfClass:[NSNumber class]]) {//不太合适哈
        return ((NSNumber *)value).floatValue;
    }
    return -1.0f;
}

+ (NSURL *)safeUrl:(NSDictionary *)dict objectForKey:(NSString *)key {
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return [NSURL URLWithString:@""];
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（url）key非法");
        return [NSURL URLWithString:@""];
    }
    
    NSString *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSString class]] || ![value isEqualToString:@""]) {
        NSString *url = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return [NSURL URLWithString:url];
    }
    return [NSURL URLWithString:@""];
}

+ (NSArray *)safeArray:(NSDictionary *)dict objectForKey:(NSString *)key {
    if ([self objIsNull:dict] || ![dict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"字典非法");
        return @[];
    }
    
    if ([self objIsNull:key] || ![key isKindOfClass:[NSString class]]) {
        NSLog(@"（array）key非法");
        return @[];
    }
    
    NSArray *value = [dict objectForKey:key];
    if ((value != nil) || [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return @[];
}






@end
