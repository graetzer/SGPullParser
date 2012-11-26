SGPullParser
============

Objective-C wrapper for &lt;libxml/xmlreader.h>

### Usage
Include libxml2 in your project, [see here](http://cmar.me/2011/04/20/adding-libxml2-to-an-xcode-4-project/)

Short example XML:

	<data>
		<templates>
	    	<template id="abcd1" src="template1.pdf" />
	    	<template id="abcd2" src="template1.pdf" />
	    	<template id="abcd3" src="template1.pdf" />
	    	<template id="abcd4" src="template1.pdf" />
    	</templates>
    	
    	<category title="Hello World">
            <media name="Hello" src="Abc.pdf" />
            <media name="Hello2" src="Abc.pdf" />
        </category>
    </data>

Sample code to parse this

	#import "SGPullParser.h"
	
	NSMutableDictionary *_templates = [NSMutableDictionary dictionaryWithCapacity:5];
	NSMutableDictionary *_categories = [NSMutableDictionary dictionaryWithCapacity:5];
	NSData* data = ...
	
	SGPullParser *parser = [SGPullParser parserWithData:data];
    while ([parser readElement]) {
    
    	// Using C strings saves unnecessary copy operations
    	if ([parser elementHasNameC:"template"]) {
    	
    		// Of course you can use NSString objects as well
            NSString *identifier = [parser attributeWithQName:@"id"];
            NSString *src = [parser attributeWithQNameC:"src"];
            
            [_templates setObject:src forKey:identifier];
        } else if ([parser elementHasNameC:"category"]) {
            NSString *title = [parser attributeWithQNameC:"title"];
            NSMutableArray *links = [NSMutableArray arrayWithCapacity:10];
            
            // Run this loop until we reach the end of category 
            while ([parser readElementUntilC:"category"])
                if ([parser elementHasNameC:"media"]) {
                    NSDictionary *media = @{@"name" : [parser attributeWithQName:@"name"],
                    							@"src" : [parser attributeWithQName:@"src"]};
                    
                    [links addObject:media];
                }
            
            [_categories setObject:links forKey:title];
        }
     }




### License
Apache License, Version 2.0