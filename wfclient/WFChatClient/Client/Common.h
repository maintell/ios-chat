//
//  Common.h
//  WFChatClient
//
//  Created by heavyrain on 2017/11/8.
//  Copyright © 2017年 WildFireChat. All rights reserved.
//

#ifndef Common_h
#define Common_h


/*
 * 说明：1000以下为系统保留类型，自定义消息请使用1000以上数值。
 * 系统消息类型中100以下为常用基本类型消息。100-199位群组消息类型。400-499为VoIP消息类型.
 */
//基本消息类型
//未知类型的消息
#define MESSAGE_CONTENT_TYPE_UNKNOWN 0
//文本消息
#define MESSAGE_CONTENT_TYPE_TEXT 1
//语音消息
#define MESSAGE_CONTENT_TYPE_SOUND 2
//图片消息
#define MESSAGE_CONTENT_TYPE_IMAGE 3
//位置消息
#define MESSAGE_CONTENT_TYPE_LOCATION 4
//文件消息
#define MESSAGE_CONTENT_TYPE_FILE 5
//视频消息
#define MESSAGE_CONTENT_TYPE_VIDEO 6
//动态表情消息
#define MESSAGE_CONTENT_TYPE_STICKER 7
//链接消息
#define MESSAGE_CONTENT_TYPE_LINK 8
//存储不计数文本消息
#define MESSAGE_CONTENT_TYPE_P_TEXT 9
//名片消息
#define MESSAGE_CONTENT_TYPE_CARD 10
//组合消息
#define MESSAGE_CONTENT_TYPE_COMPOSITE_MESSAGE 11
//富通知消息
#define MESSAGE_CONTENT_TYPE_RICH_NOTIFICATION 12
//文章消息
#define MESSAGE_CONTENT_TYPE_ARTICLES 13
//流式文本正在生成消息
#define MESSAGE_CONTENT_TYPE_STREAMING_TEXT_GENERATING 14
//流式文本消息
#define MESSAGE_CONTENT_TYPE_STREAMING_TEXT_GENERATED 15

//消息未能送达消息
#define MESSAGE_CONTENT_NOT_DELIVERED 16

//Dumy1
#define MESSAGE_CONTENT_TYPE_DUMY1 21

//Dumy2
#define MESSAGE_CONTENT_TYPE_DUMY2 22

//Ptt sound
#define MESSAGE_CONTENT_TYPE_PTT_VOICE 23

//Dumy3
#define MESSAGE_CONTENT_TYPE_DUMY3 24

//同步标记未读
#define MESSAGE_CONTENT_TYPE_MARK_UNREAD_SYNC 31

#define MESSAGE_CONTENT_TYPE_CREATE_SECRET_CHAT 40
#define MESSAGE_CONTENT_TYPE_ACCEPT_SECRET_CHAT 41
#define MESSAGE_CONTENT_TYPE_DESTROY_SECRET_CHAT 42
#define MESSAGE_CONTENT_TYPE_SECRET_CHAT_MESSAGE 43
#define MESSAGE_CONTENT_TYPE_BURN_MSG_READED 46
#define MESSAGE_CONTENT_TYPE_BURN_MSG_PLAYED 47

//频道进出消息
#define MESSAGE_CONTENT_TYPE_ENTER_CHANNEL_CHAT 71
#define MESSAGE_CONTENT_TYPE_LEAVE_CHANNEL_CHAT 72
#define MESSAGE_CONTENT_TYPE_CHANNEL_MENU_EVENT 73

//撤回消息
#define MESSAGE_CONTENT_TYPE_RECALL 80
//删除消息，请勿直接发送此消息，此消息是服务器端删除时的同步消息
#define MESSAGE_CONTENT_TYPE_DELETE 81

//提醒消息
#define MESSAGE_CONTENT_TYPE_TIP 90

//正在输入消息
#define MESSAGE_CONTENT_TYPE_TYPING 91

//以上是打招呼的内容
#define MESSAGE_FRIEND_GREETING 92
//您已经添加XXX为好友了，可以愉快地聊天了
#define MESSAGE_FRIEND_ADDED_NOTIFICATION 93

//PC 端请求登录
#define MESSAGE_PC_LOGIN_REQUSET 94



