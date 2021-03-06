//
//  xengine__module_dcloud.m
//  dcloud
//
//  Created by zk on 2020/9/7.
//  Copyright © 2020 edz. All rights reserved.


#import "__xengine__module_dcloud.h"
#import <XEngineContext.h>
#import <micros.h>
//#import <UIViewController+.h>
#import "JSONToDictionary.h"
#import <Unity.h>
#import "DCUniMP.h"
#import "WeexSDK.h"
#import <XEngineContext.h>
#import "DCUniMP.h"

@interface __xengine__module_dcloud() <DCUniMPSDKEngineDelegate>
@property (nonatomic, weak) DCUniMPInstance *uniMPInstance; /**< 保存当前打开的小程序应用的引用 注意：请使用 weak 修辞，否则应在关闭小程序时置为 nil */
@end

@implementation __xengine__module_dcloud

- (instancetype)init{
    self = [super init];
    [self setUniMPMenuItems];
    return self;
}

// 启动小程序
- (void)_openUniMP:(DcloudDTO *)dto complete:(void (^)(BOOL))completionHandler {
    // 获取配置信息
    if ([self checkUniMPResource:dto.appId]) {
        DCUniMPConfiguration *configuration = [self getUniMPConfiguration:nil];
        __weak __typeof(self)weakSelf = self;
        // 打开小程序
        [DCUniMPSDKEngine openUniMP:dto.appId configuration:configuration completed:^(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error) {
            if (uniMPInstance) {
                weakSelf.uniMPInstance = uniMPInstance;
            } else {
                
                NSLog(@"打开小程序出错：%@",error);
            }
        }];
    }
    
}

//预加载后打开小程序
- (void)_preloadUniMP:(DcloudDTO *)dto complete:(void (^)(BOOL))completionHandler {
    // 获取配置信息
    if ([self checkUniMPResource:dto.appId]) {
        DCUniMPConfiguration *configuration = [self getUniMPConfiguration:nil];
        __weak __typeof(self)weakSelf = self;
        // 预加载小程序
        [DCUniMPSDKEngine preloadUniMP:dto.appId configuration:configuration completed:^(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error) {
            if (uniMPInstance) {
                weakSelf.uniMPInstance = uniMPInstance;
                // 预加载后打开小程序
                [uniMPInstance showWithCompletion:^(BOOL success, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"show 小程序失败：%@",error);
                    }
                }];
            } else {
                NSLog(@"预加载小程序出错：%@",error);
            }
        }];
    }
}


// 启动小程序传递参数
- (void)_openUniMPWithArg:(UniMPDTO *)dto complete:(void (^)(BOOL))completionHandler {
    if ([self checkUniMPResource:dto.appId]) {
        // 获取配置信息
        DCUniMPConfiguration *configuration = [self getUniMPConfiguration:dto];
        __weak __typeof(self)weakSelf = self;
        // 打开小程序
        [DCUniMPSDKEngine openUniMP:dto.appId configuration:configuration completed:^(DCUniMPInstance * _Nullable uniMPInstance, NSError * _Nullable error) {
            if (uniMPInstance) {
                weakSelf.uniMPInstance = uniMPInstance;
            } else {
                NSLog(@"打开小程序出错：%@",error);
            }
        }];
    }
}


#pragma mark 小程序
/// 检查运行目录是否存在应用资源，不存在将应用资源部署到运行目录
- (BOOL)checkUniMPResource:(NSString *)appId {
    if (![DCUniMPSDKEngine isExistsApp:appId]) {
        // 读取导入到工程中的wgt应用资源
        NSString *appResourcePath = [[NSBundle mainBundle] pathForResource:appId ofType:@"wgt"];
        if (!appResourcePath) {
            NSLog(@"资源路径不正确，请检查");
            return NO;
        }
        // 将应用资源部署到运行路径中
        if ([DCUniMPSDKEngine releaseAppResourceToRunPathWithAppid:appId resourceFilePath:appResourcePath]) {
            return YES;
        }
    }
    return YES;
}

/// 配置胶囊按钮菜单 ActionSheet 全局项（点击胶囊按钮 ··· ActionSheet弹窗中的项）
- (void)setUniMPMenuItems {
    
    DCUniMPMenuActionSheetItem *item1 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"将小程序隐藏到后台" identifier:@"enterBackground"];
    DCUniMPMenuActionSheetItem *item2 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"关闭小程序" identifier:@"closeUniMP"];
    
    // 运行内置的 __UNI__CBDCE04 小程序，打开下面的注释可以测试原生向小程序发送事件
//    DCUniMPMenuActionSheetItem *item3 = [[DCUniMPMenuActionSheetItem alloc] initWithTitle:@"SendUniMPEvent" identifier:@"SendUniMPEvent"];
    // 添加到全局配置
    [DCUniMPSDKEngine setDefaultMenuItems:@[item1,item2]];
    // 设置 delegate
    [DCUniMPSDKEngine setDelegate:self];
}


