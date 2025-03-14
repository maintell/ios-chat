//
//  ConversationSettingMemberCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/11/3.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUConversationSettingMemberCell.h"
#import <SDWebImage/SDWebImage.h>
#import <WFChatClient/WFCChatClient.h>
#import "WFCUConfigManager.h"
#import "UIFont+YH.h"
#import "UIColor+YH.h"
#import "WFCUImage.h"

@interface WFCUConversationSettingMemberCell ()
@property(nonatomic, strong) NSObject *model;
@end

@implementation WFCUConversationSettingMemberCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headerImageView.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4);
    self.nameLabel.frame = CGRectMake(0, self.frame.size.width + 3, self.frame.size.width, 11);
    self.domainLabel.frame = CGRectMake(0, self.frame.size.width + 3 + 14, self.frame.size.width, 11);
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [WFCUConfigManager globalManager].textColor;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:11];
        [[self contentView] addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)domainLabel {
    if (!_domainLabel) {
        _domainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _domainLabel.textColor = [WFCUConfigManager globalManager].textColor;
        _domainLabel.textAlignment = NSTextAlignmentCenter;
        _domainLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:11];
        [[self contentView] addSubview:_domainLabel];
    }
    return _domainLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerImageView.autoresizingMask =
        UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.clipsToBounds = YES;
        
        _headerImageView.layer.borderWidth = 1;
        _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headerImageView.layer.cornerRadius = 8;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.backgroundColor = [UIColor clearColor];
        _headerImageView.layer.edgeAntialiasingMask =
        kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge |
        kCALayerTopEdge;
        [[self contentView] addSubview:_headerImageView];
    }
    return _headerImageView;
}

- (void)setModel:(NSObject *)model withType:(WFCCConversationType)type {
    self.contentView.backgroundColor = [WFCUConfigManager globalManager].backgroudColor;
    self.model = model;
    
    WFCCUserInfo *userInfo;
    WFCCGroupMember *groupMember;
    WFCCChannelInfo *channelInfo;
    NSString *domainId = nil;
    if (type == Group_Type) {
        groupMember = (WFCCGroupMember *)model;
        userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:groupMember.memberId inGroup:groupMember.groupId refresh:NO];
        if([WFCCUtilities isExternalTarget:groupMember.memberId]) {
            domainId = [WFCCUtilities getExternalDomain:groupMember.memberId];
        }
    } else if(type == Single_Type) {
        userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:(NSString *)model refresh:NO];
        if([WFCCUtilities isExternalTarget:(NSString *)model]) {
            domainId = [WFCCUtilities getExternalDomain:(NSString *)model];
        }
    } else if(type == Channel_Type) {
        channelInfo = [[WFCCIMService sharedWFCIMService] getChannelInfo:(NSString *)model refresh:NO];
        if([WFCCUtilities isExternalTarget:(NSString *)model]) {
            domainId = [WFCCUtilities getExternalDomain:(NSString *)model];
        }
    } else if(type == SecretChat_Type) {
        NSString *userId = [[WFCCIMService sharedWFCIMService] getSecretChatInfo:(NSString *)model].userId;
        userInfo = [[WFCCIMService sharedWFCIMService] getUserInfo:userId refresh:NO];
    } else {
        return;
    }
    
    if (type == Channel_Type) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[channelInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[WFCUImage imageNamed:@"PersonalChat"]];
        self.nameLabel.text = channelInfo.name;
    } else {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[userInfo.portrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[WFCUImage imageNamed:@"PersonalChat"]];
        
        if (userInfo.friendAlias.length) {
            self.nameLabel.text = userInfo.friendAlias;
        } else if(userInfo.groupAlias.length) {
            self.nameLabel.text = userInfo.groupAlias;
        } else if(userInfo.displayName.length) {
            self.nameLabel.text = userInfo.displayName;
        } else {
            self.nameLabel.text = nil;
        }
    }
    self.nameLabel.hidden = NO;
    if(domainId) {
        self.domainLabel.hidden = NO;
        self.domainLabel.attributedText = [WFCCUtilities getExternal:domainId withName:nil withColor:[WFCUConfigManager globalManager].externalNameColor withSize:10];
    } else {
        self.domainLabel.hidden = YES;
    }
}

- (void)resetLayout:(CGFloat)nameLabelHeight
       insideMargin:(CGFloat)insideMargin {
}
@end
