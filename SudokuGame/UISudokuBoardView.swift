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
    
    func toID() -> Int{
        return TileIndex.IDFromRow(row, andColumn: column);
    }
    
    static func IDFromRow(row: Int, andColumn column:Int) -> Int{
        return ((row-1) * 9) + column - 1;
    }
    
    static func indexFromInt(value:Int) -> TileIndex{
        return TileIndex(row: Int((value/9)+1), column: (value%9)+1);
    }
    
}

@infix func == (left: TileIndex?, right: TileIndex?) -> Bool {
    if(!left? || !right?){ return false; }
    
    return (left!.row == right!.row) && (left!.column == right!.column);
}

@infix func != (left: TileIndex?, right: TileIndex?) -> Bool {
    return !(left == right)
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
    func sudokuboardView(gameboard:UISudokuboardView!, userTapped_sudokutileAtIndex index:TileIndex, inout onChange needsUpdate:Array<TileIndex>) -> Bool
    func sudokuboardView(gameboard:UISudokuboardView!, userInput_sudokutileAtIndex index:TileIndex, withValue value:Int);
}

protocol UISudokuboardViewDatasource{
    func sudokuboardView(gameboard:UISudokuboardView!, currentValue_sudokutileWithIndex index:TileIndex) -> Int
    func sudokuboardView(gameboard:UISudokuboardView!, selectionState_forsudokutileWithIndex index:TileIndex) -> TileState
}

class UISudokuboardView: UIView, UISudokuInputViewDelegate {
    var tileViewModels: Array<SudokuTile> = Array();
    
    var delegate:  UISudokuboardViewDelegate?
    var datasource: UISudokuboardViewDatasource?
    var _inputView:UIView?
    var indexForEditting = TileIndex(row: 0, column: 0)
    
    let tileWidth: CGFloat
    let tileHeight: CGFloat
    
    func inputView() -> UIView{
        if(_inputView == nil){
            var customView = NSBundle.mainBundle().loadNibNamed("UISudokuInputView", owner: self, options: nil)[0] as UISudokuInputView;
            customView.delegate = self;
            _inputView = customView;
        }
        return _inputView!;
    }
    
    init(frame: CGRect) {
        tileWidth = frame.width/9;
        tileHeight = frame.height/9;
        super.init(frame: frame)
        
        var singleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"));
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"));
        var longTapRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongTap:"));
        self.addGestureRecognizer(singleTapRecognizer);
        
        var sublabelWidth = tileWidth/3;
        var sublabelHeight = tileHeight/3;
        
        for row in 1...9{
            for column in 1...9{
                
                var index = TileIndex(row: row, column: column);
                var tileView = UIView(frame: CGRectMake(CGFloat(column-1)*tileWidth, CGFloat(row-1)*tileHeight, tileWidth, tileHeight))
                var labelView = UILabel(frame: CGRectMake(0, 0, tileWidth, tileHeight));
                
                labelView.textAlignment = NSTextAlignment.Center;
                labelView.font = UIFont.systemFontOfSize(26);
                labelView.opaque = true;
                tileView.addSubview(labelView);
                
                for subrow in 0...2{
                    for subcolumn in 0...2{
                        var sublabelView = UILabel(frame: CGRectMake(CGFloat(subcolumn) * sublabelWidth, CGFloat(subrow) * sublabelHeight, sublabelWidth, sublabelHeight));
                        sublabelView.textAlignment = NSTextAlignment.Center;
                        sublabelView.text = "\(subrow*3 + subcolumn + 1)";
                        sublabelView.hidden = true;
                        tileView.addSubview(sublabelView);
                    }
                }

                tileView.layer.borderWidth = 1;
                tileView.tag = index.toID();
                
                self.addSubview(tileView);
                tileViewModels.append(SudokuTile(selectedState: TileState.None, currentValue: 0, imageName: nil, position: index));
            }
        }
    }
    
    func reloadData(){
        for ID in 0...self.subviews.count-1{
            var index = TileIndex.indexFromInt(ID);
            var answer = datasource?.sudokuboardView(self, currentValue_sudokutileWithIndex: index);
            var state = datasource?.sudokuboardView(self, selectionState_forsudokutileWithIndex: index);
        
            if(state != nil && state != tileViewModels[ID].selectedState){ self.setState(state!, forTileAtIndex: index); }
        }
        
    }
    
    func handleTap(sender:UIGestureRecognizer){
        var index = self.indexFromLocation(sender.locationInView(self));
        var results: Array<TileIndex> = Array();
        NSLog("Tapped: \(index.row) \(index.column) ID: \(index.toID())");
        var needsInput = delegate?.sudokuboardView(self, userTapped_sudokutileAtIndex: index, onChange: &results)
        self.updateSudokutiles(results);
        
        if(needsInput == true){
            indexForEditting = index;
            self.becomeFirstResponder();
        }
    }
    
    func updateSudokutiles(tiles:Array<TileIndex>){
        for index in tiles{
            var value = self.datasource?.sudokuboardView(self, currentValue_sudokutileWithIndex: index);
            var state = self.datasource?.sudokuboardView(self, selectionState_forsudokutileWithIndex: index);
            self.setValue(value!, forTileAtIndex: index);
            self.setState(state!, forTileAtIndex: index);
        }
    }
    
    func setState(state:TileState, forTileAtIndex index:TileIndex){
        var tileView = self.subviews[index.toID()] as UIView
        switch state {
            case TileState.None:
                tileView.layer.borderColor = UIColor.blackColor().CGColor;
                break;
            case TileState.Selected:
                tileView.layer.borderColor = UIColor.greenColor().CGColor;
                break;
            case TileState.Highlighted:
                tileView.layer.borderColor = UIColor.yellowColor().CGColor;
                break;
            case TileState.Correct:
                tileView.layer.borderColor = UIColor.blueColor().CGColor;
                break;
            case TileState.Wrong:
                tileView.layer.borderColor = UIColor.redColor().CGColor;
                break;
        }
        tileViewModels[index.toID()].selectedState = state;
    }
    
    func setValue(value:Int, forTileAtIndex index:TileIndex){
        NSLog("\(index.toID())");
        var tileView = self.subviews[index.toID()] as UIView
        (tileView.subviews[0] as UILabel).text = (value == 0) ? "" : value.description;
        tileViewModels[index.toID()].currentValue = value;
    }
    
    func indexFromLocation(location:CGPoint) -> TileIndex{
        return TileIndex(row: Int(location.y/tileHeight)+1, column: Int(location.x/tileWidth)+1);
    }
    
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

