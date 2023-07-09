//
//  ViewController.swift
//  OnBoardView
//
//  Created by Zignuts Technolab on 28/04/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
    }
    @IBAction func btnShare(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RadiusVC") as! RadiusVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

