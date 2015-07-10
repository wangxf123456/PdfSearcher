//
//  LoadingCellTableViewCell.m
//  PdfSearcher
//
//  Created by WangXiaofei on 15/7/10.
//  Copyright (c) 2015年 WangXiaofei. All rights reserved.
//

#import "LoadingCell.h"

@implementation LoadingCell

- (void)awakeFromNib {
    // Initialization code
    [self.spinner startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
