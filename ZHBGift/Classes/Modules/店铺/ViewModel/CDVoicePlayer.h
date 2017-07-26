//
//  CDVoicePlayer.h
//  ZHBGift
//
//  Created by  tianlei on 2017/6/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface CDVoicePlayer : NSObject

+ (instancetype)player;

@property (nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;

- (void)playMsg:(NSString *)msg;



@property (nonatomic, assign) BOOL canPlay;

- (BOOL)needPlayMsgWithCode:(NSString *)code;

@end
