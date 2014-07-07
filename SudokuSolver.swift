//
//  SudokuSolver.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/24/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

enum SolverActionApply:Int{
    case NakedSingles
    case Possibles
    case HiddenSingles
    case NakedPairs
    case HiddenPairs
    case HiddenTriples
}

struct SudokuSolver{
    var tiles: TileModel[]!;
    
    init(){
        
    }
    
    func getCounter(tiles:TileModel[]) -> Int[][]{
        
        var result = Int[][](count: 9, repeatedValue:Int[]());
        for (i, tile) in enumerate(tiles){
            for value in tile.possibleValues{
                result[value-1].append(i);
            }
        }
        return result;
    }
    
    
    func generatePuzzle(givens:Array<Int>, atPositions positions:Array<TileIndexPath>, withTileManager manager:MDLTileManager){
        for index in 0...positions.count-1{
            let path = positions[index];
            manager.tiles[path.row-1][path.column-1].currentValue = givens[index];
            manager.tiles[path.row-1][path.column-1].isGiven = true;
        }
    }
    
    func performAction(step: SolverActionApply)->(TileModel[], Bool){
        var result:(TileModel[], Bool) = (TileModel[](), false);
        switch(step){
            case .NakedSingles:
                return applySolvedTiles(tiles);
            case .Possibles:
                return applyPossibles(tiles);
            case .HiddenSingles:
                return applyHiddenSingles(tiles);
            case .NakedPairs:
                return applyNakedPairs(tiles);
            case .HiddenPairs:
                return applyHiddenPairs(tiles);
            case .HiddenTriples:
                return result;
            default:
                return result;
        }
    }
    
    func changePossibles(possibles:Int[], fromTiles models:TileModel[], excludeTiles exclude: TileModel[]?, removePossibles remove: Bool) -> (TileModel[], Bool){
        var tiles = models.copy();
        var possiblesChanged = false;
        
        for(i, tile) in enumerate(tiles){
            
            if let excludedTiles = exclude {
                if($.contains(excludedTiles, value: tile)){
                    continue;
                }
            }
            
            var result = tile.possibleValues.filter{
                if($.contains(possibles, value: $0)){
                    return !remove;
                }
                return remove;
            }
            if(result.count != tile.possibleValues.count) {
                tiles[i].changePossibles(result);
                possiblesChanged = true;
            }
        }
        
        return (tiles, possiblesChanged);
    }
    
    func applySolvedTiles(models:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        let tiles = models.copy();
        for (i, tile) in enumerate(tiles){
            if(tile.possibleValues.count == 1){
                tiles[i].currentValue = tiles[i].possibleValues.removeLast();
                println("Solved Tile: (\(tile.row),\(tile.column))");
                found = true;
            }
        }
        return (tiles, found);
    }

    func applyPossibles(models:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        let tiles = models.copy();
        let solvedTiles = tiles.filter{ $0.possibleValues.count == 0 };
        for (i, tile) in enumerate(tiles){
            let result = tile.possibleValues.filter {
                for solvedTile in solvedTiles {
                    //If possible value is already a found solution, then return false as it's longer a possible
                    if($0 == solvedTile.currentValue) {
                        found = true;
                        return false; }
                }
                //No matches have been found so this number is still a possible
                return true;
            }
            if(result.count != tile.possibleValues.count) {
                tiles[i].possibleValues = result;
            }
        }
        return (tiles, found);
    }
    
    func applyHiddenSingles(tiles:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        let counter = getCounter(tiles);
                
        for (i, tally) in enumerate(counter){
            if(tally.count == 1){
                tiles[tally[0]].currentValue = i+1;
                tiles[tally[0]].possibleValues.removeAll(keepCapacity: false);
                println("Hidden Single: (\(tiles[tally[0]].row),\(tiles[tally[0]].column))");
                return(tiles, true);
            }
        }
        return (tiles, false);
    }

    func applyNakedPairs(tiles:TileModel[]) -> (TileModel[], Bool){
        
        for (i, tile) in enumerate(tiles){
            if(tile.possibleValues.count < 3){
                //Enumerate through rest of array looking for a match
                //Keep track of matching values to see if we have a match
                var matches = [tile];
                var quota = tile.possibleValues; //Could be 2 or 3 values
                
                for idx in i+1...tiles.count-1{
                    let other = tiles[idx];
                    
                    if(tile.possibleValues == other.possibleValues){
                        //Definite match, determine if it's a naked double or a possible triple
                        if(tile.possibleValues.count == 2){
                            //We have a naked pair, attempt to change possibles of other tiles
                            let result = changePossibles(tile.possibleValues, fromTiles: tiles, excludeTiles: [tile, other], removePossibles: true);
                            if(result.1 == true){
                                //Return the changes
                                println("Naked Pairs: (\(tile.row),\(tile.column)) and (\(tiles[idx].row),\(tiles[idx].column))");
                                return result;
                            }
                            //Otherwise break loop, we won't find any other matches after this pair
                            break;
                        }
                    }
                    
                    //Might be a triple
                    else if($.contains(quota, value: other.possibleValues)){
                        //Possibles are already in quota, we have a match
                        matches.append(other);
                    }
                        
                    //Check if we can add to quota anyways
                    else{
                        let differentValues = $.difference([quota, other.possibleValues]);
                        
                        if(quota.count + differentValues.count <= 3){
                            //We can add value to current quota
                            matches.append(other);
                        }
                    }
                    
                    if(matches.count == 3){
                        //We have three tiles that satisfy the condition
                        //Remove values in currentQuota from all other tiles
                        let result = changePossibles(quota, fromTiles: tiles, excludeTiles: matches, removePossibles: true);
                        if(result.1 == true){
                            print("Naked Triples: ");
                            for match in matches{
                                print("(\(match.row), \(match.column)) ");
                            }
                            print("Values: \(quota)\n");
                            return result;
                        }
                    }
                }
            }
        }
        return (tiles, false);
    }
    
    //counter[0].count == 2 means the value 1 appears twice and it has the indexes stored so counter[0][0] == 3 means the value 1 is at the third index.
    func applyHiddenPairs(models:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        var tiles = models.copy();
        let counter = getCounter(tiles); //Represent value of possibles and how many times they appear in unit
    
        if(counter.filter{ $0.count == 2 }.count <= 1) { return (models, false); }
        
        //Value in this case is the inner array of counter. This will return which numbers are at the same locations using indexes.
        //matches[0].count == 3 means first match is at 3 indexes. matches[0][0] == 5 means the first index is 5. Will need to refer to counter
        //In order to get what the value of that match is, as well as which tile it belongs to.
        
        let matches = indexesOfRepeatedValues(counter);
        if(matches.count == 0) { return (models, false); }
        else {
            for match in matches{
                if(match.count > 2) { continue; } //Only interested in 2 numbers for pairs
                //Make sure these values only appear in 2 tiles. It may be 2 values that appear in the same 3 or more tiles.
                if(counter[match[0]].count > 2 || counter[match[0]].count == 0) { continue; }
                
                let firstTileIndex = counter[match[0]][0];
                let secondTileIndex = counter[match[0]][1];
                
                if(tiles[firstTileIndex].possibleValues.count == 2) {  continue; }
                
                tiles[firstTileIndex].changePossibles([match[0]+1, match[1]+1]);
                tiles[secondTileIndex].changePossibles([match[0]+1, match[1]+1]);
                println("Hidden Pairs: (\(tiles[firstTileIndex].row),\(tiles[firstTileIndex].column)) and (\(tiles[secondTileIndex].row),\(tiles[secondTileIndex].column))");
                found = true;
            }
        }
        return (tiles, found);
    }
}