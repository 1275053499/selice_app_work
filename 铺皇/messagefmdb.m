//
//  messagefmdb.m
//  铺皇
//
//  Created by selice on 2017/11/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "messagefmdb.h"

static messagefmdb * _DBCtl = nil;
@interface messagefmdb ()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}

@end

@implementation messagefmdb

+(instancetype)sharemessageData{
    if (_DBCtl == nil) {
        _DBCtl = [[messagefmdb alloc]init];
        [_DBCtl initlodadata];
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
-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(void)initlodadata{
    
    NSLog(@"创建数据列表");
    //    获取document入境
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //    文件入境
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"MessageSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //    实力化FMDataBase对象
    _db =[FMDatabase databaseWithPath:filePath];
    [_db open];
    
   
    
    NSString *messageSql    = @"CREATE TABLE IF NOT EXISTS 'messageSql'('body' VARCHAR(255),'subtitle' VARCHAR(255),'title' VARCHAR(255),'type' VARCHAR(255),'shopid' VARCHAR(255),'code' VARCHAR(255),'time' VARCHAR(255) PRIMARY KEY)";
    [_db executeUpdate:messageSql];
    [_db close];
    
}

//添加数据
-(void)adddata:(messagemodel *)model{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO messageSql (body,subtitle,title,type,shopid,code,time) VALUES(?,?,?,?,?,?,?)",model.body,model.subtitle,model.title,model.type,model.shopid,model.code,model.time];
    [_db close];
}

//删除所有数据
-(void)deledata:(messagemodel *)model{
    [_db open];
    [_db executeUpdate:@"DELETE FROM messageSql"];
    [_db close];
}

//获取数据
-(NSMutableArray *)getdatas{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM messageSql"];
    while ([res next]) {
        messagemodel *model         = [[messagemodel alloc]init];
        model.body                  = [res stringForColumn:@"body" ];
        model.subtitle              = [res stringForColumn:@"subtitle"   ];
        model.title                 = [res stringForColumn:@"title"];
        model.type                  = [res stringForColumn:@"type"   ];
        model.shopid                = [res stringForColumn:@"shopid"];
        model.code                  = [res stringForColumn:@"code"];
        model.time                  = [res stringForColumn:@"time"];
        [dataArray addObject:model];
    }
    
    [_db close];
    return  dataArray;
}
//@property(nonatomic,strong)NSString *body;      //内容
//@property(nonatomic,strong)NSString *subtitle;  //副标题
//@property(nonatomic,strong)NSString *title;     //标题
//@property(nonatomic,strong)NSString *type;      //推送类型 转让zr 出租cz 选址xz 招聘zp
//@property(nonatomic,strong)NSString *shopid;    //店铺id
//@property(nonatomic,strong)NSString *code;      //或者数据判断

@end
