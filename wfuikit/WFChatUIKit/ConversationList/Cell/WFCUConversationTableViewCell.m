//
//  ConversationTableViewCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/8/29.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUConversationTableViewCell.h"
#import "WFCUUtilities.h"
#import <WFChatClient/WFCChatClient.h>
#import <SDWebImage/SDWebImage.h>
#import "WFCUConfigManager.h"
#import "UIColor+YH.h"
#import <UIFont+YH.h>
#import "WFCUImage.h"

@implementation WFCUConversationTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isBig) {
        _potraitView.frame = CGRectMake(16, 10, 40, 40);
        _targetView.frame = CGRectMake(16 + 40 + 20, 11, [UIScreen mainScreen].bounds.size.width - (16 + 40 + 20 + 100), 16);
        _targetView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:15];
        _digestView.frame = CGRectMake(16 + 40 + 20, 11 + 16 + 8, [UIScreen mainScreen].bounds.size.width - (16 + 40 + 20 + 20), 19);
    }

}
- (void)updateUserInfo:(WFCCUserInfo *)userInfo {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoUpdated:) name:kUserInfoUpdated object:nil];
  [self.potraitView sd_setImageWithURL:[NSURL URLWithString:[userInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage: [WFCUImage imageNamed:@"PersonalChat"]];
  
    if (userInfo.friendAlias.length) {
        self.targetView.text = userInfo.friendAlias;
    } else if(userInfo.displayName.length > 0) {
        self.targetView.text = userInfo.displayName;
    } else {
        self.targetView.text = [NSString stringWithFormat:@"user<%@>", self.info.conversation.target];
    }
    [self updateExternalDomainInfo];
}

- (void)updateChannelInfo:(WFCCChannelInfo *)channelInfo {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChannelInfoUpdated:) name:kChannelInfoUpdated object:nil];
    
    [self.potraitView sd_setImageWithURL:[NSURL URLWithString:[channelInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[WFCUImage imageNamed:@"channel_default_portrait"]];
    
    if(channelInfo.name.length > 0) {
        self.targetView.text = channelInfo.name;
    } else {
        self.targetView.text = WFCString(@"Channel");
    }
    [self updateExternalDomainInfo];
}

- (void)updateGroupInfo:(WFCCGroupInfo *)groupInfo {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GroupPortraitChanged" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGroupInfoUpdated:) name:kGroupInfoUpdated object:nil];
    
    if(groupInfo.type == GroupType_Organization) {
        if(groupInfo.portrait.length) {
            [self.potraitView sd_setImageWithURL:[NSURL URLWithString:[groupInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[WFCUImage imageNamed:@"organization_icon"]];
        } else {
            self.potraitView.image = [WFCUImage imageNamed:@"organization_icon"];
        }
    } else {
        if (groupInfo.portrait.length) {
            [self.potraitView sd_setImageWithURL:[NSURL URLWithString:[groupInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[WFCUImage imageNamed:@"group_default_portrait"]];
        } else {
            __weak typeof(self)ws = self;
            NSString *groupId = groupInfo.target;
            
            [[NSNotificationCenter defaultCenter] addObserverForName:@"GroupPortraitChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                NSString *path = [note.userInfo objectForKey:@"path"];
                if ([groupId isEqualToString:note.object] && (
                                                              (ws.info.conversation.type == Group_Type && [ws.info.conversation.target isEqualToString:groupId]) ||
                                                              (ws.searchInfo.conversation.type == Group_Type  && [ws.searchInfo.conversation.target isEqualToString:groupId]))) {
                                                                  [ws.potraitView sd_setImageWithURL:[NSURL fileURLWithPath:path] placeholderImage:[WFCUImage imageNamed:@"group_default_portrait"]];
                                                              }
            }];
            
            NSString *path = [WFCCUtilities getGroupGridPortrait:groupInfo.target width:80 generateIfNotExist:YES defaultUserPortrait:^UIImage *(NSString *userId) {
                return [WFCUImage imageNamed:@"PersonalChat"];
            }];
            
            if (path) {
                [self.potraitView sd_setImageWithURL:[NSURL fileURLWithPath:path] placeholderImage:[WFCUImage imageNamed:@"group_default_portrait"]];
            } else {
                [self.potraitView setImage:[WFCUImage imageNamed:@"group_default_portrait"]];
            }
        }
    }
  
  if(groupInfo.displayName.length > 0) {
    self.targetView.text = groupInfo.displayName;
  } else {
    self.targetView.text = WFCString(@"GroupChat");
  }
  [self updateExternalDomainInfo];
}

- (void)updateExternalDomainInfo {
    if([WFCCUtilities isExternalTarget:self.info.conversation.target]) {
        NSString *domainId = [WFCCUtilities getExternalDomain:self.info.conversation.target];
        self.targetView.attributedText = [WFCCUtilities getExternal:domainId withName:self.targetView.text withColor:[WFCUConfigManager globalManager].externalNameColor withSize:12];
    }
}
- (void)setSearchInfo:(WFCCConversationSearchInfo *)searchInfo {
    _searchInfo = searchInfo;
    self.bubbleView.hidden = YES;
    self.timeView.hidden = YES;
    [self update:searchInfo.conversation];
    if (searchInfo.marchedCount > 1) {
        self.digestView.text = [NSString stringWithFormat:WFCString(@"NumberOfRecords"), searchInfo.marchedCount];
    } else {
        NSString *strContent = searchInfo.marchedMessage.digest;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:strContent];
        NSRange range = [strContent rangeOfString:searchInfo.keyword options:NSCaseInsensitiveSearch];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
        self.digestView.attributedText = attrStr;
    }
}

- (void)setInfo:(WFCCConversationInfo *)info {
    _info = info;
    if (info.unreadCount.unread == 0) {
        self.bubbleView.hidden = YES;
    } else {
        self.bubbleView.hidden = NO;
        if (info.isSilent) {
            self.bubbleView.isShowNotificationNumber = NO;
        } else {
            self.bubbleView.isShowNotificationNumber = YES;
        }
        [self.bubbleView setBubbleTipNumber:info.unreadCount.unread];
    }
    
    if (info.isSilent) {
        self.silentView.hidden = NO;
    } else {
        _silentView.hidden = YES;
    }
  
    [self update:info.conversation];
    self.timeView.hidden = NO;
    self.timeView.text = [WFCUUtilities formatTimeLabel:info.timestamp];
    
    BOOL darkMode = NO;
    if (@available(iOS 13.0, *)) {
        if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            darkMode = YES;
        }
    }
    if (darkMode) {
        if (info.isTop) {
            [self.contentView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.f]];
        } else {
            self.contentView.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
        }
    } else {
        if (info.isTop) {
            [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"0xf7f7f7"]];
        } else {
            self.contentView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if (info.lastMessage && info.lastMessage.direction == MessageDirection_Send) {
        if (info.lastMessage.status == Message_Status_Sending) {
            self.statusView.image = [WFCUImage imageNamed:@"conversation_message_sending"];
            self.statusView.hidden = NO;
        } else if(info.lastMessage.status == Message_Status_Send_Failure) {
            self.statusView.image = [WFCUImage imageNamed:@"MessageSendError"];
            self.statusView.hidden = NO;
        } else {
            self.statusView.hidden = YES;
        }
    } else {
        self.statusView.hidden = YES;
    }
    [self updateDigestFrame:!self.statusView.hidden];
}

- (void)updateDigestFrame:(BOOL)isSending {
    if (isSending) {
        _digestView.frame = CGRectMake(16 + 48 + 12 + 18, 40, [UIScreen mainScreen].bounds.size.width - 76 - 16 - 16 - 18, 19);
    } else {
        _digestView.frame = CGRectMake(16 + 48 + 12, 40, [UIScreen mainScreen].bounds.size.width - 76 - 16 - 16, 19);
    }
}

- (void)update:(WFCCConversation *)conversation {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.targetView.textColor = [WFCUConfigManager globalManager].textColor;
    WFCCGroupInfo *groupInfo;
    if(conversation.type == Single_Type) {
        WFCCUserInfo *userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:conversation.target refresh:NO];
        if(userInfo.userId.length == 0) {
            userInfo = [[WFCCUserInfo alloc] init];
            userInfo.userId = conversation.target;
        }
        [self updateUserInfo:userInfo];
    } else if (conversation.type == Group_Type) {
        groupInfo = [[WFCCIMService sharedWFCIMService] getGroupInfo:conversation.target refresh:NO];
        if(groupInfo.target.length == 0) {
            groupInfo = [[WFCCGroupInfo alloc] init];
            groupInfo.target = conversation.target;
        }
        [self updateGroupInfo:groupInfo];
        
    } else if(conversation.type == Channel_Type) {
        WFCCChannelInfo *channelInfo = [[WFCCIMService sharedWFCIMService] getChannelInfo:conversation.target refresh:NO];
        if (channelInfo.channelId.length == 0) {
            channelInfo = [[WFCCChannelInfo alloc] init];
            channelInfo.channelId = conversation.target;
        }
        [self updateChannelInfo:channelInfo];
    } else if(conversation.type == SecretChat_Type){
        WFCCSecretChatInfo *secretInfo = [[WFCCIMService sharedWFCIMService] getSecretChatInfo:conversation.target];
        NSString *userId = [[WFCCIMService sharedWFCIMService] getSecretChatInfo:conversation.target].userId;
        WFCCUserInfo *userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:userId refresh:NO];
        [self updateUserInfo:userInfo];
    } else {
        self.targetView.text = WFCString(@"Chatroom");
        [self updateExternalDomainInfo];
    }
    
    CGSize size = [WFCUUtilities getTextDrawingSize:self.targetView.text font:self.targetView.font constrainedSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 76  - 68 - 24, 8000)];
    
    if(conversation.type == SecretChat_Type) {
        self.secretChatView.hidden = NO;
        self.targetView.frame = CGRectMake(16 + 48 + 12 + 24, 16, size.width, 20);
    } else {
        self.secretChatView.hidden = YES;
        self.targetView.frame = CGRectMake(16 + 48 + 12, 16, size.width, 20);
    }
    
    if(conversation.type == Group_Type && groupInfo.type == GroupType_Organization) {
        CGRect frame = self.offcialView.frame;
        CGRect targetFrame = self.targetView.frame;
        frame.origin.x = targetFrame.origin.x + targetFrame.size.width + 4;
        frame.origin.y = targetFrame.origin.y;
        self.offcialView.frame = frame;
        self.offcialView.hidden = NO;
    } else {
        _offcialView.hidden = YES;
    }
    
    self.potraitView.layer.cornerRadius = 4.f;
    self.digestView.attributedText = nil;
    
    NSString *secretChatStateText = nil;
    if(conversation.type == SecretChat_Type) {
        WFCCSecretChatState secretChatState = [[WFCCIMService sharedWFCIMService] getSecretChatInfo:conversation.target].state;
        if (secretChatState == SecretChatState_Starting) {
            secretChatStateText = @"密聊会话建立中，正在等待对方响应。";
        } else if(secretChatState == SecretChatState_Canceled) {
            secretChatStateText = @"密聊会话已取消！";
        }
    }
    
    if(secretChatStateText) {
        self.digestView.text = secretChatStateText;
    } else if (_info.draft.length) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:WFCString(@"[Draft]") attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
        
        NSError *__error = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[_info.draft dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:kNilOptions
                                                                     error:&__error];
        
        NSString *text = _info.draft;
        if (!__error) {
            //兼容android/web端
            if([dictionary[@"content"] isKindOfClass:[NSString class]]) {
                text = dictionary[@"content"];
            } else if([dictionary[@"text"] isKindOfClass:[NSString class]]) {
                text = dictionary[@"text"];
            }
        }
        
        [attString appendAttributedString:[[NSAttributedString alloc] initWithString:text]];

        if (_info.conversation.type == Group_Type && _info.unreadCount.unreadMentionAll + _info.unreadCount.unreadMention > 0) {
            NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:WFCString(@"[MentionYou]") attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            [tmp appendAttributedString:attString];
            attString = tmp;
        }
        self.digestView.attributedText = attString;
    } else if (_info.lastMessage.direction == MessageDirection_Receive && _info.conversation.type == Group_Type) {
        NSString *groupId = nil;
        if (_info.conversation.type == Group_Type) {
            groupId = _info.conversation.target;
        }
        WFCCUserInfo *sender = [[WFCCIMService sharedWFCIMService] getUserInfo:_info.lastMessage.fromUser inGroup:groupId refresh:NO];
        if (sender.friendAlias.length && ![_info.lastMessage.content isKindOfClass:[WFCCNotificationMessageContent class]]) {
            self.digestView.text = [NSString stringWithFormat:@"%@:%@", sender.friendAlias, _info.lastMessage.digest];
        } else if (sender.groupAlias.length && ![_info.lastMessage.content isKindOfClass:[WFCCNotificationMessageContent class]]) {
            self.digestView.text = [NSString stringWithFormat:@"%@:%@", sender.groupAlias, _info.lastMessage.digest];
        } else if (sender.displayName.length && ![_info.lastMessage.content isKindOfClass:[WFCCNotificationMessageContent class]]) {
            self.digestView.text = [NSString stringWithFormat:@"%@:%@", sender.displayName, _info.lastMessage.digest];
        } else {
            self.digestView.text = _info.lastMessage.digest;
        }
        
        if (_info.unreadCount.unreadMentionAll + _info.unreadCount.unreadMention > 0) {
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:WFCString(@"[MentionYou]") attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            if (self.digestView.text.length) {
                [attString appendAttributedString:[[NSAttributedString alloc] initWithString:self.digestView.text]];
            }
            
            self.digestView.attributedText = attString;
        }
    } else {
        self.digestView.text = _info.lastMessage.digest;
    }
}

