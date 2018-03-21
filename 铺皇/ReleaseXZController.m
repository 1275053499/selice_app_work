//
//  ReleaseXZController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ReleaseXZController.h"
#import "SRActionSheet.h"
@interface ReleaseXZController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
     BOOL phoneRight;
    
    UIBarButtonItem *rightButton;
    UIBarButtonItem *backItm;
}

@property (nonatomic,strong)UILabel     *ZWcategory;    //职位名称
@property (nonatomic,strong)UILabel     *ZWGSname;      //公司信息
@property (nonatomic,strong)UITextField *ZWuser;        //联系人
@property (nonatomic,strong)UITextField *ZWphone;       //联系号码
@property (nonatomic,strong)UITextField *ZWnum;         //招聘人数
@property (nonatomic,strong)UILabel     *ZWsalary;      //薪资待遇
@property (nonatomic,strong)UILabel     *ZWhighlight;   //职位亮点
@property (nonatomic,strong)UILabel     *ZWdescribe;    //职位描述
@property (nonatomic,strong)UILabel     *ZWaddress;     //工作地址
@property (nonatomic,strong)UILabel     *ZWnature;      //工作性质
@property (nonatomic,strong)UILabel     *ZWexperience;  //工作经验
@property (nonatomic,strong)UILabel     *ZWeducation;   //学历要求



@property(nonatomic,strong)UIImageView * Licenseimgview;     //营业执照
@property(nonatomic,strong)UIImageView * Cardimgview;        //身份证复印件

@property (nonatomic,strong)NSString  *  Photochange; //认证照片切换选择
@property (nonatomic,strong)NSString  *licenseYES; //有认证照片
@property (nonatomic,strong)NSString  *cardYES;    //有身份证照片

@end

@implementation ReleaseXZController


- (void)viewDidLoad {
    [super viewDidLoad];
#pragma  -mark 初始化cell控件
    [self creatcellUI];

    _row1value = [[NSString alloc]init];
    _row2value = [[NSString alloc]init];
    _row1value = @"0";
    _row2value = @"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged1:) name:@"UITextFieldTextDidChangeNotification" object:self.ZWnum];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged2:) name:@"UITextFieldTextDidChangeNotification" object:self.ZWuser];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged3:) name:@"UITextFieldTextDidChangeNotification" object:self.ZWphone];
    
   backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackreleaseXZ)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    
    
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(keepZP)];
    rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self.title = @"发布招聘";
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    
    self.tableView.showsVerticalScrollIndicator      = NO;
    self.tableView.delegate                          = self;
    self.tableView.dataSource                        = self;
    
    //    滚动条
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView = self.tableView;
    
    // 当cell比较少时强制去掉多余的分割线
    self.tableView.tableFooterView        =[[UIView alloc]init];//关键语句
    [self.view addSubview:self.tableView       ];
}

#pragma  -mark 初始化cell控件方法
-(void)creatcellUI{
    
#pragma mark    职位类别
    _ZWcategory = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWcategory.textAlignment       = NSTextAlignmentRight;
    _ZWcategory.font                = [UIFont systemFontOfSize:14.0];
    _ZWcategory.text                = @"请填写信息";
    _ZWcategory.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];


#pragma mark    店铺（公司）信息
    _ZWGSname                   = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWGSname.font              = [UIFont systemFontOfSize:14.0];
    _ZWGSname.textAlignment     = NSTextAlignmentRight;

    _ZWGSname.text                = @"请填写信息";
    _ZWGSname.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];

#pragma mark  招聘人数
    _ZWnum                  = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, KMainScreenWidth/2, 40)];
    _ZWnum.font             = [UIFont systemFontOfSize:14.0];
    _ZWnum.textColor        = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
    _ZWnum.keyboardType     = UIKeyboardTypeNumberPad;
    _ZWnum.clearButtonMode  = UITextFieldViewModeWhileEditing;
    _ZWnum.delegate         = self;
    _ZWnum.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];


    
#pragma -mark 联系人
    _ZWuser                 = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, KMainScreenWidth/2, 40)];
    _ZWuser.font            = [UIFont systemFontOfSize:14.0];
    _ZWuser.textColor       = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
    _ZWuser.keyboardType    = UIKeyboardTypeDefault;
    _ZWuser.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ZWuser.delegate        = self;
    _ZWuser.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];

#pragma -mark 联系方式
    _ZWphone                = [[UITextField alloc]initWithFrame:CGRectMake(0, 5, KMainScreenWidth/2, 40)];
    _ZWphone.font           = [UIFont systemFontOfSize:14.0];
    _ZWphone.textColor      = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
    _ZWphone.keyboardType   = UIKeyboardTypeNumberPad;
    _ZWphone.clearButtonMode= UITextFieldViewModeWhileEditing;
    _ZWphone.delegate       = self;
    _ZWphone.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];

//_ZWsalary;//薪资待遇
//_ZWhighlight;//职位亮点
//_ZWdescribe;//职位描述
//_ZWaddress;//工作地址
//_ZWnature;//工作性质
//_ZWexperience;//工作经验
//_ZWeducation;//学历要求
    
