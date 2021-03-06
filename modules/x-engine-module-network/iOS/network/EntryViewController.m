//
//  EntryViewController.m
//  network
//
//  Created by edz on 2020/7/22.
//  Copyright © 2020 edz. All rights reserved.
//

#import "EntryViewController.h"
#import <XEngineContext.h>
#import <MircroAppController.h>
#import "UIViewController+.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface EntryViewController ()
@end

@implementation EntryViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self pushTestModule];
}

- (IBAction)Action:(id)sender {
     [self pushTestModule];
}

- (void) pushTestModule {
    // 启动 h5 服务器, npm run dev
    // 将下面的 ip 换成你的电脑 ip 即可实时调试
    NSLog(@"%@",[self getIPAddress]);
    MircroAppController *webLaderVC = [[MircroAppController alloc] initWithUrl:[NSString stringWithFormat:@"http://%@:8080/",[self getIPAddress]]];
//    MircroAppController *webLaderVC = [[MircroAppController alloc] initWithMicroAppId:@"com.zkty.microapp.moduledemo"];
    [self pushViewController:webLaderVC];
}

- (NSString *)getIPAddress {
    return @"192.168.3.208";
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
