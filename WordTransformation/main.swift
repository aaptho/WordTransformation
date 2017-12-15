//
//  main.swift
//  WordTransformation
//
//  Created by Aaron Thompson on 12/14/17.
//  Copyright © 2017 Aaron Thompson. All rights reserved.
//

import Foundation

let transformer = WordTransformer(wordList: [], fixedWordLength: 0)
let startingWord = ""
let endingWord = ""
let path = transformer.findShortestTransformationPath(fromWord: startingWord, into: endingWord)
print("Found path \(path) between \(startingWord) and \(endingWord)")
