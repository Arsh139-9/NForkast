//
//  ProductIngredientHomeVC.swift
//  Forkast
//
//  Created by Dharmani Apps mini on 3/15/21.
//

import UIKit

class ProductIngredientHomeVC: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func navToAllProductListVC(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProductListVC,StoryboardName.ProductIngredients, ProductListVC(),self.storyboard!, self.navigationController!)
    }
    @IBAction func navToAllIngredientListVC(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.IngredientListVC,StoryboardName.ProductIngredients, IngredientListVC(),self.storyboard!, self.navigationController!)
    }
    @IBAction func navToAllProductMappingVC(_ sender: Any) {
        Navigation.init().pushCallBack(ViewControllerIdentifier.ProductMappingVC,StoryboardName.ProductIngredients, ProductMappingVC(),self.storyboard!, self.navigationController!)
    }

}
