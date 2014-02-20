#import "iKeywi2.h"
#import "iKeywiCustomKeysListController.mm"

@interface CapitalRepresentationListController : iKeywiCustomKeysListController 
- (NSArray *)specifiers;
@end

@implementation CapitalRepresentationListController

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

        PSSpecifier *specialKeysGroup = [PSSpecifier emptyGroupSpecifier];
        [specialKeysGroup setProperty:iKeywiLocalizedString(@"SPECIAL_KEYS_DESCRIPTION") forKey:@"footerText"];
        [specifiers addObject:specialKeysGroup];

       	[_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
	return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = YES;
    endKey = @"12";
    [titleLabel setText:iKeywiLocalizedString(@"CAPITAL_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"capitalKey%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
	NSString* customKey = [[NSString alloc] initWithFormat:@"capitalKey%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomKey(customKey,value);
}
@end
//========================================================================================================================
@interface SmallRepresentationListController : iKeywiCustomKeysListController
- (NSArray *)specifiers;
@end

@implementation SmallRepresentationListController
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

        PSSpecifier *specialKeysGroup = [PSSpecifier emptyGroupSpecifier];
        [specialKeysGroup setProperty:iKeywiLocalizedString(@"SPECIAL_KEYS_DESCRIPTION") forKey:@"footerText"];
        [specifiers addObject:specialKeysGroup];

        [_specifiers release];
        _specifiers = nil;
        _specifiers = [[NSArray alloc]initWithArray:specifiers];
        
    }
    [self setTitle:@""];
    return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = YES;
    endKey = @"12";
    [titleLabel setText:iKeywiLocalizedString(@"SMALL_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"smallKey%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"smallKey%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomKey(customKey,value);
}
@end
//========================================================================================================================
@interface NumberRepresentationListController : iKeywiCustomKeysListController
- (NSArray *)specifiers;
@end

@implementation NumberRepresentationListController
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
    [self setTitle:@""];
    return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = YES;
    endKey = @"10";
    [titleLabel setText:iKeywiLocalizedString(@"NUMBER_KEYPAD")];
}

// - (BOOL)textFieldShouldReturn:(UITextField *)textField
// {
//     [textField resignFirstResponder];

//     return YES;
// }

// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
// {
//     UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//     BOOL isLastCell = NO;
//     for (UIView* view in [cell.contentView subviews])
//     {
//         if ([view isKindOfClass:[UILabel class]])
//         {
//             UILabel *label = (UILabel *)view;
//             [label.text hasSuffix:endKey] ? isLastCell = YES : isLastCell = NO;
//         }

//         if ([view isKindOfClass:[UITextField class]])
//         {
//             UITextField *textField = (UITextField *)view;
//             if (isLastCell)
//             {
//                 textField.delegate = self;
//                 [textField addTarget:self action:@selector(setValue:forSpecifier2:) forControlEvents:UIControlEventEditingChanged];
//                 textField.returnKeyType = UIReturnKeyDone;
//             }
//             else
//                 textField.returnKeyType = UIReturnKeyNext;
//         }
//     }
//     return cell;
// }

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberKey%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberKey%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomKey(customKey,value);
}
@end
//========================================================================================================================
@interface NumberAltRepresentationListController : iKeywiCustomKeysListController
- (NSArray *)specifiers;
@end

@implementation NumberAltRepresentationListController
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
    [self setTitle:@""];
    return _specifiers;
}

- (void)loadView
{
    [super loadView];
    isRepresentationLabel = YES;
    endKey = @"10";
    [titleLabel setText:iKeywiLocalizedString(@"NUMBER_ALT_KEYPAD")];
}

- (id)getValueForSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberAltKey%d",[specifier.identifier intValue]-1];
    return iKeywiPreferencesGetUserDefaultForKey(customKey);
}

- (void)setValue:(id)value forSpecifier:(PSSpecifier *)specifier
{
    NSString* customKey = [[NSString alloc] initWithFormat:@"numberAltKey%d",[specifier.identifier intValue]-1];
    iKeywiPreferencesSetCustomKey(customKey,value);
}
@end