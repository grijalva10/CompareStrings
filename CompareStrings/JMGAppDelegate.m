//
//  JMGAppDelegate.m
//  CompareStrings
//
//  Created by Jeff on 2/25/13.
//  Copyright (c) 2013 codeSlider. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "JMGAppDelegate.h"
#import "JMGCountedSetAdditions.h"
#import "TFHpple.h"
#import "Product.h"
#import "TFHppleElement.h"

@implementation JMGAppDelegate 

@synthesize inputBox;
@synthesize inputBoxTwo;
@synthesize arrayController;
@synthesize outputBox;
@synthesize optionSegment;
@synthesize URLTextField;
@synthesize XMLTextField;

@end

@interface JMGAppDelegate (){
    NSMutableArray *_objects;
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    

    NSDictionary *menuDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Show Duplicates",@"name",@"S",@"value",
                             @"Remove Duplicates",@"name",@"R",@"value",
                             @"Combine Both Boxes",@"name",@"C",@"value", nil];
    NSLog(@"%@",arrayController);
   
    menuItems = [menuDic allValues];
   [arrayController setContent:menuItems];
    NSLog(@"%@",arrayController);


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
    
        //1
    NSString *websiteString = [URLTextField stringValue];
    NSURL *websiteLink = [NSURL URLWithString:websiteString];
    NSString *XMLValue = [XMLTextField stringValue];
    NSData *htmlData = [NSData dataWithContentsOfURL:websiteLink];
    
        //2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    
        //3
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:XMLValue];
    
        //4
      NSMutableArray *newData = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in htmlNodes) {
            //5
        Product *productTitle = [[Product alloc] init];
        
            //6
        productTitle.title = [element content];
    }
    
    for (TFHppleElement *element in htmlNodes){
        
        Product *productURL = [[Product alloc] init];
        
        productURL.url = [element content];
        
    }
    
    for (TFHppleElement *element in htmlNodes){
        
        Product *productStyle = [[Product alloc] init];
            //7
        productStyle.style = [element content];
    }
    
        for (TFHppleElement *element in htmlNodes){
            
            Product *productImg = [[Product alloc] init];
        
            productImg.Img = [element content];
        

        }
    
    
   }

@end
