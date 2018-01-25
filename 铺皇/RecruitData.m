//
//  RecruitData.m
//  铺皇
//
//  Created by selice on 2017/9/2.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#import "RecruitData.h"
static RecruitData *_DbCtl = nil;
@interface RecruitData ()<NSCopying,NSMutableCopying>{
    FMDatabase *_db;
}

@end
@implementation RecruitData


+(instancetype)sharerecruitData{
    if (_DbCtl == nil) {
        _DbCtl =[[RecruitData alloc]init];
        [_DbCtl initloadData];
    }
    return _DbCtl;
}



+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DbCtl == nil) {
        _DbCtl = [super allocWithZone:zone];
    }
    return _DbCtl;
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

//构造数据库
-(void)initloadData{
    
//    创建数据列表
    NSLog(@"创建数据列表");
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
//    文件路径
    NSString *filepath = [documentsPath stringByAppendingPathComponent:@"recruitSql.sqlite"];
    NSLog(@"%@",filepath);
    
//    实例化FMDataBase对象
    _db = [FMDatabase databaseWithPath:filepath];
    [_db open];
//    @property (strong, nonatomic) NSString  *CompanyJobname;   //招聘职位
//    @property (strong, nonatomic) NSString  *CompanyTimers;    //招聘时间
//    @property (strong, nonatomic) NSString  *Companyname;      //公司名称
//    @property (strong, nonatomic) NSString  *CompanyArea;      //公司所在区域
//    @property (strong, nonatomic) NSString  *CompanySuffer;    //招聘经验
//    @property (strong, nonatomic) NSString  *Companyeducation; //招聘学历
//    @property (strong, nonatomic) NSString  *Companysalary;    //招聘工资
//    @property (strong, nonatomic) NSString  *Companyid;         //id
    
//    初始化列表
    NSString *recruitSql = @"CREATE TABLE IF NOT EXISTS 'RecruitAll' ('CompanyJobname' VARCHAR(255),'CompanyTimers' VARCHAR(255),'Companyname' VARCHAR(255),'CompanyArea' VARCHAR(255),'CompanySuffer' VARCHAR(255),'Companyeducation' VARCHAR(255),'Companysalary' VARCHAR(255),'Companyid' VARCHAR(255)PRIMARY KEY)";
    [_db executeUpdate:recruitSql];
    [_db close];
}


#pragma - mark 数据接口
//添加数据

-(void)addrecruit:(ShopsrecruitModel *)dynamicModel{
    [_db open];
    [_db executeUpdate:@"INSERT INTO RecruitAll(CompanyJobname,CompanyTimers,Companyname,CompanyArea,CompanySuffer,Companyeducation,Companysalary,Companyid)VALUES(?,?,?,?,?,?,?,?)",dynamicModel.CompanyJobname,dynamicModel.CompanyTimers,dynamicModel.Companyname,dynamicModel.CompanyArea,dynamicModel.CompanySuffer,dynamicModel.Companyeducation,dynamicModel.Companysalary,dynamicModel.Companyid];
    [_db close];
    
}

//删除数据
-(void)deletedsrecruitData{
    [_db open];
    [_db executeUpdate:@"DELETE FROM RecruitAll"];
    [_db close];
}

//获取数据
-(NSMutableArray*)getAllDatas{
    [_db open];
    
    NSMutableArray *dataArray =[[NSMutableArray alloc]init];
    FMResultSet *res= [_db executeQuery: @"SELECT *FROM RecruitAll"];
    while ([res next]) {
        ShopsrecruitModel *model    = [[ShopsrecruitModel alloc]init];
        model.CompanyJobname        = [res stringForColumn:@"CompanyJobname"    ];
        model.CompanyTimers         = [res stringForColumn:@"CompanyTimers"     ];
        model.Companyname           = [res stringForColumn:@"Companyname"       ];
        model.CompanyArea           = [res stringForColumn:@"CompanyArea"       ];
        model.CompanySuffer         = [res stringForColumn:@"CompanySuffer"     ];
        model.Companyeducation      = [res stringForColumn:@"Companyeducation"  ];
        model.Companysalary         = [res stringForColumn:@"Companysalary"     ];
        model.Companyid             = [res stringForColumn:@"Companyid"         ];
        [dataArray addObject:model];
    }
    
    [_db close];
    
    return  dataArray;
}









@end
