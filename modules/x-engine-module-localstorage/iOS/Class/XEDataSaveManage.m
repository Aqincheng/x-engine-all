//
//  XEDataSaveManage.m
//  ModuleApp
//
//  Created by 吕冬剑 on 2020/9/29.
//  Copyright © 2020 edz. All rights reserved.
//

#import "XEDataSaveManage.h"
#import <x-engine-module-engine/MicroAppLoader.h>

@implementation XEDataSaveManage
// 设置
+ (void)setLocalStorage:(NSString *)key withValue:(NSString *)value withIsPublic:(BOOL)isPublic {
    NSUserDefaults *defaults;
    if(isPublic){
        
        defaults = [NSUserDefaults standardUserDefaults];
    } else {
        
        defaults = [[NSUserDefaults alloc] initWithSuiteName:[MicroAppLoader sharedInstance].nowMicroAppId];
    }
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

// 获取
+ (NSString *)getLocalStorage:(NSString *)key withIsPublic:(BOOL)isPublic{
    
    NSUserDefaults *defaults;
    if(isPublic){
        defaults = [NSUserDefaults standardUserDefaults];
    } else {
        defaults = [[NSUserDefaults alloc] initWithSuiteName:[MicroAppLoader sharedInstance].nowMicroAppId];
    }
    NSString *value = [defaults objectForKey: key];
    return value;
}

// 删除某一个
+ (void)remoteLocalStorageItem:(NSString *)key withIsPublic:(BOOL)isPublic {
    NSUserDefaults *defaults;
    if(isPublic){
        defaults = [NSUserDefaults standardUserDefaults];
    } else {
        defaults = [[NSUserDefaults alloc] initWithSuiteName:[MicroAppLoader sharedInstance].nowMicroAppId];
    }
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

// 删除全部
+ (void)removeLocalStorageAll {
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:[MicroAppLoader sharedInstance].nowMicroAppId];
    [defaults removePersistentDomainForName:[MicroAppLoader sharedInstance].nowMicroAppId];
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

//// 设置
//+ (void)setLocalStorage2:(NSString *)key withValue:(NSString *)value withIsPublic:(BOOL)isPublic {
//    NSUserDefaults *defaults;
//    if(isPublic){
//        
//        defaults = [NSUserDefaults standardUserDefaults];
//    } else {
//        defaults = [[NSUserDefaults alloc] initWithSuiteName:@"temp"];
//    }
//    [defaults setObject:value forKey:key];
//    [defaults synchronize];
//}
//
//// 获取
//+ (NSString *)getLocalStorage2:(NSString *)key withIsPublic:(BOOL)isPublic{
//    
//    NSUserDefaults *defaults;
//    if(isPublic){
//        defaults = [NSUserDefaults standardUserDefaults];
//    } else {
//        defaults = [[NSUserDefaults alloc] initWithSuiteName:@"temp"];
//    }
//    NSString *value = [defaults objectForKey: key];
//    return value;
//}
@end