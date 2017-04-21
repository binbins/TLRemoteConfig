//
//  TLAppDelegate.m
//  TLRemoteConfig
//
//  Created by binbins on 04/21/2017.
//  Copyright (c) 2017 binbins. All rights reserved.
//

#import "TLAppDelegate.h"
@import TLRemoteConfig;

@implementation TLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TLRemoteConfig updateRemoteConfig];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSDictionary *appkey = [TLRemoteConfig dictionaryForKey:@"appkey"];
    NSArray *native = [TLRemoteConfig arrayForKey:@"pos_native"];
    BOOL isreviewing = [TLRemoteConfig boolForKey:@"a_taolu_enable"];
    NSArray *wrongArr = [TLRemoteConfig arrayForKey:@"other"];
    NSLog(@"appkey:%@ , native:%@, a_taolu_enable:%d, wrongarr:%@", appkey, native, (int)isreviewing, wrongArr);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
