//
//  PH_movieGuide.m
//  铺皇
//
//  Created by selice on 2017/12/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "PH_movieGuide.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface PH_movieGuide(){
    UIView * movieView;
}
@property (nonatomic, strong) AVPlayer *YJLplayer;

@end

@implementation PH_movieGuide
-(instancetype)initWithFrame:(CGRect)frame{


    self = [super initWithFrame:frame];
    if (self) {

        movieView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
        movieView.backgroundColor = [UIColor whiteColor];
        [self addSubview:movieView];
        self.YJLplayer = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie" ofType:@"mov"]]]];
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.YJLplayer];
        layer.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
        [self.YJLplayer play];
        [self addNotification];
        [movieView.layer addSublayer:layer];
        [self setupLoginView];
    }
    
    return self;
}

-(void)addNotification{
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.YJLplayer.currentItem];
}

-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [self.YJLplayer seekToTime:CMTimeMake(0, 1)];
    [self.YJLplayer play];
}

-(void)removeNotification{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupLoginView
{
    //进入按钮
    UIButton *enterMainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = kTCColor(77, 166, 214).CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    [enterMainButton setTitleColor:kTCColor(77, 166, 214) forState:UIControlStateNormal];
    enterMainButton.alpha = 0;
    [self addSubview:enterMainButton];
    [self bringSubviewToFront:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];

    [UIView animateWithDuration:4.0 animations:^{
        enterMainButton.alpha = 1.0;
    }];
}

- (void)enterMainAction:(UIButton *)btn {

    [self.YJLplayer pause];
    NSLog(@"进入应用");
    self.hidden = YES;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Gifcanshow"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Joinapp" object:self userInfo:nil];
}

@end
