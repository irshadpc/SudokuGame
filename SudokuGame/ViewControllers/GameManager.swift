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
    let solver:SudokuSolver;
    var currentlySelectedTile = TileIndexPath(row: 0, column: 0);
    
    
    let positions = [TileIndexPath(row: 2, column: 3), TileIndexPath(row: 2, column: 4),
        TileIndexPath(row: 2, column: 7), TileIndexPath(row: 3, column: 1), TileIndexPath(row: 3, column: 2),
        TileIndexPath(row: 3, column: 4), TileIndexPath(row: 3, column: 5), TileIndexPath(row: 3, column: 8),
        TileIndexPath(row: 4, column: 1), TileIndexPath(row: 4, column: 4), TileIndexPath(row: 4, column: 8),
        TileIndexPath(row: 4, column: 9), TileIndexPath(row: 5, column: 3), TileIndexPath(row: 5, column: 7),
        TileIndexPath(row: 6, column: 1), TileIndexPath(row: 6, column: 2), TileIndexPath(row: 6, column: 6),
        TileIndexPath(row: 6, column: 9), TileIndexPath(row: 7, column: 2), TileIndexPath(row: 7, column: 5),
        TileIndexPath(row: 7, column: 6), TileIndexPath(row: 7, column: 8), TileIndexPath(row: 7, column: 9),
        TileIndexPath(row: 8, column: 3), TileIndexPath(row: 8, column: 6), TileIndexPath(row: 8, column: 7)];
    let givens = [1,9,5,5,6,3,1,9,1,6,2,8,4,7,2,7,4,3,4,6,8,3,5,2,5,9];
    
    init(){
        solver = SudokuSolver(manager: tilemanager);
        solver.generatePuzzle(givens, atPositions: positions);
    }
    
    func advanceSolver(){
        if(solver.checkforPossibles()) { NSLog("Possibles found"); }
        else { NSLog("No possibles found");
            if(solver.checkforSolvedTiles()) { NSLog("Solved tiles found"); }
            else { NSLog("No solved tiles founds");
                if(solver.checkForHiddenSingles()){ NSLog("Hidden singles found"); }
                else{ NSLog("No hidden singles found");
                    if(solver.checkforNakedPairs()) { NSLog("Naked pairs have been found and applied"); }
                    else { NSLog("No naked tiles found"); }
                }
            }
        }
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