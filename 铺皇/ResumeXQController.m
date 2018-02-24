//
//  ResumeXQController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/6/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ResumeXQController.h"
#import "ShopsrecruitModel.h"
@interface ResumeXQController ()<UIScrollViewDelegate>{
    BOOL isSC;
    ShopsrecruitModel *model;
    NSString *URL;
}

@property(nonatomic,strong)UIScrollView *PHzpscrollview;
@property(nonatomic,strong)UILabel      *Jobtitle;      //职位名称
@property(nonatomic,strong)UILabel      *Salary;        //薪资
@property(nonatomic,strong)UILabel      *number;        //人数
@property(nonatomic,strong)UILabel      *JobsalaryTX;   //职位诱惑提醒
@property(nonatomic,strong)UITextView   *Jobsalary;     //职位诱惑内容

@property(nonatomic,strong)ShoppingBtn  *Region;        //区域
@property(nonatomic,strong)ShoppingBtn  *Experience;    //经验
@property(nonatomic,strong)ShoppingBtn  *Education;     //学历
@property(nonatomic,strong)ShoppingBtn  *Nature;        //性质
@property(nonatomic,strong)ShoppingBtn  *jobdescription;//职位描述
@property(nonatomic,strong)ShoppingBtn  *jobaddess;     //工作地址
@property(nonatomic,strong)ShoppingBtn  *Company;       //公司信息
@property(nonatomic,strong)ShoppingBtn  *SC;       //收藏按钮

@property(nonatomic,strong)UITextView   *jobdescrip;    //职位描述内容
@property(nonatomic,strong)UILabel      *jobaddesslab;  //工作地址内容
@property(nonatomic,strong)UILabel      *CompanynameTX; //公司名称
@property(nonatomic,strong)UILabel      *Companyname;   //公司名称内容
@property(nonatomic,strong)UILabel      *CompanyprofileTX;//公司简介
@property(nonatomic,strong)UITextView   *Companyprofile;//公司简介内容

@property(nonatomic,strong)UILabel *backgroude1;//背景1
@property(nonatomic,strong)UILabel *backgroude2;//背景2
@property(nonatomic,strong)UILabel *backgroude3;//背景3
@property(nonatomic,strong)UILabel *backgroude4;//背景4
@property(nonatomic,strong)UILabel *backgroude5;//背景5
@property(nonatomic,strong)UILabel *backgroude6;//背景6
@property(nonatomic,strong)UILabel *backgroude7;//背景7
@property(nonatomic,strong)UILabel *backgroude8;//背景8
@property(nonatomic,strong)UIButton *contactbtn;//直接电话联系店铺发布人
@end

@implementation ResumeXQController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = kTCColor(255, 255, 255);
    self.title = @"招聘职位详情";
     #pragma  -mark - 标题返回按钮
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:243/255.0 green:244/255.0 blue:248/255.0 alpha:1.0]];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackButtonClick)];
    self.navigationItem.leftBarButtonItem = backItm;
    #pragma  -mark - 右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
//    获取数据
     [self loaddata];
}

