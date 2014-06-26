//
//  ProtocolImplementation.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

extension UISudokuboardView{
    /**
    *   Makes a call to the datasource in order to update all the views and get the most current state from the data model.
    */
    func reloadData(){
        self.updateSudokutilesAtIndexPaths(allTileIndexPathes());
    }
    
    func allTileIndexPathes() -> Array<TileIndexPath>{
        var result = Array<TileIndexPath>();
        for row in 1...9{
            for column in 1...9{
                result.append(TileIndexPath(row: row, column: column));
            }
        }
        return result;
    }
    
    func updateSudokutilesAtIndexPaths(paths:Array<TileIndexPath>){
        for path in paths{
            if let newValue = self.datasource?.sudokuboardView(self, currentValue_forSudokutileWithIndexPath: path){
                self.setValue(newValue, forTileAtIndexPath: path);
                if(newValue == 0){ //There's no value there, display possibles if there are any{
                    if let newPossibles = self.datasource?.sudokuboardView(self, solutionPossibles_forSudokutileWithIndexPath: path){
                        NSLog("\(path.toIndex()), \(newPossibles.count)");
                        self.setPossibles(newPossibles, forTileAtIndexPath: path); }
                } else{
                    self.clearPossiblesForTileAtIndexPath(path);
                }
            }
            
            if let newState = self.datasource?.sudokuboardView(self, selectionState_forSudokutileWithIndexPath: path){
                self.setState(newState, forTileAtIndexPath: path); }
            
        }
    }
}

extension UISudokuboardView{
    override func canBecomeFirstResponder() -> Bool {
        return true;
    }
    
    func shouldResignFirstResponder() {
        self.resignFirstResponder();
    }
    
    func sudokuInputView(inputView: UISudokuInputView!, userInputValue value: Int) -> Bool {
        self.delegate?.sudokuboardView(self, userInput_sudokutileAtIndexPath: indexForEditting, withValue: value);
        self.updateSudokutilesAtIndexPaths([indexForEditting]);
        self.resignFirstResponder();
        return true;
    }
}