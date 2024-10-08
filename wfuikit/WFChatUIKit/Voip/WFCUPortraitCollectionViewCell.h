//
//  WFCUPortraitCollectionViewCell.h
//  WFChatUIKit
//
//  Created by dali on 2020/1/20.
//  Copyright © 2020 WildFireChat. All rights reserved.
//
#if WFCU_SUPPORT_VOIP
#import <UIKit/UIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import <WFAVEngineKit/WFAVEngineKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFCUPortraitCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)WFCCUserInfo *userInfo;
@property (nonatomic, strong)WFAVParticipantProfile *profile;

@property (nonatomic, assign)CGFloat itemSize;
@end

NS_ASSUME_NONNULL_END
#endif