-(void)creatPHwhere{
    
     _SC  = [[ShoppingBtn alloc]initWithFrame: CGRectMake(0, KMainScreenHeight-49, 90, 49) buttonStyle:UIButtonStyleButtom spaceing:0 imagesize:25];
    _SC.backgroundColor = [UIColor whiteColor];
    _SC.titleLabel.font = [UIFont systemFontOfSize:12];
    _SC.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_SC setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_SC addTarget:self action:@selector(SC:) forControlEvents:UIControlEventTouchUpInside];
    [_SC setTitleColor:[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:_SC];
    if ([model.Companycollect isEqualToString:@"no"]) {
        isSC = NO;
        [_SC setTitle:@"未收藏" forState:UIControlStateNormal];
        [_SC setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
        
    }else{
        isSC  = YES;
        [_SC setTitle:@"收藏" forState:UIControlStateNormal];
        [_SC setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
    }
    
#pragma  -mark   电话联系
    //    联系房东
    _contactbtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _contactbtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lvsekuai"]];
    _contactbtn.frame           = CGRectMake(90, KMainScreenHeight-49, KMainScreenWidth-90, 49);
    [_contactbtn setImage:[UIImage imageNamed:@"lianxifangdong"] forState:UIControlStateNormal];
    [_contactbtn setTitle:@"联系老板" forState:UIControlStateNormal];
    _contactbtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_contactbtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_contactbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_contactbtn addTarget:self action:@selector(HRclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_contactbtn];
    
}

#pragma - mark 收藏
-(void)SC:(UIButton *)btn{
     if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]){
         if (!isSC){
             //        添加收藏的
             [_SC setTitle:@"收藏" forState:UIControlStateNormal];
             [_SC setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
         
             AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
             manager.responseSerializer          = [AFJSONResponseSerializer serializer];
             manager.requestSerializer.timeoutInterval = 5.0;
             NSDictionary *params = @{
                                      @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                      @"shopid":_shopsubid,
                                      @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                      @"collect":@"1",
                                      };
             
             [manager POST:Hostzpcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                 
                 NSLog(@"状态码:%@",responseObject[@"code"]);
                 if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                     NSLog(@"收藏成功");
                     isSC = !isSC;
                     [YJLHUD showSuccessWithmessage:@"添加收藏成功"];
                     [YJLHUD dismissWithDelay:1.5];
                 }
                 
                 else{
                     
                     NSLog(@"收藏失败");
                     [YJLHUD showErrorWithmessage:@"添加收藏失败"];
                     [YJLHUD dismissWithDelay:1.5];
                     [_SC setTitle:@"未收藏" forState:UIControlStateNormal];
                     [_SC setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
                 }
                 
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 
                 NSLog(@"error:%@",error);
               
                 [YJLHUD showErrorWithmessage:@"服务器繁忙~~"];
                 [YJLHUD dismissWithDelay:1.5];
             }];
         }
         
         else{
             
             //        取消收藏的
             [_SC setTitle:@"未收藏" forState:UIControlStateNormal];
             [_SC setImage:[UIImage imageNamed:@"weishoucan_kongxin"] forState:UIControlStateNormal];
             
            
             AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
             manager.responseSerializer          = [AFJSONResponseSerializer serializer];
             manager.requestSerializer.timeoutInterval = 10.0;
           
             NSDictionary *params = @{
                                      @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                      @"shopid":_shopsubid,
                                      @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid],
                                      @"collect":@"0",
                                      };
             
             [manager POST:Hostzpcollectpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                 
                 NSLog(@"状态码:%@",responseObject[@"code"]);
                 if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                     NSLog(@"取消收藏成功");
                     
                     isSC = !isSC;
                     
                     [YJLHUD showSuccessWithmessage:@"取消收藏成功"];
                     [YJLHUD dismissWithDelay:1];
                 }
                 else{
                    
                     [YJLHUD showErrorWithmessage:@"取消收藏失败"];
                     [YJLHUD dismissWithDelay:1.5];
                     [_SC setTitle:@"收藏" forState:UIControlStateNormal];
                     [_SC setImage:[UIImage imageNamed:@"weishoucan_shixin"] forState:UIControlStateNormal];
                     NSLog(@"取消收藏失败");
                 }
                 
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                 NSLog(@"error:%@",error);
                 [YJLHUD showErrorWithmessage:@"服务器繁忙"];
                 [YJLHUD dismissWithDelay:1.5];
                 
             }];
         }
     }else{
         
         [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
         [YJLHUD dismissWithDelay:2];
         
     }
}

#pragma mark 完美适配 （描述的高度）UITextView 根据字数的计算高度
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

 #pragma  -mark 创建控件
-(void)creatPHZP{
    
    self.title = [NSString stringWithFormat:@"%@招聘%@%@人",model.Companyname,model.CompanyJobname,model.Companynum];

    _PHzpscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64)];
    _PHzpscrollview.backgroundColor                 = [UIColor whiteColor];
    _PHzpscrollview.userInteractionEnabled          = YES;
    _PHzpscrollview.showsVerticalScrollIndicator    = YES;
    _PHzpscrollview.showsHorizontalScrollIndicator  = YES;
    _PHzpscrollview.delegate                        = self;
    _PHzpscrollview.contentSize                     = CGSizeMake(KMainScreenWidth, 1000);
    [self.view addSubview:_PHzpscrollview];
    UIFont *Font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0f];//字体加粗
    UIFont *font = [UIFont systemFontOfSize:13.0f];//字体常规
    
