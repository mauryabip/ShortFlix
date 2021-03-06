//
//  ViewController.m
//  TestAVPlayer
//
//  Created by Mike on 2014-05-07.
//  Copyright (c) 2014 Mike. All rights reserved.
//

#import "KSVideoPlayerView.h"
#import <KeepLayout.h>

@implementation KSVideoPlayerView
{
    id playbackObserver;
    AVPlayerLayer *playerLayer;
    BOOL viewIsShowing;
}

-(id)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem
{
    self = [super initWithFrame:frame];
    if (self) {
        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        [playerLayer setFrame:frame];
        [self.moviePlayer seekToTime:kCMTimeZero];
        [self.layer addSublayer:playerLayer];
        self.contentURL = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
        [self initializePlayer:frame];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL
{
    self = [super initWithFrame:frame];
    if (self) {
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:contentURL];
        self.moviePlayer = [AVPlayer playerWithPlayerItem:playerItem];
        playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.moviePlayer];
        [playerLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.moviePlayer seekToTime:kCMTimeZero];
        [self.layer addSublayer:playerLayer];
        self.contentURL = contentURL;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerFinishedPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        
        [self initializePlayer:frame];
    }
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [playerLayer setFrame:frame];
}

-(void) setupConstraints
{
    
    // bottom HUD view
    self.playerHudBottom.keepHorizontalInsets.equal = KeepRequired(0);
    self.playerHudBottom.keepBottomInset.equal = KeepRequired(0);
    
    // play/pause button
    [self.playPauseButton keepHorizontallyCentered];
    [self.playPauseButton keepVerticallyCentered];
    
    //backButton
    self.backButton.keepRightOffsetTo(self.playPauseButton).equal= KeepRequired(40);
    [self.backButton keepVerticallyCentered];

    
    // nextButton
    self.nextButton.keepLeftOffsetTo(self.playPauseButton).equal = KeepRequired(40);
    [self.nextButton keepVerticallyCentered];

    //doneButton
    self.doneButton.keepLeftInset.equal = KeepRequired(5);
    [self.doneButton keepVerticallyCentered];
    
    
    // current time label
    self.playBackTime.keepLeftOffsetTo(self.doneButton).equal = KeepRequired(15);
    [self.playBackTime keepVerticallyCentered];
    
    
    // progress bar
    self.progressBar.keepLeftOffsetTo(self.playBackTime).equal = KeepRequired(5);
    self.progressBar.keepBottomInset.equal = KeepRequired(0);
    [self.progressBar keepVerticallyCentered];
    
    // total time label
    self.playBackTotalTime.keepLeftOffsetTo(self.progressBar).equal = KeepRequired(5);
    [self.playBackTotalTime keepVerticallyCentered];
    
    // zoom button
//    self.zoomButton.keepRightInset.equal = KeepRequired(5);
//    [self.zoomButton keepVerticallyCentered];
    
    // videoTypeButton
    //self.videoTypeButton.keepLeftOffsetTo(self.playBackTotalTime).equal = KeepRequired(20);
    self.videoTypeButton.keepRightInset.equal = KeepRequired(10);
    [self.videoTypeButton keepVerticallyCentered];
    
    // airplay button
    self.airplayButton.keepRightOffsetTo(self.videoTypeButton).equal = KeepRequired(self.airplayButton.frame.size.width);
    self.airplayButton.keepLeftOffsetTo(self.playBackTotalTime).equal = KeepRequired(20);
    self.airplayButton.keepBottomInset.equal = KeepRequired(6);
    [self.airplayButton keepVerticallyCentered];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(hideController:)
                                   userInfo:nil
                                    repeats:NO];

    
}

