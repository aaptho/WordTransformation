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
    
    func testSameWord() {
        let wordLength = 3
        let wordList = WordListLoader.loadWordlist(filteredByLength: wordLength)
        
        let transformer = WordTransformer(wordList: wordList, fixedWordLength: wordLength)
        let distance = transformer.findShortestTransformationPath(fromWord: "cat", into: "cat")
        print("Distance was \(distance)")
        XCTAssertEqual(distance, 0)
    }
    
    func testTransformationNotFound() {
        let wordLength = 3
        let wordList = WordListLoader.loadWordlist(filteredByLength: wordLength)
        
        let transformer = WordTransformer(wordList: wordList, fixedWordLength: wordLength)
        let distance = transformer.findShortestTransformationPath(fromWord: "cat", into: "zyx")
        print("Distance was \(distance)")
        XCTAssertEqual(distance, -1)
    }
    
    func testValidTransformation() {
        let wordLength = 3
        let wordList = WordListLoader.loadWordlist(filteredByLength: wordLength)
        
        let transformer = WordTransformer(wordList: wordList, fixedWordLength: wordLength)
        let distance = transformer.findShortestTransformationPath(fromWord: "cat", into: "dog")
        print("Distance was \(distance)")
        XCTAssertEqual(distance, 3)
    }
    
    func testMultithreadedTransformation() {
        let wordLength = 5
        let wordList = WordListLoader.loadWordlist(filteredByLength: wordLength)
        
        let transformer = WordTransformer(wordList: wordList, fixedWordLength: wordLength, threadCount: 4)
        let distance = transformer.findShortestTransformationPath(fromWord: "smart", into: "brain")
        print("Distance was \(distance)")
        XCTAssertEqual(distance, 5)
    }
    
    func testWordListLoader() {
        let wordLength = 7
        let wordList = WordListLoader.loadWordlist(filteredByLength: wordLength)
        
        XCTAssertFalse(wordList.isEmpty)
        wordList.forEach { XCTAssert($0.count == wordLength) }
    }
    
}