#pragma  -mark 职位名称  20pt
    _Jobtitle= [[UILabel alloc]init];
    _Jobtitle.font = Font;
    _Jobtitle.text = [NSString stringWithFormat:@"%@",model.CompanyJobname];
//    _Jobtitle.backgroundColor = [UIColor cyanColor];
    // 根据字体得到NSString的尺寸
    CGSize jobtitlesize = [_Jobtitle.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font,NSFontAttributeName,nil]];
    CGFloat jobtitleW = jobtitlesize.width;
    _Jobtitle.frame = CGRectMake(10, 15, jobtitleW, 20);
    [_PHzpscrollview addSubview:_Jobtitle];
    
 #pragma  -mark 薪资待遇  20pt
    _Salary = [[UILabel alloc]init];
    _Salary.text =[NSString stringWithFormat:@"%@/月",model.Companysalary];
//    _Salary.backgroundColor = [UIColor cyanColor];
    _Salary.textColor = kTCColor(255, 116, 82);
    _Salary.font =font;
    // 根据字体得到NSString的尺寸
    CGSize sizesalary = [_Salary.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat sizesalaryW = sizesalary.width;
    _Salary.frame = CGRectMake(10+jobtitleW+10, 15, sizesalaryW, 20);
    [_PHzpscrollview addSubview:_Salary];
    
#pragma  -mark 人数  20pt
    _number             = [[UILabel alloc]init];
    _number.text        =[NSString stringWithFormat:@"招聘:%@人",model.Companynum];
//    _number.backgroundColor = [UIColor cyanColor];
    _number.textColor   = kTCColor(255, 116, 82);
    _number.font        =font;
    // 根据字体得到NSString的尺寸
    CGSize sizenumber   = [_number.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat sizenumberW = sizenumber.width;
    _number.frame       = CGRectMake(10+jobtitleW+20+sizesalaryW, 15, sizenumberW, 20);
    [_PHzpscrollview addSubview:_number];
    
#pragma  -mark 四个按钮开始 30pt
    _Region                     = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10+(KMainScreenWidth-20)/4*0, 40, (KMainScreenWidth-20)/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_Region setTitle:[NSString stringWithFormat:@"%@",model.Companycity] forState:UIControlStateNormal];
    [_Region setImage:[UIImage imageNamed:@"zpxx_dingwei@2x"] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_Region];
    [_Region setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _Region.titleLabel.font     = font;
    
    _Experience                 = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10+(KMainScreenWidth-20)/4*1, 40, (KMainScreenWidth-20)/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_Experience setTitle:[NSString stringWithFormat:@"%@",model.CompanySuffer] forState:UIControlStateNormal];
    [_Experience setImage:[UIImage imageNamed:@"zpxx_nianxian@2x"] forState:UIControlStateNormal];
    _Experience.titleLabel.font = font;

    [_Experience setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_Experience];
    
    _Education                  = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10+(KMainScreenWidth-20)/4*2, 40, (KMainScreenWidth-20)/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_Education setTitle:[NSString stringWithFormat:@"%@",model.Companyeducation] forState:UIControlStateNormal];
    [_Education setImage:[UIImage imageNamed:@"zpxx_xueli@2x"] forState:UIControlStateNormal];
    _Education.titleLabel.font  = font;
    [_Education setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_Education];
    
    _Nature                     = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10+(KMainScreenWidth-20)/4*3, 40, (KMainScreenWidth-20)/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_Nature setTitle:[NSString stringWithFormat:@"%@",model.Companynature] forState:UIControlStateNormal];
    [_Nature setImage:[UIImage imageNamed:@"zpxx_quanzhi@2x"] forState:UIControlStateNormal];
    _Nature.titleLabel.font     = font;
    [_Nature setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_Nature];
