//
//  SeacheckZRController.m
//  铺皇
//
//  Created by selice on 2017/11/16.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SeacheckZRController.h"
#import "JX_FourCell.h"
#import "JX_FourModel.h"
#import "DetailedController.h"
@interface SeacheckZRController ()<UITableViewDelegate,UITableViewDataSource>{
     int  PHpage;
     CGFloat  OffestY;
   
}

@property (nonatomic , strong) UILabel        * BGlab;               //无网络提示语
@property (nonatomic , strong) UIButton       * BackBtn;             //返回按钮
@property (nonatomic , strong) UILabel        * titlelab;            //标题
@property (nonatomic , strong) UITableView    * maintabeview;        //列表
@property (nonatomic , strong) NSMutableArray * PHDataArr;           //存储数据

@property (nonatomic , strong) UIView * Navview;
@end

@implementation SeacheckZRController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor whiteColor];
     _PHDataArr        = [[NSMutableArray alloc]init];
    
    //    创建列表table
    [self creattableview];
    
    //    创建返回+self.title
    [self creatBacktitle];

    //   加载数据控件
    [self refresh];
    
}
#pragma mark - 创建上下拉刷新数据
- (void)refresh{
    //#pragma  -mark下拉刷新获取网络数据
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loaddataUPtodown)];
    
    // Set title
    [header setTitle:@"铺小皇来开场了" forState:MJRefreshStateIdle];
    [header setTitle:@"铺小皇要回家了" forState:MJRefreshStatePulling];
    [header setTitle:@"铺小皇来更新了" forState:MJRefreshStateRefreshing];
    
    // Set font
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // Set textColor
    header.stateLabel.textColor             = kTCColor(161, 161, 161);
    header.lastUpdatedTimeLabel.textColor   = kTCColor(161, 161, 161);
    self.maintabeview.mj_header     = header;
     [self.maintabeview.mj_header beginRefreshing];
//
#pragma  -mark上拉加载获取网络数据
    self.maintabeview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        PHpage++;
        [self loaddataDowntoup          ];
    }];
}

#pragma -mark 下拉刷新数据
-(void)loaddataUPtodown{
    PHpage = 0;
    [self.BGlab setHidden:YES];
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    
    [self.maintabeview.mj_footer resetNoMoreData];
    NSLog(@"即将下拉刷新之前数组有%ld个数据",_PHDataArr.count);
    NSString  * URL = [NSString stringWithFormat:@"%@?city=%@&keyword=%@&page=%d",HostmainSerach,self.Searchcity_ZR,self.Searchword_ZR,PHpage];
    NSLog(@"转让下拉刷新请求入境：%@",URL);

    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;
    
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [_PHDataArr removeAllObjects];
        [YJLHUD showSuccessWithmessage:@"加载成功"];
        [YJLHUD dismissWithDelay:1];
//        NSLog(@"请求数据成功----%@",responseObject);
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
       
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
                for (NSDictionary *dic in responseObject[@"data"][@"zr"]){

                    if ([[dic[@"ret"] stringValue] isEqualToString:@"500"]) {
                        NSLog(@"没有");
                        [self.BGlab setHidden:NO];
                       
                        self.BGlab.text             = @"没有更多数据";
                        [YJLHUD showErrorWithmessage:@"没有更多数据"];
                        [YJLHUD dismissWithDelay:1];
                        
                    }else{
                        
                        JX_FourModel *model = [[JX_FourModel alloc]init];
                        model.JX_picture    = dic[@"images" ];
                        model.JX_title      = dic[@"title"  ];
                        model.JX_quyu       = dic[@"dityour"];
                        model.JX_time       = dic[@"time"   ];
                        model.JX_tag        = dic[@"type"   ];
                        model.JX_area       = dic[@"area"   ];
                        model.JX_rent       = dic[@"rent"   ];
                        model.JX_subid      = dic[@"id"     ];
                        [model setValuesForKeysWithDictionary:dic];
                        [_PHDataArr addObject:model];
                         [self.BGlab setHidden:YES];
                    }
                    
                }
                NSLog(@" 加载后现在总请求到数据有%ld个",_PHDataArr.count);
        }

        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.maintabeview reloadData];
        });
        [self.maintabeview.mj_header endRefreshing];
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if ( [error isEqual:@"Error Domain=NSURLErrorDomain Code=-1001"]) {
            NSLog(@"网络数据连接超时了");
        }
        

        [self.BGlab setHidden:NO];
        self.BGlab.text      = @"网络数据连接超时了,稍等~~";
        [self.maintabeview .mj_header endRefreshing];
      
        [YJLHUD showErrorWithmessage:@"网络数据连接超时了,稍等~~"];
        [YJLHUD dismissWithDelay:1];
    }];
}

