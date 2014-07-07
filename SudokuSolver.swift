//
//  SudokuSolver.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/24/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

enum SolverStep:Int{
    case NakedSingles
    case Possibles
    case HiddenSingles
    case NakedPairs
    case NakedTriples
    case HiddenPairs
    case HiddenTriples
}

struct SudokuSolver{
    var manager: MDLTileManager;
    var paths: TileIndexPath[]!;
    
    func getCounter(tiles:TileModel[]) -> Int[][]{
        
        var result = Int[][](count: 9, repeatedValue:Int[]());
        for (i, tile) in enumerate(tiles){
            for value in tile.possibleValues{
                result[value-1].append(i);
            }
        }
        return result;
    }
    
    init(manager: MDLTileManager){
        self.manager = manager;
    }
    
    func generatePuzzle(givens:Array<Int>, atPositions positions:Array<TileIndexPath>){
        for index in 0...positions.count-1{
            let path = positions[index];
            manager.tiles[path.row-1][path.column-1].currentValue = givens[index];
            manager.tiles[path.row-1][path.column-1].isGiven = true;
        }
    }
    
    func takeStep(step: SolverStep)->Bool{
        var result:(TileModel[], Bool) = (TileModel[](), false);
        switch(step){
            case .NakedSingles:
                result = applySolvedTiles(manager.tilesAtIndexPaths(paths));
                break
            case .Possibles:
                result = applyPossibles(manager.tilesAtIndexPaths(paths));
                break;
            case .HiddenSingles:
                result = applyHiddenSingles(manager.tilesAtIndexPaths(paths));
                break;
            case .NakedPairs:
                result = applyNakedPairs(manager.tilesAtIndexPaths(paths));
                break;
            case .NakedTriples:
                result = applyNakedTriples(manager.tilesAtIndexPaths(paths));
                break;
            case .HiddenPairs:
                //result = applyHiddenPairs(manager.tilesAtIndexPaths(paths));
                break;
            case .HiddenTriples:
                return false;
            default:
                return false;
        }
        
        if(result.1 == true) { manager.setValue(result.0, atIndexPaths: paths); }
        return result.1;
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
    
    func applyHiddenSingles(models:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        let tiles = models.copy();
        let counter = getCounter(tiles);
                
        for (i, tally) in enumerate(counter){
            if(tally.count == 1){
                tiles[tally[0]].currentValue = i+1;
                tiles[tally[0]].possibleValues.removeAll(keepCapacity: false);
                println("Hidden Single: (\(tiles[tally[0]].row),\(tiles[tally[0]].column))");
                found = true;
            }
        }
        return (tiles, found);
    }

    func applyNakedPairs(models:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        var tiles = models.copy();

        let doublePossibles = tiles.filter { $0.possibleValues.count == 2 }
                
        for tile in doublePossibles{
            let matches = tiles.filter { ($0 as TileModel).possibleValues == tile.possibleValues }
            
            if(matches.count == 2){
                let result = changePossibles(tile.possibleValues, fromTiles: tiles, excludeTiles: matches, removePossibles: true);
                found = result.1;
                
                if(found == true){
                    tiles = result.0;
                    println("Naked Pairs: (\(matches[0].row),\(matches[0].column)) and (\(matches[1].row),\(matches[1].column))");
                    break;
                }
            }
        }
        return (tiles, found);
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
    
    // [2,5] [5,8] [2,8]
    /**
    * Search for 3 tiles that share exactly 3 different possible values between them
    */
    func applyNakedTriples(models:TileModel[]) -> (TileModel[], Bool){
        var found = false;
        var tiles = models.copy();
        let triplePossibles = tiles.filter { $0.possibleValues.count == 3 } +
                              tiles.filter { $0.possibleValues.count == 2 }
        
        for (i, tile) in enumerate(triplePossibles){
            var currentQuota = tile.possibleValues; //Could have 2 or 3 values.
            var matches = TileModel[]();
            matches.append(tile);
            
            for idx in i+1...triplePossibles.count-1{
                let other = triplePossibles[idx];
                
                if($.contains(currentQuota, value: other.possibleValues)){
                    //Other is a definite match since all its possibles are already part of quota
                    if(matches.count > 3){
                        NSLog("FREAK OUT!! applyNakedTriples: matches.count > 3");
                    }
                    
                    matches.append(other);
                }
                else{
                    var sharedElements = other.possibleValues.filter { $.contains(currentQuota, value: $0) }
                    if(sharedElements.count > 0){
                        if(currentQuota.count + (other.possibleValues.count - sharedElements.count) > 3){
                            //tile cannot possibly be part of a naked triple, as it shares an element with a tile that cannot be part of a naked triple
                            //EX: [2,5] [2,8,9] sharedElements = [2] so 2 + (3 - 1) = 4 > 3
                            break;
                        }
                        matches.append(other);
                        //currentQuota = arrayHelp(currentQuota, merge: other.possibleValues);
                    }
                }
                if(matches.count == 3){
                    //We have three tiles that satisfy the condition
                    //Remove values in currentQuota from all other tiles
                    let result = changePossibles(currentQuota, fromTiles: tiles, excludeTiles: matches, removePossibles: true);
                    if(result.1 == true){
                        tiles = result.0;
                        print("Naked Triples: ");
                        for match in matches{
                            print("(\(match.row), \(match.column)) ");
                        }
                        print("Values: \(currentQuota)\n");
                        found = true;
                    }
                }
            }
        }
        return (tiles, found);
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
                if(counter[match[0]].count > 2) { continue; }
                
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