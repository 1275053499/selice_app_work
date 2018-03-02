//
//  PersonhomeController.m
//  铺皇
//  Created by 铺皇网 on 2017/5/15.
//  Copyright © 2017年 中国铺皇. All rights reserved.

#import "PersonhomeController.h"
#import "HXProvincialCitiesCountiesPickerview.h"
#import "HXAddressManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@interface PersonhomeController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    NSInteger           _count;               //倒计时
}
@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;
@property (nonatomic,strong)NSString  *XZaddess;

@property(nonatomic,strong)UIImageView * personimgview;     //个人头像
@property(nonatomic,strong)UILabel     * personnickname;    //个人昵称
@property(nonatomic,strong)UILabel     * personnicknumber;  //个人电话
@property(nonatomic,strong)UILabel     * personsex;         //性别
@property(nonatomic,strong)UILabel     * personcity;        //城市

@property(nonatomic,strong)NSString    * personsignature;        //签名回传接收

//网络需要
@property(nonatomic,strong)NSString * personimgStr;          //个人头像str
@property(nonatomic,strong)NSString * personnicknameStr;     //个人昵称str
@property(nonatomic,strong)NSString * personsexStr;          //个人性别str
@property(nonatomic,strong)NSString * personuserStr;         //个人账户str
@property(nonatomic,strong)NSString * personidStr;           //个人IDstr
@property(nonatomic,strong)NSString * personpasswordStr;     //个人密码str
@property(nonatomic,strong)NSString * personcityStr;         //个人城市str
@property(nonatomic,strong)NSString * personsignatureStr;    //个人签名str

@property (nonatomic,strong)NSMutableArray *DataArr;

@property float autoSizeScaleX;
@property float autoSizeScaleY;
//手机
@property (nonatomic, assign)BOOL phoneRight;

@end

@implementation PersonhomeController

-(NSMutableArray*)DataArr{
    if (_DataArr == nil) {
        _DataArr =[[NSMutableArray alloc]init];
    }
    return  _DataArr;
}

-(NSString *)personsignature{
    if (_personsignature == nil) {
        _personsignature = [[NSString alloc]init];
    }
    return _personsignature;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    
    [self BuildBase];
//    创建一些cell上面的小控间
    [self creatUI];
    
//    判断数据库信息内容
    [self ishasdata];
}

-(void)ishasdata{
//    数据库取数据
    _DataArr = [[pershowData shareshowperData]getAllDatas];
//    
    if (_DataArr.count == 0){
        NSLog(@"没有数据");
        
//              请求数据
         [self LoadpersonData];
    }
    else{
        
        NSLog(@"有数据");
         personshowmodel *model = [_DataArr objectAtIndex:0];
        _personimgStr          = model.personimage;
        _personnicknameStr     = model.personnickname;
        _personsignatureStr    = model.personsignature;
//        NSLog(@"123131321312313131=%@",_personimgStr);
//        赋值到控件上面
        [_personimgview sd_setImageWithURL:[NSURL URLWithString:model.personimage] placeholderImage:nil];                //图片
        _personnickname.text    =   model.personnickname;        //昵称
        _personsex.text         =   model.personsex;             //性别
        _personnicknumber.text  =   model.personphone;           //电话
        _personcity.text        =   model.personcity;            //城市
        self.personsignatureStr =   model.personsignature;       //签名
    }
}

#pragma -mark
-(void)LoadpersonData{
   
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中..."];
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10.0;
    NSDictionary *params = @{
                                @"phone":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]
                               };
    //    13163241430 徐静
    [manager POST:Personshowpath parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"返---------%@",responseObject);
        
        _personidStr        =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"id"]]       ];//ID
        _personimgStr       =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"image"]]    ];//头像
        _personnicknameStr  =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]] ];//昵称
        _personsexStr       =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"sex"]]      ];//性别
        _personuserStr      =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]]    ];//用户账号
        _personcityStr      =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"city"]]     ];//城市
        _personsignatureStr =  [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"signature"]]];//签名
        
//        赋值到控件上面
        [_personimgview sd_setImageWithURL:[NSURL URLWithString:_personimgStr] placeholderImage:nil];                //图片
        _personnickname.text=_personnicknameStr;         //昵称
        _personsex.text     = _personsexStr;             //性别
        _personnicknumber.text=_personuserStr;           //电话
        if ( _personcityStr.length == 0) {               //城市
            _personcity.text=@"广东 深圳 宝安区";
        }
        else{
            _personcity.text=_personcityStr;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"信息失败----%@",error);
    }];
    
    [YJLHUD dismiss];
}

