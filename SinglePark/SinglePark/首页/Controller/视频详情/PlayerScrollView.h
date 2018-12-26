//
//  PlayerScrollView.h
//  testPlayer
//
//  Created by 驿路梨花 on 2018/8/11.
//  Copyright © 2018年 驿路梨花. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KSYMediaPlayer/KSYMediaPlayer.h>

#import "SPCoverModel.h"
#import "SPPersonModel.h"


@interface PlayerScrollView : UIScrollView
 

/**
  视频的播放器
 */
@property (nonatomic,strong)KSYMoviePlayerController *player;


/**
  在获取数据源之后调用此方法

 @param infoModelArray infomodel 对象
 @param playIndex 播放的下标
 */
- (void)setMovePlayerWithInfoModelArray:(NSMutableArray *)infoModelArray withPlayIndex:(NSInteger)playIndex;

/**
  加载最新数据，调用此方法
 */
- (void)addNewData:(NSMutableArray *)newDataArray;
//将当前播放的下标传递出去， 根据播放下标获取最新的视频信息，
@property(nonatomic,copy)void (^passCurrentPlayerIndex)(NSInteger index);
//注册通知方法和移除通知方法，在初始化时添加方法，在将要消失时移除监听通知
- (void)registNotification;
- (void)removeNOtification;

/**
  添加返回方法
 */
- (void)addBackBtn;

@end


