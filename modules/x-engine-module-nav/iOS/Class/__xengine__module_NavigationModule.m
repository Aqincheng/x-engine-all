//
//  __xengine__module_NavigationModule.m

#import "__xengine__module_NavigationModule.h"
#import "XEngineContext.h"
#import "PopoverViewController.h"
#import "UINavigationItem+BarButtonItem.h"
#import "Unity.h"
#import "UIViewController+Push_Present.h"
#import "MircroAppController.h"
#import "UIViewController+NavigationBar.h"
#import "UIViewController+Customized.h"
#import "UIColor+HexString.h"
#import "UIViewController+Loading_Prompt.h"
#import "JSONToDictionary.h"
#import "xengine_protocol_network.h"
#import "micros.h"
#import "MicroAppLoader.h"
#import "UIBlockButton.h"
#import "XEOneWebViewControllerManage.h"
#import "NavUtil.h"

//#import "WXApi.h"
#import "NavSearchBar.h"

static const NSUInteger BAR_BTN_FLAG = 10000;

@interface __xengine__module_NavigationModule () <UIPopoverPresentationControllerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightBarItem; /** rightBarItem */
@property (nonatomic, strong) UIBarButtonItem *leftBarItem; /** leftBarItem */
//@property (nonatomic, strong) NSDictionary *itemParam; /** 下拉菜单参数 */
@property (nonatomic,copy) NSString * isInput;
@property (nonatomic, weak) id<xengine_protocol_network> network;
@end

@implementation __xengine__module_NavigationModule

- (NSString *)moduleId {
    
    return @"com.zkty.module.nav";
}

- (void)onAllMoudlesInited {
    _network = [[XEngineContext sharedInstance] getModuleByProtocol:@protocol(xengine_protocol_network)];
}

- (void) downloadImg:(NSString*)url cb:(nullable void (^)(NSURLResponse * response, UIImage * _Nullable img, NSError * _Nullable error)) cb{
    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
    [topVC showLoading];
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDownloadTask *downloadTask = [self.network downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [topVC hideLoading];
        if(!error){
            UIImage* responseObject=[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:filePath]];
            cb(response,responseObject,error);
        }else{
            NSLog(@"%@",error);
        }
        
    }];
    [downloadTask resume];
    
}
#pragma nav
///push跳转下一页
//- (void)navigatorPush:(NSDictionary *)param callBack:(XEngineCallBack)completionHandler {
//
//
//    NavNavigatorDTO *dto = [[NavNavigatorDTO alloc] init];
//    dto.url = param[@"url"];
//    void(^change)(BOOL r) = ^(BOOL r){
//        if (completionHandler){
//            NSString *jsonStr = [JSONToDictionary toString:@{}];
//            completionHandler(jsonStr, YES);
//        }
//    };
//    [self _navigatorPush:dto complete:change];
//}
//- (void)navigatorBack:(NSDictionary *)param callBack:(XEngineCallBack)completionHandler{
//    NavNavigatorDTO *dto = [[NavNavigatorDTO alloc] init];
//    dto.url = param[@"path"];
//    void(^change)(BOOL r) = ^(BOOL r){
//        if (completionHandler){
//            NSString *jsonStr = [JSONToDictionary toString:@{}];
//            completionHandler(jsonStr, YES);
//        }
//    };
//    [self _navigatorBack:dto complete:change];
//}

- (void)setNavLeftBtn:(NSDictionary *)param callBack:(XEngineCallBack)completionHandler{
    //    if ([Unity sharedInstance].getCurrentVC.navigationController.viewControllers.count <= 1) {
    [self addItemBarButtonWithParam:param isLeft:YES];
    //    }
}

- (void)setNavRightBtn:(NSDictionary *)param callBack:(XEngineCallBack)completionHandler{
    [self addItemBarButtonWithParam:param isLeft:NO];
}

- (void)setNavRightMenuBtn:(NSDictionary *)param callBlock:(XEngineCallBack)completionHandler{
    [self addItemBarButtonWithParam:param isLeft:NO];
}

- (void)setNavTitle:(NSDictionary *)param callBlock:(XEngineCallBack)completionHandler{
    NSString *title = param[@"title"];
    NSString *titleColor = param[@"titleColor"];
    NSInteger titleSize = [param[@"titleSize"] integerValue];
    
    if ([self checkRequiredParam:title name:@"title"]) {
        [self setNavTitle:title withTitleColor:titleColor withTitleSize:titleSize];
    }
    
}

