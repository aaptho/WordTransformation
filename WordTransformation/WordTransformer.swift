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
    private let _associatedWords: [String:Set<String>]
    
    init(wordList: [String], fixedWordLength: Int) {
        _wordList = wordList
        _fixedWordLength = fixedWordLength
        _associatedWords = WordTransformer._buildAssociatedWordsDictionary(wordList: wordList)
    }
    
    func findShortestTransformationPath(fromWord word: String, into otherWord: String) -> Int {
        assert(word.count == _fixedWordLength && otherWord.count == _fixedWordLength, "Only words of length \(_fixedWordLength) are supported in this implementation")
        
        // We've already preprocessed the word list into a dictionary of associated words
        // That lets us do a breadth-first search through to find the right word
        let length = _performBFS(start: word, end: otherWord)
        
        return length
    }
    
    private class func _buildAssociatedWordsDictionary(wordList: [String]) -> [String:Set<String>] {
        var result: [String:Set<String>] = [:]
        
        for word in wordList {
            var matches = Set<String>()
            
            for otherWord in wordList {
                if word.differsByOneLetterFrom(otherWord) {
                    matches.insert(otherWord)
                }
            }
            
            result[word] = matches
        }
        
        return result
    }
    
    private func _performBFS(start: String, end: String) -> Int {
        guard start != end else {
            return 0
        }
        
        // Maintain a queue of the next nodes to try
        var queue = Array<String>()
        queue.append(start)
        
        // Maintain a set of words we've already visited
        var visitedWords = Set<String>()
        visitedWords.insert(start)
        
        var depth = 1
        
        while !queue.isEmpty {
            // Create a local copy of the queue so that we're only going level by level
            let queueCopy = queue
            for word in queueCopy {
                queue.removeFirst()
                
                let candidates = _associatedWords[word] ?? Set<String>()
                
                for candidate in candidates {
                    if candidate == end {
                        return depth
                    }
                    
                    if !visitedWords.contains(candidate) && !queue.contains(candidate) {
                        queue.append(candidate)
                    }
                }
                
                visitedWords.insert(word)
            }
            
            depth += 1
        }
        
        // We weren't able to make a transformation into this word by any path
        return -1
    }
    
}

extension String {
    
    func differsByOneLetterFrom(_ otherString: String) -> Bool {
        let selfUTF8 = self.utf8CString
        let otherUTF8 = otherString.utf8CString
        
        guard selfUTF8.count == otherUTF8.count else {
            return false
        }
        
        var differenceCount = 0
        
        for i in 0 ..< selfUTF8.count {
            if selfUTF8[i] != otherUTF8[i] {
                differenceCount += 1
            }
            
            // Just as an optimization
            if differenceCount > 1 {
                break
            }
        }
        
        return differenceCount == 1
    }
    
}
