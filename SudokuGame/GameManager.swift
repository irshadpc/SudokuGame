//
//  GameManager.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/17/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

class GameManager: UISudokuboardViewDelegate, UISudokuboardViewDatasource{
    
    var currentlySelectedTile:TileIndex?
    var tilemanager = MDLTileManager();
    
    init(){
        
    }
    
    func GameStarted(){
        
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, shouldSelect_sudokutileWithIndex index:TileIndex) -> Bool{
        return true;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, didSelect_sudokutileWithIndex index:TileIndex){
        
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, shouldDeselect_sudokutileWithIndex index:TileIndex) -> Bool{
        return true;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, didDeleselect_sudokutileWithIndex index:TileIndex){
        
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, currentValue_sudokutileWithIndex index:TileIndex) -> Int{
        return 1;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView!, selectionState_forsudokutileWithIndex index:TileIndex) -> TileState{
        return (currentlySelectedTile == index) ? TileState.Selected : TileState.None;
    }
}