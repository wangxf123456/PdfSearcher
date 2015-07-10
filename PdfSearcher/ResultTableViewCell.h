//
//  ResultTableViewCell.h
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/9.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Record.h"

@interface ResultTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) NSURL *link;

@end
