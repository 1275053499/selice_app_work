//
//  OpinionController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/18.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "OpinionController.h"
#import "PlaceholderTextView.h"
#import "PhotoCollectionViewCell.h"
#define kTextBorderColor     RGBCOLOR(227,224,216)

#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface OpinionController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property float autoSizeScaleX;
@property float autoSizeScaleY;

@property (nonatomic, strong) PlaceholderTextView * textView;

@property (nonatomic, strong) UIButton * sendButton;

@property (nonatomic, strong) UIView * aView;

@property (nonatomic, strong)UICollectionView *collectionV;
//上传图片的个数
@property (nonatomic, strong)NSMutableArray *photoArrayM;
//上传图片的button
@property (nonatomic, strong)UIButton *photoBtn;
//回收键盘
@property (nonatomic, strong)UITextField *textField;

//字数的限制
@property (nonatomic, strong)UILabel *wordCountLabel;
//邮箱
@property (nonatomic, assign)BOOL emailRight;
//手机
@property (nonatomic, assign)BOOL phoneRight;
//QQ
@property (nonatomic, assign)BOOL qqRight;

@property (nonatomic, strong)UILabel *QQlab;

@end

@implementation OpinionController
//懒加载数组
- (NSMutableArray *)photoArrayM{
    if (!_photoArrayM) {
        _photoArrayM = [NSMutableArray arrayWithCapacity:0];
    }
    return _photoArrayM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    //    适配必要使用2
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
    self.title = @"意见反馈";

    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];


    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(backset1)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    

    self.view.backgroundColor = [UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0f];
    self.aView = [[UIView alloc]init];
    _aView.backgroundColor = [UIColor whiteColor];
    _aView.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 180);
    [self.view addSubview:_aView];
    

    self.wordCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1, [UIScreen mainScreen].bounds.size.width - 40, 20)];
    _wordCountLabel.font = [UIFont systemFontOfSize:14.f];
    _wordCountLabel.textColor = [UIColor lightGrayColor];
    self.wordCountLabel.text = @"0/300";
    self.wordCountLabel.backgroundColor = [UIColor whiteColor];
    self.wordCountLabel.textAlignment = NSTextAlignmentRight;
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(self.textView.frame.origin.x + 20,  self.textView.frame.size.height + 84 - 1 + 23, [UIScreen mainScreen].bounds.size.width - 40, 1)];

    
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    [self.view addSubview:_wordCountLabel];
    [_aView addSubview:self.textView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //添加一个label(问题截图（选填）)
    [self addLabelText];
    
    //创建collectionView进行上传图片
    
    [self addCollectionViewPicture];
    
    //添加联系方式
    
    [self addContactInformation];
    //提交信息的button
    [self.view addSubview:self.sendButton];
    
    _QQlab = [[UILabel alloc]init];
    _QQlab.frame = CGRectMake(20, KMainScreenHeight-64, KMainScreenWidth-40, 40);
    _QQlab.textAlignment = NSTextAlignmentCenter;
    _QQlab.textColor = [UIColor lightGrayColor];
    _QQlab.font = [UIFont systemFontOfSize:15.0f];
    _QQlab.numberOfLines = 0;
    _QQlab.text = @"微信号：yan19940120\nQQ号：1275053499";
//    [self.view addSubview:_QQlab];
    
    //上传图片的button
    self.photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.photoBtn.frame = CGRectMake(10 , 165, (self.aView.frame.size.width- 60) / 5, (self.aView.frame.size.width- 60) / 5);
    [_photoBtn setImage:[UIImage imageNamed:@"意见反馈"] forState:UIControlStateNormal];
    //[_photoBtn setBackgroundColor:[UIColor redColor]];
    
    [_photoBtn addTarget:self action:@selector(picureUpload:) forControlEvents:UIControlEventTouchUpInside];
    [self.aView addSubview:_photoBtn];
    
}

///图片上传
-(void)picureUpload:(UIButton *)sender{
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing=YES;
    picker.delegate=self;
    [self presentViewController:picker animated:YES completion:nil];
}