-(void)BuildBase{
    
    self.title = @"个人详情";
    self.view.backgroundColor = kTCColor(255, 255, 255);
    //    适配必要使用
    //    *_autoSizeScaleX
    //    *_autoSizeScaleY
    if(KMainScreenHeight < 667){                                 // 这里以(iPhone6)为准
        _autoSizeScaleX = KMainScreenWidth/375;
        _autoSizeScaleY = KMainScreenHeight/667;
    }else{
        _autoSizeScaleX = 1.0;
        _autoSizeScaleY = 1.0;
    }
    
    NSLog(@"X比例=%f,Y比例=%f",_autoSizeScaleX,_autoSizeScaleY);
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(keeppersonEdit)];
    rightButton.tintColor=[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
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

#pragma mark -创建一些cell上面的小控间
-(void)creatUI{
    
    self.tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStylePlain];
    
    self.tableView.showsVerticalScrollIndicator =NO;
    self.tableView.delegate      = self;
    self.tableView.dataSource    = self;
    //    滚动条
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    [self.view addSubview:self.tableView];
    
    //    当cell比较少时强制去掉多余的分割线
    self.tableView.tableFooterView      =[[UIView alloc]init];//关键语句
    
    //    初始化头像
    _personimgview = [[UIImageView alloc]init];
    _personimgview.frame =CGRectMake(0, 0, 100*_autoSizeScaleY, 100*_autoSizeScaleY);  //图片
    _personimgview.autoresizingMask     = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _personimgview.layer.masksToBounds  = YES;
    _personimgview.layer.cornerRadius   = 50.0*_autoSizeScaleX;
    _personimgview.layer.borderColor    = [UIColor whiteColor].CGColor;
    _personimgview.layer.borderWidth    = 3.0f;
    _personimgview.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _personimgview.layer.shouldRasterize = YES;
    _personimgview.clipsToBounds         = YES;
    
    _personnickname                 = [[UILabel alloc]init];
    _personnickname.frame           = CGRectMake(190*_autoSizeScaleX, 15*_autoSizeScaleY, 150*_autoSizeScaleX, 30*_autoSizeScaleY);
    _personnickname.textAlignment   = NSTextAlignmentRight;
//    _personnickname.text=_personnicknameStr;         //昵称
    _personnickname.font            = [UIFont systemFontOfSize:14.0];
    _personnickname.textColor       = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    
    _personsex                      = [[UILabel alloc]init];
    _personsex.frame                = CGRectMake(190*_autoSizeScaleX, 15*_autoSizeScaleY, 150*_autoSizeScaleX, 30*_autoSizeScaleY);
//    _personsex.text = _personsexStr;                //性别
    _personsex.font                 = [UIFont systemFontOfSize:14.0];
    _personsex.textAlignment        = NSTextAlignmentRight;
    _personsex.textColor            = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    
    _personnicknumber               = [[UILabel alloc]init];
    _personnicknumber.frame         = CGRectMake(190*_autoSizeScaleX, 15*_autoSizeScaleY, 150*_autoSizeScaleX, 30*_autoSizeScaleY);
    _personnicknumber.textAlignment = NSTextAlignmentRight;
//    _personnicknumber.text=_personuserStr;          //电话
    _personnicknumber.font          = [UIFont systemFontOfSize:14.0];
    _personnicknumber.textColor     = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
    
    _personcity                     = [[UILabel alloc]init];
    _personcity.frame               = CGRectMake(150*_autoSizeScaleX, 15*_autoSizeScaleY, 190*_autoSizeScaleX, 30*_autoSizeScaleY);
    _personcity.textAlignment       = NSTextAlignmentRight;
    
    _personcity.font                = [UIFont systemFontOfSize:14.0];
    _personcity.textColor           = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1.0];
}

