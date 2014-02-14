//
//  FortuneBot.m
//  AnagramBot
//
//  Created by Paige Rudnick on 2/9/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import "FortuneBot.h"

@interface FortuneBot()
{
    NSMutableArray* _fortunes;
}
-(void)readInFile:(NSString*)path;
@end

@implementation FortuneBot
-(id)initWithFortuneFiles:(NSArray*)paths{
    self = [super init];
    if(self)
    {
        srand ((unsigned int)time(NULL));
        _fortunes = [[NSMutableArray alloc] init];
        
        for(NSString* path in paths)
            [self readInFile:path];
    }
    
    return self;
}

-(void)readInFile:(NSString*)path{
    NSString* rawData = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	rawData = [rawData stringByReplacingOccurrencesOfString:@"\b" withString:@" "];
	
    for(NSString* line in [rawData componentsSeparatedByString:@"%\n"])
        [_fortunes addObject:line];
}

-(NSString*) respondsToSwitch {
    return @"fortune";
}

-(NSArray*) processRequestWithContent:(NSString*) content{
    return [[_fortunes objectAtIndex:rand() % [_fortunes count]] componentsSeparatedByString:@"\n"];
}
@end
