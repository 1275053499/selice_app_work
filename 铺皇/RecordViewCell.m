//
//  RecordViewCell.m
//  铺皇精简版
//
//  Created by selice on 2017/12/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecordViewCell.h"
#define YJL(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#import "RecordModel.h"
@interface RecordViewCell ()

#define nick_H_W    80
#define space       10
//@property (nonatomic,weak) UIImageView *nick;  //头像
@property (nonatomic,weak) UILabel *nick; //显示文本的label
@property (nonatomic,weak) UILabel *record; //显示文本的label
@property (nonatomic,weak) UILabel *times; //显示文本的label
@property (nonatomic,weak) UIImageView *line;  //下划线

//定义一个contentLabel文本高度的属性
@property (nonatomic,assign) CGFloat contentLabelH;

@end

@implementation RecordViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UILabel *nick = [UILabel new];
    nick.font = [UIFont systemFontOfSize:14];
    nick.numberOfLines = 1;
    nick.textColor=[UIColor blackColor];
    [self.contentView addSubview:nick];
    self.nick=nick;
    
    UILabel *times = [UILabel new];
    times.font = [UIFont systemFontOfSize:14];
    times.adjustsFontSizeToFitWidth = YES;
    times.textColor =kTCColor(85, 85, 85);
    times.textAlignment   = NSTextAlignmentRight;
    [self.contentView addSubview:times];
    self.times=times;
    
    UILabel *record = [UILabel new];
    record.font = [UIFont systemFontOfSize:14];
    record.numberOfLines = 0;
    record.textColor=[UIColor grayColor];
    [self.contentView addSubview:record];
    self.record=record;
    
//    UIImageView *line=[UIImageView new];
//    line.backgroundColor=[UIColor grayColor];
//    [self.contentView addSubview:line];
//    self.line=line;
    
    //设置约束
    __weak __typeof(&*self)weakSelf = self;
    
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2*space);
        make.width.mas_equalTo(KMainScreenWidth/2-15);
        make.top.equalTo(weakSelf.mas_top).offset(space);
        make.left.equalTo(weakSelf.mas_left).offset(space);
        
    }];

    [self.times mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(2*space);
        make.width.mas_equalTo(KMainScreenWidth/2-15);
        make.top.equalTo(weakSelf.mas_top).offset(space);
        make.right.equalTo(weakSelf.mas_right).offset(-space);
        
    }];
    
    //2.设置contentLabel
    [self.record mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nick.mas_bottom).offset(space);   //文本距离头像底部10个间距
        make.left.equalTo(weakSelf.mas_left).offset(space);         //文本距离左边的距离
        make.right.equalTo(weakSelf.mas_right).offset(-space);      //文本距离右边的距离
        
        //文本高度 我们再得到模型的时候 在传递
    }];
    
//    //3.设置下划线的大小
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0.5);
//        make.left.equalTo(weakSelf.mas_left).offset(0);
//        make.right.equalTo(weakSelf.mas_right).offset(0);
//        make.bottom.equalTo(weakSelf.mas_bottom).offset(-5); //下划线距离底部10的距离
//    }];
}

-(void)setRecordModel:(RecordModel *)recordModel{
        _recordModel =recordModel;
        self.times.text =recordModel.times;
        self.nick.text =recordModel.nick;
        self.record.text =recordModel.record;
}


-(CGFloat)rowHeightWithCellModel:(RecordModel *)model{
    
    _recordModel = model;
    __weak __typeof(&*self)weakSelf = self;
    //设置标签的高度
    [self.record mas_makeConstraints:^(MASConstraintMaker *make) {
        // weakSelf.contentLabelH  这个会调用下面的懒加载方法
        make.height.mas_equalTo(weakSelf.recordLabel_H);
    }];
    
//    更新约束
    [self layoutIfNeeded];
    
    CGFloat H = CGRectGetMaxY(self.record.frame);
    
    return  H;
}

/*
 *  懒加载的方法返回contentLabel的高度  (只会调用一次)
 */

-(CGFloat)recordLabel_H{
    
    if(!_contentLabelH){
        
        CGFloat h=[self.recordModel.record boundingRectWithSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width)-2*space, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        _contentLabelH = h+space;  //内容距离底部下划线10的距离
    }
        NSLog(@"Cell:.1%lf",_contentLabelH);
        return _contentLabelH;
}

@end
