//
//  TextCell.m
//  WFChat UIKit
//
//  Created by WF Chat on 2017/9/1.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#import "WFCUTextCell.h"
#import <WFChatClient/WFCChatClient.h>
#import "WFCUUtilities.h"
#import "AttributedLabel.h"
#import "WFCUConfigManager.h"

#define TEXT_LABEL_TOP_PADDING 3
#define TEXT_LABEL_BUTTOM_PADDING 5

@interface WFCUTextCell () <AttributedLabelDelegate>

@end

@implementation WFCUTextCell
+ (UIFont *)defaultFont {
//    return [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    return [UIFont systemFontOfSize:18];
}

+ (CGSize)sizeForClientArea:(WFCUMessageModel *)msgModel withViewWidth:(CGFloat)width {
    NSDictionary *dict = [[WFCUConfigManager globalManager].cellSizeMap objectForKey:@(msgModel.message.messageId)];
    if (dict && ceil([dict[@"viewWidth"] floatValue]) == ceil(width)) {
        float width = [dict[@"width"] floatValue];
        float height = [dict[@"height"] floatValue];
        return CGSizeMake(width, height);
    }
    
  WFCCTextMessageContent *txtContent = (WFCCTextMessageContent *)msgModel.message.content;
    CGSize size = [WFCUUtilities getTextDrawingSize:txtContent.text font:[WFCUTextCell defaultFont] constrainedSize:CGSizeMake(width, 8000)];
    size.height += TEXT_LABEL_TOP_PADDING + TEXT_LABEL_BUTTOM_PADDING;
    if (size.width < 40) {
        size.width += 4;
        if (size.width > 40) {
            size.width = 40;
        } else if (size.width < 24) {
            size.width = 24;
        }
    }
    
    [[WFCUConfigManager globalManager].cellSizeMap setObject:@{@"viewWidth":@(width), @"width":@(size.width), @"height":@(size.height)} forKey:@(msgModel.message.messageId)];
  return size;
}

- (void)setModel:(WFCUMessageModel *)model {
  [super setModel:model];
    
  WFCCTextMessageContent *txtContent = (WFCCTextMessageContent *)model.message.content;
    CGRect frame = self.contentArea.bounds;
  self.textLabel.frame = CGRectMake(0, TEXT_LABEL_TOP_PADDING, frame.size.width, frame.size.height - TEXT_LABEL_TOP_PADDING - TEXT_LABEL_BUTTOM_PADDING);
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    [self.textLabel setText:txtContent.text];
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[AttributedLabel alloc] init];
        ((AttributedLabel*)_textLabel).attributedLabelDelegate = self;
        _textLabel.numberOfLines = 0;
        _textLabel.font = [WFCUTextCell defaultFont];
        _textLabel.userInteractionEnabled = YES;
        [self.contentArea addSubview:_textLabel];
    }
    return _textLabel;
}

#pragma mark - AttributedLabelDelegate
- (void)didSelectUrl:(NSString *)urlString {
    [self.delegate didSelectUrl:self withModel:self.model withUrl:urlString];
}
- (void)didSelectPhoneNumber:(NSString *)phoneNumberString {
    [self.delegate didSelectPhoneNumber:self withModel:self.model withPhoneNumber:phoneNumberString];
}
@end
