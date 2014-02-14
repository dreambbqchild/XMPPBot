//
//  BotFactory.m
//  AnagramBot
//
//  Created by Paige Rudnick on 2/9/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import "BotFactory.h"

@interface BotFactory()
{
    NSMutableDictionary* _bots;
    NSRegularExpression* _regex;
    id<Bot> _respondToAll;
}
@end

@implementation BotFactory

-(id) init{
    self =[super init];
    if(self)
    {
        _bots = [[NSMutableDictionary alloc] init];
        // This regex is responsible for parsing the input string into the switch
        // (where switches are the first thing on the line and start with a forward slash /
        // and then the value the bot has for respondsToSwitch), and the content that follows.
        _regex = [NSRegularExpression regularExpressionWithPattern:@"/([\\w|\\?]+)\\s?(.*)" options:NSRegularExpressionCaseInsensitive error:nil];
        _respondToAll = nil;
        
        [self registerBot:self];
    }
    
    return self;
}

-(void) registerBot:(NSObject<Bot>*)bot{
    if([bot respondsToSelector:@selector(respondToAll)] && [bot respondToAll])
        _respondToAll = bot;
    else
        [_bots setObject:bot forKey:[bot respondsToSwitch]];
}

-(NSArray*) processWithBot:(NSString *)body {
    if(_respondToAll)
        return [_respondToAll processRequestWithContent:body];
    
    NSTextCheckingResult *m = [_regex firstMatchInString:body options:0 range:NSMakeRange(0, [body length])];
    if(!m)
        return nil;
    
    NSString* key = [body substringWithRange:[m rangeAtIndex:1]];
    NSLog(@"Key: %@", key);
    id<Bot> bot = [_bots objectForKey:key];
    if(!bot)
        return nil;
    
    NSString* input = nil;
    if([m numberOfRanges] > 2)
        input = [body substringWithRange:[m rangeAtIndex:2]];
    
    return [bot processRequestWithContent:input];
}

-(NSString*) respondsToSwitch {
    return @"?";
}

-(NSArray*) processRequestWithContent:(NSString*) content{
    NSMutableArray* commands = [[NSMutableArray alloc] init];
    
    for(NSString* key in [_bots keyEnumerator])
    {
        NSArray* command = @[@"/", key];
        [commands addObject:[command componentsJoinedByString:@""]];
    }
    
    return @[[commands componentsJoinedByString:@" | "]];
}

@end
