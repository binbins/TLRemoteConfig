//
//  TLRemoteConfig.h
//  Pods
//
//  Created by 张帆 on 17/4/21.
//
//

#define TLAppVerName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define TLAppVerCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define TLAppBundleID [[NSBundle mainBundle] bundleIdentifier]
#define TLSysName [[[UIDevice currentDevice] systemName] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]
#define TLSysVersion [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]
#define TLSysModel [[[UIDevice currentDevice] model] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]
#define TLCurrentLanguage [[NSLocale preferredLanguages] count] > 0 ? [[NSLocale preferredLanguages] objectAtIndex:0] : @""


#define TLUSERDEFAULTS [NSUserDefaults standardUserDefaults]
#define TLREMOTEKEY @"AD_config_key"

#import <Foundation/Foundation.h>
@import AFNetworking;

@interface TLRemoteConfig : NSObject

+ (AFHTTPSessionManager *)afManager;

+ (NSDictionary *)localConfig;

#pragma mark - 从在线参数(params字典)中取值
+ (void)updateRemoteConfig;

+ (void)updateRemoteConfigHttp;

+ (NSString *)stringForKey:(NSString *)key;

+ (NSDictionary *)dictionaryForKey:(NSString *)key;

+ (NSArray *)arrayForKey:(NSString *)key;

+ (float)floatForKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;

+ (int)intForKey:(NSString *)key;

@end