//上传图片的协议与代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    //    [self.btn setImage:image forState:UIControlStateNormal];
    [self.photoArrayM addObject:image];
    //选取完图片之后关闭视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


///填写意见
-(void)addLabelText
{
    UILabel * labelText = [[UILabel alloc] init];
    labelText.text = @"问题截图(PS:选填,不可撤销,慎重选择)";
    labelText.frame = CGRectMake(10, 125,[UIScreen mainScreen].bounds.size.width - 20, 20);
    labelText.font = [UIFont systemFontOfSize:14.f];
    labelText.textColor = _textView.placeholderColor;
    [_aView addSubview:labelText];

}
#pragma mark 上传图片UIcollectionView

-(void)addCollectionViewPicture{
    //创建一种布局
    UICollectionViewFlowLayout *flowL = [[UICollectionViewFlowLayout alloc]init];
    //设置每一个item的大小
    flowL.itemSize = CGSizeMake((self.aView.frame.size.width - 60) / 5 , (self.aView.frame.size.width - 60) / 5 );
    flowL.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //列
    flowL.minimumInteritemSpacing = 10;
    //行
    flowL.minimumLineSpacing = 10;
    //创建集合视图
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 145, self.aView.frame.size.width, ([UIScreen mainScreen].bounds.size.width - 60) / 5 + 10) collectionViewLayout:flowL];
    _collectionV.backgroundColor = [UIColor whiteColor];
    // NSLog(@"-----%f",([UIScreen mainScreen].bounds.size.width - 60) / 5);
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    //添加集合视图
    [self.aView addSubview:_collectionV];
    //注册对应的cell
    [_collectionV registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

///添加联系方式
-(void)addContactInformation
{
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 314, [UIScreen mainScreen].bounds.size.width - 40, 40)];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.font = [UIFont systemFontOfSize:14.f];
    _textField.placeholder = @"你的联系方式(手机号，QQ号或电子邮箱)";
    _textField.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_textField];
    
}
-(PlaceholderTextView *)textView{
    
    if (!_textView) {
        _textView = [[PlaceholderTextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 100)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14.f];
        _textView.textColor = [UIColor blackColor];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.editable = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = kTextBorderColor.CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.placeholderColor = RGBCOLOR(0x89, 0x89, 0x89);
        _textView.placeholder = @"写下你遇到的问题，或告诉我们你的宝贵意见~";
        
    }
    
    return _textView;
}

