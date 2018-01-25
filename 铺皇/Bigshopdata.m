//
//  Bigshopdata.m
//  铺皇
//
//  Created by selice on 2017/9/19.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "Bigshopdata.h"
static Bigshopdata *_DBCtl = nil;
@interface Bigshopdata ()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}
@end

@implementation Bigshopdata

+(instancetype)sharebigData{
    if (_DBCtl == nil) {
        _DBCtl  =[[Bigshopdata alloc]init];
        
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
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"BigSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //    实力化FMDataBase对象
    _db =[FMDatabase databaseWithPath:filePath];
    [_db open];
    
    NSString *bigSql    = @"CREATE TABLE IF NOT EXISTS 'bigSql'('Newbigdata' VARCHAR(255),'Agobigdata' VARCHAR(255),'Setbigdata' VARCHAR(255) PRIMARY KEY)";

    
    [_db executeUpdate:bigSql];
    [_db close];

}

-(void)addbignewData:(Bigdatamodel *)Model{
    [_db open];
    [_db executeUpdate: @"INSERT INTO bigSql (Newbigdata,Agobigdata,Setbigdata) VALUES(?,?,?)",Model.Newbigdata,Model.Agobigdata,Model.Setbigdata];
    [_db close];
}

//删除所有数据
-(void)deletedbignewData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM bigSql"];
    [_db close];
}


//获取数据
-(NSMutableArray *)getbignewData{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM bigSql"];
    while ([res next]) {
        Bigdatamodel *model    = [[Bigdatamodel alloc]init];
        model.Newbigdata     = [res stringForColumn:@"Newbigdata" ];
        model.Agobigdata         = [res stringForColumn:@"Agobigdata"   ];
        model.Setbigdata      = [res stringForColumn:@"Setbigdata"];
               [dataArray addObject:model];
    }
    [_db close];
    return  dataArray;
}


@end
