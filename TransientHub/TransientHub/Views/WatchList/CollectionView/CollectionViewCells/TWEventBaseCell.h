//
//  TWEventBaseCell.h
//
//  Created by Kevin Hunt on 2015-04-08.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWEventBaseCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *title;

- (void)setImageURL:(NSString *)url;

@end
