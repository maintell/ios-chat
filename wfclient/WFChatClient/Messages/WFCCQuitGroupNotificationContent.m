//
//  WFCCQuitGroupNotificationContent.m
//  WFChatClient
//
//  Created by heavyrain on 2017/9/20.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCCQuitGroupNotificationContent.h"
#import "WFCCIMService.h"
#import "WFCCNetworkService.h"
#import "Common.h"
#import "WFCCDictionary.h"

@implementation WFCCQuitGroupNotificationContent
- (WFCCMessagePayload *)encode {
    WFCCMessagePayload *payload = [super encode];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    if (self.quitMember) {
        [dataDict setObject:self.quitMember forKey:@"o"];
    }
    
    if (self.groupId) {
        [dataDict setObject:self.groupId forKey:@"g"];
    }
    
    if(self.keepMessage) {
        [dataDict setObject:@"1" forKey:@"n"];
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
        self.quitMember = dictionary[@"o"];
        self.groupId = dictionary[@"g"];
        self.keepMessage = [@"1" isEqualToString:dictionary[@"n"]];
    }
}

+ (int)getContentType {
    return MESSAGE_CONTENT_TYPE_QUIT_GROUP;
}

+ (int)getContentFlags {
    return WFCCPersistFlag_PERSIST;
}



+ (void)load {
    [[WFCCIMService sharedWFCIMService] registerMessageContent:self];
}

- (NSString *)digest:(WFCCMessage *)message {
    return [self formatNotification:message];
}

- (NSString *)formatNotification:(WFCCMessage *)message {
    NSString *formatMsg;
    if ([[WFCCNetworkService sharedInstance].userId isEqualToString:self.quitMember]) {
        formatMsg = @"你退出了群聊";
    } else {
        WFCCUserInfo *userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:self.quitMember inGroup:self.groupId refresh:NO];
        if (userInfo) {
            formatMsg = [NSString stringWithFormat:@"%@退出了群聊", userInfo.readableName];
        } else {
            formatMsg = [NSString stringWithFormat:@"用户<%@>退出了群聊", self.quitMember];
        }
    }
    
    return formatMsg;
}
@end
