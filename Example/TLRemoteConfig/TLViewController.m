//
//  TLViewController.m
//  TLRemoteConfig
//
//  Created by binbins on 04/21/2017.
//  Copyright (c) 2017 binbins. All rights reserved.
//

#import "TLViewController.h"
@import TLRemoteConfig;

@interface TLViewController ()

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary *testDict = @{@"test_key":@(39345678)};
    NSString *value = [SafeObject safeString:testDict objectForKey:@"test_key"];
    NSLog(@"取值 %@", value);
}

@end
