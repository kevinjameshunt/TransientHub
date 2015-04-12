
#import "pgcAppDelegate.h"
#import <UIKit/UIKit.h>

@class BreezeViewController;

@interface InternalWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView *webView;
	id delegate;
    UISegmentedControl *segControl;
	NSURLRequest *urlRequest;
	NSURLRequest *urlLastRequest;
	UIBarButtonItem *backButtonItem;
	UIBarButtonItem *forwardButtonItem;
	UIBarButtonItem *browserButtonItem;
	BOOL navbarHidden;
    BOOL isModal;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet id delegate;
@property (nonatomic, retain) UISegmentedControl *segControl;
@property (nonatomic, retain) NSURLRequest *urlRequest;
@property (nonatomic, retain) NSURLRequest *urlLastRequest;
@property (nonatomic, retain) UIBarButtonItem *browserButtonItem;
@property (nonatomic, readwrite) BOOL isModal;

- (id)initWithDelegate:(id)appDelegate request:(NSURLRequest*)request;
- (void)updateSegments;
- (void)deselect;
- (void)handleBrowserButton:(id)sender;
- (void)finishedBrowsing:(id)sender;
- (void)backBtnPressed;

@end
