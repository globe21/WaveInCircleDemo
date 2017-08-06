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
        
        view.backgroundColor = .lightGray
        
        self.wave.hightlightColor = UIColor.blue
        self.wave.normalColor = UIColor.white
        self.wave.text = "DO"
        self.wave.fillingProgress = 0.4
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.wave.animate()
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if self.wave.fillingProgress >= 1.1 {
                timer.invalidate()
                self.wave.stopAnimate()
                self.wave.text = "OK"
            }else {
                self.wave.fillingProgress = self.wave.fillingProgress + 0.001
            }
        }
        
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
        //            self.wave.stopAnimate()
        //        }
    }
}

