//
//  ReleaseZSController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/12.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ReleaseZSController.h"
#import "HXProvincialCitiesCountiesPickerview.h"
#import "HXAddressManager.h"
#import "ZYKeyboardUtil.h"
#define MARGIN_KEYBOARD 10
@interface ReleaseZSController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>{
    BOOL phoneRight;
}
@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@property (nonatomic,strong)NSString    *XZaddess;
@property (nonatomic,strong)UITextField *XZtitle;
@property (nonatomic,strong)UITextField *XZarea;
@property (nonatomic,strong)UILabel     *XZareasub;
@property (nonatomic,strong)UILabel     *XZtype;
@property (nonatomic,strong)NSString    *XZtypeid;
@property (nonatomic,strong)UITextField *XZrent;
@property (nonatomic,strong)UILabel     *XZrentsub;
@property (nonatomic,strong)UILabel     *XZcity;

@property (nonatomic,strong)UITextField     *XZperson;//联系人
@property (nonatomic,strong)UITextField     *XZnumber;//手机号码
@property (nonatomic,strong)UILabel     *XZdescribe;//描述
@property (nonatomic,strong)UILabel     *XZSupportlab;//配套设施
@property (nonatomic,strong)NSString    *XZSupportid;//配套设施id
@property (nonatomic,strong)NSString    *Internetcheck;//网络检测

@end

@implementation ReleaseZSController


- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma  -mark 初始化cell控件
    [self creatcellUI];

    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(BackreleaseZS)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    self.title = @"发布选址";
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(keepXZ)];
    rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
   #pragma  -mark右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight)];
    
    tableView.showsVerticalScrollIndicator      = NO;
    tableView.delegate                          = self;
    tableView.dataSource                        = self;
    
 #pragma  -mark   滚动条
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    self.tableView = tableView;
    
   #pragma  -mark 当cell比较少时强制去掉多余的分割线
    self.tableView.tableFooterView        =[[UIView alloc]init];//关键语句
    [self.view addSubview:tableView       ];
    
    
 #pragma  -mark 通知限制输入字数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedtitle:) name:@"UITextFieldTextDidChangeNotification" object:self.XZtitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedarea:) name:@"UITextFieldTextDidChangeNotification" object:self.XZarea];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedrent:) name:@"UITextFieldTextDidChangeNotification" object:self.XZrent];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedperson:) name:@"UITextFieldTextDidChangeNotification" object:self.XZperson];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangednumber:) name:@"UITextFieldTextDidChangeNotification" object:self.XZnumber];
    
#pragma -mark 网络检测
    [self reachability];
}

#pragma mark 网络检测
-(void)reachability{
    
    //    网络检测
    //    AFNetworkReachabilityStatusUnknown              = -1, 未知信号
    //    AFNetworkReachabilityStatusNotReachable      = 0,  无连接网络
    //    AFNetworkReachabilityStatusReachableViaWWAN = 1,  3G网络
    //    AFNetworkReachabilityStatusReachableViaWiFi      = 2,  WIFI网络
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"status=%ld",status);
        
        switch (status) {
            case 0:{
                NSLog(@"无连接网络");
                _Internetcheck  =@"0";
            }
                break;
            case 1:{
                NSLog(@"3G网络");
                _Internetcheck  =@"1";
            }
                break;
            case 2:{
                NSLog(@"WIFI网络");
                _Internetcheck  =@"2";
            }
                break;
            default:{
                
                NSLog(@"未知网络错误");
                _Internetcheck  =@"-1";
            }
                break;
        }
    }];
}


#pragma  -mark 初始化cell控件方法
-(void)creatcellUI{
    _XZtypeid       =   [[NSString alloc]init];
    _XZaddess       =   [[NSString alloc]init];
    _XZSupportid    =   [[NSString alloc]init];
    
#pragma mark    标题
    _XZtitle                    = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-70, 50)];
    _XZtitle.font               = [UIFont systemFontOfSize:12.0];
    _XZtitle.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZtitle.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _XZtitle.returnKeyType      = UIReturnKeyDefault;
    _XZtitle.textAlignment      = NSTextAlignmentRight;
    _XZtitle.placeholder        = @"输入发布标题（20字以内）";
    _XZtitle.font               = [UIFont systemFontOfSize:12.0];
    _XZtitle.delegate = self;
    _XZtitle.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色

