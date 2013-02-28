//
//  JMGAppDelegate.h
//  CompareStrings
//
//  Created by Jeff on 2/25/13.
//  Copyright (c) 2013 codeSlider. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JMGAppDelegate : NSObject <NSApplicationDelegate> {
    NSArray *menuItems;
    NSString *menuItemSelected;
}
    

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *inputBox;
@property (weak) IBOutlet NSTextField *inputBoxTwo;
@property (strong) IBOutlet NSTextField *outputBox;
@property (strong) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSSegmentedControl *optionSegment;
@property (weak) IBOutlet NSTextField *URLTextField;
@property (weak) IBOutlet NSTextField *XMLTextField;

@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)goButton:(NSButton *)sender;
- (IBAction)parseButton:(NSButton *)sender;

@end