#pragma mark  职位薪资
    _ZWsalary = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWsalary.textAlignment       = NSTextAlignmentRight;
    _ZWsalary.font                = [UIFont systemFontOfSize:14.0];
    _ZWsalary.text                = @"请填写信息";
    _ZWsalary.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    
#pragma mark  职位待遇
    _ZWhighlight = [[UILabel alloc]init];
    
    _ZWhighlight.textAlignment       = NSTextAlignmentRight;
    _ZWhighlight.font                = [UIFont systemFontOfSize:14.0];
    _ZWhighlight.numberOfLines       = 0;
    _ZWhighlight.textColor           =[UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZWhighlight.text                = @"请填写信息";
//    _ZWhighlight.backgroundColor = [UIColor blueColor];
    _ZWhighlight.frame = CGRectMake(80, 5, KMainScreenWidth-105,[self getContactHeight:_ZWhighlight.text]);

#pragma mark  职位描述
    _ZWdescribe                     = [[UILabel alloc]init];
    _ZWdescribe.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZWdescribe.text                = @"请填写信息";
    _ZWdescribe.textAlignment       = NSTextAlignmentRight;
    _ZWdescribe.numberOfLines       =  0;
    _ZWdescribe.font                = [UIFont systemFontOfSize:14.0];
//    _ZWdescribe.backgroundColor = [UIColor blueColor];
    _ZWdescribe.frame = CGRectMake(80, 5, KMainScreenWidth-105,[self getContactHeight:_ZWdescribe.text]);

#pragma mark  工作地址
    _ZWaddress                     = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWaddress.textAlignment       = NSTextAlignmentRight;
    _ZWaddress.font                = [UIFont systemFontOfSize:14.0];
    _ZWaddress.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZWaddress.text                = @"请填写信息";
    
#pragma mark  工作性质
    _ZWnature                     = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWnature.textAlignment       = NSTextAlignmentRight;
    _ZWnature.font                = [UIFont systemFontOfSize:14.0];
    _ZWnature.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZWnature.text                = @"请填写信息";
    
#pragma mark  工作经验
    _ZWexperience                     = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWexperience.textAlignment       = NSTextAlignmentRight;
    _ZWexperience.font                = [UIFont systemFontOfSize:14.0];
    _ZWexperience.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _ZWexperience.text                = @"请填写信息";

#pragma mark  学历要求
    _ZWeducation                     = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _ZWeducation.textAlignment       = NSTextAlignmentRight;
    _ZWeducation.font                = [UIFont systemFontOfSize:14.0];
    _ZWeducation.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];//灰色
    _ZWeducation.text                = @"请填写信息";
    
    self.Licenseimgview                          = [[UIImageView alloc]init];
    self.Licenseimgview.frame                    = CGRectMake(KMainScreenWidth-150, 10, 140, 180);
    self.Licenseimgview.contentMode              = UIViewContentModeScaleAspectFit;
    self.Licenseimgview.image                    = [UIImage imageNamed:@"Ac_bg"];

    self.Cardimgview                             = [[UIImageView alloc]init];
    self.Cardimgview.frame                       = CGRectMake(KMainScreenWidth-150, 10, 140, 180);
    self.Cardimgview.contentMode                 = UIViewContentModeScaleAspectFit;
    self.Cardimgview.image                       = [UIImage imageNamed:@"Ac_bg"];

}

