//
//  FortuneBot.h
//  AnagramBot
//
//  Created by Paige Rudnick on 2/9/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../include/Bot.h"

@interface FortuneBot : NSObject<Bot>
// Initalizes a Fortune Bot with an array of UNIX Fortune files
// to use as its database.
-(id)initWithFortuneFiles:(NSArray*)paths;
@end