#pragma -mark 初始上拉加载
-(void)loaddataDowntoup{
    
    NSLog(@"上拉加载前一页数组里面的数据有%ld个",_PHDataArr.count);
    NSLog(@"马上加载第%d页",PHpage);
    [YJLHUD showMyselfBackgroundColor:nil ForegroundColor:nil BackgroundLayerColor:nil message:@"加载中...."];
    
    AFHTTPSessionManager *manager       = [AFHTTPSessionManager manager];
    manager.responseSerializer          = [AFJSONResponseSerializer serializer];
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;//AFN自动删除NULL类型数据
    manager.requestSerializer.timeoutInterval = 10.0;

    NSString  * URL = [NSString stringWithFormat:@"%@?city=%@&keyword=%@&page=%d",HostmainSerach,self.Searchcity_ZR,self.Searchword_ZR,PHpage];
    NSLog(@"转让上拉刷新请求入境：%@",URL);
    
    [manager GET:URL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
//        NSLog(@"请求数据成功----%@",responseObject);
//        NSLog(@"判断数据=======%@", responseObject[@"code"]);
        
        if ([[responseObject[@"code"] stringValue] isEqualToString:@"200"]){
            NSLog(@"可以拿到数据的");
            [YJLHUD showSuccessWithmessage:@"加载成功"];
            [YJLHUD dismissWithDelay:1];
            for (NSDictionary *dic in responseObject[@"data"][@"zr"]){
                
                if ([[dic[@"ret"] stringValue] isEqualToString:@"500"]) {
                    NSLog(@"没有");
                    [self.BGlab setHidden:YES];
                    PHpage--;
                    self.BGlab.text             = @"没有更多数据";
                    [YJLHUD showErrorWithmessage:@"没有更多数据"];
                    [YJLHUD dismissWithDelay:1];
                    
                }else{
                    
                    JX_FourModel *model = [[JX_FourModel alloc]init];
                    model.JX_picture    = dic[@"images" ];
                    model.JX_title      = dic[@"title"  ];
                    model.JX_quyu       = dic[@"dityour"];
                    model.JX_time       = dic[@"time"   ];
                    model.JX_tag        = dic[@"type"   ];
                    model.JX_area       = dic[@"area"   ];
                    model.JX_rent       = dic[@"rent"   ];
                    model.JX_subid      = dic[@"id"     ];
                    [model setValuesForKeysWithDictionary:dic];
                    [_PHDataArr addObject:model];
                    [self.BGlab setHidden:YES];
                }
            }
            NSLog(@" 加载后现在总请求到数据有%ld个",_PHDataArr.count);
        }
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.maintabeview reloadData];
        });
        [self.maintabeview.mj_footer endRefreshing];
    
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求数据失败----%@",error);
        if ( [error isEqual:@"Error Domain=NSURLErrorDomain Code=-1001"]) {
            NSLog(@"网络数据连接超时了");
        }
        
        [self.BGlab setHidden:NO];
        self.BGlab.text      = @"网络数据连接失败";
        [self.maintabeview .mj_header endRefreshing];
       
        [YJLHUD showErrorWithmessage:@"网络数据连接失败"];
        [YJLHUD dismissWithDelay:1];
    }];
}



