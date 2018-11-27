//
//  PlayerScrollView.m
//  testPlayer
//
//  Created by 驿路梨花 on 2018/8/11.
//  Copyright © 2018年 驿路梨花. All rights reserved.
//

#import "PlayerScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TranslucentView.h"
#import "JDWForceRefreshView.h"


@interface PlayerScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>

/**
  上中下的遮罩层
 */
@property (nonatomic,strong)UIImageView *topImageView,*middleImageView,*downImageView;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSMutableArray *infoModelArray;

@property (nonatomic,strong)VideoInfoModel *topInfoModel,*middleInfoModel, *downInfoModel;


@end
@implementation PlayerScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor blackColor];
        self.contentSize = CGSizeMake(0, frame.size.height *3 );
        self.contentOffset = CGPointMake(0, frame.size.height);
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        
        //设置上中下三张图片
        self.topImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_topImageView];
        self.middleImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_middleImageView];
        self.downImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight *2 , kScreenWidth, kScreenHeight)];
        _downImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_downImageView];
        self.delegate = self;
        
//        TranslucentView.h
        
        //创建播放器
        _player =[[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@""]];
        [_player.view setFrame: self.bounds];  // player's frame must match parent's
        [self addSubview: _player.view];
        _player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        _player.shouldAutoplay = YES;
        [_player setShouldLoop:YES];
        _player.scalingMode = MPMovieScalingModeAspectFit;
        self.player.view.backgroundColor = [UIColor clearColor];
        
        self.infoModelArray =[NSMutableArray array];
        
        self.topInfoModel =[[VideoInfoModel alloc] init];
        self.middleInfoModel =[[VideoInfoModel alloc] init];
        self.downInfoModel =[[VideoInfoModel alloc] init];
        
        //添加程序进入后台和程序进入前台的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeVideo_puse) name:@"video_shouldPause" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeVideo_play) name:@"video_shouldPlay" object:nil];
        [self setUI];
 
    }
    
  
    
    return  self;
}

- (void)setUI{
    TranslucentView *view = [[TranslucentView alloc] initWithFrame:CGRectMake(kScreenWidth-70, kScreenHeight*2-300-KsafeTabIPhonex-49, 60, 240)];
    
    SPVideoModel *model = [[SPVideoModel alloc] initWithDataDic:@{@"commentStr":@"444",
                                                                  @"headUrl":@"1233",
                                                                  @"goodnumber":@"1222"}];
    view.model = model;
//    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    WEAKSELF
    view.TranslucentBlock = ^(NSInteger row) {
        STRONGSELF
        if (row == 1) { //头像
            
        }else if (row == 2){//点赞/】
            [strongSelf goodluck];
        }else if (row == 3){  // 评论
            JDWForceRefreshView *forceview = [[JDWForceRefreshView alloc] initWithFrame:KEYWINDOW.bounds];
            forceview.ClicKSure = ^{
                [forceview removeFromSuperview];
            };
            [KEYWINDOW addSubview:forceview];

        }else if (row == 4){ //举报
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
            //        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
            actionSheet.delegate = self;
            [actionSheet showInView:self];
        }
    };
    
    //单击的手势
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.delegate = self;
    [tapRecognize setEnabled :YES];
    [tapRecognize delaysTouchesBegan];
    [tapRecognize cancelsTouchesInView];
    [self addGestureRecognizer:tapRecognize];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self addGestureRecognizer:doubleTapGesture];
    //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
    [tapRecognize requireGestureRecognizerToFail:doubleTapGesture];

}


