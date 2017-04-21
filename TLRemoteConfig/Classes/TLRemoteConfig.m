//
//  TLRemoteConfig.m
//  Pods
//
//  Created by 张帆 on 17/4/21.
//
//

#define TAOURL @"http://service.kv.dandanjiang.tv/remote"

#import "TLRemoteConfig.h"
#import "SafeObject.h"
#import "NSString+ToObject.h"
#import <CommonCrypto/CommonDigest.h>

@interface TLRemoteConfig()
@property (nonatomic, retain)AFHTTPSessionManager *afManager;

@end

@implementation TLRemoteConfig

#pragma mark - get
- (AFHTTPSessionManager *)afManager {
    if (_afManager == nil) {
        _afManager = [AFHTTPSessionManager manager];
        _afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _afManager.requestSerializer.timeoutInterval = 15;
        _afManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        _afManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", nil];
    }
    return _afManager;
}

#pragma mark - 暴露方法

+ (AFHTTPSessionManager *)afManager {
    return [[TLRemoteConfig alloc] afManager];
}

+ (void)updateRemoteConfig {
    
    [[TLRemoteConfig afManager] GET:TAOURL parameters:[self getRequestParas] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([USERDEFAULTS objectForKey:LocalConfigKey] == nil) {
            [USERDEFAULTS setObject:@{@"la":@"la"} forKey:LocalConfigKey];
        }
        [TLRemoteConfig checkConfigResult:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"请求在线参数失败");
    }];
}

+ (NSString *)stringForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return @"";
    }
    return [SafeObject safeString:[TLRemoteConfig localConfig] objectForKey:key];   //也有问题，返回的不一定是字符串
}

+ (NSDictionary *)dictionaryForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return @{};
    }
    NSString *string = [SafeObject safeString:[TLRemoteConfig localConfig] objectForKey:key];
    return [string toNSDictionary];
}

+ (NSArray *)arrayForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return @[];
    }
    NSString *string = [SafeObject safeString:[TLRemoteConfig localConfig] objectForKey:key];
    return [string toNSArray];
}

+ (BOOL)boolForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return NO;
    }
    NSString *string = [SafeObject safeString:[TLRemoteConfig localConfig] objectForKey:key];
    return string.boolValue;
}

+ (float)floatForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return 0.0f;
    }
    NSString *string = [SafeObject safeString:[TLRemoteConfig localConfig] objectForKey:key];
    return string.floatValue;
}

+ (int)intForKey:(NSString *)key {
    if ([SafeObject objIsNull:key]) {
        return -1;
    }
    NSString *string = [SafeObject safeString:[TLRemoteConfig localConfig] objectForKey:key];
    return string.intValue;
}

+ (NSDictionary *)localConfig {
    
    NSDictionary *dict = [USERDEFAULTS objectForKey:LocalConfigKey];
    if ([SafeObject objIsNull:dict]) {
        [self updateRemoteConfig];
        return  @{};
    }
    return dict;
}

#pragma mark - 内部方法

+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSDictionary *)getRequestParas {
    NSString *language = [CurrentLanguage hasPrefix:@"zh-"] ? @"CN" : @"EN";
    NSString *md5BundleId = [self md5: AppBundleID];
    
    NSDictionary *paras = @{@"os": @"iOS", @"appid" : md5BundleId, @"appver":AppVerName, @"appvercode":AppVerCode, @"sys_name":SysName, @"sys_ver":SysVersion, @"sys_model":SysModel, @"lan":language};
    return paras;
}

+ (void)checkConfigResult:(NSDictionary *)result {
    
    if ([SafeObject objIsNull:result] || ![result isKindOfClass:[NSDictionary class]]) {
        NSLog(@"result 非法");
        return;
    }
    
    if ([SafeObject safeInt:result objectForKey:@"code"] != 0) {   //有问题，没有判断是不是string或者number
        NSLog(@"返回值不为0");
        return;
    }
    
    NSDictionary *res = [SafeObject safeDictionary:result objectForKey:@"res"];
    if ([SafeObject objIsNull:res] || ![res isKindOfClass:[NSDictionary class]]) {
        NSLog(@"res 非法");
        return;
    }
    
    [USERDEFAULTS setObject:res forKey:LocalConfigKey];
    NSLog(@"request succeed ! content:%@",res);
}

@end
