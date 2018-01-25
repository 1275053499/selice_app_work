//
//  pershowData.m
//  铺皇
//
//  Created by selice on 2017/9/9.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "pershowData.h"
static pershowData *_DBCtl = nil;
@interface pershowData ()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}


@end

@implementation pershowData

+(instancetype)shareshowperData{
    if (_DBCtl == nil) {
        _DBCtl = [[pershowData alloc]init];
        [_DBCtl loadshowdatafield];
    }
    return  _DBCtl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl =[super allocWithZone:zone];
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

//personimage;     //头像
//personnickname;  //昵称
//personsex;       //性别
//personphone;     //账号
//personcity;      //城市
//personsignature; //签名

#pragma -mark 创建数据表
-(void)loadshowdatafield{
    
     NSLog(@"创建数据列表");
    //    获取document入境
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    //    文件入境
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"PershowdataSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //    实力化FMDataBase对象
    _db =[FMDatabase databaseWithPath:filePath];
    [_db open];
    
    NSString *PersonshowSql   = @"CREATE TABLE IF NOT EXISTS 'personshowSql'('personimage' VARCHAR(255),'personnickname' VARCHAR(255),'personsex' VARCHAR(255),'personphone' VARCHAR(255) ,'personcity' VARCHAR(255),'personsignature' VARCHAR(255),'personintegral' VARCHAR(255)PRIMARY KEY)";
    [_db executeUpdate:PersonshowSql];
    [_db close];

}

#pragma  - mark 数据接口
//添加数据
-(void)addshowData:(personshowmodel *)Model{
    [_db open];
    [_db executeUpdate:@"INSERT INTO personshowSql (personimage,personnickname,personsex,personphone,personcity,personsignature,personintegral) VALUES(?,?,?,?,?,?,?)",Model.personimage,Model.personnickname,Model.personsex,Model.personphone,Model.personcity,Model.personsignature,Model.personintegral];
    [_db close];
}

//删除数据
-(void)deletedData{
    
    [_db open];
    [_db executeUpdate:@"DELETE FROM personshowSql"];
    [_db close];
}

//更新数据
-(void)updateData:(personshowmodel *)Model{
    
    [_db open];
    [_db executeUpdate:@"UPDATE 'personshowSql' SET personimage = ? WHERE personphone = ? ",Model.personimage,Model.personphone];
    [_db executeUpdate:@"UPDATE 'personshowSql' SET personnickname = ? WHERE personphone = ? ",Model.personnickname,Model.personphone];
    [_db executeUpdate:@"UPDATE 'personshowSql' SET personsex = ? WHERE personphone = ? ",Model.personsex,Model.personphone];
    [_db executeUpdate:@"UPDATE 'personshowSql' SET personcity = ? WHERE personphone = ? ",Model.personcity,Model.personphone];
    [_db executeUpdate:@"UPDATE 'personshowSql' SET personsignature = ? WHERE personphone = ? ",Model.personsignature,Model.personphone];
    
    [_db close];
}


//获取数据
-(NSMutableArray *)getAllDatas{
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM personshowSql"];
    while ([res next]) {
        personshowmodel *model = [[personshowmodel alloc]init];
        
        model.personimage       =   [res stringForColumn:@"personimage"];
        model.personnickname    =   [res stringForColumn:@"personnickname"];
        model.personsignature   =   [res stringForColumn:@"personsignature"];
        model.personsex         =   [res stringForColumn:@"personsex"];
        model.personphone       =   [res stringForColumn:@"personphone"];
        model.personcity        =   [res stringForColumn:@"personcity"];
        model.personintegral    =   [res stringForColumn:@"personintegral"];
        [dataArray addObject:model];
    }
    
    [_db close];
    return  dataArray;
}


@end
