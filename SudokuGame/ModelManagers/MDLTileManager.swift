//
//  MDLTileManager.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/17/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

@infix func == (lhs: TileModel, rhs: TileModel) -> Bool {
    return (lhs.row == rhs.row) && (lhs.column == rhs.column) && (lhs.ID == rhs.ID);
}

class MDLTileManager{
    
    struct TileModel:Equatable{
        let ID: Int;
        var isGiven: Bool{
        didSet{
            if(isGiven == true){ possibleValues.removeAll() }
        }
        }
        var possibleValues = Int[]();
        
        var row:Int
        var column:Int
        var currentValue:Int = 0{
            didSet{
                if(currentValue != 0){
                    possibleValues.removeAll();
                }
            }
        }
        var solutionValue = 0;
        var isHighlighted = false;
        func isCorrect() -> Bool{
            return (solutionValue != 0) && (currentValue == solutionValue);
        }
        
        mutating func changePossibles(newPossibles:Int[]){
            self.possibleValues = newPossibles;
        }
        
        init(ID: Int, row: Int, column: Int, currentValue current: Int, solutionValue solution: Int, isGiven given:Bool, isHighlighted highlighted:Bool){
            self.ID = ID;
            self.row = row;
            self.column = column;
            self.currentValue = current;
            self.solutionValue = solution;
            self.isGiven = given;
            self.isHighlighted = highlighted;
            
            if(!given){
                for possibleValue in 1...9{
                    possibleValues.append(possibleValue);
                }
            }
        }
    }
    
    var tiles = TileModel[][](count: 9, repeatedValue: TileModel[]());
    
    init(){
        
        for row in 1...9{
            for column in 1...9{
                tiles[row-1].append(TileModel(ID: row+column-1, row: row, column: column, currentValue: 0, solutionValue: 0, isGiven: false, isHighlighted: false));
            }
        }
    }
    
    func isValidIndex(index: Int) -> Bool{
        if(index < 0 || index > tiles.count) { return false; }
        return true;
    }
    
    func solutionsAtIndexPaths(indexPaths: TileIndexPath[]) -> Int[]{
        var result = Array<Int>();
        
        for path in indexPaths{
            var tile = tiles[path.row-1][path.column-1];
            if(tile.currentValue > 0){
                result.append(tile.currentValue);
            }
        }
        
        return result;
    }

    func setValue(models:TileModel[], atIndexPaths paths:TileIndexPath[]){
        if(models.count != paths.count) { return; }
        
        for (i, path) in enumerate(paths){
            tiles[path.row-1][path.column-1] = models[i];
        }
    }
    
    func tileAtIndexPath(path: TileIndexPath) -> TileModel{
        return tiles[path.row-1][path.column-1];
    }
    
    func tilesAtIndexPaths(indexPaths: TileIndexPath[]) -> TileModel[]{
        var result = Array<TileModel>();
        
        for path in indexPaths{
            result.append(tileAtIndexPath(path));
        }
        return result;
    }
    
    func tilePathsWithPossibles(possibles: Int[], inPaths paths:TileIndexPath[]) -> Array<TileIndexPath>{
        var result = TileIndexPath[]();
        for path in paths{
            var values = tiles[path.row-1][path.column-1].possibleValues;
            if(values == possibles){
                result.append(path);
            }
        }
        return result;
    }
    
    func tilePathsWithPieceOfPossibles(possibles: Int[], inPaths paths: TileIndexPath[]) -> Array<TileIndexPath>{
        var result = TileIndexPath[]();
        for path in paths{
            var values = tiles[path.row-1][path.column-1].possibleValues;
            if(values.count > 0){
                if(arrayHelp(possibles, contains: values) && values.count < possibles.count){
                    result.append(path);
                }
            }
        }
        return result;
    }
    
    func removeAllPossiblesExcept(possibles:Int[], atIndexPaths paths:TileIndexPath[]) -> Bool {
        var removedPossibles = false;
        for path in paths{
            tiles[path.row-1][path.column-1].possibleValues = tiles[path.row-1][path.column-1].possibleValues.filter{
                if(arrayHelp(possibles, containsElement: $0)){ return true; }
                else {
                    removedPossibles = true;removedPossibles = true;
                    return false;
                }
            }
        }
        return removedPossibles;
    }
    
    func removePossibles(possibles: Int[], atIndexPaths paths:TileIndexPath[]) -> Bool{
        var removedPossibles = false;
        for path in paths{
            tiles[path.row-1][path.column-1].possibleValues = tiles[path.row-1][path.column-1].possibleValues.filter{
                if(!arrayHelp(possibles, containsElement: $0)){ return true; }
                else {
                    removedPossibles = true;
                    return true;
                }
            }
        }
        return removedPossibles;
    }
}