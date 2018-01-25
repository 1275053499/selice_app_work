//
//  SiftrentData.m
//  铺皇
//
//  Created by selice on 2017/8/31.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "SiftrentData.h"
static SiftrentData *_DBCtl = nil;
@interface SiftrentData ()<NSCopying,NSMutableCopying>{
    
    FMDatabase *_db;
}
@end
@implementation SiftrentData

+(instancetype)sharerentData{
    if (_DBCtl == nil) {
        _DBCtl = [[SiftrentData alloc]init];
        
        [_DBCtl initSiftDatabase];
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

-(void)initSiftDatabase{
    
    NSLog(@"创建数据列表");
    //      获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //      文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"SiftrentshopSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //      实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    
    //      初始化数据表
    NSString *SiftrentshopSql    = @"CREATE TABLE IF NOT EXISTS 'Siftrentshop' ('Featureimg' VARCHAR(255),'Featuretitle' VARCHAR(255),'Featurequyu' VARCHAR(255),'Featuretime' VARCHAR(255),'Featuretype' VARCHAR(255),'Featurecommit' VARCHAR(255),'Featurehassee' VARCHAR(255),'Featuresubid' VARCHAR(255)PRIMARY KEY)";
    [_db executeUpdate:SiftrentshopSql];
    [_db close];
}

//Featureimg;       //精选图片
//Featuretitle;     //精选标题
//Featurequyu;      //精选区域
//Featuretime;      //精选时间
//Featuretype;      //精选类型
//Featurecommit;    //精选公共
//Featurehassee;    //精选浏览量
//Featuresubid

#pragma - mark 数据接口
// 添加数据
-(void)addshoprent:(Featuremodel *)dynamicModel{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO Siftrentshop(Featureimg,Featuretitle,Featurequyu,Featuretime,Featuretype,Featurecommit,Featurehassee,Featuresubid)VALUES(?,?,?,?,?,?,?,?)",dynamicModel.Featureimg,dynamicModel.Featuretitle,dynamicModel.Featurequyu,dynamicModel.Featuretime,dynamicModel.Featuretype,dynamicModel.Featurecommit,dynamicModel.Featurehassee,dynamicModel.Featuresubid];
    [_db close];
}

//删除所有的数据
-(void)deletedrentData{
    
    [_db open];
    [_db executeUpdate:@"DELETE FROM Siftrentshop"                    ];
    //     [_db executeUpdate:@"DELETE FROM news WHERE newsID = ?",dynamicModel.newsID];  //删除指定的数据
    [_db close];
}

//获取数据
- (NSMutableArray *)getAllDatas{
    
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init      ];
    FMResultSet *res        = [_db executeQuery:@"SELECT * FROM Siftrentshop"];
    while ([res next]) {
        Featuremodel *model = [[Featuremodel alloc] init        ];
        model.Featureimg        = [res stringForColumn:@"Featureimg"    ];
        model.Featuretitle      = [res stringForColumn:@"Featuretitle"  ];
        model.Featurequyu       = [res stringForColumn:@"Featurequyu"   ];
        model.Featuretime       = [res stringForColumn:@"Featuretime"   ];
        model.Featuretype       = [res stringForColumn:@"Featuretype"   ];
        model.Featurecommit     = [res stringForColumn:@"Featurecommit" ];
        model.Featurehassee     = [res stringForColumn:@"Featurehassee" ];
        model.Featuresubid      = [res stringForColumn:@"Featuresubid"  ];
        
        [dataArray addObject:model];
    }
    [_db close];
    return dataArray;
}


@end
