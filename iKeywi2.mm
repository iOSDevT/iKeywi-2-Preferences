#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "RepresentationListControllers.mm"
#import "DisplaymentListControllers.mm"
#import "iKeywi2.h"

@interface iKeywi2ListController: PSListController
{
	CGRect topFrame;
	UIImageView* logoImage;
	UILabel* iKeywiLabel;
	UILabel* footerLabel;
	UILabel* titleLabel;
}
@property(retain) UIImageView* bannerImage;
@property(retain) NSMutableArray *translationCredits;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)addRespringButton:(NSNotification *)notification;
- (void)showLoadingView;
- (void)respring;
- (void)respringAlert;
- (void)importSettingsAlert;
- (void)resetSettingsAlert;
- (void)importSettings;
- (void)resetSettings;
- (void)showTranslators;
- (id)getTranslatorNameWithSpecifier:(PSSpecifier *)specifier;
- (UIImage*)imageForSize:(CGSize)size withSelector:(SEL)selector;
- (void)drawBanner;
- (void)drawLogo;
@end

@implementation iKeywi2ListController
- (instancetype)init
{
	self = [super init];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRespringButton:) name:@"AddRespringButton" object:nil];
	NSMutableDictionary* plistDict = [NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath];
	if ([plistDict objectForKey:@"height"] == nil)
		[plistDict setObject:@37 forKey:@"height"];
	if ([plistDict objectForKey:@"landscape_height"] == nil)
		[plistDict setObject:@28 forKey:@"landscape_height"];
	[plistDict writeToFile:UserDefaultsPlistPath atomically:YES];

	self.translationCredits = [NSMutableArray array];
    for (NSString *language in [[self.class translators].allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)])
    {
        PSSpecifier *translator = [PSSpecifier preferenceSpecifierNamed:language target:self set:NULL get:@selector(getTranslatorNameWithSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSTitleValueCell"] edit:Nil];
        [translator setProperty:[iKeywiTineButtonCell class] forKey:@"cellClass"];
        [self.translationCredits addObject:translator];
    }
	return self;
}

- (NSArray *)specifiers
{
	if (_specifiers == nil)
	{
        NSMutableArray *specifiers = [NSMutableArray array];

        if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/PredictiveKeyboard.dylib"])
        {
	        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];
	        PSSpecifier *enable = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"ENABLED") target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"] edit:Nil];
        	[enable setIdentifier:@"enabled"];
        	[specifiers addObject:enable];
        }

        PSSpecifier *gKeyRepresentation = [PSSpecifier groupSpecifierWithName:iKeywiLocalizedString(@"KEY_REPRESENTATION")];
        [gKeyRepresentation setProperty:iKeywiLocalizedString(@"KEY_REPRESENTATION_DETAIL") forKey:@"footerText"];
        [gKeyRepresentation setProperty:@(YES) forKey:@"isStaticText"];
        [specifiers addObject:gKeyRepresentation];
        
        PSSpecifier *CapitalRepresent = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"CAPITAL_KEYPAD") target:self set:NULL get:NULL detail:[CapitalRepresentationListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:CapitalRepresent];
        
        PSSpecifier *SmallRepresent = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"SMALL_KEYPAD") target:self set:NULL get:NULL detail:[SmallRepresentationListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:SmallRepresent];
        
        PSSpecifier *NumRepresent = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"NUMBER_KEYPAD") target:self set:NULL get:NULL detail:[NumberRepresentationListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:NumRepresent];
        
        PSSpecifier *NumAltRepresent = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"NUMBER_ALT_KEYPAD") target:self set:NULL get:NULL detail:[NumberAltRepresentationListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:NumAltRepresent];

        PSSpecifier *gKeyDisplayment = [PSSpecifier groupSpecifierWithName:iKeywiLocalizedString(@"KEY_DISPLAYMENT_OPTIONAL")];
        [gKeyDisplayment setProperty:iKeywiLocalizedString(@"KEY_DISPLAYMENT_DETAIL") forKey:@"footerText"];
        [gKeyDisplayment setProperty:@(YES) forKey:@"isStaticText"];
        [specifiers addObject:gKeyDisplayment];
        
        PSSpecifier *CapitalDisplay = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"CAPITAL_KEYPAD") target:self set:NULL get:NULL detail:[CapitalDisplaymentListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:CapitalDisplay];
        
        PSSpecifier *SmallDisplay = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"SMALL_KEYPAD") target:self set:NULL get:NULL detail:[SmallDisplaymentListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:SmallDisplay];
        
        PSSpecifier *NumDisplay = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"NUMBER_KEYPAD") target:self set:NULL get:NULL detail:[NumberDisplaymentListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:NumDisplay];
        
        PSSpecifier *NumAltDisplay = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"NUMBER_ALT_KEYPAD") target:self set:NULL get:NULL detail:[NumberAltDisplaymentListController class] cell:[PSTableCell cellTypeFromString:@"PSLinkCell"] edit:Nil];
        [specifiers addObject:NumAltDisplay];

        if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/PredictiveKeyboard.dylib"] && !([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/OptimizedZhuyin.dylib"] && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0) )
        {
        	PSSpecifier *gPortraitKeyHeight = [PSSpecifier groupSpecifierWithName:iKeywiLocalizedString(@"PORTRAIT_KEY_HEIGHT")];
	        [gPortraitKeyHeight setProperty:@(YES) forKey:@"isStaticText"];
	        [specifiers addObject:gPortraitKeyHeight];

	        PSSpecifier *heightSlider = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSSliderCell"] edit:Nil];
	        [heightSlider setProperty:@(YES) forKey:@"showValue"];
	        [heightSlider setProperty:@(37) forKey:@"default"];
	        [heightSlider setProperty:@(42) forKey:@"max"];
	        [heightSlider setProperty:@(30) forKey:@"min"];
	        [heightSlider setIdentifier:@"height"];
	        [specifiers addObject:heightSlider];

	        PSSpecifier *gLandscapeKeyHeight = [PSSpecifier groupSpecifierWithName:iKeywiLocalizedString(@"LANDSCAPE_KEY_HEIGHT")];
	        [gLandscapeKeyHeight setProperty:@(YES) forKey:@"isStaticText"];
	        [specifiers addObject:gLandscapeKeyHeight];

	        PSSpecifier *landscapeHeightSlider = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSSliderCell"] edit:Nil];
	        [landscapeHeightSlider setProperty:@(YES) forKey:@"showValue"];
	        [landscapeHeightSlider setProperty:@(28) forKey:@"default"];
	        [landscapeHeightSlider setProperty:@(32) forKey:@"max"];
	        [landscapeHeightSlider setProperty:@(20) forKey:@"min"];
	        [landscapeHeightSlider setIdentifier:@"landscape_height"];
	        [specifiers addObject:landscapeHeightSlider];
        }

        NSDictionary* GlobalPreferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/.GlobalPreferences.plist"];
        NSArray *AppleKeyboards = [GlobalPreferences objectForKey:@"AppleKeyboards"];
        for (NSString* keyboard in AppleKeyboards)
        {
        	if ([keyboard hasSuffix:@"Hebrew"] || [keyboard hasSuffix:@"Arabic"] || [keyboard hasSuffix:@"CangjieKeyboard"])
        	{
        		PSSpecifier* gNoCase = [PSSpecifier groupSpecifierWithName:iKeywiLocalizedString(@"OPTION_FOR_NOCASE_KEYBOARD")];
	        	[gNoCase setProperty:iKeywiLocalizedString(@"NOCASE_OPTION_DESCRIPTION") forKey:@"footerText"];
	        	[specifiers addObject:gNoCase];

	        	PSSpecifier *isNoCaseAsCapital = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"SHOW_NOCASE_AS_CAPITAL") target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSSwitchCell"] edit:Nil];
        		[isNoCaseAsCapital setIdentifier:@"isNoCaseAsCapital"];
        		[specifiers addObject:isNoCaseAsCapital];
	        	break;
        	}
        }
      
        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:iKeywi1Settings])
        {
        	PSSpecifier *importButton = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"IMPORT_SETTINGS") target:self set:NULL get:NULL detail:Nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:Nil];
	        importButton->action = @selector(importSettingsAlert);
	        [importButton setProperty:[iKeywiTineButtonCell class] forKey:@"cellClass"];
	        [specifiers addObject:importButton];
        }
        
        PSSpecifier *resetButton = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"RESET_SETTINGS") target:self set:NULL get:NULL detail:Nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:Nil];
        [resetButton setProperty:[iKeywiTineButtonCell class] forKey:@"cellClass"];
        resetButton->action = @selector(resetSettingsAlert);
        [specifiers addObject:resetButton];

        PSSpecifier* footSpecifier = [PSSpecifier emptyGroupSpecifier];
        [footSpecifier setProperty:@"© 2014 Hiraku (@hiraku_dev)" forKey:@"footerText"];
        [specifiers addObject:footSpecifier];

        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
        {
        	 PSSpecifier *translationCredits = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"TRANSLATORS") target:self set:NULL get:NULL detail:Nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:Nil];
	        [translationCredits setIdentifier:@"Translators"];
	        [translationCredits setProperty:[iKeywiTineButtonCell class] forKey:@"cellClass"];
	        translationCredits->action = @selector(showTranslators);
	        [specifiers addObject:translationCredits];
        }
       
       	[_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
    
	return _specifiers;
}

