//
//  Defination.h
//  铺皇
//
//  Created by 中国铺皇 on 2017/4/10.
//  Copyright © 2017年 中国铺皇. All rights reserved.
//

#ifndef Defination_h
#define Defination_h
#define HOST                 @"https://ph.chinapuhuang.com/API.php/"           //入口

                            #pragma -mark 登录注册
#define Registpath           @"https://ph.chinapuhuang.com/API.php/add"                    //注册账号
#define Loginpath            @"https://ph.chinapuhuang.com/API.php/log"                    //登录账号
#define ForgetOnepath        @"https://ph.chinapuhuang.com/API.php/find"                   //忘记密码入境1
#define ForgetTwopath        @"https://ph.chinapuhuang.com/API.php/replacePass"            //忘记密码入境2
#define ChangeOnepath        @"https://ph.chinapuhuang.com/API.php/editPassOne"            //修改密码入境1
#define ChangeTwopath        @"https://ph.chinapuhuang.com/API.php/editPassTwo"            //修改密码入境2

                            #pragma -mark 个人信息
#define Personshowpath         @"https://ph.chinapuhuang.com/API.php/edit"                   //个人中心展示入境
#define Personeditpath         @"https://ph.chinapuhuang.com/API.php/editPro"                //个人中心保存编辑入境

                            #pragma mark 积分获取
#define Sharecodepath          @"https://ph.chinapuhuang.com/API.php/make_coupon_card"          //分享邀请码

                            #pragma -mark 我的发布
#define InformaZRpath          @"https://ph.chinapuhuang.com/API.php/transferMessage"              //我的发布～店铺转让
#define InformaZRDEpath        @"https://ph.chinapuhuang.com/API.php/zrdel"                        //我的发布～店铺转让~删除
#define InformaZRoverpath      @"https://ph.chinapuhuang.com/API.php/zrout"                        //我的发布～店铺转让~下架

#define InformaCZpath          @"https://ph.chinapuhuang.com/API.php/rentMessage"                  //我的发布～店铺出租
#define InformaCZDEpath        @"https://ph.chinapuhuang.com/API.php/czdel"                        //我的发布～店铺出租~删除
#define InformaCZoverpath      @"https://ph.chinapuhuang.com/API.php/czout"                        //我的发布～店铺出租~下架

#define InformaXZpath          @"https://ph.chinapuhuang.com/API.php/selectionMessage"             //我的发布～店铺选址
#define InformaXZDEpath        @"https://ph.chinapuhuang.com/API.php/xzdel"                        //我的发布～店铺选址~删除
#define InformaXZoverpath      @"https://ph.chinapuhuang.com/API.php/xzout"                        //我的发布～店铺选址~下架

#define InformaZPpath          @"https://ph.chinapuhuang.com/API.php/positionMessage"              //我的发布～店铺招聘
#define InformaZPDEpath        @"https://ph.chinapuhuang.com/API.php/zpdel"                        //我的发布～店铺招聘~删除

                            #pragma -mark 首页
#define Biglshoppath         @"https://ph.chinapuhuang.com/API.php/lshop"             //大数据找店量
#define Biggshoppath         @"https://ph.chinapuhuang.com/API.php/Gshop"             //大数据成交量
#define Bigkshoppath         @"https://ph.chinapuhuang.com/API.php/kshop"             //大数据转店量
#define Dailypath            @"https://ph.chinapuhuang.com/API.php/headline"            //今日头条

#define Ainmentpath          @"https://ph.chinapuhuang.com/API.php/ylrecreation"        //娱乐类
#define Lifepath             @"https://ph.chinapuhuang.com/API.php/shrecreation"        //生活类
#define Departmentpath       @"https://ph.chinapuhuang.com/API.php/bhrecreation"        //百货类
#define Newcasepath          @"https://ph.chinapuhuang.com/API.php/zxcase"              //最新类

#define HostmainSerach       @"https://ph.chinapuhuang.com/API.php/search"             //首页大型搜索功能

                            #pragma -mark 我的服务
#define MyserviceZRpath      @"https://ph.chinapuhuang.com/API.php/attornService"            //我的服务～转让服务
#define MyserviceCZpath      @"https://ph.chinapuhuang.com/API.php/lessorService"            //我的服务～出租服务
#define MyserviceZPpath      @"https://ph.chinapuhuang.com/API.php/recruitService"           //我的服务～招聘服务
#define MyZRpushpath         @"https://ph.chinapuhuang.com/API.php/zrpush"                   //我的服务～转让服务 推送资源
#define MyCZpushpath         @"https://ph.chinapuhuang.com/API.php/czpush"                   //我的服务～出租服务 推送资源
#define MyZRfinishpath       @"https://ph.chinapuhuang.com/API.php/zrserviceed"             //我的服务～转让服务 完成记录
#define MyCZfinishpath       @"https://ph.chinapuhuang.com/API.php/czserviceed"             //我的服务～出租服务 完成记录

                        #pragma -mark 发布信息
#define HostTareapath       @"https://ph.chinapuhuang.com/API.php/DelTarea"               //转让全部数据{精选开店使用}