- (void)reloadCell {
    [self setInfo:self.info];
}

- (void)onUserInfoUpdated:(NSNotification *)notification {
    NSArray<WFCCUserInfo *> *userInfoList = notification.userInfo[@"userInfoList"];
    WFCCConversationInfo *conv = self.info;
    
    for (WFCCUserInfo *userInfo in userInfoList) {
        if (conv.conversation.type == Single_Type || conv.conversation.type == SecretChat_Type) {
            if([userInfo.userId isEqualToString:conv.conversation.target]) {
                [self reloadCell];
                break;
            }
        }
     
        if ([conv.lastMessage.fromUser isEqualToString:userInfo.userId]) {
            [self reloadCell];
            break;
        }
    }
}

- (void)onGroupInfoUpdated:(NSNotification *)notification {
    NSArray<WFCCGroupInfo *> *groupInfoList = notification.userInfo[@"groupInfoList"];
    WFCCConversationInfo *conv = self.info;
    if(conv.conversation.type == Group_Type) {
        for (WFCCGroupInfo *groupInfo in groupInfoList) {
            if ([conv.conversation.target isEqualToString:groupInfo.target]) {
                [self reloadCell];
                break;
            }
        }
    }
}

- (void)onChannelInfoUpdated:(NSNotification *)notification {
    NSArray<WFCCChannelInfo *> *channelInfoList = notification.userInfo[@"channelInfoList"];
    WFCCConversationInfo *conv = self.info;
    if(conv.conversation.type == Channel_Type) {
        for (WFCCChannelInfo *channelInfo in channelInfoList) {
            if ([conv.conversation.target isEqualToString:channelInfo.channelId]) {
                [self reloadCell];
                break;
            }
        }
    }
}

