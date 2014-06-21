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
    
    func testReturnTileRow(){
        
        for row in 1...9{
            var actual = tilemanager.tilesInRow(row);
            NSLog("Row\(row): Returned with \(actual.count) tiles.");
            for column in 1...9{
                var tile = tilemanager.tileAtIndexPath(TileIndexPath(row: row, column: column));
                NSLog("Row\(row): Comparing tileID \(tile!.ID)");
                XCTAssertEqual(actual[column-1].ID, tile!.ID, "", file: "", line: 0);
                NSLog("Sub Passed");
            }
        }
    }
    
    func testReturnTileColumn(){
        for column in 1...9{
            var actual = tilemanager.tilesInColumn(column);
            NSLog("Column\(column): Returned with \(actual.count) tiles.");
            for row in 1...9{
                var tile = tilemanager.tileAtIndexPath(TileIndexPath(row: row, column: column));
                NSLog("Column\(column): Comparing tileID \(tile!.ID)");
                XCTAssertEqual(actual[row-1].ID, tile!.ID, "", file: "", line: 0);
                NSLog("Sub Passed");
            }
        }
    }
    
    func testStructPerformance(){
        
        var tile = tilemanager.tilesAtIndexes(NSIndexSet(index: 0))[0];
        tile.ID = 99;
        XCTAssertNotEqual(tile.ID, tilemanager.tiles[0].ID, "", file: "", line: 0);
        tilemanager.tiles[0].ID = 99;
        XCTAssertEqual(tile.ID, tilemanager.tiles[0].ID, "", file: "", line: 0);
    }
    
}
