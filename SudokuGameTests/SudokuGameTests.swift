//
//  SudokuGameTests.swift
//  SudokuGameTests
//
//  Created by Alfred Cepeda on 6/13/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import XCTest
import SudokuGame

class SudokuGameTests: XCTestCase {
    var tilemanager = MDLTileManager();
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBoxToIndexPaths(){
        for box in 1...3{
            var boxpaths = TileIndexPath.indexPathesOfBox(box);
            for path in boxpaths{
                NSLog("\(path.row), \(path.column)");
            }
        }
    }
    
}