//通知消息类型
//创建群的通知消息
#define MESSAGE_CONTENT_TYPE_CREATE_GROUP 104
//加群的通知消息
#define MESSAGE_CONTENT_TYPE_ADD_GROUP_MEMBER 105
//踢出群成员的通知消息
#define MESSAGE_CONTENT_TYPE_KICKOF_GROUP_MEMBER 106
//退群的通知消息
#define MESSAGE_CONTENT_TYPE_QUIT_GROUP 107
//解散群的通知消息
#define MESSAGE_CONTENT_TYPE_DISMISS_GROUP 108
//转让群主的通知消息
#define MESSAGE_CONTENT_TYPE_TRANSFER_GROUP_OWNER 109
//修改群名称的通知消息
#define MESSAGE_CONTENT_TYPE_CHANGE_GROUP_NAME 110
//修改群昵称的通知消息
#define MESSAGE_CONTENT_TYPE_MODIFY_GROUP_ALIAS 111
//修改群头像的通知消息
#define MESSAGE_CONTENT_TYPE_CHANGE_GROUP_PORTRAIT 112
//修改群全局禁言的通知消息
#define MESSAGE_CONTENT_TYPE_CHANGE_MUTE 113
//修改群加入权限的通知消息
#define MESSAGE_CONTENT_TYPE_CHANGE_JOINTYPE 114
//修改群群成员私聊的通知消息
#define MESSAGE_CONTENT_TYPE_CHANGE_PRIVATECHAT 115
//修改群是否可搜索的通知消息
#define MESSAGE_CONTENT_TYPE_CHANGE_SEARCHABLE 116
//修改群管理的通知消息
#define MESSAGE_CONTENT_TYPE_SET_MANAGER 117
//禁言/取消禁言群成员的通知消息
#define MESSAGE_CONTENT_TYPE_MUTE_MEMBER 118
//允许/取消允许群成员发言的通知消息
#define MESSAGE_CONTENT_TYPE_ALLOW_MEMBER 119

//踢出群成员的可见通知消息
#define MESSAGE_CONTENT_TYPE_KICKOF_GROUP_MEMBER_VISIBLE_NOTIFICATION 120
//退群的可见通知消息
#define MESSAGE_CONTENT_TYPE_QUIT_GROUP_VISIBLE_NOTIFICATION 121
//修改群组Extra通知消息
#define MESSAGE_CONTENT_TYPE_MODIFY_GROUP_EXTRA 122
//修改群组成员Extra通知消息
#define MESSAGE_CONTENT_TYPE_MODIFY_GROUP_MEMBER_EXTRA 123
//修改群组设置通知消息
#define MESSAGE_CONTENT_TYPE_MODIFY_GROUP_SETTINGS 124
//拒绝加入群组消息
#define MESSAGE_CONTENT_TYPE_REJECT_JOIN_GROUP 125

//VoIP开始消息
#define VOIP_CONTENT_TYPE_START 400
//VoIP结束消息
#define VOIP_CONTENT_TYPE_END 402

#define VOIP_CONTENT_TYPE_ACCEPT 401
#define VOIP_CONTENT_TYPE_SIGNAL 403
#define VOIP_CONTENT_TYPE_MODIFY 404
#define VOIP_CONTENT_TYPE_ACCEPT_T 405
#define VOIP_CONTENT_TYPE_ADD_PARTICIPANT 406
#define VOIP_CONTENT_MUTE_VIDEO 407

#define VOIP_CONTENT_CONFERENCE_INVITE 408
#define VOIP_CONTENT_CONFERENCE_CHANGE_MODE 410
#define VOIP_CONTENT_CONFERENCE_KICKOFF_MEMBER 411
#define VOIP_CONTENT_CONFERENCE_COMMAND 412

#define VOIP_CONTENT_MULTI_CALL_ONGOING 416
#define VOIP_CONTENT_JOIN_CALL_REQUEST 417

#define VOIP_CONTENT_PTT_INVITE 420

#define MESSAGE_CONTENT_TYPE_FEED 501
#define MESSAGE_CONTENT_TYPE_COMMENT 502

#define THINGS_CONTENT_TYPE_DATA 601
#define THINGS_CONTENT_TYPE_LOST_EVENT 602



#endif /* Common_h */
