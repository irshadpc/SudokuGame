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
    let tilemanager = MDLTileManager();
    var currentlySelectedTile = TileIndexPath(row: 0, column: 0);
    
    
    let positions = [TileIndexPath(row: 1, column: 1), TileIndexPath(row: 1, column: 4),
        TileIndexPath(row: 1, column: 6), TileIndexPath(row: 1, column: 7),
        TileIndexPath(row: 1, column: 9), TileIndexPath(row: 2, column: 2),
        TileIndexPath(row: 2, column: 5), TileIndexPath(row: 2, column: 8),
        TileIndexPath(row: 3, column: 1), TileIndexPath(row: 3, column: 3),
        TileIndexPath(row: 3, column: 6), TileIndexPath(row: 3, column: 7),
        TileIndexPath(row: 4, column: 1), TileIndexPath(row: 4, column: 3),
        TileIndexPath(row: 4, column: 4), TileIndexPath(row: 4, column: 6),
        TileIndexPath(row: 4, column: 9), TileIndexPath(row: 5, column: 2),
        TileIndexPath(row: 5, column: 8), TileIndexPath(row: 6, column: 1),
        TileIndexPath(row: 6, column: 4), TileIndexPath(row: 6, column: 6),
        TileIndexPath(row: 6, column: 7), TileIndexPath(row: 6, column: 9),
        TileIndexPath(row: 7, column: 3), TileIndexPath(row: 7, column: 4),
        TileIndexPath(row: 7, column: 7), TileIndexPath(row: 7, column: 9),
        TileIndexPath(row: 8, column: 2), TileIndexPath(row: 8, column: 5),
        TileIndexPath(row: 8, column: 8), TileIndexPath(row: 9, column: 1),
        TileIndexPath(row: 9, column: 3), TileIndexPath(row: 9, column: 4),
        TileIndexPath(row: 9, column: 6), TileIndexPath(row: 9, column: 9)]
    let givens = [6,1,8,2,3,2,4,9,8,3,5,4,5,4,6,7,9,3,5,7,8,3,1,2,1,7,9,6,8,3,2,3,2,9,4,5];
    
    init(){
        SudokuSolver.generatePuzzle(tilemanager, withGivens: givens, atPositions: positions);
    }
    
    func advanceSolver(){
        SudokuSolver.checkforPossibles(tilemanager);
        SudokuSolver.checkforSolvedTiles(tilemanager);
    }
    
    func GameStarted(){
        
    }
    
    func sudokuboardView(gameboard:UISudokuboardView, userTapped_sudokutileAtIndexPath path:TileIndexPath, inout onChange needsUpdate:Array<TileIndexPath>) -> Bool{
        needsUpdate.append(path);
        if(currentlySelectedTile == path){
            currentlySelectedTile = NotSelected;
        } else {
            if(currentlySelectedTile != NotSelected) { needsUpdate.append(currentlySelectedTile); }
            currentlySelectedTile = path;
        }
        return true;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView, userInput_sudokutileAtIndexPath path:TileIndexPath, withValue value:Int){
        tilemanager.tiles[path.toIndex()].currentValue = value;
        if(SudokuSequence.isWinningSequence(tilemanager.tilesAtIndexPaths(TileIndexPath.indexPathesOfRow(path.row)))){
            gameboard.highlightIndexPathes(TileIndexPath.indexPathesOfRow(path.row));
        }
        if(SudokuSequence.isWinningSequence(tilemanager.tilesAtIndexPaths(TileIndexPath.indexPathesOfBox(1)))){
            gameboard.highlightIndexPathes(TileIndexPath.indexPathesOfBox(1));
        }
    }
    
    
    func sudokuboardView(gameboard:UISudokuboardView, currentValue_forSudokutileWithIndexPath path:TileIndexPath) -> Int{
        return tilemanager.tiles[path.toIndex()].currentValue;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView, selectionState_forSudokutileWithIndexPath path:TileIndexPath) -> TileState{
        return (currentlySelectedTile == path) ? TileState.Selected : TileState.None;
    }
    func sudokuboardView(gameboard:UISudokuboardView, solutionPossibles_forSudokutileWithIndexPath path:TileIndexPath) -> Int[]{
        return tilemanager.tiles[path.toIndex()].possibleValues
    }
}