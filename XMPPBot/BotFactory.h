//
//  BotFactory.h
//  AnagramBot
//
//  Created by Paige Rudnick on 2/9/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../include/Bot.h"

@interface BotFactory : NSObject<Bot>
// Registers a bot with the factory for use.
-(void)registerBot:(NSObject<Bot>*) bot;

// Passes a string to the factory for bot lookup and processing.
// Returns nil if the |body| didn't trigger a bot to process.
-(NSArray*) processWithBot:(NSString*)body;
@end
