//
//  Declarations.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

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
    var position: TileIndexPath
}

protocol UISudokuboardViewDelegate{
    func sudokuboardView(gameboard:UISudokuboardView!, userTapped_sudokutileAtIndex index:TileIndexPath, inout onChange needsUpdate:Array<TileIndexPath>) -> Bool
    func sudokuboardView(gameboard:UISudokuboardView!, userInput_sudokutileAtIndex index:TileIndexPath, withValue value:Int);
}

protocol UISudokuboardViewDatasource{
    func sudokuboardView(gameboard:UISudokuboardView!, currentValue_sudokutileWithIndex index:TileIndexPath) -> Int?
    func sudokuboardView(gameboard:UISudokuboardView!, selectionState_forsudokutileWithIndex index:TileIndexPath) -> TileState
}