#pragma mark    类型
    _XZtype = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-70, 50)];
    _XZtype.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZtype.text                = @"请填写信息";
    _XZtype.textAlignment       = NSTextAlignmentRight;
    _XZtype.font                = [UIFont systemFontOfSize:12.0];
    
#pragma mark    面积
    _XZarea                     = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-70, 50)];
    _XZarea.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZarea.textAlignment       = NSTextAlignmentRight;
    _XZarea.clearButtonMode     = UITextFieldViewModeWhileEditing;
    _XZarea.keyboardType        = UIKeyboardTypeNumberPad;
//    _XZarea.backgroundColor     = [UIColor redColor];
    _XZarea.placeholder         = @"输入期望面积";
    _XZarea.font                = [UIFont systemFontOfSize:14.0];
    _XZarea.delegate            = self;
    _XZarea.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
    
    _XZareasub                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
    _XZareasub.textColor        = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZareasub.text             = @"平方";
    _XZareasub.textAlignment    = NSTextAlignmentCenter;
    _XZareasub.font             = [UIFont systemFontOfSize:14.0];
    
    _XZarea.rightView           = _XZareasub;
    _XZarea.rightViewMode       = UITextFieldViewModeAlways;//左边视图显示模式
    
#pragma mark    租金
    _XZrent                     = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-100, 50)];
    _XZrent.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZrent.placeholder         = @"输入期望租金";
    _XZrent.keyboardType        = UIKeyboardTypeNumberPad;
    _XZrent.textAlignment       = NSTextAlignmentRight;
    _XZrent.clearButtonMode     = UITextFieldViewModeWhileEditing;
    _XZrent.font                = [UIFont systemFontOfSize:14.0];
    _XZrent.delegate            = self;
    _XZrent.textColor           = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
    _XZrentsub                  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    _XZrentsub.textColor        = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZrentsub.text             = @"千元";
    _XZrentsub.textAlignment    = NSTextAlignmentCenter;
    _XZrentsub.font             = [UIFont systemFontOfSize:14.0];
    
    _XZrent.rightView           = _XZrentsub;
    _XZrent.rightViewMode       = UITextFieldViewModeAlways;//左边视图显示模式
    
#pragma mark    城市区域
    _XZcity = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth-100, 50)];
    _XZcity.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    _XZcity.text                = @"请填写信息";
    _XZcity.textAlignment       = NSTextAlignmentRight;
    _XZcity.font                = [UIFont systemFontOfSize:12.0];
    
    
#pragma mark  联系人
    _XZperson                    = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _XZperson.font               = [UIFont systemFontOfSize:12.0];
    _XZperson.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _XZperson.textAlignment      = NSTextAlignmentRight;
    _XZperson.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _XZperson.placeholder        = @"请填写联系人";
    _XZperson.delegate           =self;
    _XZperson.textColor          = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色

#pragma mark  手机号码
    _XZnumber                    = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _XZnumber.font               = [UIFont systemFontOfSize:12.0];
    _XZnumber.textColor          = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _XZnumber.textAlignment      = NSTextAlignmentRight;
    _XZnumber.keyboardType       = UIKeyboardTypeNumberPad;
    _XZnumber.clearButtonMode    = UITextFieldViewModeWhileEditing;
    _XZnumber.delegate           = self;
    _XZnumber.placeholder        = @"请填写联系号码";
    _XZnumber.textColor          = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
    
#pragma mark  描述
    _XZdescribe                     = [[UILabel alloc]initWithFrame:CGRectMake(75, 5, KMainScreenWidth-100, 90)];
    _XZdescribe.font                = [UIFont systemFontOfSize:12.0];
    _XZdescribe.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _XZdescribe.textAlignment       = NSTextAlignmentRight;
    _XZdescribe.numberOfLines = 0;
    _XZdescribe.text                = @"请填写信息";
    
