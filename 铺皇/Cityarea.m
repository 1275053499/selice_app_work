//
//  Cityarea.m
//  铺皇
//
//  Created by selice on 2017/11/21.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "Cityarea.h"
static Cityarea *_DBCtl = nil;
@interface Cityarea ()<NSCopying,NSMutableCopying>{
    
    FMDatabase *_db;
}
@end
@implementation Cityarea

+(instancetype)shareCityData{
    if (_DBCtl == nil) {
        _DBCtl = [[Cityarea alloc]init];
        
        [_DBCtl initData];
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

-(id)copyWithZone:(NSZone *)zone{
    return self;
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}

-(void)initData{
    NSLog(@"创建数据列表");
    //      获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //      文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"CityareaSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //      实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    
    NSString *cityareaSql = @"CREATE TABLE IF NOT EXISTS 'CITYAREA' ('Cityareaname' VARCHAR(255),'Cityareaid' VARCHAR(255)PRIMARY KEY)";

    [_db executeUpdate:cityareaSql];
    [_db close];
}

#pragma - mark menu数据接口
//存数据
-(void)addCityarea:(Cityareamodel *)Model{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO CITYAREA(Cityareaname,Cityareaid)VALUES(?,?)",Model.Cityareaname,Model.Cityareaid];
    [_db close];
}
//删除所有的数据
-(void)deletedCityarea{
    [_db open];
    [_db executeUpdate:@"DELETE FROM CITYAREA"];
    [_db close];
}

//取数据
-(NSMutableArray *)getAllCityarea{
    
    [_db open];
    NSMutableArray *datamenuArray = [[NSMutableArray alloc]init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM CITYAREA"];
    while ([res next]) {
        Cityareamodel *model =[[Cityareamodel alloc]init];
        model.Cityareaname = [res stringForColumn:@"Cityareaname"];
        model.Cityareaid   = [res stringForColumn:@"Cityareaid"];
        [datamenuArray addObject:model];
    }
    [_db close];
    return datamenuArray;
}

@end
