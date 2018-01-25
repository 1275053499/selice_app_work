//
//  FirstcaseData.m
//  铺皇
//
//  Created by selice on 2017/9/13.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "FirstcaseData.h"
static FirstcaseData *_DBCtl = nil;
@interface FirstcaseData ()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}
@end
@implementation FirstcaseData

+(instancetype)sharecaseData{
    if (_DBCtl == nil) {
        _DBCtl  =[[FirstcaseData alloc]init];
        
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
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"CaseSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //    实力化FMDataBase对象
    _db =[FMDatabase databaseWithPath:filePath];
    [_db open];
    
    NSString *caseSql    = @"CREATE TABLE IF NOT EXISTS 'caseSql'('caseimageview' VARCHAR(255),'casetitle' VARCHAR(255),'casedistrict' VARCHAR(255),'casetime' VARCHAR(255),'casetag' VARCHAR(255),'caseprice' VARCHAR(255),'casesubid' VARCHAR(255) PRIMARY KEY)";
    
    //Anli_picture;
    //Anli_title;
    //Anli_quyu;
    //Anli_time;
    //Anli_tag;
    //Anli_area;
    //Anli_price;
    //Anli_subid;
    
    NSString *allcaseSql    = @"CREATE TABLE IF NOT EXISTS 'allcaseSql'('Anli_picture' VARCHAR(255),'Anli_title' VARCHAR(255),'Anli_quyu' VARCHAR(255),'Anli_time' VARCHAR(255),'Anli_tag' VARCHAR(255),'Anli_area' VARCHAR(255),'Anli_price' VARCHAR(255),'Anli_subid' VARCHAR(255) PRIMARY KEY)";
    
    [_db executeUpdate:allcaseSql];
    [_db executeUpdate:caseSql];
    [_db close];
}

//添加数据
-(void)addcaseData:(casecellmodel *)Model{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO caseSql (caseimageview,casetitle,casedistrict,casetime,casetag,caseprice,casesubid) VALUES(?,?,?,?,?,?,?)",Model.caseimageview,Model.casetitle,Model.casedistrict,Model.casetime,Model.casetag,Model.caseprice,Model.casesubid];
    [_db close];
}


//删除所有数据
-(void)deletedcaseData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM caseSql"];
    [_db close];
}

//获取数据
-(NSMutableArray *)getcaseAllDatas{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM caseSql"];
    while ([res next]) {
        casecellmodel *model    = [[casecellmodel alloc]init];
        model.caseimageview     = [res stringForColumn:@"caseimageview" ];
        model.casetitle         = [res stringForColumn:@"casetitle"   ];
        model.casedistrict      = [res stringForColumn:@"casedistrict"];
        model.casetime          = [res stringForColumn:@"casetime"   ];
        model.casetag           = [res stringForColumn:@"casetag"];
        model.casesubid         = [res stringForColumn:@"casesubid"];
        model.caseprice         = [res stringForColumn:@"caseprice"];
        [dataArray addObject:model];
    }
    
    [_db close];
    return  dataArray;
}







//添加全部数据
-(void)addallcaseData:(Anlimodel *)Model{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO allcaseSql (Anli_picture,Anli_title,Anli_quyu,Anli_time,Anli_tag,Anli_area,Anli_price,Anli_subid) VALUES(?,?,?,?,?,?,?,?)",Model.Anli_picture,Model.Anli_title,Model.Anli_quyu,Model.Anli_time,Model.Anli_tag,Model.Anli_area,Model.Anli_price,Model.Anli_subid];
    [_db close];
}

//删除全部数据
-(void)deletedallcaseData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM allcaseSql"];
    [_db close];
}

//获取全部数据
-(NSMutableArray *)getcaseallAllDatas{
    [_db open];
    
    NSMutableArray *dataArray   =[[NSMutableArray alloc]init];
    FMResultSet *res            =[_db executeQuery:@"SELECT * FROM allcaseSql"];
    while ([res next]) {
        Anlimodel *model        = [[Anlimodel alloc]init];
        model.Anli_picture      = [res stringForColumn:@"Anli_picture"  ];
        model.Anli_title        = [res stringForColumn:@"Anli_title"    ];
        model.Anli_quyu         = [res stringForColumn:@"Anli_quyu"     ];
        model.Anli_time         = [res stringForColumn:@"Anli_time"     ];
        model.Anli_tag          = [res stringForColumn:@"Anli_tag"      ];
        model.Anli_area         = [res stringForColumn:@"Anli_area"     ];
        model.Anli_price = [res stringForColumn:@"Anli_price"           ];
        model.Anli_subid = [res stringForColumn:@"Anli_subid"            ];
        [dataArray addObject:model];
    }

    [_db close];
    return  dataArray;
}

@end
