//
//  WordListLoader.swift
//  WordTransformation
//
//  Created by Aaron Thompson on 12/14/17.
//  Copyright © 2017 Aaron Thompson. All rights reserved.
//

import Foundation

class WordListLoader {
    
    class func loadWordlist(filteredByLength wordLength: Int) -> [String] {
    var wordList: [String] = []
        
        let dictionaryPath = "/usr/share/dict/words"
        let dictionaryString = try! String(contentsOfFile: dictionaryPath, encoding: String.Encoding.ascii)
        
        dictionaryString.enumerateLines { (word: String, stop: inout Bool) in
            if word.count == wordLength {
                wordList.append(word.lowercased())
            }
        }
        
        return wordList
    }
    
}
