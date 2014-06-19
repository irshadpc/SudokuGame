//
//  UISudokuInputView.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/17/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

protocol UISudokuInputViewDelegate{
    func shouldResignFirstResponder()
    func sudokuInputView(inputView:UISudokuInputView!, userInputValue value:Int) -> Bool
}

class UISudokuInputView:UIView, UIInputViewAudioFeedback{

    var delegate: UISudokuInputViewDelegate?
    
    @IBAction func buttonPressed(sender : UIButton) {
        UIDevice.currentDevice().playInputClick();
        self.delegate?.sudokuInputView(self, userInputValue: sender.titleLabel.text.toInt()!);
    }
    
    
    @IBAction func donePressed(sender : AnyObject) {
        UIDevice.currentDevice().playInputClick();
        self.delegate?.shouldResignFirstResponder();
    }
    
    func enableInputClicksWhenVisible() -> Bool {
        return true;
    }
}