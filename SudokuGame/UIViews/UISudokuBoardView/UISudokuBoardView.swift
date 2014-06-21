//
//  UISudokuBoardView.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/15/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

class UISudokuboardView: UIView, UISudokuInputViewDelegate {
    var tileViewModels: Array<SudokuTile> = Array();  //Contains data model not provided by UIView. Using struct rather than subclassing
    
    var delegate:  UISudokuboardViewDelegate?
    var datasource: UISudokuboardViewDatasource?
    
    var _inputView:UIView? //View for editing
    var indexForEditting = TileIndexPath(row: 0, column: 0) //Index of the tile being edited when instance becomes first responder
    
    //Keep track of tile dimensions to determine location of touches
    let tileWidth: CGFloat
    let tileHeight: CGFloat
    
    //Lazily loaded input view.
    func inputView() -> UIView{
        if(_inputView == nil){
            var customView = NSBundle.mainBundle().loadNibNamed("UISudokuInputView", owner: self, options: nil)[0] as UISudokuInputView;
            customView.delegate = self;
            _inputView = customView;
        }
        return _inputView!;
    }
    
    
    /**
    *  Divides the frame into 80 equal UIViews. Those views are further broken down into another 9 equal frames for labels needed to pencil in guesses.
    *  
    *  @remark By apples recommendations the frame should be no smaller than 396 x 396 pixels for border size
    */
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
                
                var path = TileIndexPath(row: row, column: column);
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
                tileView.tag = path.toIndex();
                
                self.addSubview(tileView);
                tileViewModels.append(SudokuTile(selectedState: TileState.None, currentValue: 0, imageName: nil, position: path));
            }
        }
    }
}