- (UIImageView *)potraitView {
    if (!_potraitView) {
        _potraitView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 48, 48)];
        _potraitView.clipsToBounds = YES;
        _potraitView.layer.cornerRadius = 4.f;
        [self.contentView addSubview:_potraitView];
    }
    return _potraitView;
}

- (UIImageView *)statusView {
    if (!_statusView) {
        _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(16 + 48 + 12, 42, 16, 16)];
        _statusView.image = [WFCUImage imageNamed:@"conversation_message_sending"];
        [self.contentView addSubview:_statusView];
    }
    return _statusView;
}

- (UILabel *)targetView {
    if (!_targetView) {
        _targetView = [[UILabel alloc] initWithFrame:CGRectMake(16 + 48 + 12, 16, [UIScreen mainScreen].bounds.size.width - 76  - 68, 20)];
        _targetView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:17];
        _targetView.textColor = [WFCUConfigManager globalManager].textColor;
        _targetView.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:_targetView];
    }
    return _targetView;
}

- (UILabel *)offcialView {
    if(!_offcialView) {
        _offcialView = [[UILabel alloc] initWithFrame:CGRectZero];
        _offcialView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:10];
        _offcialView.layer.cornerRadius = 3;
        _offcialView.layer.masksToBounds = YES;
        _offcialView.textColor = [UIColor whiteColor];
        _offcialView.backgroundColor = [UIColor blueColor];
        _offcialView.textAlignment = NSTextAlignmentCenter;
        _offcialView.text = @"官方";
        CGSize size = [WFCUUtilities getTextDrawingSize:_offcialView.text font:_offcialView.font constrainedSize:CGSizeMake(200, 200)];
        _offcialView.frame = CGRectMake(0, 0, size.width+4, size.height);
        [self.contentView addSubview:_offcialView];
    }
    return _offcialView;
}

