//
//  NewGameViewController.swift
//  SudokuGame
//
//  Created by Alfred Cepeda on 6/15/14.
//  Copyright (c) 2014 Alfred Cepeda. All rights reserved.
//

import UIKit

class NewGameVC: UIViewController, UICollectionViewDataSource {

    
    @IBOutlet var sgmtMode : UISegmentedControl = nil
    @IBOutlet var sgmtDifficulty : UISegmentedControl = nil
    
    init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!){
        
        var destination = segue.destinationViewController as GameScreenVC;
        destination.mode = GameMode.fromRaw(sgmtMode.selectedSegmentIndex)!;
        destination.difficulty = GameDifficulty.fromRaw(sgmtMode.selectedSegmentIndex)!;
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        return nil;
    }
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
        return 0;
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
