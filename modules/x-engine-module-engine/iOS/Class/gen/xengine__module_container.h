
// DO NOT MODIFY!.
// generated by x-cli, it will be overwrite eventually!


#import <xengine__module_BaseModule.h>
#import "JSONModel.h"

@protocol XEContainerDTO;

@interface XEContainerDTO: JSONModel
  	@property(nonatomic,copy) NSString* microAppId;
   	@property(nonatomic,copy) NSString* routePath;
   	@property(nonatomic,assign) NSInteger direction;
@end
    


@protocol xengine__module_container_protocol
       @required 
        - (void) _push:(XEContainerDTO*) dto complete:(void (^)(BOOL complete)) completionHandler;
    
@end
  


@interface xengine__module_container : xengine__module_BaseModule<xengine__module_container_protocol>
@end

