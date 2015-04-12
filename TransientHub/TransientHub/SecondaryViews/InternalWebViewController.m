
#import "Flurry.h"
#import "InternalWebViewController.h"

@implementation InternalWebViewController

@synthesize webView;
@synthesize delegate;
@synthesize segControl;
@synthesize urlRequest;
@synthesize urlLastRequest;
@synthesize browserButtonItem;
@synthesize isModal;

- (id)initWithDelegate:(id)appDelegate request:(NSURLRequest*)request
{
	self = [super init];
	if (self != nil) {
		// save delegate for later
		self.delegate = appDelegate;
		self.urlRequest = request;
		self.urlLastRequest = request;
		//self.hidesBottomBarWhenPushed = YES;
	}
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	// create our internal view
	// CGRect frame = [[UIScreen mainScreen] applicationFrame];
	CGRect frame = CGRectMake(0.0, 20, 480, 320);
	webView = [[UIWebView alloc] initWithFrame:frame];
	webView.autoresizesSubviews = YES;
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	webView.scalesPageToFit = YES;

	// wire handler for web view URL changes
	webView.delegate = self;
	
	// save ref to view
	self.view = webView;

	// add our DONE button to stop browsing
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithTitle:@"Done"
                                             style:UIBarButtonItemStylePlain 
                                             target:self
                                             action:@selector(finishedBrowsing:)];
    
	self.browserButtonItem = [[UIBarButtonItem alloc] 
                              initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
                              target:self
                              action:@selector(handleBrowserButton:)];
    self.browserButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.browserButtonItem;
	
    //initialize segmented control
    NSArray *imgArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"back.png"],[UIImage imageNamed:@"forward.png"], nil];
	segControl = [[UISegmentedControl alloc] initWithItems:imgArray];
    [segControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    frame = segControl.frame;
    frame.size.height = 30;
    segControl.frame = frame;
    segControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segControl setTintColor:[UIColor whiteColor]];
    //[segControl setTintColor:[UIColor colorWithRed:187.0f/255.0f green:179.0f/255.0f blue:132.0f/255.0f alpha:1.0f]];
    self.navigationItem.titleView = segControl;
    
    [self updateSegments];
                                      
	// load page
	[webView loadRequest: urlRequest];
}

- (void)updateSegments {
    [segControl setEnabled:[webView canGoBack] forSegmentAtIndex:0];
    [segControl setEnabled:[webView canGoForward] forSegmentAtIndex:1];
}

- (void)backBtnPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentAction:(id)sender {
	UISegmentedControl *segment = sender;
	NSInteger index = [segment selectedSegmentIndex];
    
    if (index == 0)
        [webView goBack];
    else if (index == 1)
        [webView goForward];
}

#pragma mark - UIActionSheet Delegate

-(void)handleBrowserButton:(id)sender {
    pgcAppDelegate* appDel = (pgcAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open in Safari" otherButtonTitles:nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:appDel.window];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *resultString;
	if (buttonIndex == 0) {
		resultString = @"Safari Button Clicked";
        [Flurry logEvent:resultString];
        [[UIApplication sharedApplication] openURL:[urlLastRequest URL]];
        return;
	} else if (buttonIndex == 1) {
		resultString = @"Cancel Button Clicked";
	}
    DLog(@"%@",resultString);
}

#pragma mark - UIWebView

- (void)finishedBrowsing:(id)sender
{
	UINavigationController *nc = [self navigationController];
    if (isModal)
        [nc dismissViewControllerAnimated:YES completion:nil];
    else
        [nc popViewControllerAnimated:YES];
}

- (BOOL)webView: (UIWebView *)theWebView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	// cache last page request so if user launches browser we have correct page
	self.urlLastRequest = request;
	
	// navigate as normal
	return TRUE;
}

- (void) deselect {
    [segControl setSelectedSegmentIndex:-1];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:.2];
    [self updateSegments];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error 
{
    DLog(@"WebView Error: %@",[error description]);
    [Flurry logEvent:[NSString stringWithFormat:@"WebView Error: %@",[error description]]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// allow full rotation of screen
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"Back", @"Back - return to profiles")
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(backBtnPressed)];
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [Flurry logEvent:@"Internal web page"];
}

- (void)viewDidAppear:(BOOL)animated {
    pgcAppDelegate *appDelegate = (pgcAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentViewController = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


@end
