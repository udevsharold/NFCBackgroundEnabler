#import "NFCActivatorClient.h"
#import "NSData+Conversion.h"
#import "Headers/NFCNDEFMessage.h"
#import "Headers/NFCNDEFPayload.h"
#import "Headers/NFTagInternal.h"
#import "NFCActivatorClient.h"

@implementation NFCActivatorClient

+(void)load{
    [self sharedInstance];
}

+(id)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t token = 0;
    dispatch_once(&token, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

-(instancetype)init{
    if ((self = [super init])){
        _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.haotestlabs.nfcactivator.center"];
        rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);
    }
    return self;
}

-(void)manager:(NFBackgroundTagReadingManager *)tagReadingManager nfcActivatorDetectedTags:(NSMutableArray <NSObject<NFTag> *> *)tags{
    
    NSMutableArray *compiledData = [[NSMutableArray alloc] init];
    for (NFTagInternal *tag in tags) {
        NSString *uid = [tag.tagID hexadecimalString];
        HBLogDebug(@"uid");
        
        NSMutableArray *records = [[NSMutableArray alloc] init];
        [tagReadingManager _readNDEFFromTag:tag];
        id messageInternal = [tagReadingManager _readNDEFFromTag:tag];
        NFCNDEFMessage *ndefMessage = [[NFCNDEFMessage alloc] initWithNFNdefMessage: messageInternal];

        for(NFCNDEFPayload *payload in ndefMessage.records) {
            HBLogDebug(@"payload");
            
            NSString *payloadData = [[NSString alloc] initWithData:payload.payload encoding:NSUTF8StringEncoding];
            NSString *type = [[NSString alloc] initWithData:payload.type encoding:NSUTF8StringEncoding];
            [records addObject:@{@"payload" : payloadData, @"type" : type}];
        }
        [compiledData addObject:@{@"uid" : uid, @"records" : [records copy]}];
    }
    [self sendDetectedTags:@{@"data" : [compiledData copy]}];
}

-(void)sendDetectedTags:(NSDictionary *)data{
    [_messagingCenter sendMessageAndReceiveReplyName:@"nfcActivatorDetectedTags" userInfo:data];
}

@end
