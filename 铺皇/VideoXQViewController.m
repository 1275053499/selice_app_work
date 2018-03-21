//
//  VideoXQViewController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/20.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "VideoXQViewController.h"
#import "VideoXQTableViewCell.h"
#import <objc/runtime.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>//视频类

@interface VideoXQViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int PHpage;
    AVPlayerViewController  *YJLPlayer;                 //视频控件
}
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property   (strong, nonatomic) UITableView     *   VoidtableView;
@property   (nonatomic, strong) ShoppingBtn     *   btnButtom;
@property   (nonatomic, strong) NSMutableArray  *   PHArr_VoideAll; //存储数据
@property   (nonatomic, strong) NSMutableArray  *   PHArr_two_VoideAll;//存储数据2级
@property   (nonatomic, strong) UIImageView     *   interimg;

@end

@implementation VideoXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatbase];
    [self creattableview];
    

}

-(void)creattableview{
#pragma -mark 无网络图示

    self.VoidtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview: self.VoidtableView];
     self.VoidtableView.dataSource = self;
     self.VoidtableView.delegate = self;
}


- (void)creatbase{
    
    self.view.backgroundColor = kTCColor(255, 255, 255);
    _PHArr_VoideAll = [[NSMutableArray alloc]init];
    _PHArr_two_VoideAll = [[NSMutableArray alloc]init];
    
    self.title = @"视频中心";
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}

#pragma mark 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellname";
    VideoXQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VideoXQTableViewCell" owner:self options:nil]lastObject];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"铺皇app宣传";
            cell.timeLabel.text = @"2017-01-10";
            cell.videoImgview.image=[UIImage imageNamed:@"铺皇app宣传ALL"];
            cell.videoPath = @"";
            break;
        case 1:
            cell.titleLabel.text = @"合作视频反馈";
            cell.timeLabel.text = @"2016-05-20";
            cell.videoImgview.image=[UIImage imageNamed:@"合作视频反馈ALL"];
            cell.videoPath = @"";
            break;
        default:{
            
            cell.titleLabel.text = @" 铺皇致富之路";
            cell.timeLabel.text = @"2017-05-20";
            cell.videoImgview.image=[UIImage imageNamed:@"宣传图_2.jpeg"];
            cell.videoPath = @"";
        
        }
            break;
    }
    return cell;
}

#pragma mark点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //直接创建AVPlayer，它内部也是先创建AVPlayerItem，这个只是快捷方法
    AVPlayer *player = [[AVPlayer alloc]init];
    switch (indexPath.row) {
        case 0:{
            
            player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://ph.chinapuhuang.com/Public/Video/2017-11-30/5a1fa547c11e70.02050213.mp4"]];
        }
            break;
        case 1:{
            
            player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://ph.chinapuhuang.com/Public/Video/2017-12-02/5a22af0b52bb35.84512993.mp4"]];
        }
            break;
        default:{
             player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://ph.chinapuhuang.com/Public/Video/2017-12-21/5a3b309ed83ee9.29373947.mp4"]];
        }
            break;
    }
    
        //创建AVPlayerViewController控制器
        YJLPlayer               = [[AVPlayerViewController alloc] init];
        YJLPlayer.player        = player;
        YJLPlayer.view.frame    = self.view.frame;
        //调用控制器的属性player的开始播放方法
        [self presentViewController:YJLPlayer animated:YES completion:nil];
        [YJLPlayer.player play];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 252;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
  
}

@end
