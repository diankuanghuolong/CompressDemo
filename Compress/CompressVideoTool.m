//
//  CompressVideoTool.m
//  LiveStreamingDemo
//
//  Created by 胡海 on 2018/8/9.
//  Copyright © 2018年 胡海. All rights reserved.
//

#import "CompressVideoTool.h"
#import <AVFoundation/AVFoundation.h>
@implementation CompressVideoTool
+(instancetype)sharedInstance{
    static CompressVideoTool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CompressVideoTool alloc] init];
    });
    return sharedInstance;
}
#pragma mark  =====  视频压缩&&上传  =====
-(void)compressByVideoURL:(NSString *)videoURL{
//    NSURL *sourceURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1.mp4" ofType:@""]];
    NSURL *sourceURL; if([videoURL hasSuffix:@".mp4"]){
        sourceURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:videoURL ofType:@""]];
    }else{
        
    }
    NSURL *newVideoUrl ; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
    NSLog(@"压缩视频文件路径->%@",path);
    newVideoUrl = [NSURL fileURLWithPath:path];//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    /*
     AVAssetExportPresetLowQuality 模糊画质
     AVAssetExportPresetMediumQuality 普通画质
     AVAssetExportPresetHighestQuality 清晰的画质
     */
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        switch (exportSession.status) {
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"AVAssetExportSessionStatusCancelled");
                break;
            case AVAssetExportSessionStatusUnknown:
                NSLog(@"AVAssetExportSessionStatusUnknown");
                break;
            case AVAssetExportSessionStatusWaiting:
                NSLog(@"AVAssetExportSessionStatusWaiting");
                break;
            case AVAssetExportSessionStatusExporting:
                NSLog(@"AVAssetExportSessionStatusExporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"AVAssetExportSessionStatusCompleted");
                NSLog(@"压缩视频文件时长->%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                NSLog(@"压缩前视频大小->%@\n压缩视频大小->%@",[NSString stringWithFormat:@"%.2f kb", [self getFileSize:[inputURL path]]], [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                /**判断视频大小，根据后台情况，提示是否可以上传*/
                [self tipByURl:outputURL];
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"AVAssetExportSessionStatusFailed");
                break;
        }
        
    }];
}
- (CGFloat) getFileSize:(NSString *)path{/**获取文件的大小-KB*/
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}
- (CGFloat) getVideoLength:(NSURL *)URL{/**获取视频文件的时长*/
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}
-(void)tipByURl:(NSURL *)url{
    CGFloat size = [self getFileSize:[url path]];
    CGFloat sizemb= size/1024;/**视频大小->M*/
    /**上传视频*/
    if (sizemb < 100) {/**假设后台要求视频大小不超过100M*/
//        NSData *videoData = [NSData dataWithContentsOfURL:url];
//        NSLog(@"上传视频data:%@",videoData);
        NSLog(@"上传视频");
    }
}
@end