/// 小程序配置信息
- (DCUniMPConfiguration *)getUniMPConfiguration:(UniMPDTO *)dto {
    
    /// 初始化小程序的配置信息
    DCUniMPConfiguration *configuration = [[DCUniMPConfiguration alloc] init];
    
    if (!dto) {
        // 配置启动小程序时传递的参数（参数可以在小程序中通过 plus.runtime.arguments 获取此参数）
        configuration.arguments = @{ @"arguments":@"Hello uni microprogram" };
        // 配置小程序启动后直接打开的页面路径 例："pages/component/view/view?a=1&b=2"
        configuration.redirectPath = nil;
        // 开启后台运行
        configuration.enableBackground = NO;
        
    }else{
        // 配置启动小程序时传递的参数（参数可以在小程序中通过 plus.runtime.arguments 获取此参数）
        configuration.arguments = dto.arguments;
        // 配置小程序启动后直接打开的页面路径 例："pages/component/view/view?a=1&b=2"
        if (![dto.redirectPath isEqualToString:@""]) {
            configuration.redirectPath = dto.redirectPath;
        }else{
            configuration.redirectPath = nil ;
        }
        // 开启后台运行
        configuration.enableBackground = dto.enableBackground;
        
        configuration.showAnimated = dto.showAnimated;
        configuration.hideAnimated = dto.hideAnimated;
    }
    
    return configuration;
}

#pragma mark - DCUniMPSDKEngineDelegate
/// DCUniMPMenuActionSheetItem 点击触发回调方法
- (void)defaultMenuItemClicked:(NSString *)identifier {
    NSLog(@"标识为 %@ 的 item 被点击了", identifier);
    
    // 将小程序隐藏到后台
    if ([identifier isEqualToString:@"enterBackground"]) {
        __weak __typeof(self)weakSelf = self;
        [self.uniMPInstance hideWithCompletion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"小程序 %@ 进入后台",weakSelf.uniMPInstance.appid);
            } else {
                NSLog(@"hide 小程序出错：%@",error);
            }
        }];
    }
    // 关闭小程序
    else if ([identifier isEqualToString:@"closeUniMP"]) {
        [self.uniMPInstance closeWithCompletion:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"小程序 closed");
            } else {
                NSLog(@"close 小程序出错：%@",error);
            }
        }];
    }
    // 向小程序发送消息
    else if ([identifier isEqualToString:@"SendUniMPEvent"]) {
        [DCUniMPSDKEngine sendUniMPEvent:@"NativeEvent" data:@{@"msg":@"native message"}];
    }
}

/// 返回打开小程序时的自定义闪屏视图
- (UIView *)splashViewForApp:(NSString *)appid {
//    UIView *splashView = [[[NSBundle mainBundle] loadNibNamed:@"SplashView" owner:self options:nil] lastObject];
    
    // 设置文件路径
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"xengine-dcloud" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    // 加载 nib 文件
    UINib *nib = [UINib nibWithNibName:@"SplashView" bundle:resourceBundle];
    NSArray *viewObjs = [nib instantiateWithOwner:nil options:nil];
    UIView * splashView = viewObjs.lastObject;
    return splashView;
}

/// 小程序关闭回调方法
- (void)uniMPOnClose:(NSString *)appid {
    NSLog(@"小程序 %@ 被关闭了",appid);
    
    self.uniMPInstance = nil;
    
    // 可以在这个时机再次打开小程序
//    [self openUniMP:nil];
}

/// 监听小程序发送的事件回调方法
/// @param event 事件
/// @param data 参数
/// @param callback 回调方法，回传数据给小程序
- (void)onUniMPEventReceive:(NSString *)event data:(id)data callback:(DCUniMPKeepAliveCallback)callback {
    
    NSLog(@"Receive UniMP event: %@ data: %@",event,data);
    
    // 回传数据给小程序
    // DCUniMPKeepAliveCallback 用法请查看定义说明
    if (callback) {
        callback(@"native callback message",NO);
    }
}


#pragma mark application

static __xengine__module_dcloud *instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[__xengine__module_dcloud alloc] init] ;
    }) ;
    return instance ;
}

- (void) dcloudRegister:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 配置参数
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithDictionary:launchOptions];
    // 设置 debug YES 会在控制台输出 js log，默认不输出 log，注：需要引入 liblibLog.a 库
    [options setObject:[NSNumber numberWithBool:YES] forKey:@"debug"];
    // 初始化引擎
    [DCUniMPSDKEngine initSDKEnvironmentWihtLaunchOptions:options];
    
    
    //    // 注册 module 注：module的 Name 需要保证唯一， class：为 module 的类名
    [WXSDKEngine registerModule:@"TestModule" withClass:NSClassFromString(@"TestModule")];
    // 注册 component 注：component 的 Name 需要保证唯一， class：为 component 的类名
    [WXSDKEngine registerComponent:@"testmap" withClass:NSClassFromString(@"TestMapComponent")];
   
}

- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    [self dcloudRegister:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark - App 生命周期方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [DCUniMPSDKEngine applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [DCUniMPSDKEngine applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [DCUniMPSDKEngine applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [DCUniMPSDKEngine applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [DCUniMPSDKEngine destory];
}

@end
 
