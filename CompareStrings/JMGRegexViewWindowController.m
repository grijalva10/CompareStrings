//
//  JMGRegexViewWindowController.m
//  CompareStrings
//
//  Created by Jeff on 7/2/13.
//  Copyright (c) 2013 codeSlider. All rights reserved.
//

#import "JMGRegexViewWindowController.h"
#import "URLSearcher.h"


@interface JMGRegexViewWindowController ()
@end

@implementation JMGRegexViewWindowController
{
    
    IBOutlet NSButton *scanButton;
	IBOutlet NSButton *verifyButton;
	IBOutlet NSButton *pasteButton;
	IBOutlet NSButton *interactiveButton;
    
	IBOutlet NSTextView *testString;
	IBOutlet NSTextView *resultsList;
    
	IBOutlet NSPopUpButton *scheme;
	IBOutlet NSPopUpButton *authority;
	IBOutlet NSButton *query;
	IBOutlet NSButton *fragment;
	
	IBOutlet NSButton *entryMode;
	IBOutlet NSButton *detectUnicode;
	IBOutlet NSButton *captureGroups;
    
	URLSearcher *es;
	
	NSString *oldInput;
	NSString *interInput;

}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    es = [URLSearcher new];
    
	[scheme selectItemAtIndex:1];
	[authority selectItemAtIndex:1];
	
	interInput = [[testString string] copy];
    

}
- (IBAction)testAction:(id)sender
{
        //NSLog(@"TESTER");
    
	NSString *str = [testString string];
	if(![str length]) {
		NSBeep();
		return;
	} else {
		[resultsList setString:@""];
        
		es = [URLSearcher urlSearcherWithRegexStr:[self createRegEx]];
		NSArray *a = [es findMatchesInString:str];
		NSMutableString *str = [NSMutableString stringWithCapacity:256];
		
		for(NSString *foo in a) {
			[str appendFormat:@"URL: %@\n", foo];
		}
		
		[resultsList setString:str];
	}
}

- (IBAction)testSelection:(id)sender
{
	NSString *str = [testString string];
	BOOL isUTF8 = NO;
	
	if(detectUnicode.state == NSOnState) {
		NSString *utStr = [es encodeUTF8:str];
		if(![str isEqualToString:utStr]) {
			str = utStr;
			isUTF8 = YES;
		}
	}
    
	es = [URLSearcher urlSearcherWithRegexStr:[self createRegEx]];
	if(es) {
		BOOL val = [es isValidURL:str];
		if(captureGroups.state == NSOnState) {
			if(val) {
				NSArray *array = [es captureGroups:str];
				if([array count] == 1) {
					[resultsList setString:[NSString stringWithFormat:@"%@%@%@%@", isUTF8 ? @"UTFized: " : @"", isUTF8 ? str : @"", isUTF8 ? @"\n" : @"", [array description]] ];
				} else {
					[resultsList setString:@"No"];
				}
			} else {
				[resultsList setString:@"No"];
			}
		} else {
			if(val) {
				[resultsList setString:[NSString stringWithFormat:@"YES%@%@%@", isUTF8 ? @": (UTFized=" : @"", isUTF8 ? str : @"", isUTF8 ? @")" : @""] ];
			} else {
				[resultsList setString:@"No"];
			}
		}
	} else {
		[resultsList setString:@"Regex failed!"];
	}
}




- (IBAction)pasteRegex:(id)sender
{
	NSString *str = [self createRegEx];
    
	if([sender tag] == 1) {
		str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0, [str length])];
		str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\"" options:0 range:NSMakeRange(0, [str length])];
		str = [NSString stringWithFormat:@"@\"%@\"", str];
	}
	[resultsList setString:str];
}

- (IBAction)interactiveMode:(NSButton *)button
{
	BOOL isOff = [button state] == NSOffState;
	scanButton.enabled = isOff;
	verifyButton.enabled = isOff;
	pasteButton.enabled = isOff;
    
#if 0
	scheme.enabled = isOff;
	authority.enabled = isOff;
	query.enabled = isOff;
	fragment.enabled = isOff;
	
	entryMode.enabled = isOff;
	detectUnicode.enabled = isOff;
	captureGroups.enabled = isOff;
#endif
    
	if(isOff) {
		interInput = [[testString string] copy];
		[testString setString:oldInput];
	} else {
		oldInput = [[testString string] copy];
		[testString setString:interInput];
	}
}

- (NSString *)createRegEx
{
	NSMutableString *regEx = [NSMutableString stringWithCapacity:512];
    
	NSString *fileName;
	NSString *part;
    
	switch([scheme indexOfSelectedItem]) {
        case 0:
            fileName = @"AllSchemes";
            break;
        case 1:
            fileName = @"HTTPScheme";
            break;
        case 2:
            fileName = @"HTTPS+FTPScheme";
            break;
        default:
            return nil;
	}
	part = [self processFile:fileName];
	[regEx appendString:part];
    
	[regEx appendString:@":"];
    
	fileName = [authority indexOfSelectedItem] == 0 ? @"AllAuthority" : @"SlashSlashAuthPathABEmpty";
	part = [self processFile:fileName];
	[regEx appendString:part];
    
	if([query state] == NSOnState) {
		part = [self processFile:@"Query"];
		[regEx appendString:part];
	}
    
	if([fragment state] == NSOnState) {
		part = [self processFile:@"Fragment"];
		[regEx appendString:part];
	}
        //NSLog(@"REGEX: %@", regEx);
	return regEx;
}

- (NSString *)processFile:(NSString *)name
{
        //NSLog(@"PROCESS %@", name);
	NSString *file = [[NSBundle mainBundle] pathForResource:name ofType:@"txt"];
	assert(file);
	
	__autoreleasing NSError *error;
	NSString *origStr = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    
	NSMutableString *str = [NSMutableString stringWithCapacity:[origStr length]];
	NSArray *array = [origStr componentsSeparatedByString:@"\n"];
	[array enumerateObjectsUsingBlock:^(NSString *sub, NSUInteger idx, BOOL *stop)
     {
     if(![sub length]) return;
     if([sub characterAtIndex:0] == '#') return;
     if([sub characterAtIndex:0] == '.') { *stop = YES; return; }
     
     NSArray *line = [sub componentsSeparatedByString:@" #"];
     NSString *first = line[0];
     first = [first stringByReplacingOccurrencesOfString:@" " withString:@""];
     if([first length]) {
             //first = [first stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         first = [first stringByReplacingOccurrencesOfString:@"☯" withString:([detectUnicode state] == NSOnState) ? @"|[\\u0080-\\U0010ffff]" : @""];
         first = [first stringByReplacingOccurrencesOfString:@"✪" withString:([entryMode state] == NSOnState) ? @"+" : @"*"];
         first = [first stringByReplacingOccurrencesOfString:@"⌽" withString:([captureGroups state] == NSOnState) ? @"" : @"?:"];
         [str appendString:first];
     }
     } ];
        // NSLog(@"REGEX file=%@: %@", name, str);
	return str;
}

- (BOOL)textView:(NSTextView *)aTextView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString
{
	if(interactiveButton.state == NSOnState) {
		dispatch_async(dispatch_get_main_queue(), ^
                       {
                       [self testSelection:nil];
                       } );
	}
    
	return YES;
}


@end