-(void)initializePlayer:(CGRect)frame
{
    int frameWidth =  frame.size.width;
    int frameHeight = frame.size.height;
    
    self.backgroundColor = [UIColor blackColor];
    viewIsShowing =  NO;
    
    [self.layer setMasksToBounds:YES];
    
    self.playerHudBottom = [[UIView alloc] init];
    self.playerHudBottom.frame = CGRectMake(0, 0, frameWidth, 25);
    [self.playerHudBottom setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.playerHudBottom];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, frameWidth, 48*frameHeight/160);
    bgView.backgroundColor = [UIColor blackColor];

    // Create the colors for our gradient.
    UIColor *transparent = [UIColor colorWithWhite:1.0f alpha:0.f];
    UIColor *opaque = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // Create a masklayer.
    CALayer *maskLayer = [[CALayer alloc]init];
    maskLayer.frame = bgView.bounds;
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc]init];
    gradientLayer.frame = CGRectMake(0,0,bgView.bounds.size.width, bgView.bounds.size.height);
    gradientLayer.colors = @[(id)transparent.CGColor, (id)transparent.CGColor, (id)opaque.CGColor, (id)opaque.CGColor];
    gradientLayer.locations = @[@0.0f, @0.09f, @0.8f, @1.0f];
    
    // Add the mask.
    [maskLayer addSublayer:gradientLayer];
    bgView.layer.mask = maskLayer;
    
    [self.playerHudBottom addSubview:bgView];
    
    //Play Pause Button
    self.playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.playPauseButton.frame = CGRectMake(5*frameWidth/240, 6*frameHeight/160, 16*frameWidth/240, 16*frameHeight/160);
    [self.playPauseButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playPauseButton setSelected:NO];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"avplayer.bundle/playback_pause"] forState:UIControlStateSelected];
    [self.playPauseButton setBackgroundImage:[UIImage imageNamed:@"avplayer.bundle/playback_play"] forState:UIControlStateNormal];
    [self.playPauseButton setTintColor:[UIColor clearColor]];
    self.playPauseButton.layer.opacity = 0;
    [self addSubview:self.playPauseButton];
    
    //nextButton
    UIImage *imagNext = [UIImage imageNamed:@"avplayer.bundle/playback_ff"];
    self.nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.nextButton.tintColor=[UIColor clearColor];
    self.nextButton.frame = CGRectMake(0,0,imagNext.size.width, imagNext.size.height);
    [self.nextButton setBackgroundImage:imagNext forState:UIControlStateNormal];
    self.nextButton.layer.opacity = 0;
    [self addSubview:self.nextButton];
   
    //backButton
    UIImage *imagback = [UIImage imageNamed:@"avplayer.bundle/playback_prev"];
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.tintColor=[UIColor clearColor];
    self.backButton.frame = CGRectMake(0,0,imagback.size.width, imagback.size.height);
    [self.backButton setBackgroundImage:imagback forState:UIControlStateNormal];
    self.backButton.layer.opacity = 0;
    [self addSubview:self.backButton];

    
    //Seek Time Progress Bar
    self.progressBar = [[UISlider alloc] init];
    self.progressBar.frame = CGRectMake(0, 0, frameWidth, 0);
    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressBar addTarget:self action:@selector(proressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
//    [self.progressBar setThumbImage:[UIImage imageNamed:@"Slider_button"] forState:UIControlStateNormal];
    [self.playerHudBottom addSubview:self.progressBar];

    //Current Time Label
    self.playBackTime = [[UILabel alloc] init];
    [self.playBackTime sizeToFit];
    self.playBackTime.text = [self getStringFromCMTime:self.moviePlayer.currentTime];
  
    [self.playBackTime setTextAlignment:NSTextAlignmentLeft];
    [self.playBackTime setTextColor:[UIColor whiteColor]];
    self.playBackTime.font = [UIFont systemFontOfSize:12];//12*frameWidth/240
    [self.playerHudBottom addSubview:self.playBackTime];
    
    //Total Time label
    self.playBackTotalTime = [[UILabel alloc] init];
    [self.playBackTotalTime sizeToFit];
    self.playBackTotalTime.text = [self getStringFromCMTime:self.moviePlayer.currentItem.asset.duration];
    [self.playBackTotalTime setTextAlignment:NSTextAlignmentRight];
    [self.playBackTotalTime setTextColor:[UIColor whiteColor]];
    self.playBackTotalTime.font = [UIFont systemFontOfSize:12];
    [self.playerHudBottom addSubview:self.playBackTotalTime];
    
    // Airplay button
    self.airplayButton = [ [MPVolumeView alloc] init] ;
    [self.airplayButton setShowsVolumeSlider:NO];
    [self.airplayButton sizeToFit];
    [self.playerHudBottom addSubview:self.airplayButton];
    
    //zoom button
    UIImage *image = [UIImage imageNamed:@"zoomBtn"];
    self.zoomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.zoomButton.tintColor=[UIColor clearColor];
    self.zoomButton.frame = CGRectMake(0,0,image.size.width, image.size.height);
   // [self.zoomButton addTarget:self action:@selector(zoomButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.zoomButton setBackgroundImage:image forState:UIControlStateNormal];
   // [self.playerHudBottom addSubview:self.zoomButton];
    
    //videoTypeButton
    UIImage *imagVideo = [UIImage imageNamed:@"auto-24"];
    self.videoTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.videoTypeButton.tintColor=[UIColor clearColor];
    self.videoTypeButton.frame = CGRectMake(0,0,imagVideo.size.width, imagVideo.size.height);
    [self.videoTypeButton setBackgroundImage:imagVideo forState:UIControlStateNormal];
    [self.playerHudBottom addSubview:self.videoTypeButton];
    
    //doneButton
    self.doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.doneButton.tintColor=[UIColor whiteColor];
    self.doneButton.frame = CGRectMake(0,0,imagVideo.size.width, imagVideo.size.height);
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.playerHudBottom addSubview:self.doneButton];
        
    
    for (UIView *view in [self subviews]) {
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
    CMTime interval = CMTimeMake(33, 1000);
    __weak __typeof(self) weakself = self;
    playbackObserver = [self.moviePlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock: ^(CMTime time) {
        CMTime endTime = CMTimeConvertScale (weakself.moviePlayer.currentItem.asset.duration, weakself.moviePlayer.currentTime.timescale, kCMTimeRoundingMethod_RoundHalfAwayFromZero);
        if (CMTimeCompare(endTime, kCMTimeZero) != 0) {
            double normalizedTime = (double) weakself.moviePlayer.currentTime.value / (double) endTime.value;
            weakself.progressBar.value = normalizedTime;
        }
        weakself.playBackTime.text = [weakself getStringFromCMTime:weakself.moviePlayer.currentTime];
       
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:weakself.playBackTime.text,@"timer",weakself.playBackTotalTime.text,@"totaltimer", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"TestNotification" object:nil userInfo:dic];

    }];
    
    [self setupConstraints];
    [self showHud:NO];
    [self hide:NO];
}

