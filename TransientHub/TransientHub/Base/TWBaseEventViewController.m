//
//  TWEventViewController.m
//  TransientHub
//
//  Created by Kevin Hunt on 2015-04-03.
//  Copyright (c) 2015 ProphetStudios. All rights reserved.
//

#import "TWBaseEventViewController.h"
#import "InternalWebViewController.h"

@interface TWBaseEventViewController () {
    UIImageView *_newImageCompView;
    UILabel *_newImageLabel;
    int _imgIndex;
}

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
    
    self.navigationItem.title = @"Blazar Outburst";
    
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
    
    _imgIndex = 1;
    
    // Row 1 - 2 singles, 1 double
    UIView *view1_1 = [self createSampleSingleCellWithFrame:CGRectMake(buffer, buffer, cellWidthSingle, cellHeightSingle) andImageName:@"1504091230684110615-0001.arch.jpg"];
    [scrollView addSubview:view1_1];
    
    UIView *view1_2 = [self createSampleSingleCellWithFrame:CGRectMake(buffer*2+cellWidthSingle, buffer, cellWidthSingle, cellHeightSingle) andImageName:@"1504091230684110615-0002.arch.jpg"];
    [scrollView addSubview:view1_2];
    
    UIView *view1_3 = [self createSampleSingleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer, cellWidthSingle, cellHeightSingle) andImageName:@"1504091230684110615-0003.arch.jpg"];
    [scrollView addSubview:view1_3];
    
    UIView *view2_4 = [self createSampleSingleCellWithFrame:CGRectMake(buffer*4+cellWidthSingle*3, buffer, cellWidthSingle, cellHeightSingle) andImageName:@"1504091230684110615-0004.arch.jpg"];
    [scrollView addSubview:view2_4];
    
    
    rowDif = buffer + cellHeightSingle;
    
    
    // Reference image and new image views
    UIView *view3_1 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer, buffer+rowDif, cellWidthDouble, cellHeightDouble) andImageName:@"1504091230684110615.master.jpg" isReference:YES];
    [scrollView addSubview:view3_1];
    
    UIView *view3_2 = [self createSampleDoubleDoubleCellWithFrame:CGRectMake(buffer*3+cellWidthSingle*2, buffer+rowDif, cellWidthDouble, cellHeightDouble) andImageName:@"1504091230684110615-0001.arch.jpg" isReference:NO];
    [scrollView addSubview:view3_2];
    
    // Details View
    UIView *view4_1 = [self createSampleFullCellWithFrame:CGRectMake(buffer, (buffer+rowDif*3), cellWidthFull, cellHeightSingle)];
    [scrollView addSubview:view4_1];
    
    // links View
    UIView *view5_1 = [self createSampleFullToolbarCellWithFrame:CGRectMake(buffer, (buffer+rowDif*4), cellWidthFull, 50)];
    [scrollView addSubview:view5_1];
    
    return scrollView;
}

- (UIView *)createSampleSingleCellWithFrame:(CGRect)frame andImageName:(NSString *)imageName {
    
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 1.0f;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
    imageView.image = [UIImage imageNamed:imageName];
    [theView addSubview:imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    //Default value for cancelsTouchesInView is YES, which will prevent buttons to be clicked
    singleTap.cancelsTouchesInView = NO;
    [theView addGestureRecognizer:singleTap];
    
    return theView;
}

- (UIView *)createSampleDoubleDoubleCellWithFrame:(CGRect)frame andImageName:(NSString *)imageName isReference:(BOOL)isReference {
    
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 3.0f;
    theView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height-30)];
    imageView.image = [UIImage imageNamed:imageName];
    
    NSString *title;
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, frame.size.height-28 , frame.size.width-16, 20)];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:12];
    typeLabel.numberOfLines = 1;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    
    if (isReference) {
        title  =@"Reference Image";
        typeLabel.text = title;
        [theView addSubview:imageView];
        [theView addSubview:typeLabel];
    } else {
        typeLabel.text = title;
        _newImageCompView = imageView;
        _newImageLabel = typeLabel;
        title  =@"New Image 1";
        [theView addSubview:_newImageCompView];
        [theView addSubview:_newImageLabel];
    }
    
    
    return theView;
}

- (UIView *)createSampleFullCellWithFrame:(CGRect)frame {
    int fromNumber = 2;
    int toNumber = 19;
    int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
    
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 4.0f;
    theView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    

    
    UITextView *typeLabel = [[UITextView alloc] initWithFrame:CGRectMake(8, -4, (frame.size.width-16), frame.size.height)];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.font = [UIFont fontWithName:@"Verdana" size:12];
    typeLabel.text = @"MV: 13.45\nRA: 13:48:11.78 Dec: 23\u00B0 36m 50.74s\nAlert Time: 2015-04-09T10:32:52\nTrigger Time: 2015-04-09T10:32:52";
    
    [theView addSubview:typeLabel];
    
    return theView;
}

- (UIView *)createSampleFullToolbarCellWithFrame:(CGRect)frame {

    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.layer.borderColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f].CGColor;
    theView.layer.borderWidth = 4.0f;
    theView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(8, 8, (frame.size.width-16), frame.size.height-16)];
    
    UIBarButtonItem *lightCurveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Light Curve" style:UIBarButtonItemStylePlain target:self action:@selector(showLightCurve)];
    UIBarButtonItem *findingChartBtn = [[UIBarButtonItem alloc] initWithTitle:@"Finding Chart" style:UIBarButtonItemStylePlain target:self action:@selector(showFindingChart)];
    UIBarButtonItem *moreImagesBtn = [[UIBarButtonItem alloc] initWithTitle:@"Other Images" style:UIBarButtonItemStylePlain target:self action:@selector(showMoreImages)];
    UIBarButtonItem *flexibleItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *flexibleItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *btnArray = [NSArray arrayWithObjects:lightCurveBtn, flexibleItem1, findingChartBtn, flexibleItem2, moreImagesBtn, nil];
    toolbar.items = btnArray;
    toolbar.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:161.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
    
    [theView addSubview:toolbar];
    
    return theView;
}

- (void)showLightCurve {
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://nesssi.cacr.caltech.edu/catalina/20150409/1504091230684110615p.html"]];
    
    InternalWebViewController *inLineViewCon = [[InternalWebViewController alloc] initWithDelegate:self request:request];
    inLineViewCon.navigationController.toolbarHidden = YES;
    [[self navigationController] pushViewController:inLineViewCon animated:YES];
}

- (void)showFindingChart {
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://voeventnet.caltech.edu/feeds/ATEL/CRTS/1504091230684110615.atel.html"]];
    
    InternalWebViewController *inLineViewCon = [[InternalWebViewController alloc] initWithDelegate:self request:request];
    inLineViewCon.navigationController.toolbarHidden = YES;
    [[self navigationController] pushViewController:inLineViewCon animated:YES];
}

- (void)showMoreImages {
    NSURLRequest*request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://nesssi.cacr.caltech.edu/catalina/20150409/1504091230684110615s.html"]];
    
    InternalWebViewController *inLineViewCon = [[InternalWebViewController alloc] initWithDelegate:self request:request];
    inLineViewCon.navigationController.toolbarHidden = YES;
    [[self navigationController] pushViewController:inLineViewCon animated:YES];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Touch detected");
    _imgIndex ++;
    if (_imgIndex > 4) {
        _imgIndex = 1;
    }
    _newImageCompView.image = [UIImage imageNamed:[NSString stringWithFormat:@"1504091230684110615-000%d.arch.jpg", _imgIndex]];
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
