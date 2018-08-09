//
//  CompressVideoTool.h
//  LiveStreamingDemo
//
//  Created by 胡海 on 2018/8/9.
//  Copyright © 2018年 胡海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompressVideoTool : NSObject
+(instancetype)sharedInstance;
-(void)compressByVideoURL:(NSString *)videoURL;/**视频压缩*/
@end
