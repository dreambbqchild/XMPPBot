//
//  Bot.h
//  AnagramBot
//
//  Created by Paige Rudnick on 2/8/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BotFactory.h"

@interface XMPP : NSObject
-(BOOL)connectWithJID:(NSString*) jid andPassword:(NSString*)password toURL:(NSString*) url;
-(BotFactory*)botFactory;
@end
