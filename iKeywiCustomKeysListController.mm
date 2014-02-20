#import "iKeywi2.h"

@interface iKeywiCustomKeysListController : PSListController <UITextFieldDelegate>
{
    UIWindow* window;
    UILabel *titleLabel;
    float currentTime;
    NSTimer *checkTimer;
    AVPlayer *player;
    AVPlayerLayer *playerLayer;
    UILabel* descriptionLabel;
    UIView* modalBackground;
    UIButton *closeButton;
    BOOL isRepresentationLabel;
    NSString* endKey;
}
- (void)viewDidAppear:(BOOL)animated;
- (void)addModalBackground;
- (void)playMovies;
- (void)closeVideo;
- (void)playerItemDidReachEnd:(NSNotification *)notification;
- (void)checkPlaybackTime;
- (void)drawCloseButton;
- (UIImage*)imageForSize:(CGSize)size withSelector:(SEL)selector;
@end

@implementation iKeywiCustomKeysListController : PSListController 

- (void)viewDidAppear:(BOOL)animated
{
    window = [UIApplication sharedApplication].keyWindow;
    if (window == nil)
        window = [[UIApplication sharedApplication].windows firstObject];
    if ([window respondsToSelector:@selector(tintColor)])
        window.tintColor = UIColorFromRGB(0xFAAB26);
}

- (void)loadView
{
    [super loadView];
    
    UINavigationItem* navigationItem = self.navigationItem;
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
    {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,40)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        navigationItem.titleView = titleLabel;
        titleLabel.textColor = iKeywiColor;
    }
    
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:iKeywiLocalizedString(@"HELP") style:UIBarButtonItemStyleBordered target:self action:@selector(addModalBackground)]; 
}

- (void)addModalBackground
{
    BOOL viewExists = NO;
    for (UIView *view in window.subviews)
    {
        if (view.tag == 696851)
        {
            viewExists = YES;
            break;
        }
        else
            viewExists = NO;
    }
    if (!viewExists)
    {
        modalBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        [window addSubview:modalBackground];
        modalBackground.backgroundColor = [UIColor blackColor];
        modalBackground.alpha = 0.4;
        modalBackground.tag = 696851;

        [self playMovies];

        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _4inch ? closeButton.frame = CGRectMake(280,568/2-90,30,30) : closeButton.frame = CGRectMake(280,480/2-90,30,30);
        UIImage* closeImage = [self imageForSize:CGSizeMake(30,30) withSelector:@selector(drawCloseButton)];
        [closeButton setBackgroundImage:closeImage forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeVideo) forControlEvents:UIControlEventTouchUpInside];
        [window addSubview:closeButton];
    }
}

- (void)playMovies
{
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:@"/Library/PreferenceBundles/iKeywi2.bundle/iKeywiHelp.mp4"];
 
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    player = [AVPlayer playerWithPlayerItem:playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];

    _4inch ? playerLayer.frame = CGRectMake(25,568/2-75,270,150) : playerLayer.frame = CGRectMake(25,480/2-75,270,150);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:@"AVPlayerItemDidPlayToEndTimeNotification" object:[player currentItem]];
    checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkPlaybackTime) userInfo:nil repeats:YES];
    [window.layer addSublayer:playerLayer];
    
    descriptionLabel = [[UILabel alloc] init];
    isRepresentationLabel ? descriptionLabel.frame = CGRectMake(110, playerLayer.frame.origin.y+17, 210, 50) : descriptionLabel.frame = CGRectMake(100, playerLayer.frame.origin.y+25, 210, 50);
    descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    descriptionLabel.textColor = iKeywiColor;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    [window addSubview:descriptionLabel];
    
    [player play];
}

- (void)closeVideo
{
    [player pause];
    [playerLayer removeFromSuperlayer];
    player = nil;

    [descriptionLabel removeFromSuperview];
    [modalBackground removeFromSuperview];
    [closeButton removeFromSuperview];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [player seekToTime:kCMTimeZero];
    [player performSelector:@selector(play) withObject:player afterDelay:0.1];
}

- (void)checkPlaybackTime
{
    currentTime = CMTimeGetSeconds([player currentTime]);
    //NSLog(@"%f",currentTime);
    if (isRepresentationLabel)
        currentTime > 3 ? descriptionLabel.text = iKeywiLocalizedString(@"REPRESENTATION_LABEL") :  descriptionLabel.text = @"";
    else
        currentTime < 3 ? descriptionLabel.text = iKeywiLocalizedString(@"DISPLAYMENT_LABEL") :  descriptionLabel.text = @"";
}



- (void)drawCloseButton
{
    //// backgroundView Drawing
    UIBezierPath* backgroundViewPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 30, 30)];
    [[UIColor clearColor] setFill];
    [backgroundViewPath fill];

    //// circle Drawing
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(5, 5, 20, 20)];
    [[UIColor whiteColor] setFill];
    [circlePath fill];
    [iKeywiColor setStroke];
    circlePath.lineWidth = 1;
    [circlePath stroke];

    //// Cross
    {
        //// leftCrossLine Drawing
        UIBezierPath* leftCrossLinePath = [UIBezierPath bezierPath];
        [leftCrossLinePath moveToPoint: CGPointMake(9.4, 9.4)];
        [leftCrossLinePath addLineToPoint: CGPointMake(20.6, 20.6)];
        [iKeywiColor setStroke];
        leftCrossLinePath.lineWidth = 1;
        [leftCrossLinePath stroke];


        //// rightCrossLine Drawing
        UIBezierPath* rightCrossLinePath = [UIBezierPath bezierPath];
        [rightCrossLinePath moveToPoint: CGPointMake(20.6, 9.4)];
        [rightCrossLinePath addLineToPoint: CGPointMake(9.4, 20.6)];
        [iKeywiColor setStroke];
        rightCrossLinePath.lineWidth = 1;
        [rightCrossLinePath stroke];
    }
}

- (UIImage*)imageForSize:(CGSize)size withSelector:(SEL)selector
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:selector];
    #pragma clang diagnostic pop
    
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}
@end