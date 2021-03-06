//
//  xengine__module_camera.m
//  camera
//
//  Created by zk on 2020/9/7.
//  Copyright © 2020 edz. All rights reserved.


#import "__xengine__module_camera.h"
#import <XEngineContext.h>
#import <x-engine-module-engine/micros.h>
#import <x-engine-module-tools/UIViewController+.h>
#import <x-engine-module-tools/JSONToDictionary.h>
#import <Unity.h>
#import <x-engine-module-engine/XEngineWebView.h>
#import <GCDWebServer.h>
#import <GCDWebServerDataResponse.h>
#import <GCDWebServerURLEncodedFormRequest.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <MircroAppController.h>

@interface __xengine__module_camera()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) GCDWebServer *webServer;
@property(nonatomic,assign) BOOL allowsEditing;
@property(nonatomic,assign) BOOL savePhotosAlbum;
@property(nonatomic,strong) UIImage * photoImage;
@property(nonatomic,copy)NSString * event;
@end

@implementation __xengine__module_camera

- (void)_openImagePicker:(CameraDTO *)dto complete:(void (^)(RetDTO *, BOOL))completionHandler {
    self.allowsEditing = dto.allowsEditing;
    self.savePhotosAlbum = dto.savePhotosAlbum;
    self.event = dto.__event__;
    __weak typeof(self) weakself = self;
    NSMutableArray *actionHandlers = [NSMutableArray array];
    ActionHandler cameraHandler = ^(UIAlertAction * _Nonnull action){
        [AVCaptureDevice requestAccessForMediaType:
         AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
         if (granted) {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakself chooseCamera:dto];
             });
         }
         else{
             dispatch_async(dispatch_get_main_queue(), ^{
                 [weakself showPhotoOrCameraWarnAlert:@"请在iPhone的“设置-隐私”选项中允许问你的相机"];
             });
            }
        }];
    };
    ActionHandler photoHandler = ^(UIAlertAction * _Nonnull action){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized){
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself choosePhotos:dto];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showPhotoOrCameraWarnAlert:@"请在iPhone的“设置-隐私”选项中允许访问你的相册"];
            });
        }
        }];
    };
    [actionHandlers addObject:cameraHandler];
    [actionHandlers addObject:photoHandler];
    [[Unity sharedInstance].getCurrentVC showActionSheetWithTitle:@"" message:@"提示" cancelTitle:@"取消" sureTitles:@[@"拍照",@"相册"] cancelHandler:^(UIAlertAction * _Nonnull action) {

    } sureHandlers:actionHandlers];
}
//- (void)_openImagePicker:(SheetDTO *)dto complete:(void (^)(MoreDTO *, BOOL))completionHandler {
////    NSLog(@"%@",dto);
//
//}

-(void)chooseCamera:(CameraDTO*)dto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.delegate = self;
        if(dto.allowsEditing){
            imagePickerController.allowsEditing = YES;
        }
        imagePickerController.sourceType = 1;
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {//ipad没有闪光灯
            imagePickerController.cameraFlashMode = dto.cameraFlashMode;
        }
        if([dto.cameraDevice isEqualToString:@"front"]) imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
        [topVC.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)choosePhotos:(CameraDTO*)dto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.delegate = self;
        if(dto.allowsEditing){
            imagePickerController.allowsEditing = YES;
        }
        imagePickerController.sourceType = 0;
        UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
        [topVC.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)image:(UIImage * )image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存失败");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak typeof(self) weakself = self;
    if(self.webServer){
        [self.webServer stop];
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if(weakself.allowsEditing){
            weakself.photoImage = [info objectForKey:UIImagePickerControllerEditedImage];
        }else{
            weakself.photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        if(weakself.savePhotosAlbum){
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImageWriteToSavedPhotosAlbum(weakself.photoImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showPhotoOrCameraWarnAlert:@"请在iPhone的“设置-隐私”选项中允许访问你的相册"];
                    });
                }
            }];
        }
         
        weakself.webServer = [[GCDWebServer alloc] init];
        [self startServer];
       
        NSString* photoAppendStr = [NSString stringWithFormat:@"pic_%@.png",[weakself getDateFormatterString]];
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:photoAppendStr];
        if(filePath && filePath.length>0) [UIImagePNGRepresentation(weakself.photoImage) writeToFile:filePath atomically:YES];
        
        UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
        if ([topVC isKindOfClass:RecyleWebViewController.class]) {
            RecyleWebViewController *webVC = (RecyleWebViewController *)topVC;
            RetDTO* d = [RetDTO new];
            d.imageUrl=[NSString stringWithFormat:@"%@Documents/%@",@"http://127.0.0.1:18129/",photoAppendStr];
            [webVC.webview callHandler:self.event arguments:@[d.imageUrl,d.imageUrl] completionHandler:^(id  _Nullable value) {}];
        }
    }];
}

