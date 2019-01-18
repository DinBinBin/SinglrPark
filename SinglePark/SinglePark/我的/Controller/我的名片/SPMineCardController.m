//
//  SPMineCardController.m
//  SinglePark
//
//  Created by DBB on 2018/10/23.
//  Copyright © 2018年 DBB. All rights reserved.
//

#import "SPMineCardController.h"
#import "SPCardTabCell.h"
#import "SPCardVideoTabCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SPUploadingController.h"
#import "QiniuSDK.h"
#import "SPVideoModel.h"

@interface SPMineCardController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)UITableView *listTabView;
@property (nonatomic,copy)NSString *coverStr;
@property (nonatomic,copy)NSString *coverStr2;

@property (nonatomic,copy)NSString *videopath;
@property (nonatomic,copy)NSString *coverPath;

@property (nonatomic,strong)SPVideoModel *videoModel;

@property (nonatomic,assign)NSInteger selectrow;


@end

@implementation SPMineCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的名片";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonLeftItemWithImageName:@"more" target:self action:@selector(selectCover)];

    [self.listTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.hideNavigationLine = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestdata];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hideNavigationLine = YES;
}

- (void)requestdata{
    
    WEAKSELF
    STRONGSELF
    
    [MBProgressHUD showLoadToView:self.view];
    
    [JDWNetworkHelper POST:SPVideoList parameters:@{@"page":@"1",@"limit":@"10"} success:^(id responseObject) {
        NSDictionary *responseDic = [SFDealNullTool dealNullData:responseObject];
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
            NSArray *arr = responseDic[@"data"][@"items"];
            if (arr.count > 0) {
                SPVideoModel *model = [SPVideoModel modelWithJSON:responseDic[@"data"][@"items"][0]];
                self.videoModel = model;
                [self.listTabView reloadData];

            }
            
            
        }else{
            [MBProgressHUD showMessage:[responseDic objectForKey:@"messages"]];
            
        }
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
        [MBProgressHUD showAutoMessage:Networkerror];
        [MBProgressHUD hideHUDForView:strongSelf.view];
        
    }];
    
  
    
}

#pragma mark ----UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SPCardTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr forIndexPath:indexPath];
        cell.model =  self.model;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        SPCardVideoTabCell *cell  = [tableView dequeueReusableCellWithIdentifier:self.coverStr2 forIndexPath:indexPath];
        cell.videoModel = self.videoModel;
        cell.titleLab.text = @"关于我&关于他";
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>=1) {
        self.selectrow = indexPath.section;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地视频",@"立即拍摄",nil];
        //        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.delegate = self;
        [actionSheet showInView:self.view];

    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

- (UITableView *)listTabView{
    if (_listTabView == nil) {
        _listTabView = [[UITableView alloc] init];
        _listTabView.dataSource = self;
        _listTabView.delegate = self;
        _listTabView.backgroundColor = PTBackColor;
        self.coverStr = @"coverId";
        [_listTabView registerClass:[SPCardTabCell class] forCellReuseIdentifier:self.coverStr];
        self.coverStr2 = @"coverId2";
        [_listTabView registerClass:[SPCardVideoTabCell class] forCellReuseIdentifier:self.coverStr2];
        _listTabView.tableFooterView = [UIView new];
        _listTabView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigbackground"]];
        [self.view addSubview:_listTabView];
    }
    return _listTabView;
}


// 更改封面
- (void)selectCover{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"拍照" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhotoWithType:1];
    }];
    
    [photo setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * choice = [UIAlertAction actionWithTitle:@"从相册中选择" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhotoWithType:0];
    }];
    [choice setValue:TextMianColor forKey:@"_titleTextColor"];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:photo];
    [alertController addAction:choice];
    [alertController addAction:cancel];
    [self showDetailViewController:alertController sender:nil];
}

- (void)openPhotoWithType:(int)type
{
    if ([self getMediaTypeVideo]) {  //获取相机权限
        UIImagePickerControllerSourceType sourceType = type;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
//        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = TextMianColor;
        [picker.navigationBar setTitleTextAttributes:attrs];
        picker.navigationBar.tintColor = TextMianColor;
        [self  presentViewController:picker animated:YES completion:^{
            //            UIViewController *vc = picker.viewControllers.lastObject;
            //            UIBarButtonItem *cancelBtn = [vc valueForKey:@"imagePickerCancelButton"];
            //            UIButton *btn = [cancelBtn valueForKey:@"view"];
            //            [btn setTitleColor:TextMianColor forState:UIControlStateNormal];
        }];//进入照相界面
    }else{
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"请设置使用照片。\n请启用照片-设置/隐私/照片"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        
        NSLog(@"相机受限");
    }
}

