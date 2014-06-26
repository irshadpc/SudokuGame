//
//  TileIndexPath.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/20/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

struct TileIndexPath{
    var row: Int
    var column: Int
  
   func box() -> Int{
        var boxColumn = (Int((column-1)/3) * 3) + 1;
   
        if(boxColumn == 1) { return self.bowRow(); }
    
        return self.bowRow() + ((boxColumn == 2) ? 1 : 2);
    }
    
    //boxRow gets it own function because it's more descriptive than boxColumn
    func bowRow() -> Int{
        return (Int((row-1)/3) * 3) + 1;
    }
    
    func toIndex() -> Int{
        return ((row-1) * 9) + column - 1;
    }
    
    func pathByIncrementFactor(factor: TileIndexPath) -> TileIndexPath{
        return TileIndexPath(row: row+factor.row, column: column+factor.column);
    }
    
    static func indexPathesOfRow(row: Int) -> Array<TileIndexPath>{
        var result = Array<TileIndexPath>();
        for column in 1...9{
            result.append(TileIndexPath(row: row, column: column));
        }
        return result;
    }
    
    static func indexPathesOfColumn(column: Int) -> Array<TileIndexPath>{
        var result = Array<TileIndexPath>();
        for row in 1...9{
            result.append(TileIndexPath(row: row, column: column))
        }
        return result;
    }

    
    
    static func indexPathesOfBox(box: Int) -> Array<TileIndexPath>{
        var result = Array<TileIndexPath>();
        let boxRow:Int = (box+2)/3;
        let boxColumn:Int = (box%3 == 0) ? 3 : box%3;
        let startrow = (3*(boxRow-1)+1)
        let startcolumn = (3*(boxColumn-1)+1)
        
        for row in startrow...startrow+2{
            for column in startcolumn...startcolumn+2{
                result.append(TileIndexPath(row: row, column: column));
            }
        }
        return result;
        
    }
    init(index:Int){
        self.row =  Int((index/9)+1);
        self.column = (index%9)+1;
    }
    
    init(row: Int, column: Int){
        self.row = row;
        self.column = column;
    }
    
}

@infix func == (left: TileIndexPath?, right: TileIndexPath?) -> Bool {
    if(!left? || !right?){ return false; }
    
    return (left!.row == right!.row) && (left!.column == right!.column);
}


@infix func != (left: TileIndexPath?, right: TileIndexPath?) -> Bool {
    return !(left == right)
}