
// DO NOT MODIFY!.
// generated by api_generator.js, it will be overwrite eventually!


#import "xengine__module_container.h"
#import <micros.h>


@implementation XEContainerDTO
    + (BOOL)propertyIsOptional:(NSString *)propertyName {
   
   	return NO;
    }
@end
    




  @implementation xengine__module_container
    - (instancetype)init
    {
        self = [super init];
        return self;
    }

    - (NSString *)moduleId{
        return @"com.zkty.module.container";
    }
    
    - (void) push:(NSDictionary*) dict complete:(XEngineCallBack)completionHandler {

          XEContainerDTO* dto = [self convert:dict clazz:XEContainerDTO.class];
          [self _push:dto complete:^(BOOL complete) {
             completionHandler(nil ,complete);
          }];
      }
  @end