#pragma -mark - tableviewcell代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _PHDataArr.count;

}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellID";
    JX_FourCell *JX_cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (JX_cell == nil){
        
        JX_cell =[[[NSBundle mainBundle]loadNibNamed:@"JX_FourCell" owner:self options:nil]lastObject];
    }
    
    NSLog(@"!!!!!%ld=????????%ld",_PHDataArr.count,indexPath.row);
    JX_FourModel *model = [_PHDataArr objectAtIndex:indexPath.row];
    JX_cell.BTlab.text                = model.JX_title;//标题
    JX_cell.QuYulab.text              = model.JX_quyu;//区域所在
    if (model.JX_quyu.length>3)
    {
        JX_cell.QuyulabWidth.constant = 50;
    }else{
        JX_cell.QuyulabWidth.constant = 40;
    }

    JX_cell.Timerlab.text             = model.JX_time;//更新时间
    JX_cell.Taglab.text               = model.JX_tag;//餐饮美食
    JX_cell.Arealab.text              = [NSString stringWithFormat:@"%@m²",model.JX_area];//店铺面积
    JX_cell.Pricelab.text             = [NSString stringWithFormat:@"%@元/月",model.JX_rent];//店铺转让费
    [JX_cell.PictureImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.JX_picture]] placeholderImage:[UIImage imageNamed:@"nopicture"]];//店铺图片
    JX_cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return JX_cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%zd点击了一下",indexPath.row);

    //    获取店铺唯一id
    self.hidesBottomBarWhenPushed = YES;//如果在push跳转时需要隐藏tabBar
    JX_FourModel *model = [_PHDataArr objectAtIndex:indexPath.row];
    DetailedController *ctl =[[DetailedController alloc]init];
    ctl.shopsubid = model.JX_subid;
    ctl.shopcode  = @"transfer";
    NSLog(@"店铺🆔%@",ctl.shopsubid);
    [self.navigationController pushViewController:ctl animated:YES];
     self.hidesBottomBarWhenPushed = YES;//1.并在push后设置self.hidesBottomBarWhenPushed=YES;2.这样back回来的时候，tabBar不会会恢复正常显示。
}

#pragma  -mark - 手势返回
- (void)recognizer:(UISwipeGestureRecognizer*)recognizer{
    [self backback];
}

#pragma -mark  返回
- (void)Clickback{
    [self backback];
}

#pragma  -mark - 返回方法
-(void)backback{
    
    NSLog(@"点击了想回去");
    
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"已经看过了我要返回");
}

#pragma -mark创建返回+标题
-(void)creatBacktitle{
    
   self.Navview = [[UIView alloc]init];
    self.Navview.backgroundColor  =kTCColor(247, 247, 247);
    [self.view addSubview:self.Navview];
    [self.view bringSubviewToFront:self.Navview];
    [self.Navview mas_makeConstraints:^(MASConstraintMaker *make) {
        self.Navview.hidden = NO;
        make.left.equalTo (self.view).with.offset(0);
        make.top.equalTo (self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
    }];
    
    _BackBtn        = [UIButton buttonWithType:UIButtonTypeCustom];
    _BackBtn.frame  = CGRectMake(0, 20, 44, 44);
    [_BackBtn setImage:[UIImage imageNamed:@"heise_fanghui"] forState:UIControlStateNormal];
    [_BackBtn addTarget:self action:@selector(Clickback) forControlEvents:UIControlEventTouchUpInside];
    [self.Navview addSubview:_BackBtn];
    
    _titlelab               = [[UILabel alloc]initWithFrame:CGRectMake(KMainScreenWidth / 7, 20, KMainScreenWidth / 7 *5, 44)];
    _titlelab.textAlignment = NSTextAlignmentCenter;
    _titlelab.textColor     = [UIColor blackColor];
    
    if (self.Searchword_ZR.length<1) {
        _titlelab.text          =@"店铺转让";
    }else{
        _titlelab.text          =[NSString stringWithFormat:@"搜索:%@", [self.Searchword_ZR stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }

    [self.Navview addSubview:_titlelab];
}

#pragma -mark创建tableview
-(void)creattableview{
    
    self.maintabeview = [[UITableView alloc]init];
    self.maintabeview.delegate          = self;
    self.maintabeview.dataSource        = self;
    self.maintabeview.backgroundColor   = [UIColor whiteColor];
    self.maintabeview.tableFooterView   = [UIView new];
    [self.view addSubview:self.maintabeview];
    [self.maintabeview mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (iOS11) {
            
             make.left.equalTo (self.view).with.offset(0);
             make.top.equalTo (self.view).with.offset(64);
             make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-64));
        }
        else{make.top.equalTo (self.view).with.offset(44);
             make.left.equalTo (self.view).with.offset(0);
             make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-44));
        }
    }];
    
    //    无数据的提示
    self.BGlab                   = [[UILabel alloc]init];
    [self.maintabeview addSubview:self.BGlab];
    self.BGlab.font             = [UIFont systemFontOfSize:12.0f];
    self.BGlab.textColor        = kTCColor(161, 161, 161);
    self.BGlab.backgroundColor  = [UIColor clearColor];
    self.BGlab.textAlignment    = NSTextAlignmentCenter;
    [self.BGlab setHidden:YES];                              //隐藏提示
    [self.BGlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maintabeview);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
}

