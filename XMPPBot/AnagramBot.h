//
//  AnagramDictionary.h
//  AnagramBot
//
//  Created by Paige Rudnick on 2/8/14.
//  Copyright (c) 2014 Paige Rudnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../include/Bot.h"

@interface AnagramBot : NSObject <NSXMLParserDelegate, Bot>
-(id)initWithFile:(NSString*) file;
-(NSString*) getAnagramForWord:(NSString*) word;
@end
