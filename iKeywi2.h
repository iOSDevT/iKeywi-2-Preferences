#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>
#import <AVFoundation/AVAsset.h>

#define PreferenceBundlePath @"/Library/PreferenceBundles/iKeywi2.bundle"
#define UserDefaultsPlistPath @"/var/mobile/Library/Preferences/tw.hiraku.ikeywi2.plist"
#define UserDefaultsChangedNotification "tw.hiraku.ikeywi2.update"
#define iKeywi1Settings @"/var/mobile/Library/Preferences/com.hiraku.ikeywi.plist"
#define LocalizationsDirectoryPath @"/Library/PreferenceBundles/iKeywi2.bundle"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define iKeywiColor UIColorFromRGB(0xFAAB26)
#define _4inch  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0

#define kCFCoreFoundationVersionNumber_iOS_5_0 675.00
#define kCFCoreFoundationVersionNumber_iOS_6_0 793.00
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
//====================================================================================================================
@interface AVPlayerItem
+ (AVPlayerItem *)playerItemWithAsset:(AVAsset *)asset;
@end

@interface PSSpecifier (iKeywi)
- (void)setIdentifier:(NSString *)identifier;
@end

@interface PSListController (iKeywi)
- (void)loadView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface PSTableCell (iKeywi)
@property(readonly, assign, nonatomic) UILabel* textLabel;
@end

@interface iKeywiTineButtonCell : PSTableCell
@end

@implementation iKeywiTineButtonCell
- (void)layoutSubviews
{
	[super layoutSubviews];

	if ([self respondsToSelector:@selector(tintColor)])
		self.textLabel.textColor = iKeywiColor;
}
@end

NSString *iKeywiLocalizedString(NSString *string)
{
    return [[NSBundle bundleWithPath:PreferenceBundlePath] localizedStringForKey:string value:string table:nil];
}
//====================================================================================================================

id iKeywiPreferencesGetUserDefaultForKey(NSString *key)
{
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath];
    return [defaults objectForKey:key];
}

void iKeywiPreferencesSetUserDefaultForKey(NSString *key, id value)
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath]];
    [defaults setObject:value forKey:key];
    [defaults writeToFile:UserDefaultsPlistPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddRespringButton" object:nil];
}

void iKeywiPreferencesSetCustomKey(NSString *key, id value)
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath]];
    [defaults setObject:value forKey:key];

    NSString* displayKey = [key stringByReplacingOccurrencesOfString:@"Key" withString:@"Display"];
    if ([defaults objectForKey:displayKey] != nil)
	    [defaults removeObjectForKey:displayKey];
    [defaults writeToFile:UserDefaultsPlistPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddRespringButton" object:nil];
}

void iKeywiPreferencesSetCustomDisplay(NSString *key, id value)
{
    NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
    [defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:UserDefaultsPlistPath]];
    [defaults setObject:value forKey:key];
    [defaults writeToFile:UserDefaultsPlistPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddRespringButton" object:nil];
}