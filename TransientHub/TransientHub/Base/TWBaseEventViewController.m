//
//  TWEventViewController.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-03.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWBaseEventViewController.h"

@interface TWBaseEventViewController ()

@end

@implementation TWBaseEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self populateSampleViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)populateSampleViews {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.scrollEnabled = YES;
    _scrollView = [self createSampleLayout:_scrollView];
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1100);
    
    [self.view addSubview:_scrollView];
}

- (UIScrollView *)createSampleLayout:(UIScrollView *)scrollView {
    
    int buffer = 8;
    int cellWidthSingle = 70;
    int cellWidthDouble = cellWidthSingle *2 + buffer;
    int cellWidthFull = (cellWidthSingle * 4) + 3 * buffer;
    int cellHeightSingle = 70;
    int cellHeightDouble = cellHeightSingle * 2 + buffer;
    int rowDif = 0;
    
    // Row 1 - 2 singles, 1 double
    UIView *view1_1 = [self createSampleSingleCellWithFrame:CGRectMake(buffer, buffer, cellWidthSingle, cellHeightSingle)];
    [scrollView addSubview:view1_1];
    
    UIView *view1_2 = [self createSampleSingleCellWithFrame:CGRectMake(buffer*2+cellWidthSingle, buffer, cellWidthSingle, cellHeightSingle)];
    [scrollView addSubview:view1_2];
    
    UIView *view1_3 = [self createSampleSingleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer, cellWidthSingle, cellHeightSingle)];
    [scrollView addSubview:view1_3];
    
    UIView *view2_4 = [self createSampleSingleCellWithFrame:CGRectMake(buffer*4+cellWidthSingle*3, buffer, cellWidthSingle, cellHeightSingle)];
    [scrollView addSubview:view2_4];
    
    return scrollView;
}

- (UIView *)createSampleSingleCellWithFrame:(CGRect)frame {
    int fromNumber = 2;
    int toNumber = 19;
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 1.0f;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
    imageView.image = [UIImage imageNamed:@"1-out.jpg"];
    
    [theView addSubview:imageView];
    
    UILabel *magLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-40, frame.size.height-30, 40, 30)];
    magLabel.text = [NSString stringWithFormat:@"+%d",randomNumber];
    magLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:16];
    magLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    [theView addSubview:magLabel];
    
    return theView;
}

- (UIView *)createSampleDoubleDoubleCellWithFrame:(CGRect)frame {
    int fromNumber = 2;
    int toNumber = 19;
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 3.0f;
    theView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, (frame.size.height-8)/2)];
    imageView.image = [UIImage imageNamed:@"1-out.jpg"];
    
    [theView addSubview:imageView];
    
    UILabel *magLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-45, (frame.size.height-8)/2-30, 45, 30)];
    magLabel.text = [NSString stringWithFormat:@"+%d",randomNumber];
    magLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:18];
    magLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    [theView addSubview:magLabel];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, (frame.size.height-8)/2+8, frame.size.width-16, (frame.size.height-8)/2-8)];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:16];
    typeLabel.numberOfLines = 4;
    typeLabel.text = @"Active galactic nucleus variability";
    
    [theView addSubview:typeLabel];
    
    return theView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
