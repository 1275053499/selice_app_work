//
//  DoubtaskerController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/7/28.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "DoubtaskerController.h"

@interface DoubtaskerController ()<UIScrollViewDelegate>

@property(strong,nonatomic)UIScrollView *Questions;

@property float autoSizeScaleX;
@property float autoSizeScaleY;

//客服
@property(strong,nonatomic)UIImageView *Aimage;
@property(strong,nonatomic)UILabel  *Aname;
@property(strong,nonatomic)UILabel  *A;
@property(strong,nonatomic)UIImageView *Abackimage;

//客户
@property(strong,nonatomic)UIImageView *Qimage;
@property(strong,nonatomic)UILabel  *Q;
@property(strong,nonatomic)UILabel  *Qname;
@property(strong,nonatomic)UIImageView *Qbackimage;

@end

@implementation DoubtaskerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(KMainScreenHeight < 667)
    {                                 // 这里以(iPhone6)为准
        _autoSizeScaleX = KMainScreenWidth/375;
        _autoSizeScaleY = KMainScreenHeight/667;
    }
    else{
        _autoSizeScaleX = 1.0;
        _autoSizeScaleY = 1.0;
    }
    NSLog(@"X比例=%f,Y比例=%f",_autoSizeScaleX,_autoSizeScaleY);
    self.title = @"服务问题解答";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self buildmain];
}


#pragma -mark 自定义背景是图scrollow
-(void)buildmain{
#pragma -mark 滚动 mainview
    _Questions = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight+64)];
    _Questions.userInteractionEnabled = YES;
    _Questions.showsVerticalScrollIndicator = YES;
    _Questions.showsHorizontalScrollIndicator = YES;
    _Questions.delegate = self;
    _Questions.backgroundColor = [UIColor whiteColor];
    _Questions.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight+200);
    [self.view addSubview:_Questions];
    
#pragma -mark    顾客问答
/****************************   顾客头像     *********************************/
    _Qimage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    _Qimage.image = [UIImage imageNamed:@"GukeQ@2x"];
    [_Questions addSubview:_Qimage];
/****************************   顾客名字     *********************************/
    _Qname  = [[UILabel  alloc]initWithFrame:CGRectMake(_Qimage.frame.origin.x,CGRectGetMaxY(_Qimage.frame)+2,_Qimage.frame.size.width, 20)];
    _Qname.text = @"客户";
    _Qname.font = [UIFont systemFontOfSize:10.0f];
    _Qname.textAlignment = NSTextAlignmentCenter;
    _Qname.textColor = kTCColor(51, 51, 51);
    [_Questions addSubview:_Qname];
    
/****************************   顾客问题     *******************************/
// 拉伸图片的中间部位 而不是等比例
    UIImage * QoldImage = [UIImage imageNamed:@"chatQ@2x"];
// 拉伸图片的中心位置 图片即使放大边界也不会有锯齿效果
    UIImage * QnewImage = [QoldImage stretchableImageWithLeftCapWidth:QoldImage.size.width/2 topCapHeight:QoldImage.size.height/2];
    _Qbackimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight)];
    _Qbackimage.image = QnewImage;
    [_Questions addSubview:_Qbackimage];
    
    _Q = [[UILabel alloc]init];
    _Q.font = [UIFont systemFontOfSize:14.0f];
    CGFloat labelWidth =KMainScreenWidth-90;
// 创建文字
    NSString *string = _Question;//@"你们公司是如何服务转店的呢？有什么特色么？你给我说说看吧！";
    _Q.text = string;
// 设置文字属性 要和label的一致
    NSDictionary *attrs = @{NSFontAttributeName : _Q.font};
    CGSize QmaxSize = CGSizeMake(labelWidth, MAXFLOAT);
// 计算文字占据的高度
    CGSize Qsize = [string boundingRectWithSize:QmaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
// 设置labelframe
    _Q.frame = CGRectMake(15, 15, Qsize.width, Qsize.height);
    _Q.numberOfLines = 0;
    
/*******************************重置文本背景frame*******************************/
    [_Qbackimage addSubview:_Q];
    _Qbackimage.frame = CGRectMake(CGRectGetMaxX(_Qimage.frame)+5, CGRectGetMaxY(_Qimage.frame)-20, Qsize.width+30, Qsize.height+30);
    
#pragma -mark    客服回答
/*********************    客服回复谈话     ******************/
 
// 拉伸图片的中间部位 而不是等比例
    UIImage * AoldImage = [UIImage imageNamed:@"chatA@2x"];
// 拉伸图片的中心位置 图片即使放大边界也不会有锯齿效果
    UIImage * AnewImage = [AoldImage stretchableImageWithLeftCapWidth:AoldImage.size.width/2 topCapHeight:AoldImage.size.height/2];
    _Abackimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight)];
    _Abackimage.image = AnewImage;
    [_Questions addSubview:_Abackimage];
    
    _A = [[UILabel alloc]init];
    _A.font = [UIFont systemFontOfSize:14.0f];
    CGFloat AlabelWidth =KMainScreenWidth-90;
// 创建文字
    NSString *Astring =_Answer;
    _A.text = Astring;

    
// 设置文字属性 要和label的一致
    NSDictionary *Aattrs = @{NSFontAttributeName : _A.font};
    CGSize AmaxSize = CGSizeMake(AlabelWidth, MAXFLOAT);
// 计算文字占据的高度
    CGSize Asize = [Astring boundingRectWithSize:AmaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:Aattrs context:nil].size;
// 设置label尺寸
    _A.frame = CGRectMake(20, 20, Asize.width, Asize.height);
    _A.numberOfLines = 0;
    
//    重置文本背景frame
    [_Abackimage addSubview:_A];
    _Abackimage.frame = CGRectMake(10, CGRectGetMaxY(_Qbackimage.frame)+30, Asize.width+40, Asize.height+40);
    
    
    /**********************   客服头像    ***************/
    _Aimage = [[UIImageView alloc]initWithFrame:CGRectMake(KMainScreenWidth-40, CGRectGetMaxY(_Abackimage.frame)-20, 30, 30)];
    _Aimage.image = [UIImage imageNamed:@"KefuA@2x"];
    [_Questions addSubview:_Aimage];
    
    
    /****************************   客服名字     *********************************/
    _Aname  = [[UILabel  alloc]initWithFrame:CGRectMake(_Aimage.frame.origin.x,CGRectGetMaxY(_Aimage.frame)+2,_Aimage.frame.size.width, 20)];
    _Aname.text = @"客服";
    _Aname.font = [UIFont systemFontOfSize:10.0f];
    _Aname.textAlignment = NSTextAlignmentCenter;
    _Aname.textColor = kTCColor(51, 51, 51);
    [_Questions addSubview:_Aname];
    
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer
{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}
#pragma  -mark - 返回
-(void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
}

@end
