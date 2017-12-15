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
    
    init(wordList: [String], fixedWordLength: Int, threadCount: Int = 1) {
        _wordList = wordList
        _fixedWordLength = fixedWordLength
        
        let buildingStartTime = CFAbsoluteTimeGetCurrent()
        if threadCount <= 1 {
            _associatedWords = WordTransformer._buildAssociatedWordsDictionary(wordListToBuild: wordList, fullWordList: wordList)
        } else {
            _associatedWords = WordTransformer._multithreadedBuildAssociatedWordsDictionary(threadCount: threadCount, wordList: wordList)
        }
        let buildingEndTime = CFAbsoluteTimeGetCurrent()
        print("Built associated words dictionary in \(buildingEndTime - buildingStartTime) seconds")
    }
    
    func findShortestTransformationPath(fromWord word: String, into otherWord: String) -> Int {
        assert(word.count == _fixedWordLength && otherWord.count == _fixedWordLength, "Only words of length \(_fixedWordLength) are supported in this implementation")
        
        // We've already preprocessed the word list into a dictionary of associated words
        // That lets us do a breadth-first search through to find the right word
        let bfsStartTime = CFAbsoluteTimeGetCurrent()
        let length = _performBFS(start: word, end: otherWord)
        let bfsEndTime = CFAbsoluteTimeGetCurrent()
        print("Performed BFS in \(bfsEndTime - bfsStartTime) seconds")
        
        return length
    }
    
    private class func _multithreadedBuildAssociatedWordsDictionary(threadCount: Int, wordList: [String]) -> [String:Set<String>] {
        // Basically want to take a mapreduce approach here
        
        // Partition the word list
        let chunkSize = wordList.count / threadCount + 1
        let partitionedWordLists = wordList.chunked(by: chunkSize)
        
        // Dispatch a job for each partition
        var processedPartitions = [[String:Set<String>]]()
        let processedPartitionsLock = DispatchQueue(label: "Processed partitions lock")
        
        // Map in parallel
        // Use counting semaphores to wait for all the jobs to finish
        let semaphore = DispatchSemaphore(value: 0)
         
        for partition in partitionedWordLists {
            DispatchQueue.global().async {
                let processedPartition = _buildAssociatedWordsDictionary(wordListToBuild: partition, fullWordList: wordList)
                print("Finished processing \(partition.first ?? "nil") through \(partition.last ?? "nil")")
                processedPartitionsLock.sync {
                    processedPartitions.append(processedPartition)
                }
                semaphore.signal()
            }
        }
        
        for _ in 0 ..< threadCount {
            semaphore.wait()
        }
        
        // Reduce
        var result = [String:Set<String>]()
        
        for partition in processedPartitions {
            result.merge(partition) { (current, _) in current }
        }
        
        return result
    }
    
    private class func _buildAssociatedWordsDictionary(wordListToBuild: [String], fullWordList: [String]) -> [String:Set<String>] {
        var result: [String:Set<String>] = [:]
        
        for word in wordListToBuild {
            var matches = Set<String>()
            
            for otherWord in fullWordList {
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

// Credit: this Swift 4 array chunking algorithm was copied from
// https://stackoverflow.com/questions/26395766/swift-what-is-the-right-way-to-split-up-a-string-resulting-in-a-string-wi/38156873#38156873
extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, self.count)])
        }
    }
}