-(void)zoomButtonPressed:(UIButton*)sender
{
    if (!self.zoomButton.selected) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationMaskAll];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        self.zoomButton.selected=YES;
    }
    else{
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        self.zoomButton.selected=NO;
    }
    
    [self.delegate playerViewZoomButtonClicked:self];
}


-(void)setIsFullScreenMode:(BOOL)isFullScreenMode
{
    _isFullScreenMode = isFullScreenMode;
    if (isFullScreenMode) {
        self.backgroundColor = [UIColor blackColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
    }
}

-(void)playerFinishedPlaying
{
    [self.moviePlayer pause];
    [self.moviePlayer seekToTime:kCMTimeZero];
    [self.playPauseButton setSelected:NO];
    self.isPlaying = NO;
    if ([self.delegate respondsToSelector:@selector(playerFinishedPlayback:)]) {
        [self.delegate playerFinishedPlayback:self];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [(UITouch*)[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(playerLayer.frame, point)) {
        [self showHud:!viewIsShowing];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:@"hide",@"touchmsg", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName: @"touch" object:nil userInfo:dic];
    }
}
-(void)someMethod{
    CGRect frame = self.playerHudBottom.frame;
    frame.origin.y = self.bounds.size.height;
    __weak __typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.playerHudBottom.frame = frame;
        weakself.playPauseButton.layer.opacity = 0;
        weakself.backButton.layer.opacity = 0;
        weakself.nextButton.layer.opacity = 0;
        self.touchMsg=@"hide";
        viewIsShowing = YES;
        NSLog(@"some method");
        [timer invalidate];
        
    }];
}
-(void) showHud:(BOOL)show
{
    self.touchMsg=@"";
    __weak __typeof(self) weakself = self;
    if(show) {
        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudBottom.frame = frame;
            weakself.playPauseButton.layer.opacity = 0;
            weakself.backButton.layer.opacity = 0;
            weakself.nextButton.layer.opacity = 0;
            self.touchMsg=@"hide";
            viewIsShowing = show;
        }];
    }
    else {
        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height-self.playerHudBottom.frame.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudBottom.frame = frame;
            weakself.playPauseButton.layer.opacity = 1;
            weakself.backButton.layer.opacity = 1;
            weakself.nextButton.layer.opacity = 1;
            self.touchMsg=@"show";
            
            viewIsShowing = show;
             NSLog(@"before some method");
            [timer invalidate];
                       //[timer fire];
          // [self performSelector:@selector(someMethod) withObject:nil afterDelay:6.0];
            
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
        timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                 target:self
                                               selector:@selector(someMethod)
                                               userInfo:nil
                                                repeats:NO];
            });

    }
