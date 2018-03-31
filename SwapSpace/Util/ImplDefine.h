//
//  ImplDefine.h
//  SwapSpace
//
//  Created by zzy on 31/08/2017.
//  Copyright © 2017 lanmao. All rights reserved.
//

#ifndef ImplDefine_h
#define ImplDefine_h

#define BaseUrl @"http://140.143.38.179/cbg"
//根据搜索关键字和模块查列表
#define kAPIPostList @"/post/listPostByKey"
//根据帖子id获取帖子详情
#define kAPIPostDetail @"/post/getPostDetail"
//增加帖子浏览量
#define kAPIAddPostReadNum @"/post/viewPost"
//用户登录
#define kAPILogin @"/user/loginUser"
//我发布的帖子
#define kAPIMyPostList @"/post/listPostByUserId"
//删除帖子
#define kAPIDeletePost @"/post/deletePostByPid"
//置顶帖子
#define kAPIStickPost @"/post/pushpost"
//修改帖子
#define kAPIEditPost @"/post/editPost1"
//举报帖子
#define kAPIReport @"/post/report"
//信息搜索页面搜索接口
#define kAPISearchPostList @"/post/listPostByXYZ"
//发帖
#define kAPIPost @"http://140.143.38.179/cbg/post/insertPost"
//获取app版本号
#define kAPIAppVersion @"/post/getAppVersion"
//app打开次数统计
#define kAPIActivation @"/count/activationCount"
#endif /* ImplDefine_h */
