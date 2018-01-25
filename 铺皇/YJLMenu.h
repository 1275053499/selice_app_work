//
//  YJLMenu.h
//  铺皇
//
//  Created by selice on 2017/11/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJLIndexPath : NSObject
@property (nonatomic, assign) NSInteger row; //行
@property (nonatomic, assign) NSInteger column; //列
@property (nonatomic, assign) NSInteger item; //item

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;

+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithColumn:(NSInteger)column row:(NSInteger)row item:(NSInteger)item;

@end


#pragma  mark - datasource
@class YJLMenu;
@protocol YJLMenuDataSource <NSObject>

@required
//每个column有多少行
- (NSInteger)menu:(YJLMenu *)menu numberOfRowsInColumn:(NSInteger)column;
//每个column中每行的title
- (NSString *)menu:(YJLMenu *)menu titleForRowAtIndexPath:(YJLIndexPath *)indexPath;

@optional
//有多少个column，默认为1列
- (NSInteger)numberOfColumnsInMenu:(YJLMenu *)menu;
//第column列，没行的image
- (NSString *)menu:(YJLMenu *)menu imageNameForRowAtIndexPath:(YJLIndexPath *)indexPath;
//detail text
- (NSString *)menu:(YJLMenu *)menu detailTextForRowAtIndexPath:(YJLIndexPath *)indexPath;
//某列的某行item的数量，如果有，则说明有二级菜单，反之亦然
- (NSInteger)menu:(YJLMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column;
//如果有二级菜单，则实现下列协议
//二级菜单的标题
- (NSString *)menu:(YJLMenu *)menu titleForItemsInRowAtIndexPath:(YJLIndexPath *)indexPath;
//二级菜单的image
- (NSString *)menu:(YJLMenu *)menu imageForItemsInRowAtIndexPath:(YJLIndexPath *)indexPath;
//二级菜单的detail text
- (NSString *)menu:(YJLMenu *)menu detailTextForItemsInRowAtIndexPath:(YJLIndexPath *)indexPath;
@end

#pragma mark - delegate
@protocol YJLMenuDelegate <NSObject>

@optional
//点击
- (void)menu:(YJLMenu *)menu didSelectRowAtIndexPath:(YJLIndexPath *)indexPath;

@end

@interface YJLMenu : UIView

@property (nonatomic, weak) id<YJLMenuDelegate> delegate;
@property (nonatomic, weak) id<YJLMenuDataSource> dataSource;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;
@property (nonatomic, strong) UIColor *detailTextColor;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIFont *detailTextFont;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) NSInteger fontSize;
//当前选中的列
@property (nonatomic, strong) NSMutableArray *currentSelectedRows;
//当有二级列表的时候，是否调用点击代理方法
@property (nonatomic, assign) BOOL isClickHaveItemValid;
//获取title
- (NSString *)titleForRowAtIndexPath:(YJLIndexPath *)indexPath;
//初始化方法
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
//菜单切换，选中的indexPath
- (void)selectIndexPath:(YJLIndexPath *)indexPath;
//默认选中
- (void)selectDeafultIndexPath;
//数据重载
- (void)reloadData;

@end