#pragma mark  配套设施
    _XZSupportlab                       = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, KMainScreenWidth-100, 50)];
    _XZSupportlab.font                  = [UIFont systemFontOfSize:12.0];
    _XZSupportlab.textColor             = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0 ];
    _XZSupportlab.textAlignment         = NSTextAlignmentRight;
    _XZSupportlab.numberOfLines         = 0;
    _XZSupportlab.text                  = @"请填写信息";
    
//键盘处理
     [self configKeyBoardRespond];
}

- (void)configKeyBoardRespond {
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    __weak ReleaseZSController *weakSelf = self;
#pragma explain - 全自动键盘弹出/收起处理 (需调用keyboardUtil 的 adaptiveViewHandleWithController:adaptiveView:)
#pragma explain - use animateWhenKeyboardAppearBlock, animateWhenKeyboardAppearAutomaticAnimBlock will be invalid.
    
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.XZnumber, weakSelf.XZperson, weakSelf.XZrent, weakSelf.XZarea, weakSelf.XZtitle,nil];
    }];
    
#pragma explain - 获取键盘信息
    [_keyboardUtil setPrintKeyboardInfoBlock:^(ZYKeyboardUtil *keyboardUtil, KeyboardInfo *keyboardInfo) {
        NSLog(@"\n\n拿到键盘信息 和 ZYKeyboardUtil对象");
    }];
}

#pragma 当点击键盘的返回键键盘下去
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 当点击键盘的返回键（右下角）时，执行该方法。
    // 一般用来隐藏键盘
    [_XZtitle resignFirstResponder];
    [_XZarea  resignFirstResponder];
    [_XZrent  resignFirstResponder];
    [_XZnumber  resignFirstResponder];
    [_XZperson resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

#pragma mark - UITextFieldDelegate 限制标题字数
-(void)textFiledEditChangedtitle:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length-1 > 50 && toBeString.length>1){
        textField.text = [toBeString substringToIndex:21];
    }
}

#pragma mark - UITextFieldDelegate 限制联系人字数
-(void)textFiledEditChangedperson:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length-1 > 20 && toBeString.length>1){
        textField.text = [toBeString substringToIndex:5];
    }
}

#pragma mark - UITextFieldDelegate 限制联系号码字数
-(void)textFiledEditChangednumber:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (toBeString.length-1 > 11 && toBeString.length>1){
        textField.text = [toBeString substringToIndex:12];
    }
}

#pragma mark - UITextFieldDelegate 限制面积字数
-(void)textFiledEditChangedarea:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 4 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:5];
    }
}

#pragma mark - UITextFieldDelegate 限制租金字数
-(void)textFiledEditChangedrent:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    
    if (toBeString.length-1 > 4 && toBeString.length>1){
        
        textField.text = [toBeString substringToIndex:5];
    }
}

