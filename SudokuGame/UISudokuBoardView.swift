//
//  UISudokuBoardView.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/15/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

struct TileIndex{
    var row: Int
    var column: Int
    
    func toInt() -> Int{
        return ((row-1) * 9) + column - 1;
    }
}

enum TileState: Int{
    case None
    case Selected
    case Highlighted
    case Correct
    case Wrong
}

struct SudokuTile{
    var selectedState: TileState
    var currentValue: Int
    var imageName: String?
    var position: TileIndex
}

protocol UISudokuboardViewDelegate{
    func sudokuboardView(gameboard:AnyObject!, shouldSelect_sudokutileWithIndex index:TileIndex) -> Bool
    func sudokuboardView(gameboard:AnyObject!, didSelect_sudokutileWithIndex index:TileIndex)
    func sudokuboardView(gameboard:AnyObject!, shouldDeselect_sudokuTileWithIndex index:TileIndex) -> Bool
    func sudokuboardView(gameboard:AnyObject!, didDeleselect_sudokuTileWithIndex index:TileIndex)
}

protocol UISudokuboardViewDatasource{
    
    func sudokuboardView(gameboard:AnyObject!, imageName_forChesstileWithIndex index:TileIndex) -> String?
    func sudokuboardView(gameboard:AnyObject!, selectionState_forChesstileWithIndex index:TileIndex) -> TileState
}

class UISudokuboardView: UIView {

    var arryTileViews: NSArray = NSArray();
    var tileViewModels: Array<SudokuTile> = Array();
    
    var delegate:  UISudokuboardViewDelegate?
    var datasource: UISudokuboardViewDatasource?
    
    let tileWidth: CGFloat
    let tileHeight: CGFloat
    
    init(frame: CGRect) {
        tileWidth = frame.width/9;
        tileHeight = frame.height/9;
        super.init(frame: frame)
        
        var tileViews = NSMutableArray();
        
        for row in 1...9{
            for column in 1...9{
                var index = TileIndex(row: row, column: column);
                tileViewModels.append(SudokuTile(selectedState: TileState.None, currentValue: 0, imageName: nil, position: index));
                var tileView = UIView(frame: CGRectMake(CGFloat(column-1)*tileWidth, CGFloat(row-1)*tileHeight, tileWidth, tileHeight))
                tileView.layer.borderWidth = 1;
                tileView.tag = index.toInt();
                tileViews.addObject(tileView);
                self.addSubview(tileView);
            }
        }
        arryTileViews = NSArray(array: tileViews);
        
        var recognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"));
        self.addGestureRecognizer(recognizer);
    }
    
    func handleTap(sender:UIGestureRecognizer){
        var index = self.indexFromLocation(sender.locationInView(self));
        NSLog("Tapped: \(index.row) \(index.column) ID: \(index.toInt())");
        if(delegate?.sudokuboardView(self, shouldSelect_sudokutileWithIndex: index) == true){
            tileViewModels[index.toInt()].selectedState = TileState.Selected;
            delegate?.sudokuboardView(self, didSelect_sudokutileWithIndex: index);
        }
        
        self.setState(tileViewModels[index.toInt()].selectedState, forTileAtIndex: index)
    }
    
    func setState(state:TileState, forTileAtIndex index:TileIndex){
        var view = arryTileViews.objectAtIndex(index.toInt()) as UIView;
        switch state {
            case TileState.None:
                view.layer.borderColor = UIColor.blackColor().CGColor;
                break;
            case TileState.Selected:
                view.layer.borderColor = UIColor.greenColor().CGColor;
                break;
            case TileState.Highlighted:
                view.layer.borderColor = UIColor.yellowColor().CGColor;
                break;
            case TileState.Correct:
                view.layer.borderColor = UIColor.blueColor().CGColor;
                break;
            case TileState.Wrong:
                view.layer.borderColor = UIColor.redColor().CGColor;
                break;
        }
    }
    
    func indexFromLocation(location:CGPoint) -> TileIndex{
        return TileIndex(row: Int(location.y/tileHeight)+1, column: Int(location.x/tileWidth)+1);
    }
}

