//
//  TWEventBaseCell.m
//
//  Created by Kevin Hunt on 2015-04-08.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWEventBaseCell.h"

@interface TWEventBaseCell ()

@end

@implementation TWEventBaseCell

-(void)awakeFromNib {
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.frame = self.frame;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

@end
