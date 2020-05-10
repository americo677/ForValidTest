//
//  DemoViewController.swift
//  PokedexApp
//
//  Created by Américo José Cantillo Gutiérrez on 8/05/20.
//  Copyright © 2020 Américo José Cantillo Gutiérrez. All rights reserved.
//

import UIKit
import QuartzCore

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setVerticalGradientBackground(leftColor: UIColor.grass, rightColor: UIColor.grass.lighter(by: 10.0)!)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
