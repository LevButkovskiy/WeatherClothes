//
//  ContainerViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 19/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, HomeViewControllerDelegate {

    var controller : UIViewController!
    var menuViewController : MenuViewController!
    var homeViewController : HomeViewController!
    
    var isMove = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*let firstLaunch = UserDefaults.standard.bool(forKey: "firstLaunch")
        if firstLaunch  {
            print("Not first launch.")
        } else {
            let tutorial = TutorialViewController()
            navigationController?.pushViewController(tutorial, animated: true)
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
        */
        let home = HomeViewController()
        loadHomeViewController()
        navigationController?.popToViewController(home, animated: true)
    }
    
    func loadHomeViewController(){
        homeViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
        homeViewController.homeViewControllerDelegate = self
        controller = homeViewController
        view.addSubview(controller.view)
        addChild(controller)
    }
    
    func loadMenuViewController(){
        if menuViewController == nil{
            menuViewController = MenuViewController()
            view.insertSubview(menuViewController.view, at: 0)
            addChild(menuViewController)
        }
    }
    
    func showMenu(shouldMove : Bool){
        if(shouldMove){
            //show Menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.controller.view.frame.origin.x = self.controller.view.frame.width / 2
            }) { (finished) in
                
            }
        }
        else{
            //hide Menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.controller.view.frame.origin.x = 0
            }) { (finished) in
            
            }
        }
        
    }
    
    // MARK: HomeViewControllerDelegate
    
    func toggleMenu() {
        loadMenuViewController()
        isMove = !isMove
        showMenu(shouldMove: isMove)
    }
}