#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [_ZWuser resignFirstResponder];
    [_ZWphone resignFirstResponder];
    [_ZWnum resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - Tableviewdatasource  代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 6;
    }
    
    if (section == 1 ||section == 3) {
        return 2;
    }
    else{
        return 4;
    }
}
#pragma mark
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"职位类别";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:_ZWcategory];
                }
                    
                    break;
                case 1:{
                    cell.textLabel.text = @"店铺信息";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:_ZWGSname];
                }
                    
                    break;
                case 2:{
                    cell.textLabel.text = @"招聘人数";
                    _ZWnum.textAlignment = NSTextAlignmentRight;
                    _ZWnum.placeholder = @"输入招聘人数";
                    cell.accessoryView = _ZWnum;
                }
                    
                    break;
                case 3:{
                    cell.textLabel.text = @"基本薪资";
                  
                    [cell.contentView addSubview:_ZWsalary];
                }
                    
                    break;
                case 4:{
                    cell.textLabel.text = @"联系人";
                    _ZWuser.textAlignment = NSTextAlignmentRight;
                    _ZWuser.placeholder = @"输入联系人";
                    cell.accessoryView = _ZWuser;
                }
                    
                    break;
                default:{
                    cell.textLabel.text = @"联系方式";
                    _ZWphone.textAlignment = NSTextAlignmentRight;
                    _ZWphone.placeholder = @"输入联系方式";
                    cell.accessoryView = _ZWphone;
                }
                    break;
            }
            
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"职位待遇";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:_ZWhighlight];
                    cell.contentView.height = [self getContactHeight:_ZWhighlight.text]+10;
                    _ZWhighlight.frame = CGRectMake(80, 5, KMainScreenWidth-105, [self getContactHeight:_ZWhighlight.text]);
                }
                
                    break;
                    
                default:{
                    cell.textLabel.text = @"职位描述";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:_ZWdescribe];
                    cell.contentView.height = [self getContactHeight:_ZWdescribe.text]+10;
                    _ZWdescribe.frame = CGRectMake(80, 5, KMainScreenWidth-105, [self getContactHeight:_ZWdescribe.text]);
                    
                }
                    break;
            }
        }
            
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"工作地址";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.contentView addSubview:_ZWaddress];
                }
                    
                    break;
                case 1:{
                    cell.textLabel.text = @"工作性质";
                  
                    [cell.contentView addSubview:_ZWnature];
                }
                    
                    break;
                case 2:{
                    cell.textLabel.text = @"工作经验";
              
                    [cell.contentView addSubview:_ZWexperience];
                }
                    
                    break;
                    
                default:{
                    cell.textLabel.text = @"学历要求";
    
                    [cell.contentView addSubview:_ZWeducation];
                }
                    break;
            }
        }
            
            break;
        default:{
            switch (indexPath.row) {
                case 0:{
                            cell.textLabel.text = @"身份证照片(选填)";
                            [cell.contentView addSubview:self.Cardimgview];
                }
                    break;
                    
                default:{
                    cell.textLabel.text               =   @"店铺营业执照";
                    cell.detailTextLabel.text         =   @"店铺租赁合同(选填)";
                    cell.detailTextLabel.textColor    = [UIColor blackColor];
                    [cell.contentView addSubview:self.Licenseimgview];
                }
                    break;
            }
            
        }
            break;
    }
    //_ZWsalary;//薪资待遇
    //_ZWhighlight;//职位亮点
    //_ZWdescribe;//职位描述
    //_ZWaddress;//工作地址
    //_ZWnature;//工作性质
    //_ZWexperience;//工作经验
    //_ZWeducation;//学历要求
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}

-(float)getContactHeight:(NSString*)contact{
    
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:14.0]};
    CGSize maxSize = CGSizeMake(KMainScreenWidth-100, MAXFLOAT);
    
    // 计算文字占据的高度
    CGSize size = [contact boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    if (size.height<50) {
        return 50;
    }else{
        return size.height;
    }
}

#pragma mark
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
             return  [self getContactHeight:_ZWhighlight.text]+10;
        }
        else{
            
            return  [self getContactHeight:_ZWdescribe.text]+10;
        }
    }
    
    if (indexPath.section ==3) {
        return 200;
    }
    return 50;
}



#pragma mark 段与段之间间隔
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return  0;
    }
    
    return 10;
}


