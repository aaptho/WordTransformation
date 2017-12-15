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

let fixedWordLength = 5
let wordList = WordListLoader.loadWordlist(filteredByLength: fixedWordLength)
let transformer = WordTransformer(wordList: wordList, fixedWordLength: 0)
let startingWord = ""
let endingWord = ""
let path = transformer.findShortestTransformationPath(fromWord: startingWord, into: endingWord)

print("Found path \(path) between \(startingWord) and \(endingWord)")