#pragma  -mark 四个按钮结束
    
#pragma  -mark 职位待遇描述 20pt
    _JobsalaryTX                = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 70, 20)];
    _JobsalaryTX.textColor      = kTCColor(161, 161, 161);
    _JobsalaryTX.text           = @"职位待遇:";
    _JobsalaryTX.font           = font;
    _JobsalaryTX.textAlignment  = NSTextAlignmentLeft;
    [_PHzpscrollview addSubview:_JobsalaryTX];
    
    
#pragma  -mark 职位待遇描述内容  100pt
    _Jobsalary                  =[[UITextView alloc]init];
    _Jobsalary.text             = [NSString stringWithFormat:@"%@",model.Companydeal];
    _Jobsalary.frame = CGRectMake(10, 105, KMainScreenWidth-20, [self heightForString:_Jobsalary andWidth:KMainScreenWidth-20]);
    _Jobsalary.editable         = NO;
    _Jobsalary.textColor        = kTCColor(161, 161, 161);
    [_PHzpscrollview addSubview:_Jobsalary];
    
#pragma  -mark   背景1 10pt
    _backgroude1                = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_Jobsalary.frame)+10, KMainScreenWidth, 10)];
    _backgroude1.backgroundColor= kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude1];
    
#pragma  -mark   职位描述 30pt
    _jobdescription                 = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_backgroude1.frame)+10, KMainScreenWidth/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_jobdescription setTitle:@"职位描述" forState:UIControlStateNormal];
    [_jobdescription setImage:[UIImage imageNamed:@"zpxx_mshu@2x"] forState:UIControlStateNormal];
    _jobdescription.titleLabel.font = Font;
    [_jobdescription setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_jobdescription];
    
#pragma  -mark   背景2  1pt
    _backgroude2                    = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_jobdescription.frame)+10, KMainScreenWidth-10, 1)];
    _backgroude2.backgroundColor    = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude2];
    
#pragma  -mark  职位描述内容 200pt
    _jobdescrip         = [[UITextView alloc]init];
    _jobdescrip.text    = [NSString stringWithFormat:@"%@",model.Companydescript] ;
     _jobdescrip.frame = CGRectMake(10, CGRectGetMaxY(_backgroude2.frame)+10, KMainScreenWidth-20, [self heightForString:_jobdescrip andWidth:KMainScreenWidth-20]);
    _jobdescrip.editable  = NO;
    _jobdescrip.textColor =kTCColor(161, 161, 161);
    [_PHzpscrollview addSubview:_jobdescrip];
    
#pragma  -mark   背景3 10pt
    _backgroude3                    = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_jobdescrip.frame)+10, KMainScreenWidth, 10)];
    _backgroude3.backgroundColor    = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude3];
    
#pragma  -mark  工作地址 30pt
    _jobaddess                  = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_backgroude3.frame)+10, KMainScreenWidth/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_jobaddess setTitle:@"工作地址" forState:UIControlStateNormal];
    [_jobaddess setImage:[UIImage imageNamed:@"zpxx_dingwei"] forState:UIControlStateNormal];
    _jobaddess.titleLabel.font  = Font;
    [_jobaddess setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_jobaddess];
    
#pragma  -mark   背景4  1pt
    _backgroude4                    = [[UILabel alloc]initWithFrame:CGRectMake(10,CGRectGetMaxY(_jobaddess.frame)+10, KMainScreenWidth-10, 1)];
    _backgroude4.backgroundColor    = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude4];
#pragma  -mark  工作地址 内容可以点击看公司地图所在
    _jobaddesslab                   = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_backgroude4.frame)+10, KMainScreenWidth-20, 30)];
    _jobaddesslab.text              =[NSString stringWithFormat:@"%@",model.Companyaddress] ;
    
    _jobaddesslab.textColor         = kTCColor(161, 161, 161);
    _jobaddesslab.font              =font;
    [_PHzpscrollview addSubview:_jobaddesslab];
#pragma  -mark  工作地址 内容加入点击事件
    UITapGestureRecognizer *addGes  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickadd)];
    [_jobaddesslab addGestureRecognizer:addGes];
     _jobaddesslab.userInteractionEnabled = YES;
    