//-(void)setNavRightMoreBtn:(NSDictionary *)param callBack:(XEngineCallBack)completionHandler{
//    [self addMoreItemBarButtonWithParam:param isLeft:NO];
//}

//-(void)setNavSearchBar:(NSDictionary *)param callBack:(XEngineCallBack)completionHandler{
//    [self addSearchBar:param];
//}

#pragma mark - fun
///切换tabbar页签
- (void)navigateSwitchTap:(NSDictionary *)data callBlock:(XEngineCallBack)completionHandler{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:UITabBarController.class]){
        UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
        [topVC.navigationController popToRootViewControllerAnimated:YES];
        topVC.tabBarController.selectedIndex = 0;
    }
}

///隐藏navbar
- (void)navigateHidden:(NSDictionary *)data complate:(XEngineCallBack)completionHandler{
    [self isHiddenNavbar:YES];
}

///显示navbar
- (void)navigateShow:(NSDictionary *)data callBlock:(XEngineCallBack)completionHandler{
    
    [self isHiddenNavbar:NO];
}


- (void)addItemBarButtonWithParam:(NSDictionary *)param isLeft:(BOOL)isLeft{
    
    NavBtnDTO *btn = [[NavBtnDTO alloc] init];
    btn.title = param[@"title"];
    btn.icon = param[@"icon"];
    
    btn.titleColor = param[@"titleColor"];
    btn.titleSize = [[NSString stringWithFormat:@"%@", param[@"titleSize"] ?: @"16"] integerValue];
    btn.iconSize = param[@"iconSize"];
    btn.__event__ = param[@"__event__"];
    if (param[@"itemList"]){
        btn.popList = param[@"itemList"];
    }
    if (param[@"popList"]){
        btn.popList = param[@"popList"];
    }
    
    btn.popWidth = param[@"popWidth"];
    if (isLeft){
        [self _setNavLeftBtn:btn complete:nil];
    } else {
        [self _setNavRightBtn:btn complete:nil];
    }
}

- (void)addMoreItemBarButtonWithParam:(NSDictionary *)params isLeft:(BOOL)isLeft{
    
    
    NSString *clickEvent = params[@"__event__"];
    NSMutableArray *btnAry = [@[] mutableCopy];
    for (int i = 0; i < params.allKeys.count; i++){
        NSDictionary *item = params[[NSString stringWithFormat:@"%d", i]];
        
        NavBtnDTO *btn = [[NavBtnDTO alloc] init];
        btn.title = item[@"title"];
        btn.icon = item[@"icon"];
        btn.titleColor = item[@"titleColor"];
        btn.titleSize = [[NSString stringWithFormat:@"%@", item[@"titleSize"] ?: @"16"] integerValue];
        btn.iconSize = item[@"iconSize"];
        btn.__event__ = item[@"__event__"];
        btn.popList = item[@"itemList"];
        //        NSArray *ary = item[@"itemList"];
        //        if (ary.count > 0){
        //            NSMutableArray *temp = [@[] mutableCopy];
        //            for (NSDictionary *i in ary) {
        //                NavPopModelDTO *dto = [[NavPopModelDTO alloc] init];
        //                dto.icon = i[@"icon"];
        //                dto.iconSize = i[@"iconSize"];
        //                dto.title = i[@"title"];
        //                [temp addObject:dto];
        //            }
        //            btn.popList = temp;
        //        }
        
        btn.popWidth = item[@"popWidth"];
        [btnAry addObject:btn];
    }
    NavMoreBtnDTO *btns = [[NavMoreBtnDTO alloc] init];
    btns.btns = btnAry;
    [self _setNavRightMoreBtn:btns complete:nil];
}

- (void)showRightMenuButtonAction:(NSArray *)itemList withMenuWidth:(NSString *)menuWidht withEvent:(NSString *)event{
    
    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
    PopoverViewController *popover = [[PopoverViewController alloc] init];
    popover.itemList = itemList;
    popover.preferredContentSize = CGSizeMake( (menuWidht && ![menuWidht isEqualToString:@""] && ![menuWidht isEqual:[NSNull null]]) ? menuWidht.floatValue:100, itemList.count * 50);
    popover.modalPresentationStyle = UIModalPresentationPopover;
    popover.selectCellBlock = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
        [topVC dismissAnimated:YES completion:^{
            RecyleWebViewController *webVC = (RecyleWebViewController *)topVC;
            NSString *indexRow = [NSString stringWithFormat:@"%ld",indexPath.item];
            if ([NavUtil getNoEmptyString:event]){
                [webVC.webview callHandler:event arguments:@[indexRow] completionHandler:^(id  _Nullable value) {}];
            }
        }];
    };
    
    
    UIPopoverPresentationController *popController = [popover popoverPresentationController];
    popController.canOverlapSourceViewRect = YES;
    popController.delegate = self;
    //     popController.permittedArrowDirections = UIPopoverArrowDirectionLeft;
    popController.barButtonItem = self.rightBarItem;
    [topVC presentViewController:popover animated:YES completion:nil];
}

