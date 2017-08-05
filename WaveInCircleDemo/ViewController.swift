//
//  ViewController.swift
//  WaveInCircleDemo
//
//  Created by 鞠汶成 on 05/08/2017.
//  Copyright © 2017 鞠汶成. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wave: WaveInCircleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wave.hightlightColor = UIColor.brown
        self.wave.normalColor = UIColor.white
        self.wave.text = "DO"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.wave.animate()
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
        //            self.wave.stopAnimate()
        //        }
    }
}

