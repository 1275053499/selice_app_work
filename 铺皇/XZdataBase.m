//
//  XZdataBase.m
//  铺皇
//
//  Created by 铺皇网 on 2017/8/25.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "XZdataBase.h"
static XZdataBase *_DBCtl = nil;
@interface XZdataBase()<NSCopying,NSMutableCopying>{
    
    FMDatabase *_db;
}
@end

@implementation XZdataBase

+(instancetype)shareXZdataBase{
    if (_DBCtl == nil) {
        _DBCtl = [[XZdataBase alloc]init];
        
        [_DBCtl initXZDatabase];
    }
    return _DBCtl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
    }
    return _DBCtl;
}


-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}
#pragma -mark 创建数据表

-(void)initXZDatabase{
    
    NSLog(@"创建数据列表");
    //      获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //      文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"XZshopSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //      实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    
//    初始化 数据表
   NSString  * XZshopSqlite        =  @"CREATE TABLE IF NOT EXISTS 'XZshop' ('Shopsitetitle' VARCHAR(255),'Shopsitedescribe' VARCHAR(255),'Shopsitetype' VARCHAR(255),'Shopsitearea' VARCHAR(255),'Shopsiterent' VARCHAR(255),'Shopsitequyu' VARCHAR(255),'Shopsitesubid' VARCHAR(255) PRIMARY KEY)";
    
   
    [_db executeUpdate:XZshopSqlite];
 
    [_db close];
}


#pragma - mark 数据接口
// 添加数据
-(void)addshopXZ:(Shopsitemodel *)dynamicModel{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO XZshop(Shopsitetitle,Shopsitedescribe,Shopsitetype,Shopsitearea,Shopsiterent,Shopsitequyu,Shopsitesubid) VALUES(?,?,?,?,?,?,?)",dynamicModel.Shopsitetitle,dynamicModel.Shopsitedescribe,dynamicModel.Shopsitetype,dynamicModel.Shopsitearea,dynamicModel.Shopsiterent,dynamicModel.Shopsitequyu,dynamicModel.Shopsitesubid];
    [_db close];
}

//删除所有的数据
-(void)deletedXZdata{
    
    [_db open];
    [_db executeUpdate:@"DELETE FROM XZshop"];
    [_db close];
}

//获取数据
- (NSMutableArray *)getAllDatas{
    
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res                = [_db executeQuery:@"SELECT * FROM XZshop" ];
    while ([res next]) {
        
        Shopsitemodel        *model = [[Shopsitemodel alloc] init               ];
        model.Shopsitetitle         = [res stringForColumn:@"Shopsitetitle"     ];
        model.Shopsitedescribe      = [res stringForColumn:@"Shopsitedescribe"  ];
        model.Shopsitetype          = [res stringForColumn:@"Shopsitetype"      ];
        model.Shopsitearea          = [res stringForColumn:@"Shopsitearea"      ];
        model.Shopsiterent          = [res stringForColumn:@"Shopsiterent"      ];
        model.Shopsitequyu          = [res stringForColumn:@"Shopsitequyu"      ];
        model.Shopsitesubid         = [res stringForColumn:@"Shopsitesubid"     ];
        [dataArray addObject:model];
    }
    
    [_db close];
    return dataArray;
}

@end



