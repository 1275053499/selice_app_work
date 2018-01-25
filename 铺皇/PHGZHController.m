//
//  PHGZHController.m
//  铺皇
//
//  Created by selice on 2017/8/30.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "PHGZHController.h"
@interface PHGZHController ()
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property(nonatomic,strong)UIImageView  *GZHimgViewTop;
@property(nonatomic,strong)UILabel      *GZHlabTop;
@property(nonatomic,strong)UIImageView  *GZHimgViewButtom;
@property(nonatomic,strong)UILabel      *GZHlabButtom;
@property(nonatomic,strong)UILabel      *GZHlabaleat;

@property(nonatomic,strong)UIView       *GZHTopView;


@end

@implementation PHGZHController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self creatbase];
    [self creatcontroller];
}

-(void)creatcontroller{
    
    _GZHTopView  = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, 134)];
    _GZHTopView.backgroundColor = kTCColor(233, 233, 233);
   [self.view addSubview:_GZHTopView];
    
    UILabel * companyname = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, KMainScreenWidth, 20)];
    companyname.text = @"深圳市铺王电子商务信息有限公司";
    companyname.textAlignment       =  NSTextAlignmentCenter;
    companyname.font                =  [UIFont systemFontOfSize:16.0f];
    [_GZHTopView addSubview:companyname];

    UILabel * other = [[UILabel alloc]initWithFrame:CGRectMake(20, 35, KMainScreenWidth, 99)];
    other.text = @"商务合作:chinapuhuang@126.com\n公司地址:\n        龙华总公司:龙华新区民治东环一路良基大厦5楼520\n        西乡分公司:宝安区西乡共和工业路国汇通商务中心502\n        广州分公司:广州市白云区增槎路787号睿晟国际503A\n商务联系:15994741808(卢总)";
    other.textColor          = kTCColor(161, 161, 161);
    other.textAlignment      = NSTextAlignmentLeft;
    other.numberOfLines      = 0;
    other.font               = [UIFont systemFontOfSize:12.0f];
    [_GZHTopView addSubview:other];
    #pragma  -mark 铺皇网
//    图片
    _GZHimgViewTop = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"铺皇网@2x"]];
    _GZHimgViewTop.frame = CGRectMake((KMainScreenWidth-150)/2, 210, 150, 150);
    _GZHimgViewTop.tag = 1;
    [self.view addSubview:_GZHimgViewTop];
//     创建长按保存
    UILongPressGestureRecognizer *ToplongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
    _GZHimgViewTop.userInteractionEnabled = YES;
    [_GZHimgViewTop addGestureRecognizer:ToplongTap];
//     双击放大图像
    UITapGestureRecognizer *TopTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TObigClick:)];
    [TopTap setNumberOfTapsRequired:2];
    [_GZHimgViewTop addGestureRecognizer:TopTap];
//    文字
    _GZHlabTop   =[[UILabel alloc]initWithFrame:CGRectMake((KMainScreenWidth-100)/2, CGRectGetMaxY(_GZHimgViewTop.frame), 100, 20)];
    _GZHlabTop.text = @"铺皇网";
    _GZHlabTop.textAlignment = NSTextAlignmentCenter;
    _GZHlabTop.textColor = kTCColor(77, 166, 214);
    _GZHlabTop.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_GZHlabTop];
    
#pragma  -mark 铺皇网订阅号
//    图片
    _GZHimgViewButtom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"铺皇网订阅号"]];
    _GZHimgViewButtom.frame = CGRectMake((KMainScreenWidth-150)/2, KMainScreenHeight/2+84, 150, 150);
    _GZHimgViewButtom.tag = 1;
    [self.view addSubview:_GZHimgViewButtom];
    //创建长按保存
    UILongPressGestureRecognizer *ButtomlongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imglongTapClick:)];
    _GZHimgViewButtom.userInteractionEnabled = YES;
    [_GZHimgViewButtom addGestureRecognizer:ButtomlongTap];
    
//     双击放大图像
    UITapGestureRecognizer *ButtomTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TObigClick:)];
    [ButtomTap setNumberOfTapsRequired:2];
    [_GZHimgViewButtom addGestureRecognizer:ButtomTap];
//    文字
    _GZHlabButtom               =[[UILabel alloc]initWithFrame:CGRectMake((KMainScreenWidth-100)/2, CGRectGetMaxY(_GZHimgViewButtom.frame), 100, 20)];
    _GZHlabButtom.text          = @"铺皇网订阅号";
    _GZHlabButtom.textAlignment = NSTextAlignmentCenter;
    _GZHlabButtom.textColor     = kTCColor(77, 166, 214);
    _GZHlabButtom.font          = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:_GZHlabButtom];
    
    
    self.GZHlabaleat = [[UILabel alloc]init];
    self.GZHlabaleat.textAlignment = NSTextAlignmentCenter;
    self.GZHlabaleat.textColor = kTCColor(161, 161, 161);
    self.GZHlabaleat.text=@"长按保存图片，进入微信扫一扫添加公众号";
    self.GZHlabaleat.font = [UIFont systemFontOfSize:10.0f];
    [self.view addSubview:self.GZHlabaleat];
    
    [self.GZHlabaleat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 15));
        make.left.equalTo(self.view).with.offset(20);
    }];
    
}

#pragma mark - 点击放大二维码
-(void)TObigClick:(UITapGestureRecognizer *)tap{
    NSLog(@"点击放大二维码。。。。。。");
   
    [YJLbigimgview showImageBrowserWithImageView:(UIImageView *)tap.view];
}

#pragma mark 长按手势弹出警告视图确认
-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture{
    
    UIImageView *imageviw = (UIImageView *)gesture.view;
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"保存图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消保存图片");
        }];
        
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"确认保存图片");
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(imageviw.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
        }];
        [alertControl addAction:cancel];
        [alertControl addAction:confirm];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}



#pragma mark 保存图片后的回调
- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(id)contextInfo{
    NSString * message =@"呵呵";
    if(!error) {
        
        message =@"成功保存到相册";
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }else{
        
        message = [error description];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

-(void)creatbase{
    
    self.view.backgroundColor = kTCColor(255, 255, 255);
    
    self.title = @"联系我们";
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(backset4)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)backset4{
    
   
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
   
}



@end