-(void)addSearchBar:(NSDictionary *)param{
    
    NavSearchBarDTO *dto = [[NavSearchBarDTO alloc] init];
    
    dto.cornerRadius = [param[@"cornerRadius"] integerValue];
    dto.backgroundColor = param[@"backgroundColor"];
    dto.iconSearch = param[@"iconSearch"];
    dto.iconSearchSize = param[@"iconSearchSize"];
    dto.iconClear = param[@"iconClear"];
    dto.iconClearSize = param[@"iconClearSize"];
    dto.textColor = param[@"textColor"];
    dto.__event__ = param[@"__event__"];
    dto.fontSize = [param[@"fontSize"] integerValue];
    dto.placeHolder = param[@"placeHolder"];
    dto.placeHolderFontSize = [param[@"placeHolderFontSize"] integerValue];
    dto.isInput = [param[@"isInput"] boolValue];
    dto.becomeFirstResponder = [param[@"becomeFirstResponder"] boolValue];
    
    [self _setNavSearchBar:dto complete:nil];
}


//-(void)tapGesture:(UITapGestureRecognizer *)gesture{
//    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
//    if ([topVC isKindOfClass:RecyleWebViewController.class]){
//        RecyleWebViewController *webVC = (RecyleWebViewController *)topVC;
//        [webVC.webview callHandler:@"handlerNavSearchBar" arguments:@[@"0"] completionHandler:^(id  _Nullable value) {
//
//        }];
//    }
//}

#pragma mark - UIPopoverPresentationControllerDelegate
// 设立实现代理，注意要返回UIModalPresentationNone
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}




- (void)_navigatorBack:(NavNavigatorDTO *)dto complete:(void (^)(BOOL))completionHandler {
    
    if ([@"0" isEqualToString:dto.url]){
        [[Unity sharedInstance].getCurrentVC.navigationController popToRootViewControllerAnimated:YES];
        return;
    }if (dto.url.length == 0){
        [[Unity sharedInstance].getCurrentVC pop];
        return;
    } else{
        
        BOOL isAction = false;
        NSArray *ary = [Unity sharedInstance].getCurrentVC.navigationController.viewControllers;
        for (UIViewController *vc in ary) {
            
            if ([vc isKindOfClass:RecyleWebViewController.class]){
                RecyleWebViewController *webVC = (RecyleWebViewController *)vc;
                if ([webVC.preLevelPath isEqualToString:dto.url] || [[NSString stringWithFormat:@"/%@", webVC.preLevelPath] isEqualToString:dto.url]){
                    [[Unity sharedInstance].getCurrentVC.navigationController popToViewController:webVC animated:YES];
                    isAction = YES;
                    break;
                }
                else if ([@"/index" isEqualToString:dto.url] && [vc isKindOfClass:[RecyleWebViewController class]]){
                    [[Unity sharedInstance].getCurrentVC.navigationController popToViewController:webVC animated:YES];
                    isAction = YES;
                    break;
                }
            }
        }
        if (!isAction){
            [[Unity sharedInstance].getCurrentVC pop];
        }
    }
    if(completionHandler){
        completionHandler(YES);
    }
}


- (void)_navigatorPush:(NavNavigatorDTO *)dto complete:(void (^)(BOOL))completionHandler {
    NSString *urlStr = dto.url;
    if([urlStr hasPrefix:@"http"]){
        [[XEOneWebViewControllerManage sharedInstance] pushWebViewControllerWithUrl:urlStr];
    } else{
        [[XEOneWebViewControllerManage sharedInstance] pushViewControllerWithPath:urlStr withParams:dto.params];
    }
    if(completionHandler){
        completionHandler(YES);
    }
}


