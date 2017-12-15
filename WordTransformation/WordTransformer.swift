//
//  WordTransformer.swift
//  WordTransformation
//
//  Created by Aaron Thompson on 12/14/17.
//  Copyright © 2017 Aaron Thompson. All rights reserved.
//

import Foundation

class WordTransformer {
    
    private let _wordList: [String]
    private let _fixedWordLength: Int
    
    init(wordList: [String], fixedWordLength: Int) {
        _wordList = wordList
        _fixedWordLength = fixedWordLength
    }
    
    func findShortestTransformationPath(fromWord word: String, into otherWord: String) -> [String] {
        assert(word.count == _fixedWordLength && otherWord.count == _fixedWordLength, "Only words of length \(_fixedWordLength) are supported in this implementation")
        
        return []
    }
    
}
