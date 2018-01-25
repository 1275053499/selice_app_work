//
//  ZWcategoryController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/27.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZWcategoryController.h"
@interface ZWcategoryController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray *array00;
    NSArray *array01;
    NSArray *array02;
    NSArray *array03;
    NSArray *array04;
    NSArray *array05;
    NSArray *array06;
    NSString *value1;//第1个列表点击的值
    NSString *value2;//第2个列表点击的值
 
    UITableView *tableV1;
    UITableView *tableV2;
    NSInteger    table1_2_row;//点击的位置
    
    NSInteger   row1;//第1个列表点击位置
    NSInteger   row2;//第2个列表点击位置
    
}
@end

@implementation ZWcategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    value2 = _labvalue;
    
    self.title = @"选择职位类别";
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem   = backItm;
    self.view.backgroundColor = kTCColor(255, 255, 255);
    
    UIBarButtonItem * rightButton           = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
    rightButton.tintColor                   =[UIColor colorWithRed:77/255.0 green:166/255.0 blue:214/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    array00 = @[@"餐饮类",@"酒店类",@"美容美发类",@"家政类",@"百货类",@"物流仓储类"];
    
    array01 = @[@"服务员",@"厨师",@"学徒",@"配送员",@"传菜员"];
    array02 = @[@"大堂经理",@"酒店领班",@"酒店安保",@"面点师",@"行政主厨",@"酒店厨师",@"厨师长",@"厨师助理",@"配菜员",@"酒店服务员",@"迎宾(接待)",@"酒店洗碗员",@"餐饮管理",@"后厨",@"茶艺师"];
    array03 = @[@"发型师",@"美发助理",@"洗头工",@"美容导师",@"美容师",@"化妆师",@"美甲师",@"宠物美容",@"美容店长",@"瘦身顾问",@"形象设计师",@"彩妆设计师",@"美体师"];
    array04 = @[@"保洁员",@"保姆",@"月嫂",@"育婴师",@"洗衣工",@"钟点工",@"保安",@"护工",@"送水工",@"家电维修"];
    array05 = @[@"收银员",@"促销员",@"营业员",@"理货员",@"防损员",@"卖场经理",@"卖场店长",@"招商经理",@"督导",@"品类管理"];
    array06 = @[@"物流专员",@"调度员",@"快递员",@"仓库管理员",@"搬运工",@"分拣员"];
    
    [self creatTableView];
    [self creattowhere];
}