- (void)setMovePlayerWithInfoModelArray:(NSMutableArray *)infoModelArray withPlayIndex:(NSInteger)playIndex{
    [self.infoModelArray addObjectsFromArray:infoModelArray];
    _middleInfoModel   = self.infoModelArray[playIndex];
    [_player setUrl:[NSURL URLWithString:_middleInfoModel.videoUrl]];
    [_player prepareToPlay];
    _index = playIndex;
    
    [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:_middleInfoModel.coverImageUrl]];
     if (self.infoModelArray.count > 1 && _index < self.infoModelArray.count - 1) {
        _downInfoModel =self.infoModelArray[_index+1];
        [self prepareImageView:self.downImageView WithModel:_downInfoModel];
         
    }
}
- (void)addNewData:(NSMutableArray *)newDataArray{
    [self.infoModelArray addObjectsFromArray:newDataArray];
}
- (void)prepareImageView:(UIImageView *)imageView WithModel:(VideoInfoModel *)infoModel{
    [imageView sd_setImageWithURL:[NSURL URLWithString:infoModel.coverImageUrl]];
}
- (void)prepareVideoWithInfoModel:(VideoInfoModel *)infoModel{
    //重制播放器，不保留上一个视频的最后一帧https://github.com/ksvc/KSYMediaPlayer_iOS/wiki/oneInstance
    [_player reset:NO];
    //重新设置链接
    [_player setUrl:[NSURL URLWithString:infoModel.videoUrl]];
    //准备播放视频
    
    [_player setBufferSizeMax:1];
     [_player setShouldAutoplay:true];
     [_player setShouldLoop:YES];
    _player.view.backgroundColor = [UIColor clearColor];
 
     [_player prepareToPlay];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
     if (self.infoModelArray.count == 1 ) {
        scrollView.scrollEnabled = NO;
        return;
    }
    if (_index == 0 && scrollView.contentOffset.y <= kScreenHeight   ) {
        scrollView.contentOffset = CGPointMake(0, kScreenHeight);
        [scrollView setContentOffset:CGPointMake(0, kScreenHeight) animated:NO];
        return;
    }
    if (_index > 0 && _index == self.infoModelArray.count-1 && scrollView.contentOffset.y > kScreenHeight) {
//        scrollView.contentOffset = CGPointMake(0, SCREEN_HIGHT);
        [scrollView setContentOffset:CGPointMake(0, kScreenHeight) animated:NO];
        return;
    }
    
    if (scrollView.contentOffset.y >=  2 *  kScreenHeight) {//往上滑动
        scrollView.contentOffset = CGPointMake(0, kScreenHeight);
        self.topImageView.image = self.middleImageView.image;
        self.middleImageView.image = self.downImageView.image;
        self.player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        _index += 1;
        _middleInfoModel = self.infoModelArray[_index];
        [self prepareVideoWithInfoModel:_middleInfoModel];
        if (_index < self.infoModelArray.count - 1 && self.infoModelArray.count >= 3) {
            _downInfoModel = self.infoModelArray[_index + 1];
            [self prepareImageView:_downImageView WithModel:_downInfoModel];
            
        }
        _topInfoModel = self.infoModelArray[_index -1];
        [self prepareImageView:_topImageView WithModel:_topInfoModel];
        if (_passCurrentPlayerIndex) {
            _passCurrentPlayerIndex(_index);
        }
        self.player.view.hidden = YES;
    }else if(scrollView.contentOffset.y <= 0 ){
       
        scrollView.contentOffset = CGPointMake(0, kScreenHeight);
        self.downImageView.image = self.middleImageView.image;
        self.middleImageView.image = self.topImageView.image;
        self.player.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
        _index -= 1;
        
        if (_index != 0 ) {
            _topInfoModel = self.infoModelArray[_index - 1];
            [self prepareImageView:_topImageView WithModel:_topInfoModel];
        }
        _middleInfoModel = self.infoModelArray[_index];
        [self prepareVideoWithInfoModel:_middleInfoModel];
        _downInfoModel = self.infoModelArray[_index + 1];
        [self prepareImageView:_downImageView WithModel:_downInfoModel];
        
        
        
        if (_passCurrentPlayerIndex) {
            _passCurrentPlayerIndex(_index);
        }
        self.player.view.hidden = YES;
    }
    
    

    
}

- (void)registNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerPreparedToPlayNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(bofang:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];

    
}
#pragma mark 在播放视频之前，此通知方法会先调用，%ld后再调(long)用下面的方法
- (void)handlePlayerNotify:(NSNotification *)noti{
    [self.player.view setHidden:NO];
}

- (void)bofang:(NSNotification *)noti{
    KSYMoviePlayerController *play = noti.object;
    
    NSLog(@"%@,%ld",noti,play.playbackState);
    
}
//调用此方法进行播放视频
- (void)handlePlayerPreparedToPlayNotify:(NSNotification *)noti{
    if ([self.player isPreparedToPlay]) {
        [self.player play];
    }
}
- (void)removeNOtification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(MPMoviePlayerFirstVideoFrameRenderedNotification) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification) object:nil];
}
- (void)addBackBtn{
    UIButton *backBtn1 =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn1.frame = CGRectMake(0, 0, 50, 50);
    [backBtn1 setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn1 addTarget:self action:@selector(handle_backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn1];
    UIButton *backBtn2 =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn2.frame = CGRectMake(0, kScreenHeight, 50, 50);
    [backBtn2 setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn2 addTarget:self action:@selector(handle_backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn2];
    UIButton *backBtn3 =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn3.frame = CGRectMake(0, kScreenHeight * 2 , 50, 50);
    [backBtn3 setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [backBtn3 addTarget:self action:@selector(handle_backBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:backBtn3];
}
- (void)handle_backBtn{
    [_player stop];
    _player = nil;
    [self removeFromSuperview];
}

#pragma mark 程序进入后台，接受通知暂停一下
- (void)makeVideo_puse{
    NSLog(@"接收通知，暂停播放，，，");
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([self.player isPlaying]) {
        [self.player pause];
        [defaults setInteger:1 forKey:@"manual_stop"];
    }else{
        [defaults setInteger:0 forKey:@"manual_stop"];
    }
}
- (void)makeVideo_play{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"manual_stop"] == 1) {
        [self.player play];
    }
    
}


-(void) handleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.player.playbackState == MPMoviePlaybackStatePaused) {
        [self.player play];
    }else{
        [self.player pause];
    }
    NSLog(@"---单击手势-------");
}

//双击手势
-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    [self goodluck];
    NSLog(@"24242424");
}

#pragma mark-------UIActionSheetDelegate  UIActionSheet 遵循的协议
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // 举报
        
        
    }
}


- (void)goodluck{
    [MBProgressHUD showAutoMessage:@"点赞"];

}


@end
