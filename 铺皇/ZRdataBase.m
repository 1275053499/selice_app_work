//
//  ZRdataBase.m
//  铺皇
//
//  Created by 铺皇网 on 2017/8/22.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "ZRdataBase.h"
static ZRdataBase *_DBCtl = nil;
@interface ZRdataBase ()<NSCopying,NSMutableCopying>{
    
    FMDatabase *_db;
}
@end

@implementation ZRdataBase

+(instancetype)shareZRdataBase{
    if (_DBCtl == nil) {
        _DBCtl = [[ZRdataBase alloc]init];
        
        [_DBCtl initZRDatabase];
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

#pragma -mark 创建数据表
-(void)initZRDatabase{
    
     NSLog(@"创建数据列表");
    //      获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
   
    //      文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"ZRshopSql.sqlite"];
    NSLog(@"%@",filePath);
    
    //      实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filePath];
    [_db open];
    
    //      初始化数据表
    NSString *ZRshopSql    = @"CREATE TABLE IF NOT EXISTS 'ZRshop' ('JX_picture' VARCHAR(255),'JX_title' VARCHAR(255),'JX_quyu' VARCHAR(255),'JX_time' VARCHAR(255),'JX_tag' VARCHAR(255),'JX_area' VARCHAR(255),'JX_rent' VARCHAR(255),'JX_subid' VARCHAR(255)PRIMARY KEY)";
    [_db executeUpdate:ZRshopSql];

    [_db close];
}


#pragma - mark 数据接口
// 添加数据
-(void)addshopZR:(JX_FourModel *)dynamicModel{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO ZRshop(JX_picture,JX_title,JX_quyu,JX_time,JX_tag,JX_area,JX_rent,JX_subid)VALUES(?,?,?,?,?,?,?,?)",dynamicModel.JX_picture,dynamicModel.JX_title,dynamicModel.JX_quyu,dynamicModel.JX_time,dynamicModel.JX_tag,dynamicModel.JX_area,dynamicModel.JX_rent,dynamicModel.JX_subid];
    [_db close];
}

//删除所有的数据
-(void)deletedZRdata{
    
    [_db open];
    [_db executeUpdate:@"DELETE FROM ZRshop"                    ];
    //     [_db executeUpdate:@"DELETE FROM news WHERE newsID = ?",dynamicModel.newsID];  //删除指定的数据
    [_db close];
}

//获取数据
- (NSMutableArray *)getAllDatas{
    
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init      ];
    FMResultSet *res        = [_db executeQuery:@"SELECT * FROM ZRshop"];
    while ([res next]) {
        JX_FourModel *model = [[JX_FourModel alloc] init        ];
        model.JX_picture    = [res stringForColumn:@"JX_picture"];
        model.JX_title      = [res stringForColumn:@"JX_title"  ];
        model.JX_quyu       = [res stringForColumn:@"JX_quyu"   ];
        model.JX_time       = [res stringForColumn:@"JX_time"   ];
        model.JX_tag        = [res stringForColumn:@"JX_tag"    ];
        model.JX_area       = [res stringForColumn:@"JX_area"   ];
        model.JX_rent      =  [res stringForColumn:@"JX_rent"   ];
        model.JX_subid      = [res stringForColumn:@"JX_subid"  ];
        [dataArray addObject:model];
    }
    [_db close];
    return dataArray;
}
@end
