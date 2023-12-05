//
//  ViewController.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/20/23.
//

import UIKit
import Lottie

class LandingPage: UIViewController {

    @IBOutlet weak var logoAnimationView: LottieAnimationView!
    let animationView = LottieAnimationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logoAnimationView.animation=LottieAnimation.named("PriceAnimation")
        logoAnimationView.play()
        logoAnimationView.loopMode = .loop
        
    }


}

