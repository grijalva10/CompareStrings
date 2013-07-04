//
//  JMGAppDelegate.m
//  CompareStrings
//
//  Created by Jeff on 2/25/13.
//  Copyright (c) 2013 codeSlider. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "JMGAppDelegate.h"
#import "TFHpple.h"
#import "Product.h"
#import "URLSearcher.h"

@interface JMGAppDelegate () {
    NSMutableArray *_objects;
    NSMutableArray *pageContent;
}
@end

@implementation JMGAppDelegate 

@synthesize inputBox;
@synthesize inputBoxTwo;
@synthesize arrayController;
@synthesize outputBox;
@synthesize optionSegment;
@synthesize URLTextField;
@synthesize XMLTextField;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    

    NSDictionary *menuDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Show Duplicates",@"name",@"S",@"value",
                             @"Remove Duplicates",@"name",@"R",@"value",
                             @"Combine Both Boxes",@"name",@"C",@"value", nil];
    NSLog(@"%@",arrayController);
   
    menuItems = [menuDic allValues];
   [arrayController setContent:menuItems];
    
  
    
        //NSLog(@"%@",arrayController);
        // [self start];

}






- (IBAction)goButton:(NSButton *)sender {
    
        //Getting NSTextField inputs
    
    NSString *inputBoxValue = [inputBox stringValue];
    NSString *inputBoxValueTwo = [inputBoxTwo stringValue];
    inputBoxValueTwo =[inputBoxTwo stringValue];
    
        //creating arrays
        //...
    NSArray *arrayOne = [inputBoxValue componentsSeparatedByString:@" " ];
    NSArray *arrayTwo = [inputBoxValueTwo componentsSeparatedByString:@" " ];
    NSArray *arrayResults;
    
        //creating MutableSets
    
    NSMutableSet *set1 = [NSMutableSet setWithArray:arrayOne];
    NSSet *set2 = [NSSet setWithArray:arrayTwo];
    
        //creating options w/ segmentedControl
    
    NSInteger segment = optionSegment.selectedSegment;
    
    if (segment == 0){
        [set1 intersectSet:set2];   //Show Duplicates
   NSLog(@"Option 0 Pressed");
    }
    else if (segment == 1){
        [set1 minusSet:set2];      //Remove Duplicates
    NSLog(@"Option 1 Pressed");
    }
    else if (segment ==2){
        [set1 unionSet:set2];     //Combine Boxes
        NSLog(@"Option 2 Pressed");
    }
    
        //Display Results according to options
        
    arrayResults = [set1 allObjects];
    NSString * finalString = [arrayResults componentsJoinedByString:@" "];
    [outputBox setStringValue:[NSString stringWithFormat:@"%@",finalString]];
    NSLog(@"Objects that intersect: %@",finalString);
    

    }

- (IBAction)parseButton:(NSButton *)sender {
    
    
        //NSMutableArray *products = [[NSMutableArray init]alloc];
        //1
    NSString *websiteString = [URLTextField stringValue];
    NSURL *websiteLink = [NSURL URLWithString:websiteString];
    
    
    NSString *productName = @"//*[@id='pdpMain']/div[1]/div[1]/div[1]/div[1]/h1";
    NSString *price = @"//*[@id='pdpATCDivpdpMain']/div[2]/div/div[1]";
    NSString *style = @"//*[@id='pdpTab1']/p[2]/b";
    NSString *image = @"//*[@id='pdpMain']/div[1]/div[2]/div[2]/img";
    
    NSData *htmlData = [NSData dataWithContentsOfURL:websiteLink];
    
        //2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
        //3
    NSArray *nameNode = [htmlParser searchWithXPathQuery:productName];
    NSArray *priceNode = [htmlParser searchWithXPathQuery:price];
    NSArray *styleNode = [htmlParser searchWithXPathQuery:style];
    NSArray *imageNode = [htmlParser searchWithXPathQuery:image];
    
        //4
        //NSMutableArray *newData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in nameNode) {
            //5
       
        NSString *name = [element text];
        
        NSLog(@"%@",name);
       
    }
    
    for (TFHppleElement *element in priceNode){
        
        NSString *price = [[[[element text]componentsSeparatedByCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]]componentsJoinedByString:@""]stringByReplacingOccurrencesOfString:@"$" withString:@""];
    
        NSLog(@"%@",price);
        
    }
    
    for (TFHppleElement *element in styleNode){
        
        NSString *style = [[[[element text]componentsSeparatedByCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]]componentsJoinedByString:@""]stringByReplacingOccurrencesOfString:@"Style(s):" withString:@""];
        
        NSLog(@"%@",style);
        
    }
    
        for (TFHppleElement *element in imageNode){
        
            NSString *image = [element objectForKey:@"src"];
            NSLog(@"%@",image);
        

        }
    
        //_objects = newData;
    
    
   }

- (IBAction)getLinks:(NSButton *)sender
{
    
    NSString *danPost = @"http://www.bootbarn.com/null/root,default,sc.html?prefn1=brand&prefv1=Dan%20Post&start=0&sz=60";
    NSString *laredo = @"http://www.bootbarn.com/null/root,default,sc.html?prefn1=brand&prefv1=Laredo&sz";
    NSString *johnDeere = @"http://www.bootbarn.com/null/root,default,sc.html?prefn1=brand&prefv1=John%20Deere&start=0&sz=60";
    NSString *durango = @"http://www.bootbarn.com/null/root,default,sc.html?prefn1=brand&prefv1=Durango&start=0&sz=60";
    NSArray *brandLinks = [NSArray arrayWithObjects:danPost,laredo,johnDeere,durango,nil];
    NSString *URL = @"//*[@class='productlisting']";
    

    NSURL *websiteLink = [NSURL URLWithString:danPost];
    NSData *htmlData = [NSData dataWithContentsOfURL:websiteLink];
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    NSArray *URLNode = [htmlParser searchWithXPathQuery:URL];

    for (TFHppleElement *element in URLNode) {
        
        NSArray *aURL = [element children];
        [pageContent addObjectsFromArray:aURL];
        NSLog(@"aURL: %@", aURL);
        
    }

}

- (IBAction)regExSettings:(id)sender {
    
    
    wc = [[JMGRegexViewWindowController alloc] initWithWindowNibName:@"JMGRegexViewWindowController"];
	assert(wc);
	assert(wc.window);
	[wc.window makeKeyAndOrderFront:self];
    
}
    
    
    
    
    
    


#pragma mark - Table View



#pragma mark - Save

    //
    //  Save the data to the desktop
    //

/* 
 
- (void) save{
    
    NSURL *url = [NSURL URLWithString:@"file:///Users/Moshe/Desktop/shuls2.txt"];
    
    NSError *error = nil;
    
    NSString * data = [[self shuls] componentsJoinedByString:@"\n"];
    
    if(![data writeToURL:url atomically:NO encoding:NSUTF16StringEncoding error:&error]){
        NSLog(@"Write failed. %@", error);
    }
 
    
}
*/

@end

