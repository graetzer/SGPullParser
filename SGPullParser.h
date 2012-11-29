//
//  SGPullParser.h
//
//  Created by Simon Grätzer on 13.11.12.
//  Copyright (c) 2012 Simon Grätzer.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>
#include <libxml/xmlreader.h>

static const int kSGXMLParseOptions = (XML_PARSE_NOCDATA | XML_PARSE_NOBLANKS);
const char *IANAEncodingCStringFromNSStringEncoding(NSStringEncoding encoding);

@interface SGPullParser : NSObject
+ (id)parserWithData:(NSData *)data;
- (id)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding;


// Gets the number of attributes on the current node.
@property (nonatomic, readonly) NSInteger attributeCount;

// Gets the base Uniform Resource Identifier (URI) of the current node.
@property (nonatomic, readonly, copy) NSString *baseURI;

// Gets a value indicating whether this reader can parse and resolve entities.
//@property (nonatomic, readonly) BOOL canResolveEntity;

// Gets the depth of the current node in the XML document.
@property (nonatomic, readonly) NSInteger depth;

// Gets a value indicating whether the XMLPullParser.ReadState is ReadState.EndOfFile, signifying the reader is positioned at the end of the stream.
@property (nonatomic, readonly) BOOL isEOF;

// Gets a value indicating whether the current node has any attributes.
@property (nonatomic, readonly) BOOL hasAttributes;

// Gets a value indicating whether the current node can have an associated text value.
@property (nonatomic, readonly) BOOL hasValue;

// Gets a value indicating whether the current node is an attribute that was generated from the default value defined in the DTD or schema.
@property (nonatomic, readonly) BOOL isDefault;

// Gets a value indicating whether the current node is an empty element (for example, <MyElement />).
@property (nonatomic, readonly) BOOL isEmptyElement;

// Gets the local name of the current node.
@property (nonatomic, readonly, copy) NSString *localName;

// Gets the qualified name of the current node.
@property (nonatomic, readonly, copy) NSString *name;

// Gets the namespace URI associated with the node on which the reader is positioned.
@property (nonatomic, readonly, copy) NSString *namespaceURI;

// Gets the name table used by the current instance to store and look up element and attribute names, prefixes, and namespaces.
//- (XmlNameTable)NameTable;

// Gets the type of the current node.
@property (nonatomic, readonly) xmlReaderTypes nodeType;

// Gets the namespace prefix associated with the current node.
@property (nonatomic, readonly, copy) NSString *prefix;

// Gets the quotation mark character used to enclose the value of an attribute.
@property (nonatomic, readonly) char quoteChar;

// Gets the read state of the reader.
@property (nonatomic, readonly) xmlTextReaderMode readState;

// Gets the text value of the current node.
@property (nonatomic, readonly, copy) NSString *value;

// Gets the current xml:lang scope.
@property (nonatomic, readonly, copy) NSString *XMLLang;

// Gets the current xml:space scope.
//- (XMLSpace)XMLSpace;

// Changes the XMLPullParser.ReadState to XMLPullParserReadState.Closed.
- (void)close;

// Returns the value of the attribute with the specified index relative to the containing element.
- (NSString *)attributeAtIndex:(NSInteger)index;

// Returns the value of the attribute with the specified qualified name.
- (NSString *)attributeWithQName:(NSString *)qName;

// Returns the value of the attribute with the specified qualified name.
- (NSString *)attributeWithQNameC:(const char*)qName;

// Returns the value of the attribute with the specified local name and namespace URI.
- (NSString *)attributeWithLocalName:(NSString *)localName namespaceURI:(NSString *)nsURI;

// Returns the value of the attribute with the specified local name and namespace URI.
- (NSString *)attributeWithLocalNameC:(const char *)localName namespaceURIC:(const char  *)nsURI;

// Determines whether the specified string is a valid XML name.
+ (BOOL)isName:(NSString *)str;

// Determines whether the specified string is a valid XML name token (Nmtoken).
+ (BOOL)isNameToken:(NSString *)str;

// Resolves a namespace prefix in the scope of the current element.
- (NSString *)lookupNamespace:(NSString *)prefix;

// Resolves a namespace prefix in the scope of the current element.
- (NSString *)lookupNamespaceC:(const char *)prefix;

// Moves the position of the current instance to the attribute with the specified index relative to the containing element.
- (void)moveToAttributeAtIndex:(NSInteger)index;

// Moves the position of the current instance to the attribute with the specified qualified name.
- (BOOL)moveToAttributeWithQName:(NSString *)qName;

// Moves the position of the current instance to the attribute with the specified qualified name.
- (BOOL)moveToAttributeWithQNameC:(const char*)qName;

// Moves the position of the current instance to the attribute with the specified local name and namespace URI.
- (BOOL)moveToAttributeWithLocalName:(NSString *)localName namespaceURI:(NSString *)nsURI;

// Moves the position of the current instance to the attribute with the specified local name and namespace URI.
- (BOOL)moveToAttributeWithLocalNameC:(const char *)localName namespaceURIC:(const char *)nsURI;

// Moves the position of the current instance to the node that contains the current Attribute node.
- (BOOL)moveToElement;

// Moves the position of the current instance to the first attribute associated with the current node.
- (BOOL)moveToFirstAttribute;

// Moves the position of the current instance to the next attribute associated with the current node.
- (BOOL)moveToNextAttribute;

// Moves the position of the current instance to the next node in the stream, exposing its properties.
- (BOOL)read;

// Moves the position of the current instance to the next element node in the stream, exposing its properties.
// Skips every node wich is not an element
- (BOOL)readElement;

// Moves the position of the current instance to the next element node in the stream, exposing its properties.
// Skips every node wich is not an element. Returns NO if the end tag with the specified end tag is found
- (BOOL)readElementUntil:(NSString *)qname;

// Moves the position of the current instance to the next element node in the stream, exposing its properties.
// Skips every node wich is not an element. Returns NO if the end tag with the specified end tag is found
// Argument is of type const char* for memory efficency
- (BOOL)readElementUntilC:(const char*)qname;

// Parses an attribute value into one or more Text, EntityReference, and EndEntity nodes.
- (BOOL)readAttributeValue;

// Reads the contents of the current node, including child nodes and markup.
- (NSString *)readInnerXML;

// Reads the current node and its contents, including child nodes and markup.
- (NSString *)readOuterXML;

// Reads the contents of an element or text node as a string.
- (NSString *)readString;

// Skips over the current element and moves the position of the current instance to the next node in the stream.
- (BOOL)skip;

// Compares the qualified name
- (BOOL)elementHasQName:(NSString *)name;

// Compares the qualified name, takes const char for memory efficency
- (BOOL)elementHasQNameC:(const char*)name;

// Compares the local name
- (BOOL)elementHasName:(NSString *)name;

// Compares the local name, takes const char for memory efficency
- (BOOL)elementHasNameC:(const char*)name;

@end