- (void)viewDidDisappear:(BOOL)animated
{
	UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if ([window respondsToSelector:@selector(tintColor)])
		window.tintColor = nil;
	
}

- (void)loadView
{
  	[super loadView];

  	UIWindow *window = [UIApplication sharedApplication].keyWindow;
  	if (window == nil)
  		window = [[UIApplication sharedApplication].windows firstObject];
  	if ([window respondsToSelector:@selector(tintColor)])
		window.tintColor = UIColorFromRGB(0xFAAB26);

  	UINavigationItem* navigationItem = self.navigationItem;
  	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0)
		navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareiKeywi)];

    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
    {
    	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,40)];
	    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:17]];
	    [titleLabel setText:@""];
	    titleLabel.textAlignment = NSTextAlignmentCenter;
	    titleLabel.backgroundColor = [UIColor clearColor];
	    titleLabel.adjustsFontSizeToFitWidth = YES;
	    navigationItem.titleView = titleLabel;
	    titleLabel.textColor = iKeywiColor;
	    [titleLabel setAlpha:0];

	    topFrame = CGRectMake(0, -150, 320, 150);
	  	self.bannerImage = [[UIImageView alloc] initWithImage:[self imageForSize:CGSizeMake(topFrame.size.width,topFrame.size.height) withSelector:@selector(drawBanner)]];
	  	[self.bannerImage setFrame:topFrame];
	  	[self.view addSubview:self.bannerImage];
	  	[self.view sendSubviewToBack:self.bannerImage];
	    
	    logoImage = [[UIImageView alloc] initWithImage:[self imageForSize:CGSizeMake(50,50) withSelector:@selector(drawLogo)]];
	    [self.bannerImage addSubview:logoImage];
	  
	    iKeywiLabel = [[UILabel alloc] initWithFrame:CGRectMake(106,topFrame.size.height/2,200,80)];
	    iKeywiLabel.text = @"iKeywi 2"; 
	    [iKeywiLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:52]];
		iKeywiLabel.textColor = [UIColor whiteColor];
	    [self.bannerImage addSubview:iKeywiLabel];
	    //iKeywiLabel.textAlignment = NSTextAlignmentRight;

	    footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,topFrame.size.height/2+40,320,50)];
	    footerLabel.text = iKeywiLocalizedString(@"CUSTOMIZABLE_EXTRA_KEYS_FOR_ALL_LANGUAGES"); 
	    [footerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
		footerLabel.textColor = [UIColor whiteColor];
		footerLabel.alpha = 0.7;
		footerLabel.textAlignment = NSTextAlignmentCenter;
	    [self.bannerImage addSubview:footerLabel];

	    [self.table setContentInset:UIEdgeInsetsMake(150,0,0,0)];
	    [self.table setContentOffset:CGPointMake(0, -150)];
	}

    if ([[NSFileManager defaultManager] fileExistsAtPath:iKeywi1Settings] && 
    	[[NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath] objectForKey:@"showImportAlert"] == nil)
    {
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:iKeywiLocalizedString(@"FOUND_IKEYWI_SETTINGS") message:iKeywiLocalizedString(@"FOUND_IKEYWI_SETTINGS_MESSAGE") delegate:self cancelButtonTitle:nil otherButtonTitles:iKeywiLocalizedString(@"CANCEL"),iKeywiLocalizedString(@"IMPORT"), nil];
    	[alert show];
    	[alert release];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGFloat scrollOffset = scrollView.contentOffset.y;
    topFrame = CGRectMake(0, scrollOffset, 320, -scrollOffset);
    //NSLog(@"%f",scrollOffset);
    if (scrollOffset < -213)
    {
    	self.bannerImage.image = [self imageForSize:CGSizeMake(topFrame.size.width,topFrame.size.height) withSelector:@selector(drawBanner)];
	    [self.bannerImage setFrame:topFrame];
	    [logoImage setFrame:CGRectMake(42,topFrame.size.height/2,50,50)];
	    [iKeywiLabel setFrame:CGRectMake(106,topFrame.size.height/2-14,200,80)];
	    [footerLabel setFrame:CGRectMake(0,topFrame.size.height/2+35,320,50)];
	    footerLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (scrollOffset > -167 && scrollOffset < -116 && scrollOffset != -150)
    {
    	[titleLabel setText:@"iKeywi 2"];
    	float alphaDegree = -116 - scrollOffset;
    	[titleLabel setAlpha:1/alphaDegree];
    }
    else if ( scrollOffset >= -116)
    	[titleLabel setAlpha:1];
   	else if (scrollOffset < -167)
	   	[titleLabel setAlpha:0];
}
//=============================================================================
- (void)shareiKeywi
{
	NSString *iKeywiShareText = iKeywiLocalizedString(@"IKEYWI_SHARE_TEXT");
	NSArray *activityItems = @[iKeywiShareText]; 
	UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0)
		activityViewController.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAirDrop];
	else
		activityViewController.excludedActivityTypes = @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard];
	[self presentViewController:activityViewController animated:YES completion:nil];
}


