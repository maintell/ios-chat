//
//  WFCCPCLoginRequestMessageContent.m
//  WFChatClient
//
//  Created by heavyrain on 2017/9/19.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCCPCLoginRequestMessageContent.h"

#import "WFCCNetworkService.h"
#import "Common.h"
#import "WFCCDictionary.h"

@implementation WFCCPCLoginRequestMessageContent
- (WFCCMessagePayload *)encode {
    WFCCMessagePayload *payload = [super encode];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.sessionId) {
        [dataDict setObject:self.sessionId forKey:@"t"];
    }
    if (self.platform) {
        [dataDict setObject:@(self.platform) forKey:@"p"];
    }
    
    
    payload.binaryContent = [NSJSONSerialization dataWithJSONObject:dataDict
                                                                           options:kNilOptions
                                                                             error:nil];
    
    return payload;
}

- (void)decode:(WFCCMessagePayload *)payload {
    [super decode:payload];
    NSError *__error = nil;
    WFCCDictionary *dictionary = [WFCCDictionary fromData:payload.binaryContent error:&__error];
    if (!__error) {
        self.sessionId = dictionary[@"t"];
        self.platform = [dictionary[@"p"] intValue];
    }
}

+ (int)getContentType {
    return MESSAGE_PC_LOGIN_REQUSET;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_NOT_PERSIST;
}

+ (void)load {
    [[WFCCIMService sharedWFCIMService] registerMessageContent:self];
}

- (NSString *)digest:(WFCCMessage *)message {
    return nil;
}
@end
