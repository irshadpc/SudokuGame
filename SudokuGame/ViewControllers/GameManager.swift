//
//  GameManager.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/17/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

class GameManager: UISudokuboardViewDelegate, UISudokuboardViewDatasource{
    let NotSelected = TileIndexPath(row: 0, column: 0);
    var currentlySelectedTile = TileIndexPath(row: 0, column: 0);
    var tilemanager = MDLTileManager();
    
    init(){
        
    }
    
    func GameStarted(){
        
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, userTapped_sudokutileAtIndex index:TileIndexPath, inout onChange needsUpdate:Array<TileIndexPath>) -> Bool{
        needsUpdate.append(index);
        if(currentlySelectedTile == index){
            currentlySelectedTile = NotSelected;
        } else {
            if(currentlySelectedTile != NotSelected) { needsUpdate.append(currentlySelectedTile); }
            currentlySelectedTile = index;
        }
        return true;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, userInput_sudokutileAtIndex index:TileIndexPath, withValue value:Int){
        tilemanager.setValue(value, ofTileAtIndexPath: index);
    }
    
    
    func sudokuboardView(gameboard:UISudokuboardView!, currentValue_sudokutileWithIndex index:TileIndexPath) -> Int?{
        return tilemanager.tileAtIndexPath(index)?.currentValue;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, selectionState_forsudokutileWithIndex index:TileIndexPath) -> TileState{
        return (currentlySelectedTile == index) ? TileState.Selected : TileState.None;
    }
    
}