- (void)addRespringButton:(NSNotification *)notification
{
	UINavigationItem* navigationItem = self.navigationItem;
	UIBarButtonItem *respringButton = [[UIBarButtonItem alloc] initWithTitle:iKeywiLocalizedString(@"APPLY") style:UIBarButtonItemStyleBordered target:self action:@selector(respringAlert)];
	[respringButton setTitleTextAttributes:@{
     UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0],
	} forState:UIControlStateNormal];
    navigationItem.leftBarButtonItem = respringButton;
    
    // if ([navigationItem.leftBarButtonItem respondsToSelector:@selector(tintColor)])
    // 	navigationItem.leftBarButtonItem.tintColor = nil;//UIColorFromRGB(0xE74C3C);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   
    if ([alertView.title isEqualToString:iKeywiLocalizedString(@"RESTART_SPRINGBOARD")] && buttonIndex == 1)
    {
    	[self showLoadingView];
	    [self performSelector:@selector(respring) withObject:self afterDelay:2.0];
	}
	else if ([alertView.title isEqualToString:iKeywiLocalizedString(@"RESET_SETTINGS")] && buttonIndex == 1)
    {	
    	[self showLoadingView];
    	[self resetSettings];
	    [self performSelector:@selector(respring) withObject:self afterDelay:2.0];
	}
	else if ([alertView.title isEqualToString:iKeywiLocalizedString(@"FOUND_IKEYWI_SETTINGS")] && buttonIndex == 1)
    {	
    	[self showLoadingView];
    	[self resetSettings];
    	[self importSettings];
	    [self performSelector:@selector(respring) withObject:self afterDelay:2.0];   
	}
	else if ([alertView.title isEqualToString:iKeywiLocalizedString(@"FOUND_IKEYWI_SETTINGS")] && buttonIndex != 1)
    {	
    	NSMutableDictionary* plistDict = [NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath];
    	[plistDict setObject:@NO forKey:@"showImportAlert"];
    	[plistDict writeToFile:UserDefaultsPlistPath atomically:YES];
	}
	else if ([alertView.title isEqualToString:iKeywiLocalizedString(@"IMPORT_SETTINGS")] && buttonIndex == 1)
    {	
    	[self showLoadingView];
    	[self resetSettings];
    	[self importSettings];
	    [self performSelector:@selector(respring) withObject:self afterDelay:2.0];   
	}
	titleLabel.textColor = iKeywiColor;
}

- (void)showLoadingView
{
	UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    	
	UIView* loading = [[UIView alloc] initWithFrame:CGRectMake(window.frame.size.width/2-50, window.frame.size.height/2-50, 100, 100)];
    [loading setBackgroundColor:[UIColor blackColor]];
    [loading setAlpha:0.7];
    loading.layer.cornerRadius = 15;
        
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [spinner startAnimating];
    
    [loading addSubview:spinner];
    loading.userInteractionEnabled = NO;
    [window addSubview:loading];
}

- (void)respring
{
	system("killall lsd SpringBoard");
}

- (void)respringAlert
{
	titleLabel.textColor = [UIColor blackColor];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:iKeywiLocalizedString(@"RESTART_SPRINGBOARD") message:iKeywiLocalizedString(@"RESTART_SPRINGBOARD_MESSAGE") delegate:self cancelButtonTitle:iKeywiLocalizedString(@"CANCEL") otherButtonTitles:iKeywiLocalizedString(@"RESPRING_BUTTON"), nil];
    [alert show];
    [alert release];
}

- (void)importSettingsAlert
{
	titleLabel.textColor = [UIColor blackColor];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:iKeywiLocalizedString(@"IMPORT_SETTINGS") message:iKeywiLocalizedString(@"IMPORT_SETTINGS_MESSAGE") delegate:self cancelButtonTitle:iKeywiLocalizedString(@"CANCEL") otherButtonTitles:iKeywiLocalizedString(@"CONFIRM"), nil];
    [alert show];
    [alert release];
}

- (void)resetSettingsAlert
{
	titleLabel.textColor = [UIColor blackColor];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:iKeywiLocalizedString(@"RESET_SETTINGS") message:iKeywiLocalizedString(@"RESET_SETTINGS_MESSAGE") delegate:self cancelButtonTitle:iKeywiLocalizedString(@"CANCEL") otherButtonTitles:iKeywiLocalizedString(@"CONFIRM"), nil];
    [alert show];
    [alert release];
}

- (void)importSettings
{
 	NSDictionary* iKeywi1Plist = [NSDictionary dictionaryWithContentsOfFile:iKeywi1Settings];
 	NSMutableDictionary* plistDict = [NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath];
 	
 	for (int i = 0; i < 12; ++i)
 	{
 		NSString* oldValueAlt = [[NSString alloc] initWithFormat:@"customAltKey%d",i];
 		NSString* oldValue = [[NSString alloc] initWithFormat:@"customKey%d",i];
    	if ([iKeywi1Plist objectForKey:oldValueAlt] != nil)
    		iKeywiPreferencesSetCustomDisplay([[NSString alloc] initWithFormat:@"capitalKey%d",i],[iKeywi1Plist objectForKey:oldValueAlt]);
    	if ([iKeywi1Plist objectForKey:oldValue] != nil)
    		iKeywiPreferencesSetCustomDisplay([[NSString alloc] initWithFormat:@"smallKey%d",i],[iKeywi1Plist objectForKey:oldValue]);
 	}
 	if ([iKeywi1Plist objectForKey:@"height"] != nil)
		[plistDict setObject:@37 forKey:@"height"];
	if ([iKeywi1Plist objectForKey:@"landscape_height"] != nil)
		[plistDict setObject:@28 forKey:@"landscape_height"];
	[plistDict writeToFile:UserDefaultsPlistPath atomically:YES];

	NSError *error = nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:iKeywi1Settings])
    {
        BOOL delSuccess = [[NSFileManager defaultManager] removeItemAtPath:iKeywi1Settings error:&error];
        if (!delSuccess || error)
            NSLog(@"No settings found");
    }
}