//    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.touchMsg,@"touchmsg", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName: @"touch" object:nil userInfo:dic];
}

-(NSString*)getStringFromCMTime:(CMTime)time
{
    Float64 currentSeconds = CMTimeGetSeconds(time);
    int mins = currentSeconds/60.0;
    int secs = fmodf(currentSeconds, 60.0);
    NSString *minsString = mins < 10 ? [NSString stringWithFormat:@"0%d", mins] : [NSString stringWithFormat:@"%d", mins];
    NSString *secsString = secs < 10 ? [NSString stringWithFormat:@"0%d", secs] : [NSString stringWithFormat:@"%d", secs];
    return [NSString stringWithFormat:@"%@:%@", minsString, secsString];
}

//-(void)volumeButtonPressed:(UIButton*)sender
//{
//    if (sender.isSelected) {
//        [self.moviePlayer setMuted:YES];
//        [sender setSelected:NO];
//    } else {
//        [self.moviePlayer setMuted:NO];
//        [sender setSelected:YES];
//    }
//}

-(void)playButtonAction:(UIButton*)sender
{
    if (self.isPlaying) {
        [self pause];
//        [sender setSelected:NO];
    } else {
        [self play];
//        [sender setSelected:YES];
    }
}

-(void)progressBarChanged:(UISlider*)sender
{
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
    CMTime seekTime = CMTimeMakeWithSeconds(sender.value * (double)self.moviePlayer.currentItem.asset.duration.value/(double)self.moviePlayer.currentItem.asset.duration.timescale, self.moviePlayer.currentTime.timescale);
    [self.moviePlayer seekToTime:seekTime];
}

-(void)proressBarChangeEnded:(UISlider*)sender
{
    if (self.isPlaying) {
        [self.moviePlayer play];
    }
}

-(void)volumeBarChanged:(UISlider*)sender
{
    [self.moviePlayer setVolume:sender.value];
}

-(void)play
{
    [self.moviePlayer play];
    self.isPlaying = YES;
    [self.playPauseButton setSelected:YES];
}

-(void)pause
{
    [self.moviePlayer pause];
    self.isPlaying = NO;
    [self.playPauseButton setSelected:NO];
}

-(void)dealloc
{
    [self.moviePlayer removeTimeObserver:playbackObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)hide:(BOOL)show{
    __weak __typeof(self) weakself = self;
    if(show) {
        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudBottom.frame = frame;
            weakself.playPauseButton.layer.opacity = 0;
            weakself.backButton.layer.opacity = 0;
            weakself.nextButton.layer.opacity = 0;
            viewIsShowing = show;
        }];
    } else {
        CGRect frame = self.playerHudBottom.frame;
        frame.origin.y = self.bounds.size.height-self.playerHudBottom.frame.size.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakself.playerHudBottom.frame = frame;
            weakself.playPauseButton.layer.opacity = 1;
            weakself.backButton.layer.opacity = 1;
            weakself.nextButton.layer.opacity = 1;
            
            viewIsShowing = show;
        }];
    }
    
}
-(void)hideController:(NSTimer *)timer{
 [self hide:!viewIsShowing];
}

@end