- (void)_setNavLeftBtn:(NavBtnDTO *)dto complete:(void (^)(BOOL))completionHandler {
    if ([Unity sharedInstance].getCurrentVC.navigationController.viewControllers.count <= 1) {
        [self setBarItems:@[dto] withIsRight:NO withEvent:nil withBeginIndex:0];
    }
    if(completionHandler){
        completionHandler(YES);
    }
}


- (void)_setNavRightBtn:(NavBtnDTO *)dto complete:(void (^)(BOOL))completionHandler {
    [self setBarItems:@[dto] withIsRight:YES withEvent:nil withBeginIndex:0];
    if(completionHandler){
        completionHandler(YES);
    }
}


- (void)_setNavRightMenuBtn:(NavBtnDTO *)dto complete:(void (^)(BOOL))completionHandler{
    [self setBarItems:@[dto] withIsRight:YES withEvent:nil withBeginIndex:0];
    if(completionHandler){
        completionHandler(YES);
    }
}


- (void)_setNavRightMoreBtn:(NavMoreBtnDTO *)dto complete:(void (^)(BOOL))completionHandler {
    [self setBarItems:dto.btns withIsRight:YES withEvent:nil withBeginIndex:0];
    if(completionHandler){
        completionHandler(YES);
    }
}


- (void)_setNavTitle:(NavTitleDTO *)dto complete:(void (^)(BOOL))completionHandler {
    [self setNavTitle:dto.title withTitleColor:dto.titleColor withTitleSize:dto.titleSize];
}

- (void)_setNavSearchBar:(NavSearchBarDTO *)dto complete:(void (^)(BOOL))completionHandler {
    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
    NavSearchBar *searchBar = [[NavSearchBar alloc] init];
    [searchBar setSearchModel:dto];
    topVC.navigationItem.titleView = searchBar;
    
    if(completionHandler){
        completionHandler(YES);
    }
}


//- (void)_setNavBase:(NavDTO *)dto complete:(void (^)(BOOL))completionHandler {
//
//    [self setBarItems:dto.leftBtns withIsRight:NO withEvent:dto.__event__ withBeginIndex:0];
//    [self setBarItems:dto.rightBtns withIsRight:YES withEvent:dto.__event__ withBeginIndex:BAR_BTN_FLAG];
//    [self isHiddenNavbar:dto.isHiddenNavBar];
//    if (!dto.isHiddenNavBar){
//        [self setNavTitle:dto.title withTitleColor:dto.titleFont.textColor withTitleSize:dto.titleFont.fontSize];
//    }
//    completionHandler(YES);
//}

//- (void)_setNavLeftBtns:(NavBtns *)dto complete:(void (^)(BOOL))completionHandler {
//    [self setBarItems:dto withIsRight:NO withEvent:nil withBeginIndex:0];
//    completionHandler(YES);
//}
//
//- (void)_setNavRightBtns:(NavBtns *)dto complete:(void (^)(BOOL))completionHandler {
//    [self setBarItems:dto withIsRight:YES withEvent:nil withBeginIndex:BAR_BTN_FLAG];
//    completionHandler(YES);
//}

//- (void)_setAlertNavRightBtn:(NavBtns *)dto complete:(void (^)(BOOL))completionHandler{
//
//    [self setBarItems:dto withIsRight:YES withEvent:nil withBeginIndex:BAR_BTN_FLAG];
//    completionHandler(YES);
//}

- (void)setNavTitle:(NSString *)title withTitleColor:(NSString *)color withTitleSize:(NSInteger)size {
    
    if ([self checkRequiredParam:title name:@"title"]) {
        UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
        topVC.title = title;
        UIColor *rgbColor;
        if ([NavUtil getNoEmptyString:color]){
            rgbColor = [UIColor colorWithHexString:color];
        }
        if (rgbColor == nil){
            rgbColor = [UIColor blackColor];
        }
        float fontSize = size;
        NSDictionary *dic = @{
            NSForegroundColorAttributeName:rgbColor,
            NSFontAttributeName:[UIFont systemFontOfSize:fontSize],
        };
        [topVC.navigationController.navigationBar setTitleTextAttributes:dic];
    }
}

- (void)isHiddenNavbar:(BOOL)isHidden{
    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
    [topVC.navigationController setNavigationBarHidden:isHidden animated:YES];
}

