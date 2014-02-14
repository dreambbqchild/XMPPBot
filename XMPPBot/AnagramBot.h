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
// Initalizes the Bot with an Anagram XML file.
-(id)initWithFile:(NSString*) file;

// Looks up an anagram for the word supplied.
-(NSString*) getAnagramForWord:(NSString*) word;
@end
