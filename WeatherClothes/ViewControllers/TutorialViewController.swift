//
//  TutorialViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 01/09/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var views = [UIView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = .blue
        generateViews()
        // Do any additional setup after loading the view.
    }

    func generateViews(){
        let firstView = UIView()
        firstView.backgroundColor = .orange
        let secondView = UIView()
        secondView.backgroundColor = .red
        views.append(firstView)
        views.append(secondView)
        loadImf()
        scrollView.isPagingEnabled = true
    }
    
    func loadImf(){

        for view in views{
            //let image = UIImage.init(named: name)
            scrollView.addSubview(view)
        }
        
        for(index, view) in views.enumerated(){
            view.frame.size = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
            view.frame.origin.x = scrollView.frame.width * CGFloat(index)
            view.frame.origin.y = 0
        }
        let contentWidth  = scrollView.frame.width * CGFloat(views.count)
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width;
        print(page)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width;
        let index = Int(page)
        
        print(index)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width;
        let index = lroundf(Float(page))
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = self.views[index].backgroundColor
        }
        print(index)
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