-(bool)getMediaTypeVideo
{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusRestricted){// 受限制 家长权限之类的
        return NO;
    } else if(author == ALAuthorizationStatusDenied){// 已经拒绝的
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"请设置使用照片。\n请启用照片-设置/隐私/照片"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        return NO;
    } else if(author == ALAuthorizationStatusAuthorized){// 已允许的
        
        return YES;
        
    } else if(author == ALAuthorizationStatusNotDetermined){// 还没决定的
        return YES;
        
    } else {
        return NO;
    }}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark - imagePicker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if ([picker.mediaTypes[0] isEqualToString:@"public.movie"]) { //视频
        NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videopath = [sourceURL path];
        if (!sourceURL) {
            
            sourceURL = [info objectForKey:UIImagePickerControllerReferenceURL];
            self.videopath = [NSString stringWithFormat:@"%@",sourceURL];
            
        }        NSURL *newVideoUrl ; //一般.mp4
        NSString *tempPath = [self TempFilePathWithExtension:@"mp4"];
        newVideoUrl = [NSURL fileURLWithPath:tempPath];
        
        [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
    //    NSLog(@"%@",info );
    
    [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];

//   UIImage  *img = [self scaleToSize:[info objectForKey:@"UIImagePickerControllerEditedImage"] size:CGSizeMake(300, 500)];
    self.listTabView.backgroundView = [[UIImageView alloc] initWithImage:img];

    [self commitHeadimg:img];
    }
    
    
}

- (void)commitHeadimg:(UIImage *)img{
    NSString *filePath = [kDocumentDirectoryPath stringByAppendingPathComponent:@"VideoImg"];
    
    self.coverPath = [filePath stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%5.2f.png",[[NSDate date] timeIntervalSince1970]]];  // 保存文件的名称
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    };
    BOOL result =[UIImagePNGRepresentation(img)writeToFile:self.coverPath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
        [self gettoken:self.coverPath];
    }else{
        [MBProgressHUD showAutoMessage:@"选取失败"];
    }
}



#pragma mark-------UIActionSheetDelegate  UIActionSheet 遵循的协议
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self goPhoto];

    }else if(buttonIndex == 1){
        [self goCamera];
    }
}

#pragma mark ----- 视频选择
- (void)goPhoto{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;//设置委托
}

- (void)goCamera{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.videoMaximumDuration = 30000.0f;//30秒
    ipc.delegate = self;//设置委托
}

// 压缩路径获取图片第一帧
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
//    [MBProgressHUD showLoadToView:nil];
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    
    //    图片第一帧
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:avAsset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    
    [self saveImage:videoImage title:[NSString stringWithFormat:@"%ld",self.selectrow]];
    CGImageRelease(image);
    SPUploadingController *load = [[SPUploadingController alloc]  init];
    load.videopath = self.videopath;
    [self.navigationController pushViewController:load animated:YES];
    
    //coverPath
    
    
    //    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
    //     {
    //         switch (exportSession.status) {
    //             case AVAssetExportSessionStatusCancelled:
    //                 NSLog(@"AVAssetExportSessionStatusCancelled");
    //                 break;
    //             case AVAssetExportSessionStatusUnknown:
    //                 NSLog(@"AVAssetExportSessionStatusUnknown");
    //                 break;
    //             case AVAssetExportSessionStatusWaiting:
    //                 NSLog(@"AVAssetExportSessionStatusWaiting");
    //                 break;
    //             case AVAssetExportSessionStatusExporting:
    //                 NSLog(@"AVAssetExportSessionStatusExporting");
    //                 break;
    //             case AVAssetExportSessionStatusCompleted:
    //                 NSLog(@"AVAssetExportSessionStatusCompleted");
    ////                 self.videopath = [outputURL path]; //路径
    ////                 [self selectView:2 isphoto:YES];
    //                 break;
    //             case AVAssetExportSessionStatusFailed:
    //                 NSLog(@"AVAssetExportSessionStatusFailed");
    //                 break;
    //         }
    //     }];
}

- (void)saveImage:(UIImage *)image title:(NSString *)str{
    NSString *filePath = [kDocumentDirectoryPath stringByAppendingPathComponent:@"VideoImg"];
    
    self.coverPath = [filePath stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%@.png",str]];  // 保存文件的名称
//    self.imgarr[self.selectrow] = self.coverPath;
    [self.listTabView reloadData];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    };
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:self.coverPath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
    
}

-(NSString *) TempFilePathWithExtension:(NSString*) extension{
    NSString* fileName = [NSUUID UUID].UUIDString;
    NSString* path = NSTemporaryDirectory();
    path = [path stringByAppendingPathComponent:fileName];
    path = [path stringByAppendingPathExtension:extension];
    return path;
}

- (void)saveImage:(UIImage *)image{
    NSString *filePath = [kDocumentDirectoryPath stringByAppendingPathComponent:@"VideoImg"];
    
    self.coverPath = [filePath stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"%5.2f.png",[[NSDate date] timeIntervalSince1970]]];  // 保存文件的名称
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
    };
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:self.coverPath   atomically:YES]; // 保存成功会返回YES
    if (result == YES) {
        NSLog(@"保存成功");
    }
}

// 上传图片
- (void)gettoken:(NSString *)filePath{
    
    [JDWNetworkHelper POST:SPQiniuToken parameters:nil success:^(id responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        if ([responseDic[@"error_code"] intValue] == 0 && responseDic != nil) {
             NSString *qiniutoken = responseDic[@"data"][@"qiniu"];
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
                NSLog(@"percent == %.2f", percent);
            }
                                                                         params:nil
                                                                       checkCrc:NO
                                                             cancellationSignal:nil];
            [upManager putFile:filePath key:nil token:qiniutoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info ===== %@", info);
                NSLog(@"resp ===== %@", resp);
                

            }
                        option:uploadOption];
        }else{
            [MBProgressHUD showMessage:responseDic[@"messages"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:Networkerror];
    }];
}


@end
