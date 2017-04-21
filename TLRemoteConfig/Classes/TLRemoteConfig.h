//
//  TLRemoteConfig.h
//  Pods
//
//  Created by 张帆 on 17/4/21.
//
//

#define AppVerName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppVerCode [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define AppBundleID [[NSBundle mainBundle] bundleIdentifier]
#define SysName [[[UIDevice currentDevice] systemName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysVersion [[[UIDevice currentDevice] systemVersion] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define SysModel [[[UIDevice currentDevice] model] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define CurrentLanguage [[NSLocale preferredLanguages] count] > 0 ? [[NSLocale preferredLanguages] objectAtIndex:0] : @""


#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define LocalConfigKey @"AD_config_key"

#import <Foundation/Foundation.h>
@import AFNetworking;

@interface TLRemoteConfig : NSObject

+ (AFHTTPSessionManager *)afManager;

+ (NSDictionary *)localConfig;

#pragma mark - 从在线参数(params字典)中取值
+ (void)updateRemoteConfig;

+ (NSString *)stringForKey:(NSString *)key;

+ (NSDictionary *)dictionaryForKey:(NSString *)key;

+ (NSArray *)arrayForKey:(NSString *)key;

+ (float)floatForKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;

+ (int)intForKey:(NSString *)key;

@end