#pragma -mark 代理方法传值
-(void)passedValue:(NSString *)inputValue1 :(NSString *)inputValue2{
    
    NSLog(@"传至位置：%@-%@",inputValue1,inputValue2);
    _row1value = inputValue1;
    _row2value = inputValue2;
}
#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark    键盘垫下去
    
    [_ZWnum   resignFirstResponder];
    [_ZWuser  resignFirstResponder];
    [_ZWphone resignFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"第%ld段---第%ld行",(long)indexPath.section,(long)indexPath.row);

    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row){
                case 0:{
#pragma mark 职位类别
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    NSLog(@"%@",cell.textLabel.text);
                    ZWcategoryController  *ctl = [[ZWcategoryController alloc]init];
                    ctl.delegate = self;
                    
                    ctl.labvalue = _ZWcategory.text;
                    ctl.row1value = _row1value;
                    ctl.row2value = _row2value;
                    ctl.returnValueBlock = ^(NSString *strValue){
                        
                        NSLog(@"职位类别内容:%@",strValue);
                        _ZWcategory.text   =   strValue;
                        _ZWcategory.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                    };
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }
                    break;
                case 1:{
#pragma mark 公司信息
                    NSLog(@"公司信息");
                    NSLog(@"%@",cell.textLabel.text);
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    Companyinformontroller  *ctl = [[Companyinformontroller alloc]init];
                    ctl. nameValue= _ZWGSname.text;
                    ctl.profileValue =_ZWGSprifestrstr;
                    ctl.returnValueBlockname= ^(NSString *nameValue){
                        
                        NSLog(@"店铺名称：%@",nameValue);
                        _ZWGSname.text=nameValue;
                        _ZWGSname.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                    };
                    
                    
                    ctl.returnValueBlockpfofile=^(NSString *profileValue){
                        
                        _ZWGSprifestrstr = [NSString stringWithFormat:@"%@",profileValue];
                        NSLog(@"店铺简介：%@",profileValue);
                    };
                    
               
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                    
                case 2:{
#pragma mark 招聘人数
                    NSLog(@"招聘人数");
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
                case 3:{
#pragma mark 职位薪资
                    NSLog(@"职位薪资");
                    NSLog(@"%@",cell.textLabel.text);
                    
                    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                cancelTitle:@"取消"
                                                                           destructiveTitle:nil
                                                                                otherTitles:@[@"1K～3K", @"3K～5K",@"5K～8K",@"8K～10K",@"10K以上",@"面议"]
                                                                                otherImages:nil
                                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                              
                                                                              NSLog(@"%zd", index);
                                                                              
                                                                              switch (index) {
                                                                                  case 0:
                                                                                  {
                                                                                      _ZWsalary.text = @"1K～3K/月";
                                                                                      _ZWsalary.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 1:
                                                                                  {
                                                                                      _ZWsalary.text = @"3K～5K/月";
                                                                                      _ZWsalary.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 2:
                                                                                  {
                                                                                      _ZWsalary.text = @"5K～8K/月";
                                                                                      _ZWsalary.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 3:
                                                                                  {
                                                                                      _ZWsalary.text = @"8K～10K/月";
                                                                                      _ZWsalary.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 4:
                                                                                  {
                                                                                      _ZWsalary.text = @"10K以上/月";
                                                                                      _ZWsalary.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 5:
                                                                                  {
                                                                                      _ZWsalary.text = @"面议";
                                                                                      _ZWsalary.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                              }
                                                                          }];
                    [actionSheet show];
                }
                    break;
                case 4:{
#pragma mark 招聘人数
                    NSLog(@"联系人");
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
                default:{
#pragma mark 招聘人数
                    NSLog(@"联系方式");
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
                    
        }
            }
            break;
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
#pragma mark 职位亮点
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    NSLog(@"职位待遇");
                    NSLog(@"%@",cell.textLabel.text);
                    ZWhighlightController  *ctl = [[ZWhighlightController alloc]init];
                    ctl.labvalue = _ZWhighlight.text;
                    ctl.returnValueBlock = ^(NSString *strValue)
                    {
                        NSLog(@"传值过来后的内容%@",strValue);
                        if (strValue.length==0) {
                            _ZWhighlight.text =@"您尚未填写信息";
                        }
                        
                        else{
                            
                            _ZWhighlight.text = strValue;
                        }
                        
                        _ZWhighlight.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                        if (_ZWhighlight.text.length % 19 > 0 && _ZWhighlight.text.length>19) {
                            _ZWhighlight.textAlignment = NSTextAlignmentLeft;
                        }else{
                            _ZWhighlight.textAlignment = NSTextAlignmentRight;
                        }
                        
                         [self.tableView reloadData];
                    };
                    
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    
                    break;
                    
                default:{
#pragma mark 职位描述
                    NSLog(@"职位描述");
                    NSLog(@"%@",cell.textLabel.text);
                    
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    ZWdescribeController  *ctl = [[ZWdescribeController alloc]init];
                    ctl.labvalue = _ZWdescribe.text;
                    ctl.returnValueBlock = ^(NSString *strValue)
                    {
                        NSLog(@"传值过来后的内容%@",strValue);
                        if (strValue.length==0) {
                            _ZWdescribe.text =@"您尚未填写信息";
                        }
                        else{
                            _ZWdescribe.text = strValue;
                        }
                        
                        _ZWdescribe.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                        if (_ZWdescribe.text.length % 19 > 0 && _ZWdescribe.text.length>19) {
                            _ZWdescribe.textAlignment = NSTextAlignmentLeft;
                        }else{
                            _ZWdescribe.textAlignment = NSTextAlignmentRight;
                        }
                         [self.tableView reloadData];
                    };
                    
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
#pragma mark 工作地址
                    //            NSLog(@"工作地址");
                    NSLog(@"%@",cell.textLabel.text);
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    ZWaddressController  *ctl   = [[ZWaddressController alloc]init];
                    
                    ctl.labvalue                = _ZWaddress.text;
                    NSLog(@"传值过去%@",ctl.labvalue);
                    ctl.labvalueadd             = _ZWaddstrstr;
                    //            城市
                    ctl.returnValueBlock        = ^(NSString *strValue)
                    {
                        NSLog(@"传值过来后的内容%@",strValue);
                        if (strValue.length==0)
                        {
                            NSLog(@"999==%@",strValue);
                            
                        }
                        else
                            
                        {
                            _ZWaddress.text             = strValue;
                            _ZWaddress.lineBreakMode    = NSLineBreakByTruncatingMiddle;
                        }
                        
                        _ZWaddress.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                    };
                    
                    //            具体地址
                    ctl.returnValueBlockadd         = ^(NSString *addValue){
                        
                        _ZWaddstrstr                   = [NSString stringWithFormat:@"%@",addValue];
                        NSLog(@" 值===%@",addValue);
                    };
        
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                }
                    break;
                case 1:{
#pragma mark 工作性质
                    NSLog(@"工作性质");
                    NSLog(@"%@",cell.textLabel.text);
                    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                cancelTitle:@"取消"
                                                                           destructiveTitle:nil
                                                                                otherTitles:@[@"全职", @"兼职", @"实习生"]
                                                                                otherImages:nil
                                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                              
                                                                              NSLog(@"%zd", index);
                                                                              
                                                                              switch (index) {
                                                                                  case 0:
                                                                                  {
                                                                                      _ZWnature.text = @"全职";
                                                                                      _ZWnature.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 1:
                                                                                  {
                                                                                      _ZWnature.text = @"兼职";
                                                                                      _ZWnature.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 2:
                                                                                  {
                                                                                      _ZWnature.text = @"实习生";
                                                                                      _ZWnature.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                              }
                                                                          }];
                    [actionSheet show];
                }
                    break;
                case 2:{
#pragma mark 工作经验
                    NSLog(@"工作经验");
                    NSLog(@"%@",cell.textLabel.text);
                    
                    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                cancelTitle:@"取消"
                                                                           destructiveTitle:nil
                                                                                otherTitles:@[@"不限", @"应届毕业生", @"1～3年",@"3～5年", @"5～10年", @"10年以上"]
                                                                                otherImages:nil
                                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                              
                                                                              NSLog(@"%zd", index);
                                                                              
                                                                              switch (index) {
                                                                                  case 0:
                                                                                  {
                                                                                      _ZWexperience.text = @"不限";
                                                                                      _ZWexperience.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 1:
                                                                                  {
                                                                                      _ZWexperience.text = @"应届毕业生";
                                                                                      _ZWexperience.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 2:
                                                                                  {
                                                                                      _ZWexperience.text = @"1～3年";
                                                                                      _ZWexperience.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                      
                                                                                  case 3:
                                                                                  {
                                                                                      _ZWexperience.text = @"3～5年";
                                                                                      _ZWexperience.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 4:
                                                                                  {
                                                                                      _ZWexperience.text = @"5～10年";
                                                                                      _ZWexperience.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 5:
                                                                                  {
                                                                                      _ZWexperience.text = @"10年以上";
                                                                                      _ZWexperience.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                              }
                                                                          }];
                    [actionSheet show];
                }
                    break;
                case 3:{
#pragma mark 学历要求
                    NSLog(@"学历要求");
                    NSLog(@"%@",cell.textLabel.text);
                    
                    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                cancelTitle:@"取消"
                                                                           destructiveTitle:nil
                                                                                otherTitles:@[@"不限", @"初中", @"高中", @"大专", @"本科",@"硕士"]
                                                                                otherImages:nil
                                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                              
                                                                              NSLog(@"%zd", index);
                                                                              
                                                                              switch (index) {
                                                                                  case 0:
                                                                                  {
                                                                                      _ZWeducation.text = @"不限";
                                                                                      _ZWeducation.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 1:
                                                                                  {
                                                                                      _ZWeducation.text = @"初中";
                                                                                      _ZWeducation.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                  }
                                                                                      break;
                                                                                  case 2:
                                                                                  {
                                                                                      _ZWeducation.text = @"高中";
                                                                                      _ZWeducation.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 3:
                                                                                  {
                                                                                      _ZWeducation.text = @"大专";
                                                                                      _ZWeducation.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 4:
                                                                                  {
                                                                                      _ZWeducation.text = @"本科";
                                                                                      _ZWeducation.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                      
                                                                                  case 5:
                                                                                  {
                                                                                      _ZWeducation.text = @"硕士";
                                                                                      _ZWeducation.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                              }
                                                                          }];
                    [actionSheet show];
                    
                }
                    break;
                default:{
                    
                }
                    break;
            }
        }
            break;
        default:{
            
                    switch (indexPath.row) {
                        case 0:{
                        
                                     //                身份证
                                     self.Photochange = [NSString new];
                                     self.Photochange = @"card";
                                     [self usephoto];
                            
                        }
                            break;
                            
                        default:{
                            
                            //                营业执照
                            NSLog(@"营业执照");
                            self.Photochange = [NSString new];
                            self.Photochange = @"lice";
                            [self usephoto];
                           
            
                        }
                            break;
                    }
        }
            break;
     }
}


-(void)takelocaCamera{
    
    //    AVAuthorizationStatusNotDetermined = 0,没有询问是否开启相机
    //    AVAuthorizationStatusRestricted    = 1,未授权，家长限制
    //    AVAuthorizationStatusDenied        = 2,//未授权
    //    AVAuthorizationStatusAuthorized    = 3,玩家授权
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
    }];
    
    //判断相机是否能够使用
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    if (status == AVAuthorizationStatusAuthorized) {
        /**********   已经授权 可以打开相机   ***********/
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        /**********   已经授权 可以打开相机   ***********/
    }else if (status == AVAuthorizationStatusNotDetermined){
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                //第一次用户接受
                    [self presentViewController:picker animated:YES completion:nil];
            }else{
                //用户拒绝
            }
        }];
    }else if (status == AVAuthorizationStatusRestricted){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的相机权限受限" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }else if (status == AVAuthorizationStatusDenied){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (iOS8) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                NSURL *privacyUrl;
                
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    [[UIApplication sharedApplication] openURL:privacyUrl];
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"取消");
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alertController addAction:cancleAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }
}


-(void)takelocaPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    //相册的权限
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        
        NSLog(@"Authorized");
        [self presentViewController:picker animated:YES completion:nil];
        
    }else if (photoAuthorStatus == PHAuthorizationStatusDenied){
        
        NSLog(@"Denied");
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (iOS8) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                NSURL *privacyUrl;
                
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
                if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                    [[UIApplication sharedApplication] openURL:privacyUrl];
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"取消");
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alertController addAction:cancleAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
        
    }else if (photoAuthorStatus == PHAuthorizationStatusNotDetermined){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"Authorized");
                [self presentViewController:picker animated:YES completion:nil];
            }else{
                NSLog(@"Denied or Restricted");
            }
        }];
        NSLog(@"not Determined");
        
    }else if (photoAuthorStatus == PHAuthorizationStatusRestricted){
        
        NSLog(@"Restricted");
        
    }
}