- (void)startServer {
    __weak typeof(self) weakself = self;
    [_webServer addHandlerForMethod:@"GET" pathRegex:@"^/.*" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
        NSDictionary * requestData = [[NSDictionary alloc]initWithDictionary:request.query];
        UIImage *image = weakself.photoImage;
        NSData *imageData;
        CGFloat width_height_per = image.size.width/image.size.height;
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        if (requestData.count) {
            NSString * w = [NSString stringWithFormat:@"%@",requestData[@"w"]];
            NSString * h = [NSString stringWithFormat:@"%@",requestData[@"h"]];
            if ([weakself getNoEmptyString:w])  width = w.floatValue;
            if ([weakself getNoEmptyString:h])  height = h.floatValue;
            if (![weakself getNoEmptyString:w]) width = height*width_height_per;
            if (![weakself getNoEmptyString:h]) height = width/width_height_per;
            image= [__xengine__module_camera imageWithImageSimple:image scaledToSize:CGSizeMake(width, height)];

            NSString * quality = [NSString stringWithFormat:@"%@",requestData[@"q"]];
            NSString * bytes = [NSString stringWithFormat:@"%@",requestData[@"bytes"]];
            imageData = [weakself compressOriginalImage:image toMaxDataSizeKBytes:bytes withQuality:quality];
            image = [UIImage imageWithData:imageData];
        }else{
            imageData = UIImageJPEGRepresentation(image, 1);
        }
        
        return [GCDWebServerDataResponse responseWithData:imageData contentType:@"image"];
    }];
   
    [_webServer startWithPort:18129 bonjourName:@"GCD Web Server"];
    
}

-(void)showPhotoOrCameraWarnAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
            //设备系统为IOS 10.0或者以上的
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }]];
    UIViewController *topVC = [Unity sharedInstance].getCurrentVC;
    [topVC.navigationController presentViewController:alert animated:true completion:nil];
}

//图片裁剪
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//压缩图片
-(NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(NSString*)size withQuality:(NSString *)q{
    CGFloat compression ;
    if ([self getNoEmptyString:q]) {
        compression = q.floatValue;
    }else{
        compression = 1;
    }
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if ([self getNoEmptyString:size]) {
        if (data.length/1024 < size.floatValue) return data;
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            data = UIImageJPEGRepresentation(image, compression);
            if (data.length/1024 < size.floatValue * 0.9) {
                min = compression;
            } else if (data.length/1024 > size.floatValue) {
                max = compression;
            } else {
                break;
            }
        }
        UIImage *resultImage = [UIImage imageWithData:data];
        if (data.length/1024 < size.floatValue) return data;
        
        NSUInteger lastDataLength = 0;
        while (data.length/1024 > size.floatValue && data.length/1024 != lastDataLength) {
            lastDataLength = data.length /1024;
            CGFloat ratio = (CGFloat)size.floatValue / data.length/1024;
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
        }
    }
    
    return data;
}

//判断字符串
-(BOOL)getNoEmptyString:(NSString *)sting{
    if (sting != nil & sting != NULL & ![sting isEqualToString:@"(null)"] & ![sting isEqualToString:@"null"] &![sting isEqualToString:@""] & ![sting isKindOfClass:[NSNull class]]){
        return YES;
    }
    return NO;
}

-(NSString * )getDateFormatterString{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmssSS"];
    return [dateFormatter stringFromDate:currentDate];
}

@end
 


