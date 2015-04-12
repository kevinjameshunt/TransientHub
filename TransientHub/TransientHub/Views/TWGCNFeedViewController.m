//
//  TWGCNFeedViewController.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-12.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWGCNFeedViewController.h"
#import "TWBaseEventViewController.h"

@interface TWGCNFeedViewController () {
    int _imgCount;
    NSArray *_imgDict;
    NSArray *_eventDict;
}

@end

@implementation TWGCNFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) getSegueID{
    return @"gcnFeedSegue";
}

- (void)populateSampleViews {
    _imgDict = [NSArray arrayWithObjects:@"2CG121p04.png", @"NGC253.orbit.png", @"oao1657_fig1.png", @"PSRJ0007p7303.mission.png", @"PSRJ0007p7303.orbit.png", @"SwiftJ045106.8-694803.orbit.png", @"TXS0141p268.png", @"velax1_fig1.png", nil];
    _eventDict = [NSArray arrayWithObjects:@"2CG121+04", @"NGC253", @"OAO1657", @"PSRJ0007+7303", @"PSRJ0007p7303", @"J045106.8-694803", @"TXS0141+268", @"Vela X-1", nil];
    
    _imgCount = 0;
    int sampleHeight = 432;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.scrollEnabled = YES;
    self.scrollView = [self createSampleLayout:self.scrollView andOffset:sampleHeight*0];
    self.scrollView = [self createSampleLayout:self.scrollView andOffset:sampleHeight*1];
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 1100);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    //Default value for cancelsTouchesInView is YES, which will prevent buttons to be clicked
    singleTap.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:singleTap];
    
    [self.view addSubview:self.scrollView];
}

- (UIScrollView *)createSampleLayout:(UIScrollView *)scrollView andOffset:(int)offset {
    
    int buffer = 8;
    int cellWidthSingle = 70;
    int cellWidthDouble = cellWidthSingle *2 + buffer;
    int cellWidthFull = (cellWidthSingle * 4) + 3 * buffer;
    int cellHeightSingle = 70;
    int cellHeightDouble = 100;
    int rowDif = buffer + cellHeightDouble;
    
    // Row 4 - 1 double-double, 2 singles x 2 singles
    UIView *view1_1 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer, buffer+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view1_1];
    
    UIView *view1_2 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view1_2];
    
    UIView *view2_1 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer, buffer+rowDif+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view2_1];
    
    UIView *view2_2 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer+rowDif+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view2_2];
    
    UIView *view3_1 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer, buffer+rowDif*2+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view3_1];
    
    UIView *view3_2 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer+rowDif*2+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view3_2];
    
    UIView *view4_1 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer, buffer+rowDif*3+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view4_1];
    
    UIView *view4_2 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer+rowDif*3+offset, cellWidthDouble, cellHeightDouble)];
    [scrollView addSubview:view4_2];
    
    return scrollView;
}

- (UIView *)createSampleDoubleDoubleCellWithFrame:(CGRect)frame {
    
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 3.0f;
    theView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height-30)];
    imageView.image = [UIImage imageNamed:[_imgDict objectAtIndex:_imgCount]];
    
    [theView addSubview:imageView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, frame.size.height-28, frame.size.width-16, 20)];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:16];
    typeLabel.numberOfLines = 4;
    typeLabel.text = [_eventDict objectAtIndex:_imgCount];
    typeLabel.adjustsFontSizeToFitWidth = YES;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [theView addSubview:typeLabel];
    
    _imgCount ++;
    if (_imgCount > 7) {
        _imgCount = 0;
    }
    
    return theView;
}


- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Touch detected");
    //TWBaseEventViewController *eventViewController = [[TWBaseEventViewController alloc] init];
    //[self.navigationController pushViewController:eventViewController animated:YES];
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
