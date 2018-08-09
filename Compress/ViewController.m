//
//  ViewController.m
//  Compress
//
//  Created by 胡海 on 2018/8/9.
//  Copyright © 2018年 胡海. All rights reserved.
//

#import "ViewController.h"
#import "CompressVideoTool.h"
@interface ViewController ()
@property (nonatomic,copy) NSString *urlStr;
@property (nonatomic,strong) UIButton *compressVideoButton;
@property (nonatomic,strong) UIButton *compressURLVideoButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlStr = @"1.mp4";
    //config
    [self config];
    //laodSubViews
    [self loadSubViews];
}
#pragma mark  ======  config  ======
-(void)config{
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.title = @"压缩";
}
#pragma mark  =====  laodSubViews  ======
-(void)loadSubViews{
    [self.view addSubview:self.compressVideoButton];
}
-(UIButton *)compressVideoButton{
    if (!_compressVideoButton) {
        _compressVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
        [_compressVideoButton setTitle:@"压缩本地视频" forState:UIControlStateNormal];
        _compressVideoButton.layer.cornerRadius = 5;
        _compressVideoButton.layer.masksToBounds = YES;
        [_compressVideoButton setBackgroundColor:[UIColor greenColor]];
        [_compressVideoButton addTarget:self action:@selector(compressVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _compressVideoButton;
}
-(UIButton *)compressURLVideoButton{
    if (!_compressURLVideoButton) {
        _compressURLVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 50)];
        [_compressURLVideoButton setTitle:@"压缩url视频" forState:UIControlStateNormal];
        _compressURLVideoButton.layer.cornerRadius = 5;
        _compressURLVideoButton.layer.masksToBounds = YES;
        [_compressURLVideoButton setBackgroundColor:[UIColor blueColor]];
        [_compressURLVideoButton addTarget:self action:@selector(compressByVideoURL:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _compressURLVideoButton;
}
-(void)compressVideo:(UIButton *)sender{
    [[CompressVideoTool sharedInstance] compressByVideoURL:self.urlStr];
}
-(void)compressByVideoURL:(UIButton *)sender{
    [[CompressVideoTool sharedInstance] compressByVideoURL:@"http://player.alicdn.com/video/aliyunmedia.mp4"];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (touches.anyObject.view == self.view) {
        self.urlStr = @"2.mp4";
    }
}
@end
