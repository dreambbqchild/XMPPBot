//
//  AnagramDictionary.m
//  AnagramBot
//
//  Created by Paige Rudnick on 2/8/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import "AnagramBot.h"
#import "NSString+SortExtension.h"

@interface AnagramBot()
{
    NSMutableDictionary* _anagrams;
    NSMutableArray* _currentArray;
    NSRegularExpression* _regex;
}
@end

@implementation AnagramBot
-(id)initWithFile:(NSString*) file
{
    self = [super init];
    if(self)
    {
        srand ((unsigned int)time(NULL));
        _anagrams = [[NSMutableDictionary alloc] init];
        _regex = [NSRegularExpression regularExpressionWithPattern:@"([\\w|']+)(\\S*)" options:NSRegularExpressionCaseInsensitive error:nil];
        NSData* data = [NSData dataWithContentsOfFile:file];
        NSXMLParser* parser = [[NSXMLParser alloc]initWithData:data];
        [parser setDelegate:self];
        if(![parser parse])
            return nil;
        
        _currentArray = nil;
        
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqual:@"key"])
    {
        _currentArray = [[NSMutableArray alloc]init];
        [_anagrams setObject:_currentArray forKey:[attributeDict objectForKey:@"is"]];
    }
    else if([elementName isEqual:@"for"])
    {
        [_currentArray addObject:[attributeDict objectForKey:@"word"]];
    }
}

-(NSString*) getAnagramForWord:(NSString*) word {
    
    NSTextCheckingResult *m = [_regex firstMatchInString:word options:0 range:NSMakeRange(0, [word length])];
    
    if(m)
    {
        NSString* wordOnly = [word substringWithRange:[m rangeAtIndex:1]];
         
        NSString* lowerCaseWord = [wordOnly lowercaseString];
        NSString* key = [lowerCaseWord sorted];
        NSMutableArray* result = [_anagrams objectForKey: key];
        if(result)
        {
            int index = rand() % [result count];
            NSString* found = [result objectAtIndex:index];
            if([found isEqual: lowerCaseWord])
                found = [result objectAtIndex:(index + 1) % [result count]];
            
            if([m numberOfRanges] > 2)
            {
                NSArray* components = @[found, [word substringWithRange: [m rangeAtIndex:2]]];
                found = [components componentsJoinedByString:@""];
            }
            
            return found;
        }
    }
    return word;
}

-(NSString*) respondsToSwitch{
    return @"anagram";
}

-(NSArray*) processRequestWithContent:(NSString*) content {
    NSArray* wordArray = [content componentsSeparatedByString:@" "];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    for(NSString* word in wordArray)
    {
        [results addObject:[self getAnagramForWord:word]];
    }
    
    return @[[results componentsJoinedByString:@" "]];
}

@end