#define HostTareaupload     @"https://ph.chinapuhuang.com/API.php/adduplode"              //转让上传
#define HostZRTareapath     @"https://ph.chinapuhuang.com/API.php/zrinformation"          //转让信息套餐(店铺转让)
#define HostZRparticular    @"https://ph.chinapuhuang.com/API.php/DelTarea"               //转让详情页
#define HostZRHomepath      @"https://ph.chinapuhuang.com/API.php/home"                   //转让首页套餐(推荐)
#define HostZRrecordpath    @"https://ph.chinapuhuang.com/API.php/zrrecord"               //转让客服记录


#define Hostrentupload       @"https://ph.chinapuhuang.com/API.php/rent"                 //出租上传
#define Hostrentpath         @"https://ph.chinapuhuang.com/API.php/rentDetails"          //出租详情下载
#define HostCZrentpath       @"https://ph.chinapuhuang.com/API.php/czinformation"        //出租信息（店铺出租）
#define HostCZrecordpath     @"https://ph.chinapuhuang.com/API.php/czrecord"            //出租客服记录

#define Hostselectionupload  @"https://ph.chinapuhuang.com/API.php/selection"            //选址上传
#define Hostselectionpath    @"https://ph.chinapuhuang.com/API.php/selectionDetails"     //选址下载(店铺选址)

#define Hostrecruitupload    @"https://ph.chinapuhuang.com/API.php/recruit"              //招聘上传
#define Hostrecruitpath      @"https://ph.chinapuhuang.com/API.php/recruitDetails"       //招聘下载（招聘中心）

#define Hostmaplistpath      @"https://ph.chinapuhuang.com/API.php/maplocation"         //地图选铺
//#define Hostmaplistpath      @"https://ph.chinapuhuang.com/API.php/map_location"         //地图选铺

                            #pragma -mark 详情信息 收藏
#define Hostzrcollectpath      @"https://ph.chinapuhuang.com/API.php/zrcollect"         //转让收藏
#define Hostczcollectpath      @"https://ph.chinapuhuang.com/API.php/czcollect"         //出租收藏
#define Hostxzcollectpath      @"https://ph.chinapuhuang.com/API.php/xzcollect"         //选址收藏
#define Hostzpcollectpath      @"https://ph.chinapuhuang.com/API.php/zpcollect"         //招聘收藏

                             #pragma -mark 我的收藏
#define MycollectZRpath             @"https://ph.chinapuhuang.com/API.php/myzrcollect"           //我的收藏～转让收藏
#define MycollectCZpath             @"https://ph.chinapuhuang.com/API.php/myczcollect"           //我的收藏～出租收藏
#define MycollectXZpath             @"https://ph.chinapuhuang.com/API.php/myxzcollect"           //我的收藏～选址收藏
#define MycollectZPpath             @"https://ph.chinapuhuang.com/API.php/myzpcollect"           //我的收藏～招聘收藏

                             #pragma -mark 支付密码
#define Hostpaysetword            @"https://ph.chinapuhuang.com/API.php/payset"               //支付密码设置，修改，    清除
                             #pragma -mark 我的积分
#define Myintergalpath            @"https://ph.chinapuhuang.com/API.php/consumer"         //我的积分首页
#define Myintergalredusepath      @"https://ph.chinapuhuang.com/API.php/consumercalendar" //我的积分~消耗
#define Myintergalchargepath      @"https://ph.chinapuhuang.com/API.php/rechargerecord"   //我的积分~充值

#define Myservicezrbagpath        @"https://ph.chinapuhuang.com/API.php/zrservice"           //我的服务～转让背包
#define Myserviceczbagpath        @"https://ph.chinapuhuang.com/API.php/czservice"           //我的服务～出租背包
#define Myservicezpbagpath        @"https://ph.chinapuhuang.com/API.php/zpservice"           //我的服务～招聘背包

#define ContractZRpath            @"https://ph.chinapuhuang.com/API.php/shopservice"        //我的发布～店铺转让续约
#define ContractCZpath            @"https://ph.chinapuhuang.com/API.php/czshopservice"      //我的发布～店铺出租续约

                                 #pragma -mark 其他事件
#define Mycitypath                @"https://ph.chinapuhuang.com/API.php/city"   //获取城市区域

//城市区域获取
#define EnterApppath              @"https://ph.chinapuhuang.com/API.php/serviceed"           //进入app传值给后台判断到期时间

                                 #pragma -mark 充值中心
#define payWechat                @"https://ph.chinapuhuang.com/wxapi.php"                    //微信支付获取订单数据
#define payAlipay                @"https://ph.chinapuhuang.com/Aliyun.php"                   //支付宝支付获取订单数据

#define payrecharge              @"https://ph.chinapuhuang.com/API.php/wxpay"                //支付信息订单数据存服务器

#define feedback                 @"https://ph.chinapuhuang.com/API.php/feedback"             //意见反馈

#define Videopath                @"https://ph.chinapuhuang.com/API.php/video"               //视频获取


#endif /* Defination_h */