- (void)setBarItems:(NSArray<NavBtnDTO *> *)dtoNavBarAry withIsRight:(BOOL)isRight withEvent:(NSString *)event withBeginIndex:(NSUInteger)index{
    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
    NSMutableArray *barAry = [@[] mutableCopy];
    
    if(dtoNavBarAry.count > 0) {
        
        __weak __xengine__module_NavigationModule *weakSelf = self;
        int tag = 0;
        for (NavBtnDTO *item in dtoNavBarAry) {
            NSString *title = item.title;
            NSString *icon = item.icon;
            NSString *titleColor = item.titleColor;
            NSString *itemEvent = item.__event__;
            NSArray *iconSizeArray = item.iconSize;
            CGSize iconSize = [NavUtil getIconSize:iconSizeArray];
            
            if (![NavUtil getNoEmptyString:title] && ![NavUtil getNoEmptyString:icon]){
                [self showErrorAlert:@"title或icon"];
                continue;;
            }
            UIBlockButton *itemButton = [UIBlockButton buttonWithType:UIButtonTypeCustom];
            UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
            
            itemButton.tag = BAR_BTN_FLAG + tag + index;
            
            itemButton.frame = CGRectMake(0, 0, iconSize.width, iconSize.height);
            itemButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            [itemButton handleControlEvent:UIControlEventTouchUpInside withBlock:^(UIBlockButton *sender){
                
                if(item.popList && item.popList.count > 0){
                    weakSelf.rightBarItem = btnItem;
                    [weakSelf showRightMenuButtonAction:item.popList withMenuWidth:item.popWidth withEvent:item.__event__];
                } else {
                    NSString *eventName = nil;
                    if ([NavUtil getNoEmptyString:itemEvent]){
                        eventName = itemEvent;
                    } else if ([NavUtil getNoEmptyString:event]){
                        eventName = event;
                    }
                    if (eventName){
                        if ( [topVC isKindOfClass:[RecyleWebViewController class]] ){
                            
                            RecyleWebViewController *webVC = (RecyleWebViewController *)topVC;
                            [webVC.webview callHandler:eventName arguments:@[@(tag + index)] completionHandler:nil];
                        }
                    }
                }
            }];
            if ([NavUtil getNoEmptyString:title]){
                [itemButton setTitle:title forState:UIControlStateNormal];
            }
            //            else {
            if ([NavUtil getNoEmptyString:icon]) {
                UIImage * image = [NavUtil getOrignalImage:icon];
                [itemButton setImage:[NavUtil setImageSize:iconSize image:image] forState:UIControlStateNormal];
            }
            //            }
            
            [itemButton sizeToFit];
            if ([NavUtil getNoEmptyString:titleColor]){
                [itemButton setTitleColor:[UIColor colorWithHexString:titleColor] forState:UIControlStateNormal];
            } else {
                [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            itemButton.titleLabel.font = [UIFont systemFontOfSize:item.titleSize];
            [barAry addObject:btnItem];
            tag += 1;
        }
    }
    if (isRight){
        topVC.navigationItem.rightBarButtonItems = barAry;
    } else {
        topVC.navigationItem.leftBarButtonItems = barAry;
    }
}

- (void)_navigatorRouter:(NavOpenAppDTO *)dto complete:(void (^)(BOOL))completionHandler {
    
    switch ([dto.type intValue]) {
        case 0:{
            //http
            [[XEOneWebViewControllerManage sharedInstance] pushWebViewControllerWithUrl:dto.uri];
            break;
        }
        case 1:{
            //appid
            long version;
            NSString *urlStr = [[MicroAppLoader sharedInstance] locateMicroAppByMicroappId:dto.uri out_version:&version];
//            [[XEOneWebViewControllerManage sharedInstance] pushViewControllerWithUrl:urlStr withParams:nil];
            [[XEOneWebViewControllerManage sharedInstance] pushWebViewControllerWithUrl:urlStr];
            break;
        }
        case 2:
            //uni
            break;
        case 3:{
            //wx
//            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
//            launchMiniProgramReq.userName = dto.uri;  //拉起的小程序的username
//            launchMiniProgramReq.path = dto.path;    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
//            launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
//            [WXApi sendReq:launchMiniProgramReq];
            break;
        }
        case 4:{
            //navtie
            NSArray *ary = [dto.uri componentsSeparatedByString:@","];
            for (NSString *item in ary){
                if([item hasSuffix:@"Controller"]){
                    UIViewController *vc = [[NSClassFromString(item) alloc] init];
                    [[Unity sharedInstance].getCurrentVC.navigationController pushViewController:vc animated:YES];
                }
            }
            break;
        }
        default:
            break;
    }
}



@end

