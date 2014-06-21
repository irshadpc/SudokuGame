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
        var boxRow:Int = (box+2)/3;
        var boxColumn:Int = (box%3 == 0) ? 3 : box%3;
        var start = (3*(boxRow-1)+1)
        
        for row in start...start+2{
            for column in start...start+2{
                result.append(TileIndexPath(row: row, column: column));
            }
        }
        return result;
        
    }
    init(value:Int){
        self.row =  Int((value/9)+1);
        self.column = (value%9)+1;
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