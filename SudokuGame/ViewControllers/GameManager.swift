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
    var solver:SudokuSolver;
    var currentlySelectedTile = TileIndexPath(row: 0, column: 0);
    
    
    let positions = [TileIndexPath(row: 1, column: 1), TileIndexPath(row: 1, column: 5), TileIndexPath(row: 2, column: 4),
                        TileIndexPath(row: 2, column: 6), TileIndexPath(row: 2, column: 8), TileIndexPath(row: 3, column: 2),
                        TileIndexPath(row: 3, column: 6), TileIndexPath(row: 3, column: 9), TileIndexPath(row: 4, column: 5),
                        TileIndexPath(row: 4, column: 8), TileIndexPath(row: 4, column: 9), TileIndexPath(row: 5, column: 3),
                        TileIndexPath(row: 5, column: 5), TileIndexPath(row: 5, column: 7), TileIndexPath(row: 6, column: 1),
                        TileIndexPath(row: 6, column: 2), TileIndexPath(row: 6, column: 5), TileIndexPath(row: 7, column: 1),
                        TileIndexPath(row: 7, column: 4), TileIndexPath(row: 7, column: 8), TileIndexPath(row: 8, column: 2),
                        TileIndexPath(row: 8, column: 4), TileIndexPath(row: 8, column: 6), TileIndexPath(row: 9, column: 5),
                        TileIndexPath(row: 9, column: 9)];
    let givens = [4,1,3,9,4,7,5,9,6,2,1,4,7,6,1,9,5,9,4,7,3,6,8,3,6];
    
    init(){
        solver = SudokuSolver();
        solver.generatePuzzle(givens, atPositions: positions, withTileManager: tilemanager);
    }
    
    func advanceSolver(){
        for unitType in 0...2{
            for unit in 1...9{
                NSLog("\(UnitType.fromRaw(unitType)!): \(unit)");
                var action = 0;
                var changeMade = false;
                while(!changeMade){
                    if let solverAction = SolverActionApply.fromRaw(action){
                        let locationsToTraverse = TileIndexPath.indexPathsOfUnit(unit, ofUnitType: UnitType.fromRaw(unitType)!);
                        solver.tiles = tilemanager.tilesAtIndexPaths(locationsToTraverse);
                        let result = solver.performAction(solverAction);
                        changeMade = result.1
                        if(changeMade){
                            tilemanager.setValue(result.0, atIndexPaths: locationsToTraverse);
                        }
                    } else {
                        //NSLog("No changes made to \(UnitType.fromRaw(unitType)!): \(unit)");
                        break;
                    }
                    action++;
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
        tilemanager.tiles[path.row-1][path.column-1].currentValue = value;
        if(SudokuSequence.isWinningSequence(tilemanager.tilesAtIndexPaths(TileIndexPath.indexPathesOfRow(path.row)))){
            gameboard.highlightIndexPathes(TileIndexPath.indexPathesOfRow(path.row));
        }
        if(SudokuSequence.isWinningSequence(tilemanager.tilesAtIndexPaths(TileIndexPath.indexPathesOfBox(1)))){
            gameboard.highlightIndexPathes(TileIndexPath.indexPathesOfBox(1));
        }
    }
    
    
    func sudokuboardView(gameboard:UISudokuboardView, currentValue_forSudokutileWithIndexPath path:TileIndexPath) -> Int{
        return tilemanager.tiles[path.row-1][path.column-1].currentValue;
    }
    
    func sudokuboardView(gameboard:UISudokuboardView, selectionState_forSudokutileWithIndexPath path:TileIndexPath) -> TileState{
        return (currentlySelectedTile == path) ? TileState.Selected : TileState.None;
    }
    func sudokuboardView(gameboard:UISudokuboardView, solutionPossibles_forSudokutileWithIndexPath path:TileIndexPath) -> [Int]{
        return tilemanager.tiles[path.row-1][path.column-1].possibleValues
    }
}