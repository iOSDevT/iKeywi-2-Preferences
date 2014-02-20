#import "iKeywi2.h"
#import "iKeywiCustomKeysListController.mm"

@interface CapitalDisplaymentListController : iKeywiCustomKeysListController {}
- (NSArray *)specifiers;
@end

@implementation CapitalDisplaymentListController
- (NSArray *)specifiers
{
	if (_specifiers == nil)
	{
        NSMutableArray *specifiers = [NSMutableArray array];

        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];
        for (int i = 1; i <= 10; ++i)
        {
        	PSSpecifier *customKey = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString([[NSString alloc] initWithFormat:@"Key %d",i]) target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        	[customKey setIdentifier:[[NSString alloc] initWithFormat:@"%d",i]];
        	[specifiers addObject:customKey];
        }

        PSSpecifier *footerGroup = [PSSpecifier emptyGroupSpecifier];
        [footerGroup setProperty:iKeywiLocalizedString(@"KEYS_ONLY_AVAILABLE_FOR_SOME_LANG") forKey:@"footerText"];
        [specifiers addObject:footerGroup];

        PSSpecifier *key11 = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"Key 11") target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        [key11 setIdentifier:@"11"];
        [specifiers addObject:key11];

        PSSpecifier *key12 = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"Key 12") target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        [key12 setIdentifier:@"12"];
        [specifiers addObject:key12];

       	[_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
	return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = NO;
    endKey = @"12";
    [titleLabel setText:iKeywiLocalizedString(@"CAPITAL_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
	NSString* customKey = [[NSString alloc] initWithFormat:@"capitalDisplay%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
	NSString* customKey = [[NSString alloc] initWithFormat:@"capitalDisplay%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomDisplay(customKey,value);
}
@end
//========================================================================================================================
@interface SmallDisplaymentListController : iKeywiCustomKeysListController {}
- (NSArray *)specifiers;
@end

@implementation SmallDisplaymentListController
- (NSArray *)specifiers
{
    if (_specifiers == nil)
    {
        NSMutableArray *specifiers = [NSMutableArray array];

        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];
        for (int i = 1; i <= 10; ++i)
        {
            PSSpecifier *customKey = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString([[NSString alloc] initWithFormat:@"Key %d",i]) target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
            [customKey setIdentifier:[[NSString alloc] initWithFormat:@"%d",i]];
            [specifiers addObject:customKey];
        }

        PSSpecifier *footerGroup = [PSSpecifier emptyGroupSpecifier];
        [footerGroup setProperty:iKeywiLocalizedString(@"KEYS_ONLY_AVAILABLE_FOR_SOME_LANG") forKey:@"footerText"];
        [specifiers addObject:footerGroup];

        PSSpecifier *key11 = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"Key 11") target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        [key11 setIdentifier:@"11"];
        [specifiers addObject:key11];

        PSSpecifier *key12 = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString(@"Key 12") target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
        [key12 setIdentifier:@"12"];
        [specifiers addObject:key12];

        [_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
    return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = NO;
    endKey = @"12";
    [titleLabel setText:iKeywiLocalizedString(@"SMALL_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"smallDisplay%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"smallDisplay%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomDisplay(customKey,value);
}
@end
//========================================================================================================================
@interface NumberDisplaymentListController : iKeywiCustomKeysListController {}
- (NSArray *)specifiers;
@end

@implementation NumberDisplaymentListController
- (NSArray *)specifiers
{
    if (_specifiers == nil)
    {
        NSMutableArray *specifiers = [NSMutableArray array];

        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];

        for (int i = 1; i <= 10; ++i)
        {
            PSSpecifier *customKey = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString([[NSString alloc] initWithFormat:@"Key %d",i]) target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
            [customKey setIdentifier:[[NSString alloc] initWithFormat:@"%d",i]];
            [specifiers addObject:customKey];
        }
        [_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
    return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = NO;
    endKey = @"10";
    [titleLabel setText:iKeywiLocalizedString(@"NUMBER_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberDisplay%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberDisplay%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomDisplay(customKey,value);
}
@end
//========================================================================================================================
@interface NumberAltDisplaymentListController : iKeywiCustomKeysListController {}
- (NSArray *)specifiers;
@end

@implementation NumberAltDisplaymentListController
- (NSArray *)specifiers
{
    if (_specifiers == nil)
    {
        NSMutableArray *specifiers = [NSMutableArray array];

        [specifiers addObject:[PSSpecifier emptyGroupSpecifier]];

        for (int i = 1; i <= 10; ++i)
        {
            PSSpecifier *customKey = [PSSpecifier preferenceSpecifierNamed:iKeywiLocalizedString([[NSString alloc] initWithFormat:@"Key %d",i]) target:self set:@selector(setValue:forSpecifier:) get:@selector(getValueForSpecifier:) detail:Nil cell:[PSTableCell cellTypeFromString:@"PSEditTextCell"] edit:Nil];
            [customKey setIdentifier:[[NSString alloc] initWithFormat:@"%d",i]];
            [specifiers addObject:customKey];
        }
        [_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
    return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = NO;
    endKey = @"10";
    [titleLabel setText:iKeywiLocalizedString(@"NUMBER_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberAltDisplay%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberAltDisplay%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomDisplay(customKey,value);
}
@end