#pragma  -mark tableviewcell代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section){
        case 0:{
            return 8;
        }
            break;
            
        default:{
            return 1;
        }
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    cell.textLabel.text = @"标题";
                    cell.accessoryView  = _XZtitle;
                }
                    break;
                case 1:{
                    cell.textLabel.text = @"面积";
                    cell.accessoryView  = _XZarea;
                    
                }
                    break;
                case 2:{
                    cell.textLabel.text = @"租金";
                    cell.accessoryView  = _XZrent;
                                    }
                    break;
                case 3:{
                    cell.textLabel.text = @"类型";
                    cell.accessoryView  =_XZtype;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 4:{
                    cell.textLabel.text = @"城市区域";
                    cell.accessoryView  = _XZcity;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 5:{
                    cell.textLabel.text = @"配套设施";
                    [cell.contentView addSubview:_XZSupportlab];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                    break;
                case 6:{
                    cell.textLabel.text = @"联系人";
                   
                    [cell.contentView addSubview:_XZperson];
                }
                    break;
                    
                default:{
                    cell.textLabel.text = @"联系号码";
                    [cell.contentView addSubview:_XZnumber];
                }
                    break;
            }
        }
        
            break;
            
        default:{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.contentView addSubview:_XZdescribe];
            cell.textLabel.text = @"详情描述";
        }
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    #pragma mark 描述比较大
   
    if (indexPath.section == 1) {
        return 100;
    }
        return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return 10;
}
#pragma mark cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第%ld列-第%ld行",(long)indexPath.section,(long)indexPath.row);
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
#pragma mark    键盘垫下去
    [_XZtitle resignFirstResponder];
    [_XZrent resignFirstResponder];
    [_XZarea resignFirstResponder];
    [_XZperson resignFirstResponder];
    [_XZnumber resignFirstResponder];
    switch (indexPath.section) {
        case 0:{
            
            switch (indexPath.row) {
                case 0:{
                   
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
                case 1:{
                    
                    NSLog(@"%@",cell.textLabel.text);
#pragma mark 加载面积
                    
                }
                    break;
                case 2:{
                    
#pragma mark 加载租金
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
                case 3:{
                    
                    NSLog(@"%@",cell.textLabel.text);
#pragma mark 加载类型
                    
                    SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                                cancelTitle:@"取消"
                                                                           destructiveTitle:nil
                                                                                otherTitles:@[@"餐饮美食", @"美容美发", @"服饰鞋包", @"休闲娱乐", @"百货超市", @"生活服务", @"电子通讯", @"汽车服务", @"医疗保险", @"家具建材", @"教育培训", @"酒店宾馆"]
                                                                                otherImages:nil
                                                                          selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                              
                                                                              NSLog(@"%zd", index);
                                                                              _XZtypeid = [NSString stringWithFormat:@"%ld",index+1];
                                                                              switch (index) {
                                                                                  case 0:
                                                                                  {
                                                                                      _XZtype.text = @"餐饮美食";
                                                                                       _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 1:
                                                                                  {
                                                                                      _XZtype.text = @"美容美发";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 2:
                                                                                  {
                                                                                      _XZtype.text = @"服饰鞋包";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 3:
                                                                                  {
                                                                                      _XZtype.text = @"休闲娱乐";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 4:
                                                                                  {
                                                                                      _XZtype.text = @"百货超市";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 5:
                                                                                  {
                                                                                      _XZtype.text = @"生活服务";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 6:
                                                                                  {
                                                                                      _XZtype.text = @"电子通讯";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                  case 7:
                                                                                  {
                                                                                      _XZtype.text = @"汽车服务";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 8:
                                                                                  {
                                                                                      _XZtype.text = @"医疗保险";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 9:
                                                                                  {
                                                                                      _XZtype.text = @"家居建材";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                      
                                                                                  }
                                                                                      break;
                                                                                  case 10:
                                                                                  {
                                                                                      _XZtype.text = @"教育培训";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                  }
                                                                                      break;
                                                                                      break;
                                                                                  default:{
                                                                                      _XZtype.text = @"酒店宾馆";
                                                                                      _XZtype.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];//主题色
                                                                                  }
                                                                                      break;
                                                                              }
                                                                          }];
                    [actionSheet show];

                  }
                    break;
                case 4:{
                    
#pragma mark 加载城市
                    NSLog(@"%@",cell.textLabel.text);
                    
                    if ([_XZcity.text isEqualToString:@"请填写信息"]) {
                        _XZaddess = @"广东 深圳 宝安区";
                    }else{
                        _XZaddess = _XZcity.text;
                    }
                    NSArray  *array =[_XZaddess componentsSeparatedByString:@" "];
                    NSString *province = @"";//省
                    NSString *city = @"";//市
                    NSString *county = @"";//县
                    if (array.count > 2) {
                        province = array[0];
                        city = array[1];
                        county = array[2];
                    } else if (array.count > 1) {
                        province = array[0];
                        city = array[1];
                    } else if (array.count > 0) {
                        province = array[0];
                    }
#pragma  -mark 城市选择 调用
                    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
                }
                    break;
                case 5:{
                    
#pragma  -mark 配套设施
                   NSLog(@"%@",cell.textLabel.text);
                     self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    ZRfacilityController *ctl = [[ZRfacilityController alloc]init];
#pragma mark - block传值 设施
                    ctl.returnValueBlock = ^(NSString *strValue){
                        
                        NSLog(@"传值过来后的内容%@",strValue);
                        if (strValue.length==0) {
                                                    _XZSupportlab.text =@"您尚未填写信息";
                        }
                        else{
                                                    _XZSupportlab.text = strValue;
                        }
                        _XZSupportlab.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
                    };
                    
                    ctl.returnValueBlockid=^(NSString *strValue){
                        
                        NSLog(@"传值过来后的内容ID=%@",strValue);
                        _XZSupportid = strValue;
                        
                    };
                    [self.navigationController pushViewController:ctl animated:YES];
                     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
                }
                    break;
                case 6:{
                    
                    NSLog(@"%@",cell.textLabel.text);
                    //                   联系人
                    NSLog(@"可联系人");
                    NSLog(@"%@",cell.textLabel.text);
                    
                }
                    break;
                    
                default:{
                    
                    NSLog(@"手机号码");
                    NSLog(@"%@",cell.textLabel.text);
                }
                    break;
            }
        }
            
            break;
            
        default:{
            
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            //                    店铺描述
            NSLog(@"%@",cell.textLabel.text);
            ZRdescribeController *ctl = [[ZRdescribeController alloc]init];
            ctl.labvalue =_XZdescribe.text;
#pragma mark - block传值 店铺描述
            ctl.returnValueBlock = ^(NSString *strValue){
                
                NSLog(@"传值过来后的内容%@",strValue);
                if (strValue.length==0){
                    _XZdescribe.text =@"您尚未填写信息";
                }
                else{
                    
                    _XZdescribe.text = strValue;
                    _XZdescribe.lineBreakMode = NSLineBreakByTruncatingMiddle;
                }
                _XZdescribe.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
            };
            
            [self.navigationController pushViewController:ctl animated:YES];
             self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示
        }
            break;
    }
}

#pragma  -mark 城市选择方法
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            self.XZcity.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
            self.XZcity.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

#pragma  -mark 发布选址内容
-(void)keepXZ{
    NSLog(@"发布选址信息");
    
    switch (_Internetcheck.integerValue){
            
        case 0:{
            NSLog(@"无连接网络");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"由于您的网络错误，信息发布失败" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                                NSLog(@"点击了确认");
                                               
                            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了设置");
                //                    跳转的URL写法:
                //                    无线局域网 App-Prefs:root=WIFI
                //                    蓝牙 App-Prefs:root=Bluetooth
                //                    蜂窝移动网络 App-Prefs:root=MOBILE_DATA_SETTINGS_ID
                //                    个人热点 App-Prefs:root=INTERNET_TETHERING
                //                    运营商 App-Prefs:root=Carrier
                //                    通知 App-Prefs:root=NOTIFICATIONS_ID
                //                    通用 App-Prefs:root=General
                //                    通用-关于本机 App-Prefs:root=General&path=About
                //                    通用-键盘 App-Prefs:root=General&path=Keyboard
                //                    通用-辅助功能 App-Prefs:root=General&path=ACCESSIBILITY
                //                    通用-语言与地区 App-Prefs:root=General&path=INTERNATIONAL
                //                    通用-还原 App-Prefs:root=Reset
                //                    墙纸 App-Prefs:root=Wallpaper
                //                    Siri App-Prefs:root=SIRI
                //                    隐私 App-Prefs:root=Privacy
                //                    Safari App-Prefs:root=SAFARI
                //                    音乐 App-Prefs:root=MUSIC
                //                    音乐-均衡器 App-Prefs:root=MUSIC&path=com.apple.Music:EQ
                //                    照片与相机 App-Prefs:root=Photos
                //                    FaceTime App-Prefs:root=FACETIME
                
                //                     NSString * urlStr = @"App-Prefs:root=Bluetooth";
                
                if (iOS10) {
                    
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }
                
                else
                {
                    //                        ios6
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            }];
            
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
            
        case 1:{
            
            NSLog(@"3G网络");
            [self upload];
            
        }
            break;
        case 2:{
            
            NSLog(@"WIFI网络");
            [self upload];
            
        }
            break;
        default:{
            
            NSLog(@"未知信号");
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络错误，请检查网络状态" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了设置");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
                
            }];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击了取消");
                
            }];
            [alertController addAction:commitAction];
            [alertController addAction:cancleAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
    }
}

#pragma -mark 数据上传后台吧
-(void)upload{
    
    //    @property (nonatomic,strong)NSString  *XZaddess;
    //    @property (nonatomic,strong)UITextField *XZtitle;
    //    @property (nonatomic,strong)UITextField *XZarea;
    //    @property (nonatomic,strong)UILabel *XZareasub;
    //    @property (nonatomic,strong)UILabel *XZtype;
    //    @property (nonatomic,strong)NSString *XZtypeid;
    //    @property (nonatomic,strong)UITextField *XZrent;
    //    @property (nonatomic,strong)UILabel *XZrentsub;
    //    @property (nonatomic,strong)UILabel *XZcity;
    //
    //    @property (nonatomic,strong)UILabel   *XZperson;//联系人
    //    @property (nonatomic,strong)UILabel   *XZnumber;//手机号码
    //    @property (nonatomic,strong)UILabel   *XZdescribe;//描述
    //    @property (nonatomic,strong)UILabel   *XZSupportlab;//配套设施
    //    @property (nonatomic,strong)NSString  *XZSupportid;//配套设施id
    //    @property (nonatomic,strong)NSString *Internetcheck;//网络检测
    NSLog(@"标题：%@"      ,self.XZtitle.text      );
    NSLog(@"面积：%@"      ,self.XZarea.text       );
    NSLog(@"行业：%@"      ,self.XZtype.text       );
    NSLog(@"行业id：%@"    ,self.XZtypeid          );
    NSLog(@"租金：%@"      ,self.XZrent.text       );
    NSLog(@"城市区域：%@"   ,self.XZcity.text       );
    NSLog(@"配套：%@"      ,self.XZSupportlab.text );
    NSLog(@"配套ID：%@"    ,self.XZSupportid       );
    NSLog(@"描述：%@"      ,self.XZdescribe.text   );
    NSLog(@"联系人：%@"     ,self.XZperson.text     );
    NSLog(@"号码：%@"      ,self.XZnumber.text     );
    
    [self isMobileNumber:_XZnumber.text];
    //电话号码正确
    if (phoneRight != 0)
    {
      
        if (self.XZtitle.text.length<1||self.XZarea.text.length<1||self.XZrent.text.length<1||[self.XZtype.text isEqualToString:@"请填写信息"]||[self.XZcity.text isEqualToString:@"请填写信息"]||[self.XZSupportlab.text isEqualToString:@"请填写信息"]||[self.XZperson.text isEqualToString:@"请填写信息"]||[self.XZnumber.text isEqualToString:@"请填写信息"]||[self.XZdescribe.text isEqualToString:@"请填写信息"]||[self.XZSupportlab.text isEqualToString:@"您尚未填写信息"]||[self.XZperson.text isEqualToString:@"您尚未填写信息"]||[self.XZnumber.text isEqualToString:@"您尚未填写信息"]||[self.XZdescribe.text isEqualToString:@"您尚未填写信息"]) {
           
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"好像漏掉了什么信息，需要完善一下" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"完善信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                
                NSLog(@"点击了确认");
                
            }];
            
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            
             [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"发布服务中...."];
            
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10.0;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
            
            //2.上传文件,在这里我们还要求传别的参数，用字典保存一下，不需要的童鞋可以省略此步骤
            NSDictionary *params = @{
                                         @"publisher":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                     };
            
            [manager POST:Hostselectionupload parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                
                //    名称
                NSData*datatitle=[self.XZtitle.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:datatitle name:@"title"];
                
                //    面积
                NSData*dataarea=[self.XZarea.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:dataarea name:@"areas"];
                
                //    租金
                NSData*datarent=[self.XZrent.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:datarent name:@"rent"];
                
                //    区域
                self.XZcity.text = [self.XZcity.text stringByReplacingOccurrencesOfString:@" " withString:@","];//替换字符
                NSData*datacity=[self.XZcity.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:datacity name:@"area"];
                
                //   行业
                NSData*type=[self.XZtypeid dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:type name:@"type"];
                
                //    配套设施id
                NSData*datasupport=[self.XZSupportid dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:datasupport name:@"facility"];
                
                //    联系人
                
                NSData*dataperson=[self.XZperson.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:dataperson name:@"person"];
                
                //    联系电话
                NSData*dataphone=[self.XZnumber.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:dataphone name:@"phone"];
                
                //    描述
                NSData*datadescri=[self.XZdescribe.text dataUsingEncoding:NSUTF8StringEncoding];
                [formData appendPartWithFormData:datadescri name:@"detail"];
                
            }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                      NSLog(@"请求成功=%@",responseObject);
                      [YJLHUD dismiss];
                      //                  上传成功提示信息
                      [self aleartwin:[NSString stringWithFormat:@"%@",responseObject[@"code"]]];
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                      [self aleartfaile];
                      [YJLHUD dismiss];
                      NSLog(@"请求失败=%@",error);
                  }];
        }

    }
    
    //电话号码出错
    else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的号码为空号，请修改" preferredStyle:UIAlertControllerStyleAlert];
       
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击了确认");
            
        }];
        
        [alertController addAction:commitAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma -mark上传成功提示信息
-(void)aleartwin:(NSString *)code{
    
    
    switch ([code integerValue]) {
        case 200:{
            //        发布成功提示
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功" message:@"待审核通过即可服务，可前往发布中心查看服务状态" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了取消");
                    
                }];
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了确认");
                   
                    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
                    InformaXZController *ctl = [InformaXZController new];
                    [self.navigationController pushViewController:ctl animated:YES];
                    self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
                    
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertController addAction:cancleAction];
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            });
            
            
        }
            
            break;
        case 300:{
            //        发布失败提示
            [self aleartfaile];
        }
            
            break;
        case 309:{
            //        发布失败提示
            [self aleartfaile];
        }
            
            break;
        case 406:{
            //        今日发布量达到上限
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的发布有限，请明日再来!" preferredStyle:UIAlertControllerStyleAlert];
               
                UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"明日再来" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击了确认");
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alertController addAction:commitAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                });
            });
            
        }
            break;
        default:{
            
        }
            break;
    }
    
    NSLog(@"%@",code);
}

#pragma -mark上传失败提示信息
-(void)aleartfaile{
    
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的信息发布失败，点击【确认】重新发布" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了确认");
        [self upload];
    }];
    
          dispatch_async(dispatch_get_main_queue(), ^{
              [alertController addAction:cancleAction];
              [alertController addAction:commitAction];
              [self presentViewController:alertController animated:YES completion:nil];
          });
      });
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您真的要放弃发布选址信息了么？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        NSLog(@"点击了确认");
        
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"已经看过了我要返回");
    }];
    
     dispatch_async(dispatch_get_main_queue(), ^{
             [alertController addAction:cancleAction];
             [alertController addAction:commitAction];
             [self presentViewController:alertController animated:YES completion:nil];
         });
     });
}

#pragma  back
-(void)BackreleaseZS{

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        // 耗时的操作
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您真的要放弃发布选址信息了么？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了取消");
        }];
        
        UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSLog(@"点击了确认");
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"已经看过了我要返回");
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [self presentViewController:alertController animated:YES completion:nil];
        });
    });
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
   
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

@end