- (void)resetSettings
{
	NSError *error = nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:UserDefaultsPlistPath])
    {
        BOOL delSuccess = [[NSFileManager defaultManager] removeItemAtPath:UserDefaultsPlistPath error:&error];
        if (!delSuccess || error)
            NSLog(@"No settings found");
    }
}
//=============================================================================
- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    return iKeywiPreferencesGetUserDefaultForKey(specifier.identifier);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    iKeywiPreferencesSetUserDefaultForKey(specifier.identifier, value);
}
//=============================================================================
- (void)showTranslators
{
    if ([[self.specifiers.lastObject identifier] isEqualToString:@"Translators"])
        [self addSpecifiersFromArray:self.translationCredits animated:YES];
    else
        for (PSSpecifier *credits in self.translationCredits)
            [self removeSpecifier:credits animated:YES];
}

- (id)getTranslatorNameWithSpecifier:(PSSpecifier *)specifier
{
    return [self.class translators][specifier.name];
}

+ (NSDictionary *)translators
{
    return @{@"English": @"(Main Language)",
             @"繁體中文": @"(Hiraku)",
             @"简体中文": @"@chengggggg",
             @"Polski":@"@andrzejf1994",
             @"Русский":@"@yablyktube",
             @"Español":@"@TheDarcker"
         	};
}
//=============================================================================

-(void)drawBanner
{
	// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();

	// Color Declarations
	UIColor* beginColor = [UIColor colorWithRed: 1 green: 0.851 blue: 0.161 alpha: 1];
	UIColor* endColor = [UIColor colorWithRed: 1 green: 0.604 blue: 0.227 alpha: 1];

	// Gradient Declarations
	NSArray* gradientColors = [NSArray arrayWithObjects: (id)beginColor.CGColor, (id)endColor.CGColor, nil];
	CGFloat gradientLocations[] = {0, 1};
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);

	// Rectangle Drawing
	UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, topFrame.size.width, topFrame.size.height) cornerRadius: 1];
	CGContextSaveGState(context);
	[rectanglePath addClip];
	CGContextDrawLinearGradient(context, gradient, CGPointMake(160, 0), CGPointMake(160, topFrame.size.height), 0);
	CGContextRestoreGState(context);

	// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorSpace);
}

