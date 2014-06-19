//
//  Declarations.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

struct TileIndex{
    var row: Int
    var column: Int
    
    func toID() -> Int{
        return TileIndex.IDFromRow(row, andColumn: column);
    }
    
    static func IDFromRow(row: Int, andColumn column:Int) -> Int{
        return ((row-1) * 9) + column - 1;
    }
    
    static func indexFromInt(value:Int) -> TileIndex{
        return TileIndex(row: Int((value/9)+1), column: (value%9)+1);
    }
    
}

@infix func == (left: TileIndex?, right: TileIndex?) -> Bool {
    if(!left? || !right?){ return false; }
    
    return (left!.row == right!.row) && (left!.column == right!.column);
}

@infix func != (left: TileIndex?, right: TileIndex?) -> Bool {
    return !(left == right)
}

enum TileState: Int{
    case None
    case Selected
    case Highlighted
    case Correct
    case Wrong
}

struct SudokuTile{
    var selectedState: TileState
    var currentValue: Int
    var imageName: String?
    var position: TileIndex
}

protocol UISudokuboardViewDelegate{
    func sudokuboardView(gameboard:UISudokuboardView!, userTapped_sudokutileAtIndex index:TileIndex, inout onChange needsUpdate:Array<TileIndex>) -> Bool
    func sudokuboardView(gameboard:UISudokuboardView!, userInput_sudokutileAtIndex index:TileIndex, withValue value:Int);
}

protocol UISudokuboardViewDatasource{
    func sudokuboardView(gameboard:UISudokuboardView!, currentValue_sudokutileWithIndex index:TileIndex) -> Int
    func sudokuboardView(gameboard:UISudokuboardView!, selectionState_forsudokutileWithIndex index:TileIndex) -> TileState
}