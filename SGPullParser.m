//
//  SGPullParser.m
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


#import "SGPullParser.h"

const char *IANAEncodingCStringFromNSStringEncoding(NSStringEncoding encoding)
{
	CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
	CFStringRef ianaCharacterSetName = CFStringConvertEncodingToIANACharSetName(cfEncoding);
	return [(__bridge NSString*)ianaCharacterSetName UTF8String];
}

@interface NSString (libxml2Support)
+ (id)stringWithXmlChar:(xmlChar *)xc;
+ (id)stringWithConstXmlChar:(const xmlChar *)xc;
- (xmlChar *)xmlChar;
@end

@implementation NSString (libxml2Support)

+ (id)stringWithXmlChar:(xmlChar *)xc {
    return xc != NULL ? [NSString stringWithUTF8String:(char *)xc] : nil;
}

+ (id)stringWithConstXmlChar:(const xmlChar *)xc {
    return xc != NULL ? [NSString stringWithUTF8String:(const char *)xc] : nil;
}

- (xmlChar *)xmlChar {
    return (xmlChar *)[self UTF8String];
}

@end


@implementation SGPullParser {
    xmlTextReaderPtr _reader;
    NSStringEncoding _encoding;
}

+ (id)parserWithData:(NSData *)data {
    return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (id)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding {
    if (self = [super init]) {
        _encoding = encoding;

        const char* url = NULL;
        _reader = xmlReaderForMemory((const char*)data.bytes, data.length, url,
                                    IANAEncodingCStringFromNSStringEncoding(encoding), kSGXMLParseOptions);
        if (_reader == NULL) {
            DLog(@"Error opening xml stuff");
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    xmlFreeTextReader(_reader);
}

#pragma mark -
#pragma mark Properties

- (NSInteger)attributeCount {
    return xmlTextReaderAttributeCount(_reader);
}


- (NSString *)baseURI {
    return [NSString stringWithXmlChar:xmlTextReaderBaseUri(_reader)];
}


//- (BOOL)canResolveEntity {
//      return YES;
//}


- (NSInteger)depth {
    return xmlTextReaderDepth(_reader);
}


- (BOOL)isEOF {
    return [self readState] == XML_TEXTREADER_MODE_EOF;
}


- (BOOL)hasAttributes {
    return xmlTextReaderHasAttributes(_reader);
}


- (BOOL)hasValue {
    return xmlTextReaderHasValue(_reader);
}


- (BOOL)isDefault {
    return xmlTextReaderIsDefault(_reader);
}


- (BOOL)isEmptyElement {
    return xmlTextReaderIsEmptyElement(_reader);
}


- (NSString *)localName {
    return [NSString stringWithConstXmlChar:xmlTextReaderConstLocalName(_reader)];
}

- (NSString *)name {
    return [NSString stringWithConstXmlChar:xmlTextReaderConstName(_reader)];
}


- (NSString *)namespaceURI {
    return [NSString stringWithConstXmlChar:xmlTextReaderConstNamespaceUri(_reader)];
}

- (xmlReaderTypes)nodeType {
    return xmlTextReaderNodeType(_reader);
}

- (NSString *)prefix {
    return [NSString stringWithConstXmlChar:xmlTextReaderConstPrefix(_reader)];
}

- (char)quoteChar {
    return xmlTextReaderQuoteChar(_reader);
}

- (xmlTextReaderMode)readState {
    return xmlTextReaderReadState(_reader);
}

- (NSString *)value {
    return [NSString stringWithConstXmlChar:xmlTextReaderConstValue(_reader)];
}

- (NSString *)XMLLang {
    return [NSString stringWithConstXmlChar:xmlTextReaderConstXmlLang(_reader)];
}

#pragma mark -
#pragma mark Methods

- (void)close {
    xmlTextReaderClose(_reader);
}

- (NSString *)attributeAtIndex:(NSInteger)index {
    return [NSString stringWithXmlChar:xmlTextReaderGetAttributeNo(_reader, index)];
}

- (NSString *)attributeWithQName:(NSString *)qName {
    return [NSString stringWithXmlChar:xmlTextReaderGetAttribute(_reader, [qName xmlChar])];
}

- (NSString *)attributeWithQNameC:(const char *)qName {
    return [NSString stringWithXmlChar:xmlTextReaderGetAttribute(_reader, (xmlChar *)qName)];
}

- (NSString *)attributeWithLocalName:(NSString *)localName namespaceURI:(NSString *)nsURI {
    return [NSString stringWithXmlChar:xmlTextReaderGetAttributeNs(_reader, [localName xmlChar], [nsURI xmlChar])];
}

- (NSString *)attributeWithLocalNameC:(const char *)localName namespaceURIC:(const char  *)nsURI {
    return [NSString stringWithXmlChar:xmlTextReaderGetAttributeNs(_reader, (xmlChar *)localName, (xmlChar *)nsURI)];
}

+ (BOOL)isName:(NSString *)str {
    return YES;
}

+ (BOOL)isNameToken:(NSString *)str {
    return YES;
}

- (NSString *)lookupNamespace:(NSString *)prefix {
    return [NSString stringWithXmlChar:xmlTextReaderLookupNamespace(_reader, [prefix xmlChar])];
}

- (NSString *)lookupNamespaceC:(const char *)prefix {
    return [NSString stringWithXmlChar:xmlTextReaderLookupNamespace(_reader, (xmlChar *)prefix)];
}

- (void)moveToAttributeAtIndex:(NSInteger)index {
    xmlTextReaderMoveToAttributeNo(_reader, index);
}

- (BOOL)moveToAttributeWithQName:(NSString *)qName {
    return xmlTextReaderMoveToAttribute(_reader, [qName xmlChar]);
}

- (BOOL)moveToAttributeWithQNameC:(const char *)qName {
    return xmlTextReaderMoveToAttribute(_reader, (xmlChar *)qName);
}

- (BOOL)moveToAttributeWithLocalName:(NSString *)localName namespaceURI:(NSString *)nsURI {
    return xmlTextReaderMoveToAttributeNs(_reader, [localName xmlChar], [nsURI xmlChar]);
}

- (BOOL)moveToAttributeWithLocalNameC:(const char *)localName namespaceURIC:(const char *)nsURI {
    return xmlTextReaderMoveToAttributeNs(_reader, (xmlChar *)localName, (xmlChar *)nsURI);
}

- (BOOL)moveToElement {
    return xmlTextReaderMoveToElement(_reader);
}

- (BOOL)moveToFirstAttribute {
    return xmlTextReaderMoveToFirstAttribute(_reader);
}

- (BOOL)moveToNextAttribute {
    return xmlTextReaderMoveToNextAttribute(_reader);
}

- (BOOL)read {
    return xmlTextReaderRead(_reader);
}

- (BOOL)readElement {
    int ret;
    while ((ret = [self read]) && [self nodeType] != XML_READER_TYPE_ELEMENT);

    return ret;
}

- (BOOL)readElementUntil:(NSString *)qname {
    return [self readElementUntilC:qname.UTF8String];
}

- (BOOL)readElementUntilC:(const char *)qname {
    int ret;
    while ((ret = [self read])) {
        int t = [self nodeType];
        if (t == XML_READER_TYPE_ELEMENT)
            return YES;
        else if (t == XML_READER_TYPE_END_ELEMENT && [self elementHasQNameC:qname])
            return NO;
    }

    return ret;
}

- (BOOL)readAttributeValue {
    return xmlTextReaderReadAttributeValue(_reader);
}

- (NSString *)readElementString {
    return [NSString stringWithXmlChar:xmlTextReaderReadString(_reader)];
}

- (NSString *)readInnerXML {
    return [NSString stringWithXmlChar:xmlTextReaderReadInnerXml(_reader)];
}

- (NSString *)readOuterXML {
    return [NSString stringWithXmlChar:xmlTextReaderReadOuterXml(_reader)];
}

- (NSString *)readString {
    return [NSString stringWithXmlChar:xmlTextReaderReadString(_reader)];
}

- (BOOL)skip {
    return xmlTextReaderNextSibling(_reader);//xmlTextReaderNext
}

// Compares the qualified name
- (BOOL)elementHasQName:(NSString *)name {
    return xmlStrEqual(xmlTextReaderConstName(_reader), name.xmlChar);
}

- (BOOL)elementHasQNameC:(const char*)name {
    return xmlStrEqual(xmlTextReaderConstName(_reader), (xmlChar *)name);
}

- (BOOL)elementHasName:(NSString *)name {
    return xmlStrEqual(xmlTextReaderConstLocalName(_reader), name.xmlChar);
}

- (BOOL)elementHasNameC:(const char*)name {
    return xmlStrEqual(xmlTextReaderConstLocalName(_reader), (xmlChar *)name);
}

@end