-(void)drawLogo
{
	//// General Declarations
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = UIGraphicsGetCurrentContext();

	//// Color Declarations
	UIColor* innerSeedColor = [UIColor colorWithRed: 0.961 green: 0.941 blue: 0.592 alpha: 0.31];
	UIColor* coreLight = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.795];
	UIColor* seedColor = [UIColor colorWithRed: 0.467 green: 0.271 blue: 0.125 alpha: 0.5];
	UIColor* outterSeedColor = [UIColor colorWithRed: 0.408 green: 0.627 blue: 0.055 alpha: 0.59];
	UIColor* skinColor = [UIColor colorWithRed: 0.467 green: 0.27 blue: 0.125 alpha: 1];
	UIColor* coreColor = [UIColor colorWithRed: 0.976 green: 0.843 blue: 0.431 alpha: 0.63];
	UIColor* kiwiMeatGreen = [UIColor colorWithRed: 0.432 green: 0.887 blue: 0.103 alpha: 1];

	//// Gradient Declarations
	NSArray* radialGradient3Colors = [NSArray arrayWithObjects: 
	    (id)coreColor.CGColor, 
	    (id)coreLight.CGColor, nil];
	CGFloat radialGradient3Locations[] = {0, 1};
	CGGradientRef radialGradient3 = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)radialGradient3Colors, radialGradient3Locations);

	//// iKeywiLogo
	{
	    CGContextSaveGState(context);
	    CGContextSetAlpha(context, 0.8);
	    CGContextBeginTransparencyLayer(context, NULL);


	    //// outterSkin Drawing
	    UIBezierPath* outterSkinPath = [UIBezierPath bezierPath];
	    [outterSkinPath moveToPoint: CGPointMake(22.1, 49.69)];
	    [outterSkinPath addCurveToPoint: CGPointMake(49.86, 24.86) controlPoint1: CGPointMake(34.97, 49.69) controlPoint2: CGPointMake(49.86, 38.97)];
	    [outterSkinPath addCurveToPoint: CGPointMake(22.1, 0.02) controlPoint1: CGPointMake(49.86, 10.74) controlPoint2: CGPointMake(34.97, 0.02)];
	    [outterSkinPath addCurveToPoint: CGPointMake(22.1, 49.69) controlPoint1: CGPointMake(9.24, 0.02) controlPoint2: CGPointMake(9.24, 49.69)];
	    [outterSkinPath closePath];
	    outterSkinPath.miterLimit = 4;

	    outterSkinPath.usesEvenOddFillRule = YES;

	    [skinColor setFill];
	    [outterSkinPath fill];


	    //// innerSkin Drawing
	    UIBezierPath* innerSkinPath = [UIBezierPath bezierPath];
	    [innerSkinPath moveToPoint: CGPointMake(22.47, 49.49)];
	    [innerSkinPath addCurveToPoint: CGPointMake(44.95, 24.75) controlPoint1: CGPointMake(34.89, 49.49) controlPoint2: CGPointMake(44.95, 38.42)];
	    [innerSkinPath addCurveToPoint: CGPointMake(22.47, 0) controlPoint1: CGPointMake(44.95, 11.08) controlPoint2: CGPointMake(34.89, 0)];
	    [innerSkinPath addCurveToPoint: CGPointMake(0, 24.75) controlPoint1: CGPointMake(10.06, 0) controlPoint2: CGPointMake(0, 11.08)];
	    [innerSkinPath addCurveToPoint: CGPointMake(22.47, 49.49) controlPoint1: CGPointMake(0, 38.42) controlPoint2: CGPointMake(10.06, 49.49)];
	    [innerSkinPath closePath];
	    innerSkinPath.miterLimit = 4;

	    innerSkinPath.usesEvenOddFillRule = YES;

	    [skinColor setFill];
	    [innerSkinPath fill];


	    //// kiwiMeat Drawing
	    UIBezierPath* kiwiMeatPath = [UIBezierPath bezierPath];
	    [kiwiMeatPath moveToPoint: CGPointMake(22.47, 48.99)];
	    [kiwiMeatPath addCurveToPoint: CGPointMake(44.44, 24.75) controlPoint1: CGPointMake(34.61, 48.99) controlPoint2: CGPointMake(44.44, 38.14)];
	    [kiwiMeatPath addCurveToPoint: CGPointMake(22.47, 0.51) controlPoint1: CGPointMake(44.44, 11.36) controlPoint2: CGPointMake(34.61, 0.51)];
	    [kiwiMeatPath addCurveToPoint: CGPointMake(0.51, 24.75) controlPoint1: CGPointMake(10.34, 0.51) controlPoint2: CGPointMake(0.51, 11.36)];
	    [kiwiMeatPath addCurveToPoint: CGPointMake(22.47, 48.99) controlPoint1: CGPointMake(0.51, 38.14) controlPoint2: CGPointMake(10.34, 48.99)];
	    [kiwiMeatPath closePath];
	    kiwiMeatPath.miterLimit = 4;

	    kiwiMeatPath.usesEvenOddFillRule = YES;

	    [kiwiMeatGreen setFill];
	    [kiwiMeatPath fill];


	    //// outterSeed Drawing
	    UIBezierPath* outterSeedPath = [UIBezierPath bezierPath];
	    [outterSeedPath moveToPoint: CGPointMake(29.55, 20.4)];
	    [outterSeedPath addCurveToPoint: CGPointMake(36.69, 18.49) controlPoint1: CGPointMake(33.62, 18.79) controlPoint2: CGPointMake(36.46, 18)];
	    [outterSeedPath addCurveToPoint: CGPointMake(28.61, 23.8) controlPoint1: CGPointMake(36.96, 19.06) controlPoint2: CGPointMake(33.6, 21.23)];
	    [outterSeedPath addCurveToPoint: CGPointMake(38.12, 25.54) controlPoint1: CGPointMake(34.21, 24.22) controlPoint2: CGPointMake(38.14, 24.9)];
	    [outterSeedPath addCurveToPoint: CGPointMake(29.63, 26.59) controlPoint1: CGPointMake(38.1, 26.13) controlPoint2: CGPointMake(34.65, 26.52)];
	    [outterSeedPath addCurveToPoint: CGPointMake(36.8, 31.27) controlPoint1: CGPointMake(34.11, 28.86) controlPoint2: CGPointMake(37.04, 30.73)];
	    [outterSeedPath addCurveToPoint: CGPointMake(28.78, 29.16) controlPoint1: CGPointMake(36.56, 31.8) controlPoint2: CGPointMake(33.33, 30.91)];
	    [outterSeedPath addCurveToPoint: CGPointMake(33.62, 35.89) controlPoint1: CGPointMake(32.04, 32.78) controlPoint2: CGPointMake(34.03, 35.48)];
	    [outterSeedPath addCurveToPoint: CGPointMake(26.17, 30.4) controlPoint1: CGPointMake(33.18, 36.33) controlPoint2: CGPointMake(30.15, 34.05)];
	    [outterSeedPath addCurveToPoint: CGPointMake(28, 39.48) controlPoint1: CGPointMake(27.79, 35.55) controlPoint2: CGPointMake(28.58, 39.26)];
	    [outterSeedPath addCurveToPoint: CGPointMake(24.05, 32.51) controlPoint1: CGPointMake(27.46, 39.67) controlPoint2: CGPointMake(25.91, 36.85)];
	    [outterSeedPath addCurveToPoint: CGPointMake(22.73, 40.4) controlPoint1: CGPointMake(23.79, 37.22) controlPoint2: CGPointMake(23.3, 40.4)];
	    [outterSeedPath addCurveToPoint: CGPointMake(21.33, 31.04) controlPoint1: CGPointMake(22.1, 40.4) controlPoint2: CGPointMake(21.56, 36.54)];
	    [outterSeedPath addCurveToPoint: CGPointMake(15.97, 38.85) controlPoint1: CGPointMake(18.71, 35.89) controlPoint2: CGPointMake(16.54, 39.12)];
	    [outterSeedPath addCurveToPoint: CGPointMake(18.36, 30.9) controlPoint1: CGPointMake(15.45, 38.59) controlPoint2: CGPointMake(16.45, 35.39)];
	    [outterSeedPath addCurveToPoint: CGPointMake(11.46, 35.51) controlPoint1: CGPointMake(14.62, 34.04) controlPoint2: CGPointMake(11.86, 35.93)];
	    [outterSeedPath addCurveToPoint: CGPointMake(15.91, 29.6) controlPoint1: CGPointMake(11.09, 35.11) controlPoint2: CGPointMake(12.89, 32.78)];
	    [outterSeedPath addCurveToPoint: CGPointMake(8.77, 31.51) controlPoint1: CGPointMake(11.83, 31.21) controlPoint2: CGPointMake(9, 32)];
	    [outterSeedPath addCurveToPoint: CGPointMake(16.84, 26.2) controlPoint1: CGPointMake(8.5, 30.94) controlPoint2: CGPointMake(11.85, 28.77)];
	    [outterSeedPath addCurveToPoint: CGPointMake(7.33, 24.46) controlPoint1: CGPointMake(11.24, 25.78) controlPoint2: CGPointMake(7.31, 25.1)];
	    [outterSeedPath addCurveToPoint: CGPointMake(15.82, 23.41) controlPoint1: CGPointMake(7.35, 23.87) controlPoint2: CGPointMake(10.8, 23.48)];
	    [outterSeedPath addCurveToPoint: CGPointMake(8.65, 18.73) controlPoint1: CGPointMake(11.34, 21.14) controlPoint2: CGPointMake(8.41, 19.27)];
	    [outterSeedPath addCurveToPoint: CGPointMake(16.67, 20.84) controlPoint1: CGPointMake(8.89, 18.2) controlPoint2: CGPointMake(12.12, 19.09)];
	    [outterSeedPath addCurveToPoint: CGPointMake(11.83, 14.11) controlPoint1: CGPointMake(13.41, 17.22) controlPoint2: CGPointMake(11.42, 14.52)];
	    [outterSeedPath addCurveToPoint: CGPointMake(19.29, 19.6) controlPoint1: CGPointMake(12.27, 13.67) controlPoint2: CGPointMake(15.31, 15.95)];
	    [outterSeedPath addCurveToPoint: CGPointMake(17.46, 10.52) controlPoint1: CGPointMake(17.67, 14.45) controlPoint2: CGPointMake(16.88, 10.74)];
	    [outterSeedPath addCurveToPoint: CGPointMake(21.4, 17.49) controlPoint1: CGPointMake(17.99, 10.33) controlPoint2: CGPointMake(19.55, 13.15)];
	    [outterSeedPath addCurveToPoint: CGPointMake(22.73, 9.6) controlPoint1: CGPointMake(21.66, 12.78) controlPoint2: CGPointMake(22.16, 9.6)];
	    [outterSeedPath addCurveToPoint: CGPointMake(24.12, 18.96) controlPoint1: CGPointMake(23.35, 9.6) controlPoint2: CGPointMake(23.89, 13.46)];
	    [outterSeedPath addCurveToPoint: CGPointMake(29.48, 11.15) controlPoint1: CGPointMake(26.74, 14.11) controlPoint2: CGPointMake(28.92, 10.88)];
	    [outterSeedPath addCurveToPoint: CGPointMake(27.1, 19.1) controlPoint1: CGPointMake(30, 11.41) controlPoint2: CGPointMake(29, 14.61)];
	    [outterSeedPath addCurveToPoint: CGPointMake(33.99, 14.49) controlPoint1: CGPointMake(30.83, 15.96) controlPoint2: CGPointMake(33.6, 14.07)];
	    [outterSeedPath addCurveToPoint: CGPointMake(29.55, 20.4) controlPoint1: CGPointMake(34.36, 14.89) controlPoint2: CGPointMake(32.56, 17.22)];
	    [outterSeedPath closePath];
	    outterSeedPath.miterLimit = 4;

	    outterSeedPath.usesEvenOddFillRule = YES;

	    [outterSeedColor setFill];
	    [outterSeedPath fill];


	    //// seed Drawing
	    UIBezierPath* seedPath = [UIBezierPath bezierPath];
	    [seedPath moveToPoint: CGPointMake(21.18, 16.14)];
	    [seedPath addCurveToPoint: CGPointMake(21.71, 14.77) controlPoint1: CGPointMake(21.59, 16.07) controlPoint2: CGPointMake(21.83, 15.45)];
	    [seedPath addCurveToPoint: CGPointMake(20.74, 13.66) controlPoint1: CGPointMake(21.58, 14.08) controlPoint2: CGPointMake(21.15, 13.58)];
	    [seedPath addCurveToPoint: CGPointMake(20.21, 15.03) controlPoint1: CGPointMake(20.33, 13.73) controlPoint2: CGPointMake(20.09, 14.34)];
	    [seedPath addCurveToPoint: CGPointMake(21.18, 16.14) controlPoint1: CGPointMake(20.33, 15.72) controlPoint2: CGPointMake(20.77, 16.22)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(13.43, 31.87)];
	    [seedPath addCurveToPoint: CGPointMake(14.88, 31.64) controlPoint1: CGPointMake(13.7, 32.19) controlPoint2: CGPointMake(14.35, 32.09)];
	    [seedPath addCurveToPoint: CGPointMake(15.36, 30.25) controlPoint1: CGPointMake(15.42, 31.19) controlPoint2: CGPointMake(15.63, 30.57)];
	    [seedPath addCurveToPoint: CGPointMake(13.91, 30.48) controlPoint1: CGPointMake(15.09, 29.93) controlPoint2: CGPointMake(14.44, 30.03)];
	    [seedPath addCurveToPoint: CGPointMake(13.43, 31.87) controlPoint1: CGPointMake(13.37, 30.93) controlPoint2: CGPointMake(13.16, 31.55)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(28.81, 34.88)];
	    [seedPath addCurveToPoint: CGPointMake(29.12, 33.43) controlPoint1: CGPointMake(29.21, 34.74) controlPoint2: CGPointMake(29.35, 34.09)];
	    [seedPath addCurveToPoint: CGPointMake(27.99, 32.49) controlPoint1: CGPointMake(28.89, 32.78) controlPoint2: CGPointMake(28.39, 32.35)];
	    [seedPath addCurveToPoint: CGPointMake(27.69, 33.93) controlPoint1: CGPointMake(27.6, 32.62) controlPoint2: CGPointMake(27.46, 33.27)];
	    [seedPath addCurveToPoint: CGPointMake(28.81, 34.88) controlPoint1: CGPointMake(27.91, 34.59) controlPoint2: CGPointMake(28.42, 35.01)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(32.2, 30.73)];
	    [seedPath addCurveToPoint: CGPointMake(31.38, 29.5) controlPoint1: CGPointMake(32.38, 30.35) controlPoint2: CGPointMake(32.01, 29.8)];
	    [seedPath addCurveToPoint: CGPointMake(29.92, 29.66) controlPoint1: CGPointMake(30.75, 29.21) controlPoint2: CGPointMake(30.09, 29.28)];
	    [seedPath addCurveToPoint: CGPointMake(30.74, 30.88) controlPoint1: CGPointMake(29.74, 30.04) controlPoint2: CGPointMake(30.11, 30.58)];
	    [seedPath addCurveToPoint: CGPointMake(32.2, 30.73) controlPoint1: CGPointMake(31.37, 31.17) controlPoint2: CGPointMake(32.03, 31.1)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(20.96, 36.87)];
	    [seedPath addCurveToPoint: CGPointMake(21.72, 35.61) controlPoint1: CGPointMake(21.38, 36.87) controlPoint2: CGPointMake(21.72, 36.3)];
	    [seedPath addCurveToPoint: CGPointMake(20.96, 34.34) controlPoint1: CGPointMake(21.72, 34.91) controlPoint2: CGPointMake(21.38, 34.34)];
	    [seedPath addCurveToPoint: CGPointMake(20.2, 35.61) controlPoint1: CGPointMake(20.54, 34.34) controlPoint2: CGPointMake(20.2, 34.91)];
	    [seedPath addCurveToPoint: CGPointMake(20.96, 36.87) controlPoint1: CGPointMake(20.2, 36.3) controlPoint2: CGPointMake(20.54, 36.87)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(18.24, 17.82)];
	    [seedPath addCurveToPoint: CGPointMake(17.86, 16.4) controlPoint1: CGPointMake(18.53, 17.52) controlPoint2: CGPointMake(18.36, 16.89)];
	    [seedPath addCurveToPoint: CGPointMake(16.42, 16.07) controlPoint1: CGPointMake(17.36, 15.92) controlPoint2: CGPointMake(16.71, 15.77)];
	    [seedPath addCurveToPoint: CGPointMake(16.81, 17.49) controlPoint1: CGPointMake(16.13, 16.37) controlPoint2: CGPointMake(16.3, 17.01)];
	    [seedPath addCurveToPoint: CGPointMake(18.24, 17.82) controlPoint1: CGPointMake(17.31, 17.98) controlPoint2: CGPointMake(17.95, 18.12)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(30.85, 23.29)];
	    [seedPath addCurveToPoint: CGPointMake(32.25, 23.71) controlPoint1: CGPointMake(30.95, 23.69) controlPoint2: CGPointMake(31.58, 23.88)];
	    [seedPath addCurveToPoint: CGPointMake(33.3, 22.67) controlPoint1: CGPointMake(32.93, 23.55) controlPoint2: CGPointMake(33.4, 23.08)];
	    [seedPath addCurveToPoint: CGPointMake(31.89, 22.24) controlPoint1: CGPointMake(33.19, 22.27) controlPoint2: CGPointMake(32.56, 22.08)];
	    [seedPath addCurveToPoint: CGPointMake(30.85, 23.29) controlPoint1: CGPointMake(31.21, 22.41) controlPoint2: CGPointMake(30.74, 22.88)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(28.03, 29.8)];
	    [seedPath addCurveToPoint: CGPointMake(27.48, 28.44) controlPoint1: CGPointMake(28.28, 29.47) controlPoint2: CGPointMake(28.03, 28.86)];
	    [seedPath addCurveToPoint: CGPointMake(26.01, 28.28) controlPoint1: CGPointMake(26.92, 28.02) controlPoint2: CGPointMake(26.26, 27.95)];
	    [seedPath addCurveToPoint: CGPointMake(26.56, 29.65) controlPoint1: CGPointMake(25.76, 28.61) controlPoint2: CGPointMake(26.01, 29.23)];
	    [seedPath addCurveToPoint: CGPointMake(28.03, 29.8) controlPoint1: CGPointMake(27.12, 30.07) controlPoint2: CGPointMake(27.78, 30.13)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(32.09, 18.22)];
	    [seedPath addCurveToPoint: CGPointMake(30.63, 18.32) controlPoint1: CGPointMake(31.85, 17.87) controlPoint2: CGPointMake(31.2, 17.92)];
	    [seedPath addCurveToPoint: CGPointMake(30.03, 19.66) controlPoint1: CGPointMake(30.05, 18.72) controlPoint2: CGPointMake(29.79, 19.32)];
	    [seedPath addCurveToPoint: CGPointMake(31.5, 19.56) controlPoint1: CGPointMake(30.27, 20.01) controlPoint2: CGPointMake(30.92, 19.96)];
	    [seedPath addCurveToPoint: CGPointMake(32.09, 18.22) controlPoint1: CGPointMake(32.07, 19.16) controlPoint2: CGPointMake(32.33, 18.56)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(14.42, 19.16)];
	    [seedPath addCurveToPoint: CGPointMake(13.82, 17.81) controlPoint1: CGPointMake(14.66, 18.82) controlPoint2: CGPointMake(14.39, 18.21)];
	    [seedPath addCurveToPoint: CGPointMake(12.35, 17.71) controlPoint1: CGPointMake(13.25, 17.41) controlPoint2: CGPointMake(12.59, 17.37)];
	    [seedPath addCurveToPoint: CGPointMake(12.95, 19.05) controlPoint1: CGPointMake(12.11, 18.05) controlPoint2: CGPointMake(12.38, 18.65)];
	    [seedPath addCurveToPoint: CGPointMake(14.42, 19.16) controlPoint1: CGPointMake(13.52, 19.45) controlPoint2: CGPointMake(14.18, 19.5)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(11.68, 27.5)];
	    [seedPath addCurveToPoint: CGPointMake(13.13, 27.8) controlPoint1: CGPointMake(11.82, 27.89) controlPoint2: CGPointMake(12.47, 28.03)];
	    [seedPath addCurveToPoint: CGPointMake(14.07, 26.67) controlPoint1: CGPointMake(13.78, 27.58) controlPoint2: CGPointMake(14.21, 27.07)];
	    [seedPath addCurveToPoint: CGPointMake(12.63, 26.37) controlPoint1: CGPointMake(13.94, 26.28) controlPoint2: CGPointMake(13.29, 26.14)];
	    [seedPath addCurveToPoint: CGPointMake(11.68, 27.5) controlPoint1: CGPointMake(11.97, 26.6) controlPoint2: CGPointMake(11.55, 27.1)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(30.3, 26.45)];
	    [seedPath addCurveToPoint: CGPointMake(31.53, 27.27) controlPoint1: CGPointMake(30.28, 26.87) controlPoint2: CGPointMake(30.83, 27.24)];
	    [seedPath addCurveToPoint: CGPointMake(32.83, 26.58) controlPoint1: CGPointMake(32.22, 27.31) controlPoint2: CGPointMake(32.8, 27)];
	    [seedPath addCurveToPoint: CGPointMake(31.61, 25.76) controlPoint1: CGPointMake(32.85, 26.16) controlPoint2: CGPointMake(32.3, 25.8)];
	    [seedPath addCurveToPoint: CGPointMake(30.3, 26.45) controlPoint1: CGPointMake(30.91, 25.72) controlPoint2: CGPointMake(30.33, 26.03)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(24.69, 17.13)];
	    [seedPath addCurveToPoint: CGPointMake(25.74, 16.09) controlPoint1: CGPointMake(25.1, 17.24) controlPoint2: CGPointMake(25.57, 16.77)];
	    [seedPath addCurveToPoint: CGPointMake(25.31, 14.68) controlPoint1: CGPointMake(25.9, 15.42) controlPoint2: CGPointMake(25.71, 14.79)];
	    [seedPath addCurveToPoint: CGPointMake(24.26, 15.73) controlPoint1: CGPointMake(24.9, 14.58) controlPoint2: CGPointMake(24.43, 15.05)];
	    [seedPath addCurveToPoint: CGPointMake(24.69, 17.13) controlPoint1: CGPointMake(24.1, 16.4) controlPoint2: CGPointMake(24.29, 17.03)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(15.6, 34.55)];
	    [seedPath addCurveToPoint: CGPointMake(16.99, 34.07) controlPoint1: CGPointMake(15.92, 34.82) controlPoint2: CGPointMake(16.55, 34.61)];
	    [seedPath addCurveToPoint: CGPointMake(17.23, 32.62) controlPoint1: CGPointMake(17.44, 33.54) controlPoint2: CGPointMake(17.55, 32.89)];
	    [seedPath addCurveToPoint: CGPointMake(15.83, 33.1) controlPoint1: CGPointMake(16.91, 32.35) controlPoint2: CGPointMake(16.28, 32.56)];
	    [seedPath addCurveToPoint: CGPointMake(15.6, 34.55) controlPoint1: CGPointMake(15.39, 33.63) controlPoint2: CGPointMake(15.28, 34.28)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(26.27, 20.61)];
	    [seedPath addCurveToPoint: CGPointMake(27.47, 19.74) controlPoint1: CGPointMake(26.66, 20.77) controlPoint2: CGPointMake(27.19, 20.38)];
	    [seedPath addCurveToPoint: CGPointMake(27.26, 18.28) controlPoint1: CGPointMake(27.74, 19.1) controlPoint2: CGPointMake(27.65, 18.45)];
	    [seedPath addCurveToPoint: CGPointMake(26.07, 19.15) controlPoint1: CGPointMake(26.88, 18.12) controlPoint2: CGPointMake(26.34, 18.51)];
	    [seedPath addCurveToPoint: CGPointMake(26.27, 20.61) controlPoint1: CGPointMake(25.8, 19.79) controlPoint2: CGPointMake(25.89, 20.44)];
	    [seedPath closePath];
	    [seedPath moveToPoint: CGPointMake(10.57, 22.59)];
	    [seedPath addCurveToPoint: CGPointMake(11.84, 23.32) controlPoint1: CGPointMake(10.58, 23) controlPoint2: CGPointMake(11.15, 23.33)];
	    [seedPath addCurveToPoint: CGPointMake(13.09, 22.54) controlPoint1: CGPointMake(12.54, 23.31) controlPoint2: CGPointMake(13.1, 22.96)];
	    [seedPath addCurveToPoint: CGPointMake(11.82, 21.81) controlPoint1: CGPointMake(13.09, 22.12) controlPoint2: CGPointMake(12.52, 21.79)];
	    [seedPath addCurveToPoint: CGPointMake(10.57, 22.59) controlPoint1: CGPointMake(11.12, 21.82) controlPoint2: CGPointMake(10.56, 22.17)];
	    [seedPath closePath];
	    seedPath.miterLimit = 4;

	    seedPath.usesEvenOddFillRule = YES;

	    [seedColor setFill];
	    [seedPath fill];


	    //// innerSeed Drawing
	    UIBezierPath* innerSeedPath = [UIBezierPath bezierPath];
	    [innerSeedPath moveToPoint: CGPointMake(25.51, 31.71)];
	    [innerSeedPath addCurveToPoint: CGPointMake(22.73, 35.86) controlPoint1: CGPointMake(24.86, 34.24) controlPoint2: CGPointMake(23.86, 35.86)];
	    [innerSeedPath addCurveToPoint: CGPointMake(19.95, 31.71) controlPoint1: CGPointMake(21.6, 35.86) controlPoint2: CGPointMake(20.59, 34.24)];
	    [innerSeedPath addCurveToPoint: CGPointMake(15.05, 32.68) controlPoint1: CGPointMake(17.7, 33.04) controlPoint2: CGPointMake(15.85, 33.48)];
	    [innerSeedPath addCurveToPoint: CGPointMake(16.02, 27.78) controlPoint1: CGPointMake(14.25, 31.88) controlPoint2: CGPointMake(14.69, 30.02)];
	    [innerSeedPath addCurveToPoint: CGPointMake(11.87, 25) controlPoint1: CGPointMake(13.49, 27.13) controlPoint2: CGPointMake(11.87, 26.13)];
	    [innerSeedPath addCurveToPoint: CGPointMake(16.02, 22.22) controlPoint1: CGPointMake(11.87, 23.87) controlPoint2: CGPointMake(13.49, 22.87)];
	    [innerSeedPath addCurveToPoint: CGPointMake(15.05, 17.32) controlPoint1: CGPointMake(14.69, 19.98) controlPoint2: CGPointMake(14.25, 18.12)];
	    [innerSeedPath addCurveToPoint: CGPointMake(19.95, 18.29) controlPoint1: CGPointMake(15.85, 16.52) controlPoint2: CGPointMake(17.7, 16.96)];
	    [innerSeedPath addCurveToPoint: CGPointMake(22.73, 14.14) controlPoint1: CGPointMake(20.59, 15.76) controlPoint2: CGPointMake(21.6, 14.14)];
	    [innerSeedPath addCurveToPoint: CGPointMake(25.51, 18.29) controlPoint1: CGPointMake(23.86, 14.14) controlPoint2: CGPointMake(24.86, 15.76)];
	    [innerSeedPath addCurveToPoint: CGPointMake(30.41, 17.32) controlPoint1: CGPointMake(27.75, 16.96) controlPoint2: CGPointMake(29.61, 16.52)];
	    [innerSeedPath addCurveToPoint: CGPointMake(29.44, 22.22) controlPoint1: CGPointMake(31.2, 18.12) controlPoint2: CGPointMake(30.77, 19.98)];
	    [innerSeedPath addCurveToPoint: CGPointMake(33.59, 25) controlPoint1: CGPointMake(31.96, 22.87) controlPoint2: CGPointMake(33.59, 23.87)];
	    [innerSeedPath addCurveToPoint: CGPointMake(29.44, 27.78) controlPoint1: CGPointMake(33.59, 26.13) controlPoint2: CGPointMake(31.96, 27.13)];
	    [innerSeedPath addCurveToPoint: CGPointMake(30.41, 32.68) controlPoint1: CGPointMake(30.77, 30.02) controlPoint2: CGPointMake(31.2, 31.88)];
	    [innerSeedPath addCurveToPoint: CGPointMake(25.51, 31.71) controlPoint1: CGPointMake(29.61, 33.48) controlPoint2: CGPointMake(27.75, 33.04)];
	    [innerSeedPath closePath];
	    innerSeedPath.miterLimit = 4;

	    innerSeedPath.usesEvenOddFillRule = YES;

	    [innerSeedColor setFill];
	    [innerSeedPath fill];


	    //// kiwiCore Drawing
	    UIBezierPath* kiwiCorePath = [UIBezierPath bezierPath];
	    [kiwiCorePath moveToPoint: CGPointMake(22.47, 29.29)];
	    [kiwiCorePath addCurveToPoint: CGPointMake(26.77, 25) controlPoint1: CGPointMake(24.85, 29.29) controlPoint2: CGPointMake(26.77, 27.37)];
	    [kiwiCorePath addCurveToPoint: CGPointMake(22.47, 20.71) controlPoint1: CGPointMake(26.77, 22.63) controlPoint2: CGPointMake(24.85, 20.71)];
	    [kiwiCorePath addCurveToPoint: CGPointMake(18.18, 25) controlPoint1: CGPointMake(20.1, 20.71) controlPoint2: CGPointMake(18.18, 22.63)];
	    [kiwiCorePath addCurveToPoint: CGPointMake(22.47, 29.29) controlPoint1: CGPointMake(18.18, 27.37) controlPoint2: CGPointMake(20.1, 29.29)];
	    [kiwiCorePath closePath];
	    kiwiCorePath.miterLimit = 4;

	    kiwiCorePath.usesEvenOddFillRule = YES;

	    CGContextSaveGState(context);
	    [kiwiCorePath addClip];
	    CGContextDrawRadialGradient(context, radialGradient3,
	        CGPointMake(22.47, 25), 0,
	        CGPointMake(22.47, 25), 9.52,
	        kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	    CGContextRestoreGState(context);


	    CGContextEndTransparencyLayer(context);
	    CGContextRestoreGState(context);
	}

	//// Cleanup
	CGGradientRelease(radialGradient3);
	CGColorSpaceRelease(colorSpace);
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
// vim:ft=objc
