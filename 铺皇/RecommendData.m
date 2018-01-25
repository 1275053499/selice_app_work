//
//  RecommendData.m
//  铺皇
//
//  Created by selice on 2017/9/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecommendData.h"
static RecommendData *_DBCtl = nil;
@interface RecommendData ()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}

@end

@implementation RecommendData

+(instancetype)sharerecommendData{
    if (_DBCtl == nil) {
        _DBCtl  =[[RecommendData alloc]init];
        
        [_DBCtl initloaddata];
    }
    return _DBCtl;
}

+(instancetype )allocWithZone:(struct _NSZone *)zone{
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


#pragma -mark 创建数据表
-(void)initloaddata{
    
    NSLog(@"创建数据列表");
    //    获取document入境
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //    文件入境
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"RecommendSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //    实力化FMDataBase对象
    _db =[FMDatabase databaseWithPath:filePath];
    [_db open];
    
//    reommendImgview;
//    recomendTime;
//    recomendTitle;
//    recomendTag;
//    recomendPrice;
//    recomendSubid;
    
    NSString *recreationSql    = @"CREATE TABLE IF NOT EXISTS 'recreationSql'('reommendImgview' VARCHAR(255),'recomendTitle' VARCHAR(255),'recomendTime' VARCHAR(255),'recomendTag' VARCHAR(255),'recomendPrice' VARCHAR(255),'recomendSubid' VARCHAR(255) PRIMARY KEY)";
    
    NSString *lifeSql    = @"CREATE TABLE IF NOT EXISTS 'lifeSql'('reommendImgview' VARCHAR(255),'recomendTitle' VARCHAR(255),'recomendTime' VARCHAR(255),'recomendTag' VARCHAR(255),'recomendPrice' VARCHAR(255),'recomendSubid' VARCHAR(255) PRIMARY KEY)";
    
    NSString *departmentSql    = @"CREATE TABLE IF NOT EXISTS 'departmentSql'('reommendImgview' VARCHAR(255),'recomendTitle' VARCHAR(255),'recomendTime' VARCHAR(255),'recomendTag' VARCHAR(255),'recomendPrice' VARCHAR(255),'recomendSubid' VARCHAR(255) PRIMARY KEY)";
    
     [_db executeUpdate:lifeSql];
     [_db executeUpdate:departmentSql];
    [_db executeUpdate:recreationSql];
    [_db close];
}

#pragma  - mark 数据接口

//添加娱乐类
-(void)addrecreationData:(recomendcellmodel *)Model{
    
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO recreationSql (reommendImgview,recomendTitle,recomendTime,recomendTag,recomendPrice,recomendSubid) VALUES(?,?,?,?,?,?)",Model.reommendImgview,Model.recomendTitle,Model.recomendTime,Model.recomendTag,Model.recomendPrice,Model.recomendSubid];
    [_db close];
    
}

//删除娱乐类所有数据
-(void)deletedrecreationData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM recreationSql"];
    [_db close];
}

//获取娱乐类数据
-(NSMutableArray *)getrecreationAllDatas{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM recreationSql"];
    while ([res next]) {
        recomendcellmodel *model   = [[recomendcellmodel alloc]init];
        
        model.reommendImgview    = [res stringForColumn:@"reommendImgview" ];
        model.recomendTitle      = [res stringForColumn:@"recomendTitle"   ];
        model.recomendTime       = [res stringForColumn:@"recomendTime"    ];
        model.recomendSubid      = [res stringForColumn:@"recomendSubid"   ];
        model.recomendTag        = [res stringForColumn:@"recomendTag"     ];
        model.recomendPrice      = [res stringForColumn:@"recomendPrice"   ];
        
        [dataArray addObject:model];
    }
    
    [_db close];
    return  dataArray;
}


//添加生活类
-(void)addlifeData:(recomendcellmodel *)Model{

    [_db open];
    [_db executeUpdate:@"INSERT INTO lifeSql (reommendImgview,recomendTitle,recomendTime,recomendTag,recomendPrice,recomendSubid) VALUES(?,?,?,?,?,?)",Model.reommendImgview,Model.recomendTitle,Model.recomendTime,Model.recomendTag,Model.recomendPrice,Model.recomendSubid];
    [_db close];
    
}

//删除生活所有数据
-(void)deletedlifeData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM lifeSql"];
    [_db close];
}

//获取生活数据
-(NSMutableArray *)getlifeAllDatas{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM lifeSql"];
    while ([res next]) {
        recomendcellmodel *model   = [[recomendcellmodel alloc]init];
        model.reommendImgview    = [res stringForColumn:@"reommendImgview" ];
        model.recomendTitle      = [res stringForColumn:@"recomendTitle"   ];
        model.recomendTime       = [res stringForColumn:@"recomendTime"];
        model.recomendSubid      = [res stringForColumn:@"recomendSubid"   ];
        model.recomendTag        = [res stringForColumn:@"recomendTag"];
        model.recomendPrice      = [res stringForColumn:@"recomendPrice"];
        
        [dataArray addObject:model];
    }
    [_db close];
    return  dataArray;
}

//添加百货类
-(void)adddepartmentData:(recomendcellmodel *)Model{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO departmentSql (reommendImgview,recomendTitle,recomendTime,recomendTag,recomendPrice,recomendSubid) VALUES(?,?,?,?,?,?)",Model.reommendImgview,Model.recomendTitle,Model.recomendTime,Model.recomendTag,Model.recomendPrice,Model.recomendSubid];
    [_db close];
    
}

//删除百货所有数据
-(void)deleteddepartmentData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM departmentSql"];
    [_db close];
}

//获取百货数据
-(NSMutableArray *)getdepartmentAllDatas{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM departmentSql"];
    while ([res next]) {
        recomendcellmodel *model   = [[recomendcellmodel alloc]init];
        model.reommendImgview    = [res stringForColumn:@"reommendImgview" ];
        model.recomendTitle      = [res stringForColumn:@"recomendTitle"   ];
        model.recomendTime       = [res stringForColumn:@"recomendTime"];
        model.recomendSubid      = [res stringForColumn:@"recomendSubid"   ];
        model.recomendTag        = [res stringForColumn:@"recomendTag"];
        model.recomendPrice      = [res stringForColumn:@"recomendPrice"];
        [dataArray addObject:model];
    }
    [_db close];
    return  dataArray;
}

@end