#pragma 上传照片 弹框
-(void)usephoto{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请上传合理的照片，避免不必要的麻烦，谢谢合作!" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"个性拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"拍照");
            [self takelocaCamera];
            
        }];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"相册/图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"相册");
            [self takelocaPhoto];
            
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [alertController addAction:saveAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    });
}



//在这里创建一个路径，用来在照相的代理方法里作为照片存储的路径
-(NSString *)getImageSaveliceZPPath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath  = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath  = [documentPath stringByAppendingPathComponent:@"liceZPPhotoFile"];
    return imageDocPath;
}

//在这里创建一个路径，用来在照相的代理方法里作为照片存储的路径
-(NSString *)getImageSavecardZPPath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath  = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath  = [documentPath stringByAppendingPathComponent:@"cardZPPhotoFile"];
    return imageDocPath;
}

#pragma mark - 图片选择器的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([self.Photochange isEqualToString:@"lice"]) {
        NSLog(@"获取到照片到信息===%@",info);
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.Licenseimgview.image = image;
        NSString *imageDocPath = [self getImageSaveliceZPPath];//保存
        self.licenseYES = [NSString new];
        self.licenseYES = @"licenseYES";
        NSLog(@"imageDocPath == %@", imageDocPath);
        [picker dismissViewControllerAnimated:YES completion:NULL];
        
    }else if([self.Photochange isEqualToString:@"card"]) {
        NSLog(@"获取到照片到信息===%@",info);
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.Cardimgview.image = image;
        NSString *imageDocPath = [self getImageSavecardZPPath];//保存
        self.cardYES = [NSString new];
        self.cardYES = @"cardYES";
        NSLog(@"imageDocPath == %@", imageDocPath);
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"您取消了选择图片");
    }];
}

