//
//  GoalV.swift
//  CashCraft
//
//  Created by Gopi Lokindi on 11/21/23.
//

import UIKit

class GoalV: UIView {

    @IBOutlet weak var GoalImage: UIImageView!
    
     @IBOutlet weak var GoalName: UILabel!
    
    /*
     // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpXibView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpXibView()
    }
    
    private func setUpXibView(){
        if let viewofxib = Bundle.main.loadNibNamed("GoalV", owner: self, options: nil)?.first as? UIView {
            viewofxib.frame = self.bounds
            viewofxib.layer.borderWidth=2
            viewofxib.layer.borderColor = UIColor.white.cgColor
            viewofxib.layer.cornerRadius = 20
            self.addSubview(viewofxib)
            
        }
    }

}
