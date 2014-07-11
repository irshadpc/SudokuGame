//
//  TileIndexPath.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/20/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import Foundation

enum UnitType:Int, Printable{
    case Row
    case Column
    case Box
    
    var description: String{
    switch(self){
    case .Row:
        return "Row";
    case .Column:
        return "Column";
    case .Box:
        return "Box";
        }
    }
}

struct TileIndexPath: Equatable, Printable{
    var row: Int
    var column: Int
    
    var description: String {
    return "Row: \(row), Column: \(column)";
    }
    
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
    
    static func indexPathsOfUnit(unit:Int, ofUnitType type:UnitType) -> Array<TileIndexPath>{
        var result = [TileIndexPath]();
        switch type{
        case UnitType.Row:
            return indexPathesOfRow(unit);
        case UnitType.Column:
            return indexPathesOfColumn(unit);
        case UnitType.Box:
            return indexPathesOfBox(unit);
        }
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
        self.column = (index == 0) ? 1 : (index%9);
    }
    
    init(row: Int, column: Int){
        self.row = row;
        self.column = column;
    }
    
}


@infix func == (lhs: TileIndexPath, rhs: TileIndexPath) -> Bool {
    return (lhs.row == rhs.row) && (lhs.column == rhs.column);
}