- (UIImageView *)secretChatView {
    if(!_secretChatView) {
        _secretChatView = [[UIImageView alloc] initWithFrame:CGRectMake(16 + 48 + 12, 16, 20, 20)];
        _secretChatView.image = [WFCUImage imageNamed:@"secret_chat_icon"];
        [self.contentView addSubview:_secretChatView];
    }
    return _secretChatView;
}
- (UILabel *)digestView {
    if (!_digestView) {
        _digestView = [[UILabel alloc] initWithFrame:CGRectMake(16 + 48 + 12, 42, [UIScreen mainScreen].bounds.size.width - 76  - 16 - 16, 19)];
        _digestView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
        _digestView.lineBreakMode = NSLineBreakByTruncatingTail;
        _digestView.textColor = [UIColor colorWithHexString:@"b3b3b3"];
        [self.contentView addSubview:_digestView];
    }
    return _digestView;
}

- (UIImageView *)silentView {
    if (!_silentView) {
        _silentView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 12  - 20, 45, 12, 12)];
        _silentView.image = [WFCUImage imageNamed:@"conversation_mute"];
        [self.contentView addSubview:_silentView];
    }
    return _silentView;
}

- (UILabel *)timeView {
    if (!_timeView) {
        _timeView = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 52  - 16, 20, 52, 12)];
        _timeView.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:12];
        _timeView.textAlignment = NSTextAlignmentRight;
        _timeView.textColor = [UIColor colorWithHexString:@"b3b3b3"];
        [self.contentView addSubview:_timeView];
    }

    return _timeView;
}

- (BubbleTipView *)bubbleView {
    if (!_bubbleView) {
        if(self.potraitView) {
            _bubbleView = [[BubbleTipView alloc] initWithSuperView:self.contentView];
            _bubbleView.hidden = YES;
        }
    }
    return _bubbleView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
