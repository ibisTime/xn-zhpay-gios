//
//  CDVoicePlayer.m
//  ZHBGift
//
//  Created by  tianlei on 2017/6/26.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "CDVoicePlayer.h"
#import "AppConfig.h"
#define CAN_PLAY_VOICE_KEY @"CAN_PLAY_VOICE_KEY_CD"
#define LAST_PLAY_MSG_CODE @"LAST_PLAY_MSG_CODE_CD"


@interface CDVoicePlayer ()


@end

@implementation CDVoicePlayer

- (AVSpeechSynthesizer *)speechSynthesizer {

    if (!_speechSynthesizer) {
        
        _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    }
    
    return _speechSynthesizer;

}

+ (instancetype)player {

    static CDVoicePlayer *player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        player = [[CDVoicePlayer alloc] init];
        player.canPlay = YES;
    });
    
    return player;

}

- (BOOL)needPlayMsgWithCode:(NSString *)code {

    if ([AppConfig config].runEnv == RunEnvDev) {
        
        return YES;

    }
    
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:LAST_PLAY_MSG_CODE];
    if (!value ) {
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:LAST_PLAY_MSG_CODE];
        return YES;
    }
    
    if (!code) {
        return NO;
    }
    
    if ([value isEqualToString:code]) {
        
        return NO;
        
    } else {
    
        [[NSUserDefaults standardUserDefaults] setObject:code forKey:LAST_PLAY_MSG_CODE];
        return YES;
    }
    
    
    
}



- (void)voice{

 

}

- (void)setCanPlay:(BOOL)canPlay {

    [[NSUserDefaults standardUserDefaults] setObject:@(canPlay) forKey:CAN_PLAY_VOICE_KEY];

}

- (BOOL)canPlay {

    
   id value = [[NSUserDefaults standardUserDefaults] objectForKey:CAN_PLAY_VOICE_KEY];
    if (!value) {
        return YES;
    }
    
    return [value boolValue];

}

- (void)playMsg:(NSString *)msg {

    if (!self.canPlay) {
        return;
    }
    
    //
    AVSpeechUtterance *utterance1 = [AVSpeechUtterance speechUtteranceWithString:msg];
    
    if (!self.speechSynthesizer.speaking) {
        
        [self.speechSynthesizer speakUtterance:utterance1];

    }
    //
}

@end