//把回车键当做退出键盘的响应键  textView退出键盘的操作
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([@"\n" isEqualToString:text] == YES){
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

- (UIButton *)sendButton{
    
    if (!_sendButton) {
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.layer.cornerRadius = 2.0f;
        _sendButton.frame = CGRectMake(20, 364, self.view.frame.size.width - 40, 40);
        _sendButton.backgroundColor = [self colorWithRGBHex:0x60cdf8];
        [_sendButton setTitle:@"提交" forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendFeedBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sendButton;

}

#pragma mark 提交意见反馈
- (void)sendFeedBack{
    
    [self.textField resignFirstResponder];
    [self.textView  resignFirstResponder];
    if (self.textView.text.length == 0) {
        
        UIAlertController *alertLength = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的信息为空，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *suer = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertLength addAction:suer];
        [self presentViewController:alertLength animated:YES completion:nil];
    }
    else{
        
        [self isMobileNumber:self.textField.text];
        [self isValidateEmail:self.textField.text];
        //验证qq未写
        
        if (self.emailRight != 0 || self.phoneRight != 0) {
            
            [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"提交反馈中..."];
#pragma -mark    网络上传反馈的信息 start
         
            AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
            manager.responseSerializer          = [AFJSONResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 10.0;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
            [manager POST:feedback parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
            
                if (self.photoArrayM.count >0) {
                    
                    for(NSInteger i = 0; i < self.photoArrayM.count; i++){
                        
                        NSData *imageData = UIImageJPEGRepresentation(self.photoArrayM[i], 0.5);
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        // 设置时间格式
                        [formatter setDateFormat:@"yyyyMMddHHmmss"];
                        NSString *dateString = [formatter stringFromDate:[NSDate date]];
                        NSString *fileName = [NSString  stringWithFormat:@"%@%ld.jpg", dateString,i];
                        NSLog(@"图片名字：%@",fileName);
                        /*
                         *该方法的参数
                         1. appendPartWithFileData：要上传的照片[二进制流]
                         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                         3. fileName：要保存在服务器上的文件名
                         4. mimeType：上传的文件的类型
                         */
                        [formData appendPartWithFileData:imageData name:@"image[]" fileName:fileName mimeType:@"image/jpeg"];
                        NSLog(@"上传照片image%ld",i);
                        
                        //    意见
                        [formData appendPartWithFormData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
                        //    联系方法
                        [formData appendPartWithFormData:[self.textField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
                    }
                }else{
                    
                    //    意见
                    [formData appendPartWithFormData:[self.textView.text dataUsingEncoding:NSUTF8StringEncoding] name:@"content"];
                    //    联系方法
                    [formData appendPartWithFormData:[self.textField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phone"];
                }
            }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     [YJLHUD showSuccessWithmessage:@"提交成功"];
                      [YJLHUD dismissWithDelay:1.0];
                      
                      NSLog(@"请求成功=%@",responseObject);
                      
                      if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]) {
                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"意见反馈" message:@"您的意见我们已经收到，感谢您的谅解，我们会尽快处理" preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction *album = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
                              [self backset1];
                          }];
                          [alertController addAction:album];
                          [self presentViewController:alertController animated:YES completion:nil];
                      }else{
                          
                          UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的意见好像被网络拦截了，尝试再次发送吧" preferredStyle:UIAlertControllerStyleAlert];
                          
                          UIAlertAction *album = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                              
                              [self sendFeedBack];
                          }];
                          [alertController addAction:album];
                          UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                              
                              [self sendFeedBack];
                          }];
                          [alertController addAction:cancel];
                          [self presentViewController:alertController animated:YES completion:nil];
                          
                          
                      }

                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      [YJLHUD showErrorWithmessage:@"网络繁忙,提交失败"];
                      [YJLHUD dismissWithDelay:1.0];

                      NSLog(@"请求失败=%@",error);
                  }];
            
            #pragma -mark    网络上传反馈的信息 end
            
           
        }
        else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"通知" message:@"你输入的邮箱，QQ号或者手机号错误,请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }
    }
}


- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_photoArrayM.count == 0) {
        return 0;
    }
    else{
        return _photoArrayM.count;
    }
}

//返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.photoV.image = self.photoArrayM[indexPath.item];
    return cell;
}

#pragma mark textField的字数限制

//在这个地方计算输入的字数
- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
    [self wordLimit:textView];
}
#pragma mark 超过300字不能输入
-(BOOL)wordLimit:(UITextView *)text{
    if (text.text.length < 300) {
        NSLog(@"%ld",text.text.length);
        self.textView.editable = YES;
        
    }
    else{
        self.textView.editable = NO;
        
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

#pragma mark 判断邮箱，手机，QQ的格式
-(BOOL)isValidateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    self.emailRight = [emailTest evaluateWithObject:email];
    return self.emailRight;
    
}

//验证手机号码的格式

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
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        self.phoneRight = 1;
        return YES;
    }
    else
    {
        self.phoneRight = 0;
        return NO;
    }
}


#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 返回
-(void)backset1{
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

//button的frame
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.photoArrayM.count < 5) {
        
        [self.collectionV reloadData];
        _aView.frame = CGRectMake(20, 84, self.view.frame.size.width - 40, 180);
        self.photoBtn.frame = CGRectMake(10 * (self.photoArrayM.count + 1) + (self.aView.frame.size.width - 60) / 5 * self.photoArrayM.count, 154 - 5, (self.aView.frame.size.width - 60) / 5, (self.aView.frame.size.width - 60) / 5 + 5);
    }else{
        
        [self.collectionV reloadData];
        self.photoBtn.frame = CGRectMake(0, 0, 0, 0);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
}

@end
