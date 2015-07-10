//
//  Record.h
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/10.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *link;

- (void)configureWithDictionary:(NSDictionary *)dictionary;

@end
