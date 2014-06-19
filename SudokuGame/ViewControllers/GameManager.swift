//
//  GameManager.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/17/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

class GameManager: UISudokuboardViewDelegate, UISudokuboardViewDatasource{
    let NotSelected = TileIndex(row: 0, column: 0);
    var currentlySelectedTile = TileIndex(row: 0, column: 0);
    var tilemanager = MDLTileManager();
    
    init(){
        
    }
    
    func GameStarted(){
        
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, userTapped_sudokutileAtIndex index:TileIndex, inout onChange needsUpdate:Array<TileIndex>) -> Bool{
        needsUpdate.append(index);
        if(currentlySelectedTile == index){
            currentlySelectedTile = NotSelected;
        } else {
            if(currentlySelectedTile != NotSelected) { needsUpdate.append(currentlySelectedTile); }
            currentlySelectedTile = index;
        }
        return true;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, userInput_sudokutileAtIndex index:TileIndex, withValue value:Int){
        tilemanager.setValue(value, ofTileWithIndex: index);
    }
    
    
    func sudokuboardView(gameboard:UISudokuboardView!, currentValue_sudokutileWithIndex index:TileIndex) -> Int{
        return tilemanager.valueforTileIndex(index);
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, selectionState_forsudokutileWithIndex index:TileIndex) -> TileState{
        return (currentlySelectedTile == index) ? TileState.Selected : TileState.None;
    }
    
}