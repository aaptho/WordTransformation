//
//  WordTransformationTests.swift
//  WordTransformationTests
//
//  Created by Aaron Thompson on 12/14/17.
//  Copyright © 2017 Aaron Thompson. All rights reserved.
//

import XCTest

class WordTransformationTests: XCTestCase {
    
    func testInvalidWordLengths() {
    }
    
    func testSameWordLength() {
    }
    
    func testTransformationNotFound() {
    }
    
    func testValidTransformation() {
    }
    
    func testWordListLoader() {
        let wordLength = 7
        let wordList = WordListLoader.loadWordlist(filteredByLength: 7)
        
        wordList.forEach {
            XCTAssert($0.count == wordLength)
        }
    }
    
}
