//
//  MicroAppLoader.m
//  AFNetworking
//
//  Created by zk on 2020/8/27.
//

#import "MicroAppLoader.h"

@interface MicroAppLoader()
    @property (nonatomic, strong) NSMutableDictionary *microappId_versionInSandbox;
@end
@implementation MicroAppLoader

+ (instancetype)sharedInstance{
    static MicroAppLoader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MicroAppLoader alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init {
    self = [super init];
    self.microappId_versionInSandbox = [[NSMutableDictionary alloc] init];
    return self;
}
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

+ (NSString *)microappDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths lastObject] stringByAppendingPathComponent:@"microapps"];
}


- (void) scanMicroAppsInSandBox{
    NSString * sandbox_microapps_location = [MicroAppLoader microappDirectory];
    NSArray* microapps = [MicroAppLoader listFilesInDirectoryAtPath:sandbox_microapps_location deep:false];
    for (NSString* microapp in microapps){
       NSMutableArray* tokens=[[microapp  componentsSeparatedByString:@"."] mutableCopy];
       NSInteger cur_version =  [[tokens lastObject] intValue];
       [tokens removeLastObject];
       NSString* appid = [tokens componentsJoinedByString:@"."];
       NSNumber* old_version = [self.microappId_versionInSandbox objectForKey:appid];
        if(!old_version || (old_version && [old_version integerValue] < cur_version)){
            [self.microappId_versionInSandbox setObject:[NSNumber numberWithLong:cur_version] forKey:appid];
        }
    }
}

- (NSString*) locateMicroAppByMicroappId:(NSString*)microappId out_version:(long*) version{
    [self scanMicroAppsInSandBox];
    NSNumber* v = [self.microappId_versionInSandbox objectForKey:microappId];
    // found in sand box
    if(v)
    {
        *version = [v integerValue];
        NSString * sandbox_microapp_location = [NSString stringWithFormat:@"file://%@/%@.%ld/index.html",[MicroAppLoader microappDirectory],microappId,*version];
        return sandbox_microapp_location;
    }
    // otherwise found in project / NSBundle
    else{
       NSString * htmlPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.%@/index",microappId,@"0"] ofType:@"html"];
       if (htmlPath) {
            *version = 0;
            return [NSString stringWithFormat:@"file://%@", htmlPath];
       }
    }
    *version = -1;
    return nil;
}
 
 
@end