#pragma mark - UITextFieldDelegate 限制字数
-(void)textFiledEditChanged1:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    if (toBeString.length-1 > 20 && toBeString.length>1) {
        textField.text = [toBeString substringToIndex:4];
    }
}

-(void)textFiledEditChanged2:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    if (toBeString.length-1 > 15 && toBeString.length>1) {
        textField.text = [toBeString substringToIndex:4];
    }
}

-(void)textFiledEditChanged3:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    if (toBeString.length-1 > 11 && toBeString.length>1) {
        textField.text = [toBeString substringToIndex:12];
    }
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self back];
}

#pragma  back  返回
-(void)BackreleaseXZ{
    [self back];
}


-(void)back{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您真的要放弃发布招聘信息了么？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"已经看过了我要返回");
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 发布招聘
-(void)keepZP{
    
    rightButton.enabled = NO;
    [self lodatamassege];
}

-(void)lodatamassege{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"查询服务...."];
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
  
    NSDictionary *params = @{
                                 @"id":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                             };
    [manager GET:Myservicezpbagpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject){
       
//        NSLog(@"请求成功咧");
//        NSLog(@"数据:%@", responseObject[@"data"]);
       
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            
             NSString * recruits = [NSString new];
            for (NSDictionary *dic in responseObject[@"data"]){
                
                NSLog(@"数据:%@",dic[@"recruits"]);
                recruits = dic[@"recruits"];

            }
            
            if ( [recruits integerValue] > 0) {
                
                [YJLHUD showSuccessWithmessage:@"查询成功"];
               [YJLHUD dismissWithDelay:0.2];

                [self upload];
                
            }else{
    
                [YJLHUD showErrorWithmessage:@"查询失败"];
                [YJLHUD dismissWithDelay:1];
            
                rightButton.enabled = YES;

                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您目前没有可发布的招聘信息量，请先去购买" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了购买");
                    
                    self.hidesBottomBarWhenPushed = YES;
                    RecruitserviceController *ctl = [[RecruitserviceController alloc]init];
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;
                    
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了取消");
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:commitAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
        }
        
        else{

            [YJLHUD showErrorWithmessage:@"查询失败"];
            [YJLHUD dismissWithDelay:1];
            rightButton.enabled = YES;
            
            //code 401
            NSLog(@"不可以拿到数据的");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您目前没有可发布的招聘信息量，请先去购买" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"购买" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了购买");
                
                self.hidesBottomBarWhenPushed = YES;
                RecruitserviceController *ctl = [[RecruitserviceController alloc]init];
                [self.navigationController pushViewController:ctl animated:YES];
                self.hidesBottomBarWhenPushed = YES;
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消");
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         rightButton.enabled = YES;
        
        [YJLHUD showErrorWithmessage:@"网络数据连接出现问题了,请检查一下"];
        [YJLHUD dismissWithDelay:1];
       
    }];
}


