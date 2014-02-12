//
//  Bot.h
//  AnagramBot
//
//  Created by Paige Rudnick on 2/9/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Bot
-(NSString*) respondsToSwitch;
-(NSArray*) processRequestWithContent:(NSString*) content;
-(BOOL) respondToAll;
@end
