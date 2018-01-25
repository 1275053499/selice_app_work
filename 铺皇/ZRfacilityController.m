//
//  ZRfacilityController.m
//  铺皇
//
//  Created by 铺皇网 on 2017/5/26.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRfacilityController.h"
#import "ZHBtnSelectView.h"
#import "ZHCustomBtn.h"
@interface ZRfacilityController ()<ZHBtnSelectViewDelegate>
@property (nonatomic,strong)UIButton  *surebtn;
@property (nonatomic,weak)ZHCustomBtn *currentBtn;
@property (nonatomic,weak)ZHBtnSelectView *btnView;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,strong)NSArray * titlenames;
@property (nonatomic,strong)NSString *inputStringname;
@property (nonatomic,strong)NSString *inputStringid;
@end

@implementation ZRfacilityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputStringname  = [[NSString alloc]init];
    self.inputStringid  = [[NSString alloc]init];
    
    UIBarButtonItem *backItm = [UIBarButtonItem barButtonItemWithImage:@"heise_fanghui" highImage:nil target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItm;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"选择店铺设施标签";
   
    //右滑手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(recognizer:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
#pragma  -mark确认按钮按钮初始化
    _surebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_surebtn  setBackgroundImage:[UIImage imageNamed:@"pay_bg@2x"] forState:UIControlStateNormal];
    [_surebtn setTitle:@"确定" forState:UIControlStateNormal];
    [_surebtn addTarget:self action:@selector(sureback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_surebtn];
    //    选择适配方法
    [self.surebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(KMainScreenWidth-40, 40));
        make.left.equalTo(self.view).with.offset(20);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    
    self.titleArr               = @[].mutableCopy;
    self.titlenames             = @[@"上下火",@"可明火",@"380V",@"煤气管道",@"排烟管道",@"排污管道",@"停车位",@"产权",@"证件齐全",@"中央空调"];
    
    // 自动计算view的高度
    ZHBtnSelectView *btnView    = [[ZHBtnSelectView alloc] initWithFrame:CGRectMake(0, 64, KMainScreenWidth,0)
                                                               titles:self.titlenames column:3];
    [self.view addSubview:btnView];
    btnView.backgroundColor = [UIColor whiteColor];
    btnView.verticalMargin  = 10;
    btnView.delegate        = self;
    self.btnView            = btnView;
    //    确认选择类型 多选
    self.btnView.selectType = BtnSelectTypeMultiChoose;
}

// view的代理方法
- (void)btnSelectView:(ZHBtnSelectView *)btnSelectView selectedBtn:(ZHCustomBtn *)btn {
    
    if (self.btnView.selectType)
    { // 多选
        btn.btnSelected = !btn.btnSelected;
        
        if (btn.btnSelected){
            [self.titleArr addObject:btn.titleLabel.text];
            
        }
        
        else
        {
            [self.titleArr removeObject:btn.titleLabel.text];
        }
        
        NSLog(@"有%ld个数值",self.titleArr.count);
        
//        NSLog(@"111--222--%@--",btn.titleLabel.text);
    }
}

#pragma  -mark - 按钮确认并返回   block回去传旨了
-(void)sureback:(UIButton *)btn{
    
    if (self.titleArr.count<1) {
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您没有选择设施，必须选择至少一项" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"选择" style:UIAlertActionStyleDefault handler:nil];
        [alertC addAction:alertAction];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }else{
        for (int i =0; i < self.titleArr.count; i++)
        {
            for (int j =0; j < self.titlenames.count; j++ )
            {
                if ([self.titleArr[i] isEqualToString:self.titlenames[j]])
                {
                    NSLog(@"%d==%@",j,self.titlenames[j]);
                    _inputStringid   = [_inputStringid  stringByAppendingString:[NSString stringWithFormat:@"%d,",j+1]];
                    _inputStringname = [_inputStringname stringByAppendingString:[NSString stringWithFormat:@"%@ ",self.titlenames[j]]];
                    NSLog(@"id:%@=name:%@",_inputStringid,_inputStringname);
                }
            }
        }
        
        //name
        if (self.returnValueBlock)
        {
            self.returnValueBlock(_inputStringname);
        }
        
        //ID
        if (self.returnValueBlockid)
        {
            self.returnValueBlockid(_inputStringid);
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

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];

}


@end
