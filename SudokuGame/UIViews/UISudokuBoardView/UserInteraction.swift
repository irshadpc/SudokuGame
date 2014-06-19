//
//  UserInteraction.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/18/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

extension UISudokuboardView{
    /**
    *  Handles single touch taps from users made on the sudoku board
    */
    func handleTap(sender:UIGestureRecognizer){
    
        var index = self.indexFromLocation(sender.locationInView(self)); //Get tile tap was located in
        var results: Array<TileIndex> = Array(); //Will contain the result of which TileViews need to be updated
    
    
        var needsInput = delegate?.sudokuboardView(self, userTapped_sudokutileAtIndex: index, onChange: &results) //Yes if datamodel changed.
        self.updateSudokutiles(results);
    
        if(needsInput == true){ //Delegate is requesting an input from the user, prepare for editing and become first responder
            indexForEditting = index;
            self.becomeFirstResponder();
        }
    }

    func indexFromLocation(location:CGPoint) -> TileIndex{
        return TileIndex(row: Int(location.y/tileHeight)+1, column: Int(location.x/tileWidth)+1);
    }
}