#pragma mark - Tableviewdatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID = @"oneCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    switch (indexPath.row) {
        case 0:{
            
            cell.textLabel.text=@"头像";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            cell.accessoryView = _personimgview ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:{
            
            cell.textLabel.text=@"昵称";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            [cell.contentView addSubview:_personnickname];
        }
           break;
        case 2:{
            
            cell.textLabel.text=@"性别";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            [cell.contentView addSubview:_personsex];
           
        }
            break;
        case 3:{
            
            cell.textLabel.text=@"电话";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            [cell.contentView addSubview:_personnicknumber];

        }
            break;
        case 4:{
            
            cell.textLabel.text=@"城市";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            [cell.contentView addSubview:_personcity];
           
        }
            break;
        default:
            cell.textLabel.text=@"个性签名";
            cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.row == 0) {
        return 120*_autoSizeScaleY;
    }
    
    return 60*_autoSizeScaleY;
}

-(void)takeCamera
{
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


-(void)takePhoto{
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


//点击cell事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"点击了第%ld段,第%ld个cell信息",indexPath.section,indexPath.row);
    switch (indexPath.row) {
        case 0:{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"更换头像,展现更美的一面" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"取消");
            }];
        
            UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"拍照");
                [self takeCamera];
            
            }];
            
            UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"相册");
                
                [self takePhoto];

            }];
            [alertController addAction:cancleAction];
            [alertController addAction:commitAction];
            [alertController addAction:saveAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
            break;
        case 1:{
            
            NSLog(@"弹出框，输入昵称");
            __block UITextField *name = nil;
            [LEEAlert alert].config
            //            .LeeTitle(@"填写姓名")
            .LeeContent(@"昵称修改")
            .LeeAddTextField(^(UITextField *textField)
                             {
                                 textField.font = [UIFont systemFontOfSize:14.0f];
                                 // 这里可以进行自定义的设置
                                 textField.placeholder = @"请输入昵称";
                                 textField.textColor = [UIColor darkGrayColor];
                                 name = textField; //赋值
                                 name.text = _personnickname.text;
                                 
                             })
            .LeeAction(@"确认", ^{
                if (name.text.length <1) {
//                    _personnickname.text = @"您尚未填写信息";
                }
                else{
                    _personnickname.text = name.text;
                }
//                _personnickname.textColor = kTCColor(77, 166, 214);
                [name resignFirstResponder];
            })
            .LeeCancelAction(@"取消", nil) // 点击事件的Block如果不需要可以传nil
            .LeeShow();
        
        }
            break;
        case 2:{
            
            SRActionSheet *actionSheet = [SRActionSheet sr_actionSheetViewWithTitle:nil
                                                                        cancelTitle:@"取消"
                                                                   destructiveTitle:nil
                                                                        otherTitles:@[@"男", @"女"]
                                                                        otherImages:nil
                                                                  selectActionBlock:^(SRActionSheet *actionSheet, NSInteger index) {
                                                                      
                                                                      NSLog(@"%zd", index);
                                                                      
                                                                      switch (index) {
                                                                          case 0:{
                                                                              _personsex.text = @"男";
                                                                          }
                                                                              break;
                                                                          case 1:{
                                                                              _personsex.text = @"女";
                                                                          }
                                                                              break;
                                                                      }
                                                                  }];
            [actionSheet show];
        }
            break;
        case 3:{
        
            /* 账号现在限制不能修改 之后加入解绑功能*/
        }
            break;
        case 4:{
            
            NSLog(@"切换城市");
            _XZaddess = _personcity.text;
            NSArray * array =[_XZaddess componentsSeparatedByString:@" "];
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
                    NSLog(@"个性签名");
                    PeosonQMController *ctl = [[PeosonQMController alloc]init];
                    ctl.labvalue =_personsignatureStr;
#pragma mark - block传值 签名返回
                    ctl.returnValueBlock = ^(NSString *strValue) {
                
                        NSLog(@"传值过来后的内容%@",strValue);
                        _personsignatureStr =  _personsignature = strValue;

            };
           
            self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
            [self.navigationController pushViewController:ctl animated:YES];
            self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
        }
            break;
        default:{
            
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
            self.personcity.text = [NSString stringWithFormat:@"%@ %@ %@",provinceName,cityName,countyName];
//            self.personcity.textColor = [UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0 ];
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}
#pragma  - mark验证手机号码的格式
- (BOOL)isMobileNumber:(NSString *)mobileNum{
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
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)){
        self.phoneRight = 1;
        return YES;
    }
    else{
        self.phoneRight = 0;
        return NO;
    }
}