#pragma -mark 跳转到位置
-(void)creattowhere{

    NSLog(@"tab1位置：%@  tab2位置：%@",_row1value,_row2value);
    
    //获取到需要跳转位置的行数
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:_row1value.integerValue inSection:0];
    //滚动到其相应的位置
    [tableV1 scrollToRowAtIndexPath:scrollIndexPath
                   atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [tableV1 selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    UITableViewCell*cell=(UITableViewCell*)[tableV1 cellForRowAtIndexPath:scrollIndexPath];
    cell.textLabel.textColor=kTCColor(77, 166, 214);
    
    table1_2_row = _row1value.integerValue;
    NSLog(@"控制第二个tab刷新第【array0%ld】数组",(long)table1_2_row+1);
    [tableV2 reloadData];

    //获取到需要跳转位置的行数
    NSIndexPath *scrollIndexPath2 = [NSIndexPath indexPathForRow:_row2value.integerValue inSection:0];
    //滚动到其相应的位置
    [tableV2 scrollToRowAtIndexPath:scrollIndexPath
                   atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [tableV2 selectRowAtIndexPath:scrollIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    UITableViewCell*cell2=(UITableViewCell*)[tableV2 cellForRowAtIndexPath:scrollIndexPath2];
    cell2.textLabel.textColor=kTCColor(77, 166, 214);
}

#pragma -mark 创建列表
-(void)creatTableView{
    
    tableV1                 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth/2-20, KMainScreenHeight) style:UITableViewStylePlain];
    tableV1.delegate        = self;
    tableV1.dataSource      = self;
    tableV1.tableFooterView = [UIView new];
    [self.view addSubview:tableV1];
    
    tableV2 = [[UITableView alloc]initWithFrame:CGRectMake(KMainScreenWidth/2-20, 64, KMainScreenWidth/2+20, KMainScreenHeight-64) style:UITableViewStylePlain];
    tableV2.delegate        = self;
    tableV2.dataSource      = self;
    tableV2.tableFooterView = [UIView new];
    [self.view addSubview:tableV2];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == tableV1)
    {
        return array00.count;
    }

    else
    {
        switch (table1_2_row)
        {
            case 0:
                return  array01.count;
                break;
            case 1:
                return  array02.count;
                break;
            case 2:
                return  array03.count;
                break;
            case 3:
                return  array04.count;
                break;
            case 4:
                return  array05.count;
                break;
            case 5:
                return  array06.count;
                break;
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //表1

    if (tableView == tableV1){
        
        static NSString *cellId1 = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId1];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId1];
        }
        
        cell.textLabel.text = array00[indexPath.row];
        if (KMainScreenWidth>320) {
            cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        else{
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor=[UIColor blackColor];
        return cell;
    }
    
    {
    //表2
    static NSString *cellId2 = @"cell2";
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellId2];
    
    if (!cell2) {
        
        cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
    }
    
    switch (table1_2_row){
            
        case 0:
            cell2.textLabel.text = array01[indexPath.row];
            break;
        case 1:
            cell2.textLabel.text = array02[indexPath.row];
            break;
        case 2:
            cell2.textLabel.text = array03[indexPath.row];
            break;
        case 3:
            cell2.textLabel.text = array04[indexPath.row];
            break;
        case 4:
            cell2.textLabel.text = array05[indexPath.row];
            break;
        case 5:
            cell2.textLabel.text = array06[indexPath.row];
            break;
        default:
            break;
    }
        
        if (KMainScreenWidth>320) {
            cell2.textLabel.font = [UIFont systemFontOfSize:15.0f];
        }
        
        else{
            cell2.textLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        
    cell2.selectionStyle=UITableViewCellSelectionStyleNone;
    cell2.textLabel.textColor=[UIColor blackColor];
    return cell2;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == tableV1)
    {
        NSLog(@"%@",array00[indexPath.row]);
        
        NSIndexPath*dex1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        UITableViewCell*cell=(UITableViewCell*)[tableV1 cellForRowAtIndexPath:dex1];
        cell.textLabel.textColor=kTCColor(77, 166, 214);
        
        table1_2_row  = indexPath.row;
        [tableV2 reloadData];
        
        value1 = array00[indexPath.row];
        row1 = indexPath.row;
        value2 = @"";
    }
    else{

        NSIndexPath*dex1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        UITableViewCell*cell=(UITableViewCell*)[tableV2 cellForRowAtIndexPath:dex1];
        cell.textLabel.textColor=kTCColor(77, 166, 214);

        switch (table1_2_row)
        {
            case 0:
                value2 = array01[indexPath.row];
                row2 = indexPath.row ;
                NSLog(@"%@",array01[indexPath.row]);
                break;
            case 1:
                value2 = array02[indexPath.row];
                row2 = indexPath.row ;
                NSLog(@"%@",array02[indexPath.row]);
                break;
            case 2:
                value2 = array03[indexPath.row];
                row2 = indexPath.row ;
                NSLog(@"%@",array03[indexPath.row]);
                break;
            case 3:
                value2 = array04[indexPath.row];
                row2 = indexPath.row ;
                NSLog(@"%@",array04[indexPath.row]);
                break;
            case 4:
                value2 = array05[indexPath.row];
                row2 = indexPath.row ;
                NSLog(@"%@",array05[indexPath.row]);
                break;
            case 5:
                value2 = array06[indexPath.row];
                row2 = indexPath.row ;
                NSLog(@"%@",array06[indexPath.row]);
                break;
            default:
                break;
        }
    }
}

#pragma  -mark -反选 
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == tableV1){
        
        NSIndexPath*dex1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        UITableViewCell*cell=(UITableViewCell*)[tableV1 cellForRowAtIndexPath:dex1];
        cell.textLabel.textColor=[UIColor blackColor];
    }
    else{
        
        NSIndexPath*dex1=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
        UITableViewCell*cell=(UITableViewCell*)[tableV2 cellForRowAtIndexPath:dex1];
        cell.textLabel.textColor=[UIColor blackColor];
    }
}
#pragma -mark 确定选择
-(void)sure{
    
    NSLog(@"1传值数据：%ld--%ld = %@--%@",row1,row2,value1,value2);
    NSLog(@"1111%ld",_row1value.integerValue);
    if (value2.length <= 0) {
        NSLog(@"请选择类型");
        
       
        [YJLHUD showImage:nil message:@"请选择类型"];//无图片 纯文字
        [YJLHUD dismissWithDelay:2];
        
        
    }else{
        
        
        
            if (value1.length <1)
            {
                row1 = _row1value.integerValue;
                    if (row2>0)
                    {
                        }
                else{
                        row2 = _row2value.integerValue;
                        }
            }
        
        NSLog(@"lspispig");
        NSLog(@"2传值数据：列表1位置：%ld--列表2位置：%ld = 列表2值：%@",row1,row2,value2);
        
        NSString *row11 = [NSString stringWithFormat:@"%ld",(long)row1];
        NSString *row22 = [NSString stringWithFormat:@"%ld",(long)row2];
        if(self.delegate && [self.delegate respondsToSelector:@selector(passedValue::)])
        {
            [self.delegate passedValue:row11 :row22];
        }
        NSString *inputString = value2;
        
        if (self.returnValueBlock){
            
            self.returnValueBlock(inputString);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
