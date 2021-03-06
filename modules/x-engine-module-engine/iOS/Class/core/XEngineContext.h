//
//  XEngineContext.h


#import <Foundation/Foundation.h>
@interface XEngineContext : NSObject
 
+ (instancetype)sharedInstance;

- (NSMutableArray*) modules;
- (id) getModuleByProtocol:(Protocol *) proto;
- (NSMutableArray*) getModulesByProtocol:(Protocol *) proto;
- (void) onApplicationDelegate:(NSString*) eventName arg1:(id)application args:(id) args;
- (void) start;

@end

