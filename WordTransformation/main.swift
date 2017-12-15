//
//  main.swift
//  WordTransformation
//
//  Created by Aaron Thompson on 12/14/17.
//  Copyright © 2017 Aaron Thompson. All rights reserved.
//

/*
 Given two five letter words, A and B, and a dictionary of five letter words, find a shortest transformation from A to B, such that only one letter can be changed at a time and all intermediate words in the transformation must exist in the dictionary.
 
 For example, if A and B are "smart" and "brain", the result may be:
 smart
 start
 stark
 stack
 slack
 black
 blank
 bland
 brand
 braid
 brain
 
 Your implementation should take advantage of multiple CPU cores. Please also include test cases against your algorithm.
 */

import Foundation

let fixedWordLength = 3
let wordList = ["cat", "bat", "cog", "log", "dog", "qzy", "cot", "bog", "bag", "dag", "lag"]
print("Loaded list of \(fixedWordLength)-letter words that was \(wordList.count) words long")

let transformer = WordTransformer(wordList: wordList, fixedWordLength: fixedWordLength)
let startingWord = "cat"
let endingWord = "log"
let distance = transformer.findShortestTransformationPath(fromWord: startingWord, into: endingWord)
print("Transformation distance was \(distance)")