#pragma  -mark   背景5 10pt
    _backgroude5                    = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_jobaddesslab.frame)+10, KMainScreenWidth, 10)];
    _backgroude5.backgroundColor    = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude5];
    
#pragma  -mark  公司信息 30pt
    _Company                        = [[ShoppingBtn alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_backgroude5.frame)+10, KMainScreenWidth/4, 30) buttonStyle:UIButtonStyleRight spaceing:5 imagesize:15];
    [_Company setTitle:@"店铺信息" forState:UIControlStateNormal];
    [_Company setImage:[UIImage imageNamed:@"zpxx_dingwei"] forState:UIControlStateNormal];
    _Company.titleLabel.font        = Font;
    [_Company setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PHzpscrollview addSubview:_Company];
#pragma  -mark   背景6 1pt
    _backgroude6                    = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_Company.frame)+10, KMainScreenWidth, 1)];
    _backgroude6.backgroundColor    = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude6];
    
#pragma  -mark   公司名称 20pt  
    _CompanynameTX                  = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_backgroude6.frame)+10, 70, 20)];
    _CompanynameTX.text             = @"店铺名称:";
    _CompanynameTX.font             = font;
    _CompanynameTX.textColor        = kTCColor(161, 161, 161);
    [_PHzpscrollview addSubview:_CompanynameTX];
    
    _Companyname                    = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_CompanynameTX.frame)+10, KMainScreenWidth-20, 20)];
    _Companyname.text               = [NSString stringWithFormat:@"%@",model.Companyname] ;
    _Companyname.font               = font;
    _Companyname.textColor          = kTCColor(161, 161, 161);
    [_PHzpscrollview addSubview:_Companyname];
#pragma  -mark   背景7 1pt
    _backgroude7 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_Companyname.frame)+10, KMainScreenWidth, 1)];
    _backgroude7.backgroundColor = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude7];
    
#pragma  -mark   公司简介 200pt
    _CompanyprofileTX = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_backgroude7.frame)+10, 70, 20)];
    _CompanyprofileTX.text = @"店铺简介:";
    _CompanyprofileTX.font = font;
    _CompanyprofileTX.textColor = kTCColor(161, 161, 161);
    [_PHzpscrollview addSubview:_CompanyprofileTX];
    
    _Companyprofile = [[UITextView alloc]init];
    _Companyprofile.text = [NSString stringWithFormat:@"%@",model.Companysummary] ;
     _Companyprofile.frame = CGRectMake(10, CGRectGetMaxY(_CompanyprofileTX.frame)+10, KMainScreenWidth-20, [self heightForString:_Companyprofile andWidth:KMainScreenWidth-20]);
    _Companyprofile.editable  = NO;
    _Companyprofile.textColor =kTCColor(161, 161, 161);
    [_PHzpscrollview addSubview:_Companyprofile];
#pragma  -mark   背景8 1pt
    _backgroude8 = [[UILabel alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(_Companyprofile.frame)+10, KMainScreenWidth, 20)];
    _backgroude8.backgroundColor = kTCColor(240, 240, 240);
    [_PHzpscrollview addSubview:_backgroude8];
    
    
    NSLog(@"%lf",CGRectGetMaxY(_backgroude8.frame));
    if (CGRectGetMaxY(_backgroude8.frame)<KMainScreenHeight) {
            _PHzpscrollview.contentSize     = CGSizeMake(KMainScreenWidth, KMainScreenHeight+50);
    }else{
            _PHzpscrollview.contentSize     = CGSizeMake(KMainScreenWidth, CGRectGetMaxY(_backgroude8.frame)+50);
    }

}

