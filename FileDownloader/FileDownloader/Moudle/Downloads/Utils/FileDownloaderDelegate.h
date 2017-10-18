//
//  FileDownloaderDelegate.h
//  FileDownloader
//
//  Created by Ossey on 2017/7/3.
//  Copyright © 2017年 Ossey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloadProtocol.h"

/*
 此类遵守了FileDownloaderDelegate，作为FileDownloader的协议实现类
 主要对下载状态的更新、下载进度的更新、发送通知、下载信息的规则
 */


@interface FileDownloaderDelegate : NSObject <FileDownloaderDelegate>

@end