#pragma -mark 数据上传后台吧
-(void)upload{
    
    NSLog(@"职位名称%@"       ,self.ZWcategory.text      );
    NSLog(@"店铺信息:%@-%@"   ,self.ZWGSname.text,self.ZWGSprifestrstr);
    NSLog(@"招聘人数：%@"      ,self.ZWnum.text       );
    NSLog(@"薪资待遇：%@"      ,self.ZWsalary.text          );
    NSLog(@"联系人  ：%@"      ,self.ZWuser.text       );
    NSLog(@"联系号码：%@"      ,self.ZWphone.text       );
    NSLog(@"职位亮点：%@"      ,self.ZWhighlight.text );
    NSLog(@"职位描述：%@"      ,self.ZWdescribe.text       );
    NSLog(@"工作地址：%@-%@"   ,self.ZWaddress.text,self.ZWaddstrstr   );
    NSLog(@"工作性质：%@"      ,self.ZWnature.text     );
    NSLog(@"工作经验：%@"      ,self.ZWexperience.text     );
    NSLog(@"学历要求：%@"      ,self.ZWeducation.text     );
    
     [self isMobileNumber:self.ZWphone.text];
    
    if (phoneRight!=0) {
        
        NSString *Allmessage = [NSString new];
        Allmessage = @"请填写信息";
        if ([self.ZWcategory.text isEqualToString:Allmessage]|| [self.ZWGSname.text isEqualToString:Allmessage]|| [self.ZWsalary.text isEqualToString:Allmessage]|| [self.ZWhighlight.text isEqualToString:Allmessage]|| [self.ZWdescribe.text isEqualToString:Allmessage]|| [self.ZWaddress.text isEqualToString:Allmessage]|| [self.ZWnature.text isEqualToString:Allmessage]|| [self.ZWexperience.text isEqualToString:Allmessage]|| [self.ZWeducation.text isEqualToString:Allmessage]||self.ZWnum.text.length<1||self.ZWuser.text.length<1||self.ZWphone.text.length<1){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"好像漏掉了什么信息，需要完善一下" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"完善信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                NSLog(@"点击了确认");
                rightButton.enabled = YES;
            }];
            
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            
//            上传数据
 [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"发布服务中...."];
            NSDictionary *params = @{
                                             @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                             @"uid":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                                     };
            NSLog(@"账号字典内容 = %@",params);
#pragma - marl     发布招聘信息
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10.0;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
            [manager POST:Hostrecruitupload parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                
                if ([self.licenseYES isEqualToString: @"licenseYES"]) {
                    //        营业执照
                    NSDateFormatter *formatterlice1      = [[NSDateFormatter alloc] init];
                    formatterlice1.dateFormat            = @"yyyyMMddHHmmss";
                    NSString *fileNamelice1              = [NSString stringWithFormat:@"%@.png", [formatterlice1 stringFromDate:[NSDate date]]];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(_Licenseimgview.image, 0.1) name:@"license" fileName:fileNamelice1 mimeType:@"image/png"];
                    NSLog(@"营业执照图片名字：%@",fileNamelice1);
                }
                if ([self.cardYES isEqualToString:@"cardYES"]) {
            
                //        身份证信息
                    NSDateFormatter *formattercord1      = [[NSDateFormatter alloc] init];
                    formattercord1.dateFormat            = @"ddMMyyyyHHmmss";
                    NSString *fileNamecord1              = [NSString stringWithFormat:@"%@.png", [formattercord1 stringFromDate:[NSDate date]]];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(_Cardimgview.image, 0.1) name:@"card" fileName:fileNamecord1 mimeType:@"image/png"];
                    NSLog(@"身份证图片名字：%@",fileNamecord1);
                }
                
               
 //                职位类型
                [formData appendPartWithFormData:[self.ZWcategory.text dataUsingEncoding:NSUTF8StringEncoding] name:@"category"];
