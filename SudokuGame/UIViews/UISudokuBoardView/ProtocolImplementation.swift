//
//  ProtocolImplementation.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

extension UISudokuboardView{
    /**
    *   Makes a call to the datasource in order to update all the views and get the most current state from the data model.
    */
    func reloadData(){
        for ID in 0...self.subviews.count-1{
            self.updateSudokutiles(allTileIndexPathes());
        }
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
    
    func updateSudokutiles(tiles:Array<TileIndexPath>){
        for index in tiles{
            var newValue = self.datasource?.sudokuboardView(self, currentValue_sudokutileWithIndex: index);
            var newState = self.datasource?.sudokuboardView(self, selectionState_forsudokutileWithIndex: index);
            self.setValue(newValue, forTileAtIndex: index);
            self.setState(newState, forTileAtIndexPath: index);
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
        self.delegate?.sudokuboardView(self, userInput_sudokutileAtIndex: indexForEditting, withValue: value);
        self.setValue(value, forTileAtIndex: indexForEditting);
        self.resignFirstResponder();
        return true;
    }
}