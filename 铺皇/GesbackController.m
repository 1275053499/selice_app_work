//
//  GesbackController.m
//  铺皇精简版
//
//  Created by selice on 2017/12/8.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "GesbackController.h"
#import "RecordModel.h"
#import "RecordViewCell.h"

#define NAVGATION_ADD_STATUS_HEIGHT (STATUS_HEIGHT + NAVGATION_HEIGHT)
#define NumberRow 4 //  设置每行显示的图片数量
#define CollClearance 3 //  图片据上下两边的宽度
#define ImageWidthMargin 3  //    图片据左右两边的宽度


@interface GesbackController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString * URL;

}

@property (nonatomic , strong) UILabel        * BGlab;               //无网络提示语
@property (nonatomic,strong) NSMutableArray * arrModel;     //存放的数据模型
@property(nonatomic,strong)NSURLSessionDataTask * task;

@end

@implementation GesbackController

-(NSMutableArray *)arrModel
{
    if(_arrModel==nil){
        _arrModel=[NSMutableArray array];
    }
    return _arrModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客服服务记录";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    [self creattableview];
    [self loaddata];
}

#pragma -mark 获取数据
-(void)loaddata{
    
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];

     if ([self.Shopcode  isEqualToString:@"rentout"]) {//出租
    
         URL= [NSString stringWithFormat:@"%@?shopid=%@",HostCZrecordpath,_Shopid];
         AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
         manager.responseSerializer          = [AFJSONResponseSerializer serializer];
         manager.requestSerializer.timeoutInterval = 10.0;
         ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
         self.task =   [manager GET: URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
             NSLog(@"客服记录:%@",responseObject[@"data"]);
             NSLog(@"客服记录code:%@",responseObject[@"code"]);
             if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                 for (NSDictionary *    dic in responseObject[@"data"]){
                     
                     RecordModel *  m=  [[RecordModel alloc]init];
                     m.nick     =   dic[@"nickname"];
                     m.times    =   dic[@"time"];
                     m.record   =   dic[@"content"];
                     m.image    =   dic[@"images"   ];
                     //把模型那存到模型数组中
                     [self.arrModel addObject:m];
                     [self.tableview reloadData];
                 }
                 
                 
                 [YJLHUD showSuccessWithmessage:@"加载成功"];
                 [YJLHUD dismissWithDelay:1];
                 [self.BGlab setHidden:YES];
             }else{
                 
                 [YJLHUD showErrorWithmessage:@"尚未有跟进记录"];
                 [YJLHUD dismissWithDelay:1];
                 
                 [self.BGlab setHidden:NO];
                 self.BGlab.text             = @"尚未有跟进记录";
                 
             }
         }
                        
        failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"%@",error);
                    [self.BGlab setHidden:NO];
                    self.BGlab.text      = @"网络数据连接失败";
            
                    [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
                    [YJLHUD dismissWithDelay:1];
            }];
         
     }else{//转让
         
         URL= [NSString stringWithFormat:@"%@?shopid=%@",HostZRrecordpath,_Shopid];
//                  URL= [NSString stringWithFormat:@"https://ph.chinapuhuang.com/API.php/zrrecord?shopid=3806"];//测试数据
         AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
         manager.responseSerializer          = [AFJSONResponseSerializer serializer];
         manager.requestSerializer.timeoutInterval = 10.0;
        ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;  //AFN自动删除NULL类型数据
         self.task =   [manager GET: URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject){
             NSLog(@"客服记录:%@",responseObject[@"data"]);
             NSLog(@"客服记录code:%@",responseObject[@"code"]);
             if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
                 for (NSDictionary *    dic in responseObject[@"data"]){
                     
                     RecordModel * m =  [[RecordModel alloc]init];
                     m.nick     =   dic[@"nickname" ];
                     m.times    =   dic[@"time"     ];
                     m.record   =   dic[@"content"  ];
                     m.image    =   dic[@"images"   ];
                     //把模型那存到模型数组中
                     [self.arrModel addObject:m];
                     [self.tableview reloadData];
                 }
                 
                 [YJLHUD showSuccessWithmessage:@"加载成功"];
                 [YJLHUD dismissWithDelay:1];
                [self.BGlab setHidden:YES];
             }else{
                 
                 [YJLHUD showErrorWithmessage:@"尚未有跟进记录"];
                 [YJLHUD dismissWithDelay:1];
                [self.BGlab setHidden:NO];
                self.BGlab.text             = @"尚未有跟进记录";
             }
         }
                        
        failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [self.BGlab setHidden:NO];
            self.BGlab.text      = @"网络数据连接超时了,稍等~~";
           
            [YJLHUD showErrorWithmessage:@"服务器加载失败"];
            [YJLHUD dismissWithDelay:1];
        }];
     }
}