#pragma -mark UIScrollViewdelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"将要开始拖拽，手指已经放在view上并准备拖动的那一刻===%f",offset);
    OffestY = offset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offset = scrollView.contentOffset.y;
//    NSLog(@"只要view有滚动=%f",offset);
   
//    int i = 10;//这个值对应数据源数组个数
    if (_PHDataArr.count<7) {//小于6个的不能进行这个特效实现哦
        NSLog(@"数量太少不进行特效");
    }else{
        
        if (iOS11) {
            #pragma -mark ios 11 特效开始
            if (offset > 0 ) {
            
                        CGFloat offsetnav = offset ;
                        [self.Navview mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo (self.view).with.offset(0);
                            make.top.equalTo (self.view).with.offset(-offsetnav);
                            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
                        }];
                
                            if (offset < OffestY) {//移动位置比刚刚触摸位置小 一直存在自定义导航栏
                
                                [self.Navview mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo (self.view).with.offset(0);
                                    make.top.equalTo (self.view).with.offset(0);
                                    make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
                                }];
                            }
                
                    }
            else{
                
                            [self.Navview mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo (self.view).with.offset(0);
                            make.top.equalTo (self.view).with.offset(0);
                            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
                
                        }];
                    }
            
                if (offset > 0&& offset <= 64) {
                    
                   CGFloat offsettab = offset ;
                    NSLog(@"tab====%f",offsettab);
                    [self.maintabeview mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo (self.view).with.offset(0);
                        make.top.equalTo (self.view).with.offset(64 - offsettab);
                        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+(64-offsettab)));
                    }];
            
                    }else if (offset >64){
            
                      [self.maintabeview mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo (self.view).with.offset(0);
                        make.top.equalTo (self.view).with.offset(0);
                        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight));
                                        }];
                                    }
                    else{
            
                            [self.maintabeview mas_remakeConstraints:^(MASConstraintMaker *make) {
                                    make.left.equalTo (self.view).with.offset(0);
                                    make.top.equalTo (self.view).with.offset(64);
                                    make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-64));
                            }];
                }
            #pragma -mark ios 11 特效结束
        }
        
        
        else{
        
#pragma -mark ios 11 以下 特效开始
    if (offset>-20) {

           CGFloat offsetnav = offset + 20;
        [self.Navview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo (self.view).with.offset(0);
            make.top.equalTo (self.view).with.offset(-offsetnav);
            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
        }];

            if (offset < OffestY) {//移动位置比刚刚触摸位置小 一直存在自定义导航栏

                [self.Navview mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo (self.view).with.offset(0);
                    make.top.equalTo (self.view).with.offset(0);
                    make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));
                }];
            }

    }else{

            [self.Navview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo (self.view).with.offset(0);
            make.top.equalTo (self.view).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, 64));

        }];
    }

    if (offset > -20&& offset <= 24) {
       CGFloat offsettab = offset+20 ;
        NSLog(@"tab====%f",offsettab);
        [self.maintabeview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo (self.view).with.offset(0);
            make.top.equalTo (self.view).with.offset(44 - offsettab);
            make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+(44-offsettab)));
        }];

                    }else if (offset >24){

                        [self.maintabeview mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.equalTo (self.view).with.offset(0);
                                make.top.equalTo (self.view).with.offset(0);
                                make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight+44));
                            }];
                        }
                else{

                        [self.maintabeview mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo (self.view).with.offset(0);
                        make.top.equalTo (self.view).with.offset(44);
                        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth, KMainScreenHeight-44));
                }];

    }
#pragma -mark  ios 11 以下 特效结束
        }
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}


@end
