//
//  MessageModel.h
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/1.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFChatClient/WFCChatClient.h>

@interface WFCUMessageModel : NSObject
+ (instancetype)modelOf:(WFCCMessage *)message showName:(BOOL)showName showTime:(BOOL)showTime;
@property (nonatomic, assign)BOOL showTimeLabel;
@property (nonatomic, assign)BOOL showNameLabel;
@property (nonatomic, strong)WFCCMessage *message;
@property (nonatomic, strong)WFCCMessage *quotedMessage;
@property (nonatomic, assign)BOOL mediaDownloading;
@property (nonatomic, assign)int mediaDownloadProgress;
@property (nonatomic, assign)BOOL voicePlaying;
@property (nonatomic, assign)BOOL highlighted;

@property (nonatomic, assign)BOOL lastReadMessage;

@property (nonatomic, strong)NSMutableDictionary<NSString *, NSNumber *> *deliveryDict;
@property (nonatomic, strong)NSMutableDictionary<NSString *, NSNumber *> *readDict;

@property (nonatomic, assign)float deliveryRate;
@property (nonatomic, assign)float readRate;

@property (nonatomic, assign)float selecting;

@property (nonatomic, assign)float selected;

//可以用来翻译或者语音转文字
@property (nonatomic, assign)BOOL translating;
@property (nonatomic, strong)NSString *translateText;
- (void)loadQuotedMessage;
@end