#pragma -mark创建tableview
-(void)creattableview{
    
    self.tableview  = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight) style:UITableViewStyleGrouped];
    self.tableview.showsVerticalScrollIndicator =NO;
    self.tableview.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉默认下划线
    self.tableview.estimatedRowHeight=200; //预估行高 可以提高性能
    self.tableview.rowHeight = 88;
    self.tableview.dataSource    = self;
    self.tableview.delegate      = self;
    [self.view addSubview:self.tableview];
    
    //注册表格单元
    [self.tableview registerClass:[RecordViewCell class] forCellReuseIdentifier:recordIndentifier];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.tableview addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableview);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"%ld",self.arrModel.count);
    return self.arrModel.count;
}

//段头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

//段尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    RecordModel *model = _arrModel[section];

    int integer = (int)model.image.count / NumberRow;
    int remainder = model.image.count % NumberRow;
    if (remainder>0) {
        remainder = 1;
    }
    
    int imageHeight = (((KMainScreenWidth  - 12 - (3 * (NumberRow - 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 4);
    if (imageHeight > KMainScreenWidth - 64) {
        imageHeight = KMainScreenWidth - 64 - 2 * CollClearance;
    }
    return imageHeight + 6;
}

//段尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 80 )];
    mainView.backgroundColor = [UIColor whiteColor];
    RecordModel *model = _arrModel[section];
    
    int integer = (int)model.image.count / NumberRow;
    int remainder = model.image.count % NumberRow;
    if (remainder>0) {
        remainder = 1;
    }
    
    int imageHeight = (((KMainScreenWidth  - 12 - (3 * (NumberRow - 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 4);
    
    if (imageHeight > KMainScreenWidth - 64) {
        imageHeight = KMainScreenWidth - 64 - 2 * CollClearance;
    }
    
    ManyImageView *imageView  = [ManyImageView initWithFrame:CGRectMake(0, 0, KMainScreenWidth, imageHeight) imageArr:model.image numberRow:NumberRow widthClearance:3];
    
    imageView.backgroundColor = [UIColor whiteColor];
    [mainView addSubview:imageView];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor grayColor];
    
    lineLabel.frame = CGRectMake(0, imageView.bottom+5, KMainScreenWidth, 0.5);
    [mainView addSubview:lineLabel];
    
    return mainView;
}

/*
 返回多少行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

/*
 返回表格单元
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //取出模型
    RecordModel *model=self.arrModel[indexPath.row];
    NSLog(@"%@",model.nick);
    NSLog(@"%@",model.record);
    NSLog(@"%@",model.times);

    RecordViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:recordIndentifier];
    //传递模型给cell
    cell.recordModel=model;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

/*
 *  返回每一个表格单元的高度
 */

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取出模型
    RecordModel *Model = self.arrModel[indexPath.row];
    
    return    Model.cellHeight ;
}

#pragma mark 当前导航栏出现？不出现
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 让导航栏不显示出来***********************************
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma  -mark - 返回
-(void)back{
    
    if(self.task) {
       
        [self.task cancel];//取消当前界面的数据请求.
    }
   
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    
    if(self.task) {
        
        [self.task cancel];//取消当前界面的数据请求.
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

@end
