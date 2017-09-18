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
@property (nonatomic, assign)BOOL onRequesting;

@end

@implementation TLRemoteConfig

#pragma mark - get
- (AFHTTPSessionManager *)afManager {
    if (_afManager == nil) {
        _afManager = [AFHTTPSessionManager manager];
        _afManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _afManager.requestSerializer.timeoutInterval = 30;
        _afManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        _afManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _afManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", nil];
    }
    return _afManager;
}

#pragma mark - 暴露方法

+ (AFHTTPSessionManager *)afManager {
    return [[TLRemoteConfig shareManager] afManager];
}

+ (void)updateRemoteConfig {
    
    if ([TLRemoteConfig shareManager].onRequesting) {
        return;
    }
    
    [TLRemoteConfig shareManager].onRequesting = YES;
    
    [[TLRemoteConfig afManager] GET:TAOURL parameters:[self getRequestParas] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([TLUSERDEFAULTS objectForKey:TLREMOTEKEY] == nil) {
            [TLUSERDEFAULTS setObject:@{@"la":@"la"} forKey:TLREMOTEKEY];
        }
        [TLRemoteConfig checkConfigResult:responseObject];
        [TLRemoteConfig shareManager].onRequesting = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [TLRemoteConfig shareManager].onRequesting = NO;
        NSLog(@"请求在线参数失败: %@", error);
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
    
    NSDictionary *dict = [TLUSERDEFAULTS objectForKey:TLREMOTEKEY];
    if ([dict allKeys].count < 3) { //小于3认定为没有获取到数据
        [self updateRemoteConfig];
        return  @{};
    }
    return dict;
}

#pragma mark - 内部方法
static TLRemoteConfig *tlManager;

+ (TLRemoteConfig *)shareManager {
    if (tlManager == nil) {
        tlManager = [[TLRemoteConfig alloc] init];
    }
    return tlManager;
}

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
    NSString *language = [self languagePara];
    NSString *md5BundleId = [self md5: TLAppBundleID];
    
    NSDictionary *paras = @{@"os": @"iOS", @"appid" : md5BundleId, @"appver":TLAppVerName, @"appvercode":TLAppVerCode, @"sys_name":TLSysName, @"sys_ver":TLSysVersion, @"sys_model":TLSysModel, @"lan":language};
    return paras;
}
/*
 public const string LANGUAGE_CHINESE = "CN";
 public const string LANGUAGE_CHINESE_TRADITIONAL = "CT";
 public const string LANGUAGE_ENGLISH = "EN";
 public const string LANGUAGE_FRENCH = "FR";
 public const string LANGUAGE_GERMAN = "GE";
 
 public const string LANGUAGE_ITALY = "IT";
 public const string LANGUAGE_JAPANESE = "JP";
 public const string LANGUAGE_KOREA = "KR";
 public const string LANGUAGE_RUSSIA = "RU";
 public const string LANGUAGE_SPANISH = "SP";
 */
+ (NSString *)languagePara {

    if ([TLCurrentLanguage hasPrefix:@"zh-"]) {
        if ([TLCurrentLanguage hasPrefix:@"zh-Hans"]) {
            return @"CN";
        }
        return @"CT";
    }
    
    if ([TLCurrentLanguage hasPrefix:@"fr-"]) {
        return @"FR";   //法语
    }
    
    if ([TLCurrentLanguage hasPrefix:@"de-"]) {
        return @"GE";   //德语
    }
    
    if ([TLCurrentLanguage hasPrefix:@"it-"]) {
        return @"IT";   //意大利语
    }
    
    if ([TLCurrentLanguage hasPrefix:@"ja-"]) {
        return @"JP";   //日语
    }
    
    if ([TLCurrentLanguage hasPrefix:@"ko-"]) {
        return @"KR";   //韩语
    }
    
    if ([TLCurrentLanguage hasPrefix:@"ru-"]) {
        return @"RU";   //俄语
    }
    
    if ([TLCurrentLanguage hasPrefix:@"es-"]) {
        return @"SP";   //西班牙语
    }
    
    return @"EN";   //默认英文
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
    
    [TLUSERDEFAULTS setObject:res forKey:TLREMOTEKEY];
    NSLog(@"request succeed ! 执行 [TLRemoteConfig localConfig] 查看参数内容");
}



@end
