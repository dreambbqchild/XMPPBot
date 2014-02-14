//
//  Bot.h
//  AnagramBot
//
//  Created by Paige Rudnick on 2/9/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//
// This protocol defines the basic needs of a bot.


#import <Foundation/Foundation.h>


@protocol Bot
// reports the name of the switch that this bot is responsible for.
-(NSString*) respondsToSwitch;

// Passes |content| (if any) to the bot for processing.
-(NSArray*) processRequestWithContent:(NSString*) content;

@optional
// Designates a bot as fully automated and is to respond to all
// incoming requests with no need for a switch.
-(BOOL) respondToAll;
@end
