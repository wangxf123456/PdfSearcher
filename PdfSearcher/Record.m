//
//  Record.m
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/10.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import "Record.h"

@implementation Record

- (void)configureWithDictionary:(NSDictionary *)dictionary {
    NSString *nameText = [dictionary objectForKey:@"title"];
    NSArray *temp = [nameText componentsSeparatedByString:@"_"];
    if ([temp count] > 0) {
        self.name = [temp objectAtIndex:0];
    } else {
        self.name = nameText;
    }
    self.link = [NSURL URLWithString:[dictionary objectForKey:@"link"]];
}

@end
