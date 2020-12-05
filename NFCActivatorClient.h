#import <RocketBootstrap/rocketbootstrap.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import "Headers/NFBackgroundTagReadingManager.h"
#import "Headers/NFTag.h"

@interface NFCActivatorClient : NSObject{
    CPDistributedMessagingCenter * _messagingCenter;
}
+(id)sharedInstance;
-(void)manager:(NFBackgroundTagReadingManager *)tagReadingManager nfcActivatorDetectedTags:(NSMutableArray <NSObject<NFTag> *> *)tags;
@end