//                店铺标题
                [formData appendPartWithFormData:[self.ZWGSname.text dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
//                店铺简介
                [formData appendPartWithFormData:[self.ZWGSprifestrstr dataUsingEncoding:NSUTF8StringEncoding] name:@"summary"];
//                招聘人数
                [formData appendPartWithFormData:[self.ZWnum.text dataUsingEncoding:NSUTF8StringEncoding] name:@"number"];
//                薪资待遇
                NSArray *salaryarr = @[@"1K～3K/月",@"3K～5K/月",@"5K～8K/月",@"8K～10K/月",@"10K以上/月",@"面议"];
                NSString *salarystr = [[NSString alloc]init];
                for (int i =0; i < salaryarr.count; i++){
                    
                    if ([self.ZWsalary.text isEqualToString:salaryarr[i]]){
                        
                        salarystr = [NSString stringWithFormat:@"%d",i+1];
                    }
                }
                NSLog(@"薪资====== %@ ",salarystr);
                [formData appendPartWithFormData:[salarystr dataUsingEncoding:NSUTF8StringEncoding] name:@"money"];

//                联系人
                NSData*data5=[self.ZWuser.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data5 name:@"user"];
//                联系方式
                NSData*data6=[self.ZWphone.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data6 name:@"phone"];
//                职位待遇
                NSData*data7=[self.ZWhighlight.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data7 name:@"deal"];
//                职位描述
                NSData*data8=[self.ZWdescribe.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:data8 name:@"descript"];
                
//                工作地址区域
                NSString *addstr = [NSString stringWithFormat:@"%@",self.ZWaddress.text];
//                addstr = [addstr stringByReplacingOccurrencesOfString:@" " withString:@","];//替换字符
                [formData appendPartWithFormData:[[addstr stringByReplacingOccurrencesOfString:@" " withString:@","] dataUsingEncoding:NSUTF8StringEncoding] name:@"district"];
                
//                工作地址详细
                [formData appendPartWithFormData:[self.ZWaddstrstr dataUsingEncoding:NSUTF8StringEncoding] name:@"address"];
                
//                工作性质
                NSArray *naturearr = @[@"全职",@"兼职",@"实习生"];
                NSString *naturestr = [[NSString alloc]init];
                for (int i =0; i < naturearr.count; i++){
                    
                    if ([self.ZWnature.text isEqualToString:naturearr[i]]){
                        
                        naturestr = [NSString stringWithFormat:@"%d",i+1];
                        
                    }
                }
                NSLog(@"性质====== %@ ",naturestr);
                [formData appendPartWithFormData:[naturestr dataUsingEncoding:NSUTF8StringEncoding] name:@"nature"];
                
//                工作经验
                NSArray *experarr = @[@"不限",@"应届毕业生",@"1～3年",@"3～5年",@"5～10年",@"10年以上"];
                NSString *experstr = [[NSString alloc]init];
                for (int i =0; i < experarr.count; i++){
                    
                    if ([self.ZWexperience.text isEqualToString:experarr[i]]){
                        
                        experstr = [NSString stringWithFormat:@"%d",i+1];
                    }
                }
                
                NSLog(@"经验====== %@ ",experstr);
                [formData appendPartWithFormData:[experstr dataUsingEncoding:NSUTF8StringEncoding] name:@"experience"];
//                学历要求
                NSArray *eduarr = @[@"不限",@"初中",@"高中",@"大专",@"本科",@"硕士"];
                NSString *edustr = [[NSString alloc]init];
                for (int i =0; i < eduarr.count; i++){
                    
                    if ([self.ZWeducation.text isEqualToString:eduarr[i]]){
                        edustr = [NSString stringWithFormat:@"%d",i+1];
                    }
                }
                NSLog(@"学历====== %@ ",edustr);
                [formData appendPartWithFormData:[edustr dataUsingEncoding:NSUTF8StringEncoding] name:@"edu"];
                
                
            }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      [YJLHUD showSuccessWithmessage:@"发布成功"];
                      [YJLHUD dismissWithDelay:0.5];
                      rightButton.enabled = YES;
                      NSLog(@"招聘信息返回数据：%@",responseObject);
                      //                  上传成功提示信息
                    [self aleartwin:[NSString stringWithFormat:@"%@",responseObject[@"code"]]:[NSString stringWithFormat:@"%@",responseObject[@"massign"]]];
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      [YJLHUD showErrorWithmessage:@"发布失败"];
                      [YJLHUD dismissWithDelay:.5];
                      rightButton.enabled = YES;
                      [self aleartfaile];
                      NSLog(@"请求失败=%@",error);
                  }];
        }
    }
    
    else{
        
        rightButton.enabled = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的号码为空号，请修改" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认");
            
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}


#pragma -mark上传成功提示信息
-(void)aleartwin:(NSString *)code :(NSString *)massign{
    NSLog(@"%@",code);
    if ([code isEqualToString:@"305"]) {
        [self aleartfaile];
    }
    else{//200
        
        //        @"您的信息发布成功，可以到您的个人中心查看"
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功" message:@"待审核通过即可服务，可前往发布中心查看服务状态" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消");
           
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认");

            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
             InformaZPController *ctl = [InformaZPController new];
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。

        }];
        
        [alertController addAction:cancleAction];
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma -mark上传失败提示信息
-(void)aleartfaile{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信息发布失败，是否继续发布？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了取消");
    }];
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认");
            [self upload];
    }];
    
    [alertController addAction:cancleAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma -mark 验证号码的正确性
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[014-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     14         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189          181
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";//增加181号码
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    
    NSString * THPHS = @"^0(10|2[0-9]|\\d{3})\\d{7,8}$";
    
    /**
     29         * 大陆地区4位固话
     30         * 区号：0755 0733
     31         * 号码：八位
     32         */
    NSString * FOPHS = @"^0([1-9][0-9][0-9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct     = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestTHPHS  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", THPHS];
    NSPredicate *regextestFOPHS  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", FOPHS];
    
    //    电话号码是可用的
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)||([regextestTHPHS evaluateWithObject:mobileNum])==YES||([regextestFOPHS evaluateWithObject:mobileNum])==YES){
        phoneRight = 1;
        return YES;
    }
    else{
        
        phoneRight = 0;
        return NO;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}



@end
