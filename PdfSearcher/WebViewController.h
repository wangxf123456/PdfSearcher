//
//  WebViewController.h
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/10.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