#pragma  -mark 电话咨询
-(void)HRclick{
    
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]) {
        [LEEAlert alert].config
        
        .LeeAddTitle(^(UILabel *label) {
            
            label.text =[NSString stringWithFormat:@"联系人:%@",model.Companyusername];
            
            label.textColor = [UIColor blackColor];
        })
        .LeeAddContent(^(UILabel *label) {
            label.text =[NSString stringWithFormat:@"TEL:%@",model.Companyuserphone];
            label.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        })
        
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeCancel;
            
            action.title = @"取消";
            
            action.titleColor = kTCColor(255, 255, 255);
            
            action.backgroundColor = kTCColor(174, 174, 174);
            
            action.clickBlock = ^{
                
                // 取消点击事件Block
            };
        })
        
        .LeeAddAction(^(LEEAction *action) {
            
            action.type = LEEActionTypeDefault;
            
            action.title = @"呼叫";
            
            action.titleColor = kTCColor(255, 255, 255);
            
            action.backgroundColor = kTCColor(77, 166, 214);
            
            action.clickBlock = ^{
                
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",model.Companyuserphone]]];
            };
        })
        .LeeHeaderColor(kTCColor(255, 255, 255))
        .LeeShow();
    }
    else{
      
        [YJLHUD showImage:nil message:@"请先登录账号"];//无图片 纯文字
        [YJLHUD dismissWithDelay:2];
    }
}

#pragma  -mark - 地址点击去地图查看
-(void)clickadd{
    
//    NSLog(@"地址=====%@",_jobaddesslab);
    MapcheckController *ctl = [[MapcheckController alloc]init];
    ctl.valueaddess         = _jobaddesslab.text;
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    [self.navigationController pushViewController:ctl animated:YES];
    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
    
//    NSLog(@"点击跳转看地图");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//     CGFloat offset = scrollView.contentOffset.y;
    
//    NSLog(@"%f",offset);
}
#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 按钮返回
- (void)BackButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"已经看过了我要返回");
}

#pragma -mark 获取数据
-(void)loaddata{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    if ([[[YJLUserDefaults shareObjet]getObjectformKey:YJLloginstate] isEqualToString:@"loginyes"]) {
        URL= [NSString stringWithFormat:@"%@?subid=%@&uid=%@",Hostrecruitpath,_shopsubid,[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]];
//        NSLog(@"登录店铺详情入境：%@",URL);
    }else{
        
        URL = [NSString stringWithFormat:@"%@?subid=%@",Hostrecruitpath,_shopsubid];
//        NSLog(@"未登录店铺详情入境：%@",URL);
    }
    
//    NSLog(@"下拉刷新请求入境：%@",URL);
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
            
            NSLog(@"可以拿到数据的");
            model                        = [[ShopsrecruitModel alloc]init];            //初始化一下
            model.CompanyJobname         = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"category"]]];
            model.Companyname            = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"name"]]];
            model.CompanySuffer          = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"experience"]]];
            model.Companyeducation       = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"edu"]]];
            model.Companysalary          = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"money"]]];
            model.Companynum             = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"number"]]];
            model.Companydeal            = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"deal"]]];
            model.Companydescript        = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"descript"]]];
            model.Companyaddress         = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"address"]]];
            model.Companysummary         = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"summary"]]];
            model.Companycity            = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"city"]]];
            model.Companynature          = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"nature"]]];
            model.Companyusername        = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"user"]]];
            model.Companyuserphone       = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]]];
            model.Companycollect       = responseObject[@"data"][@"collect"];
            NSLog(@"%@~%@~%@~%@",model.Companycollect,model.Companyusername,model.Companysummary, model.Companydeal);
           
#pragma  -mark 创建控件吧
            [self creatPHZP];
#pragma  -mark 根据不同进入的界面创建不同的按钮
            [self creatPHwhere];

            [YJLHUD dismissWithDelay:1];
        }else{
            
            NSLog(@"300--拿不到数据啊");
            [YJLHUD showErrorWithmessage:@"没有更多数据"];
            [YJLHUD dismissWithDelay:1];
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"请求数据失败----%@",error);
             if ( [error isEqual:@"Error Domain=NSURLErrorDomain Code=-1001"]) {
                 NSLog(@"网络数据连接超时了");
             }
             [YJLHUD showErrorWithmessage:@"服务器开小差了，稍等~"];
             [YJLHUD dismissWithDelay:1];

         }];
}

#pragma mark - 视图将要出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    //    让导航栏显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}
@end