#pragma  - mark在这里创建一个路径，用来在照相的代理方法里作为照片存储的路径
-(NSString *)getImageSavePath{
    //获取存放的照片
    //获取Documents文件夹目录
    NSArray *path           = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath  = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath  = [documentPath stringByAppendingPathComponent:@"PhotoFile"];
    return imageDocPath;
}


#pragma mark - 图片选择器的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"获取到照片到信息===%@",info);
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    _personimgview.image = image;
    NSString *imageDocPath = [self getImageSavePath];//保存
    NSLog(@"imageDocPath == %@", imageDocPath);
     [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"您取消了选择图片222");
    }];
}


#pragma mark 保存 上传数据
-(void)keeppersonEdit{
    NSLog(@"%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser]);
    NSLog(@"%@",[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]);
    
    NSDictionary *params1 = @{
                             @"phone":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                             @"id"   :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                             };
    
    NSLog(@"上传必须参数:%@",params1);
    
    NSLog(@"保存");
    
     [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"更新中..."];
   
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    //2.上传文件,在这里我们还要求传别的参数，用字典保存一下，不需要的童鞋可以省略此步骤
    NSDictionary *params = @{
                                @"phone":[[YJLUserDefaults shareObjet]getObjectformKey:YJLuser],
                                @"id"   :[[YJLUserDefaults shareObjet]getObjectformKey:YJLuserid]
                            };
    
    NSLog(@"上传必须参数:%@",params);
    //post请求

    [manager POST:Personeditpath parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
      
        // 图片处理二进制
        NSData *imageData = UIImageJPEGRepresentation(_personimgview.image, 0.1);
        NSLog(@"图片二进制:%@",imageData);
        NSDateFormatter *formatter      = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat            = @"yyyyMMddHHmmss";
        NSString *fileName              = [NSString stringWithFormat:@"%@.png", [formatter stringFromDate:[NSDate date]]];
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
        NSLog(@"图片名字：%@",fileName);
        
//      昵称
        [formData appendPartWithFormData:[self.personnickname.text dataUsingEncoding:NSUTF8StringEncoding] name:@"nickname"];
        NSLog(@"昵称:%@",self.personnickname.text);
//      性别
        [formData appendPartWithFormData:[self.personsex.text dataUsingEncoding:NSUTF8StringEncoding] name:@"sex"];
        NSLog(@"性别:%@",self.personsex.text);
        
//      用户账号（电话）
        [formData appendPartWithFormData:[self.personnicknumber.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
        NSLog(@"用户账号:%@",self.personnicknumber.text);
        
//      城市
        [formData appendPartWithFormData: [self.personcity.text dataUsingEncoding:NSUTF8StringEncoding] name:@"city"];
         NSLog(@"城市:%@",self.personcity.text);
        
//      签名
       [formData appendPartWithFormData:[self.personsignatureStr dataUsingEncoding:NSUTF8StringEncoding] name:@"signature"];
        NSLog(@"签名:%@",self.personsignature);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        NSString *code = [ NSString stringWithFormat:@"%@",responseObject[@"code"]];
           NSLog(@"状态码：%@",code);
        if ([code isEqualToString:@"200"]||[code isEqualToString:@"201"]) {
            
            //  本地存数据 账号密码
            [[YJLUserDefaults shareObjet]saveObject:@"YES" forKey:YJLEditchange];
           
            [YJLHUD showSuccessWithmessage:@"修改成功"];
            [YJLHUD dismissWithDelay:1];
           
             _count = 1;
             [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        }
        else if ([code isEqualToString:@"403"]){
            [YJLHUD showSuccessWithmessage:@"操作频繁"];
            [YJLHUD dismissWithDelay:1];
        }
        
        else if ([code isEqualToString:@"301"]||[code isEqualToString:@"302"]){
             //  只是图片修改不成功 301
             //  只是文字修改不成功 302
            [YJLHUD showErrorWithmessage:@"修改失败"];
            [YJLHUD dismissWithDelay:1];
        }
        else{
            NSLog(@"哈哈打卡机");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSLog(@"请求失败：%@",error);
        [YJLHUD showErrorWithmessage:@"服务器连接失败"];
        [YJLHUD dismissWithDelay:1];
    }];
}

//倒计时返回
-(void)timerFired:(NSTimer *)timer{
    if (_count !=0) {
        _count -=1;
       
    }
    else{
        
         [timer invalidate];
         [self back];
    }
}

#pragma mark 返回
-(void)back{

    NSLog(@"返回");
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
