//
//  ViewController.swift
//  Gravityyyy
//
//  Created by Farshad.Jahanmanesh on 1.08.2018.
//  Copyright © 2018 Farshad.Jahanmanesh. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var slider : GravitySlider?
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaultSettings = GravitySlider.Settings()
        defaultSettings.colors.circle = .red
        slider?.settings = defaultSettings
    }
}
