//
//  OSDownloaderManager.h
//  DownloaderManager
//
//  Created by Ossey on 2017/6/4.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSDownloadProtocol.h"
#import "OSDownloadProgress.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^OSBackgroundSessionCompletionHandler)();
typedef void (^OSDownloaderResumeDataHandler)(NSData * aResumeData);

FOUNDATION_EXTERN NSString * const OS_Downloader_Folder;

@interface OSDownloaderManager : NSObject

@property (nonatomic, class) OSDownloaderManager *manager;

@property (nonatomic, assign) NSInteger maxConcurrentDownloads;

@property (nonatomic, weak) id<OSDownloadProtocol> downloadDelegate;

/// 初始化
- (void)setupTasksWithCompletionHandler:(void (^)())completionHandler;


/// 执行开始下载任务
/// @param urlPath 下载任务的remote url path
- (void)downloadWithURL:(NSString *)urlPath;

/// 执行开始下载任务
/// @param urlPath 下载任务的remote url path
/// @param resumeData 之前下载的数据
- (void)downloadWithURL:(NSString *)urlPath resumeData:(nullable NSData *)resumeData;

/// 根据是否urlPath判断正在下载中
/// @param urlPath 下载任务的url
- (BOOL)isDownloadingByURL:(NSString *)urlPath;

/// 根据是否urlPath判断在等待中
/// @param urlPath 下载任务的url
- (BOOL)isWaitingByURL:(NSString *)urlPath;

/// 当前是否有任务下载
- (BOOL)hasActiveDownloads;

/// 取消下载
/// @param urlPath 下载任务
- (void)cancelWithURL:(NSString *)urlPath;


/// 当完成一个后台任务时回调
- (void)setBackgroundSessionCompletionHandler:(nullable OSBackgroundSessionCompletionHandler)completionHandler;


/// 获取下载进度
/// urlPath 当前下载任务的唯一标识符
/// @return 下载进度的信息
- (OSDownloadProgress *)getDownloadProgressByURL:(NSString *)urlPath;

@end

NS_ASSUME_NONNULL_END
