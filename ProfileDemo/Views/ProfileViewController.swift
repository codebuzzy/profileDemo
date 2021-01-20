//
//  ProfileViewController.swift
//  ProfileDemo
//
//  Created by Malti Maurya on 20/01/21.
//  Copyright © 2021 Malti Maurya. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var portfolioCollectionView: UICollectionView!
    @IBOutlet weak var totalQuotesLabel: UILabel!
    @IBOutlet weak var quotesCompletedLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pincodeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageview: UIImageView!
    
    // MARK: Variables declearations
    var viewModel : ProfileViewControllerViewModelProtocol?
    var portfolioArray : [portfolio] = []
    var msgCount : String = "0"
    var notificationscount : String = "0"
    
    //MARK : Overidden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ProfileViewControllerViewModel()
        self.viewModel?.serviceRequest(apiName: RequestItemsType.profile)
        self.bindUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.scrollView.isHidden = true
        self.setUpNavigationBar()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : Navigation Bar Setup
    private func setUpNavigationBar()
    {
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "ic_msg"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(message), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)

        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "ic_notify"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(notifications), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)

        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
    }
    
    @objc func message()
    {
        self.showToast(message: "You have " + msgCount + " messages", font: UIFont.systemFont(ofSize: 15.0))
    }
    
    @objc func notifications()
    {
         self.showToast(message: "You have " + notificationscount + " notifications", font: UIFont.systemFont(ofSize: 15.0))
    }
    
    

    //MARK : Bind Data to View
     private func bindUI() {
           
           self.viewModel?.alertMessage.bind({ [weak self] in
               self?.showAlertDismissOnly(message: $0)
           })
           
           
           self.viewModel?.response.bind({ [weak self] in
               
               if let response = $0 {
                
                if response.status
                {
                self!.scrollView.isHidden = false
                let profileObj : profileResponse = response
                self!.userImageview.downloaded(from: profileObj.data.userImage)
                self!.usernameLabel.text = profileObj.data.userName
                self!.emailLabel.text = profileObj.data.userEmail
                self!.contactLabel.text = profileObj.data.userContact
                self!.addressLabel.text = profileObj.data.userLocation
                self!.descriptionLabel.text = profileObj.data.userDesc
                self!.pincodeLabel.text = profileObj.data.pincode
                self!.portfolioArray = profileObj.data.portfolio
                self!.ratingLabel.text = profileObj.data.userRating
                self!.reviewCountLabel.text = profileObj.data.uesrNoReview
                self!.quotesCompletedLabel.text = profileObj.data.userTotalQuoteCompleted
                self!.msgCount = String(profileObj.messageCount)
                self!.notificationscount = String(profileObj.notificationCount)
                self!.totalQuotesLabel.text = "out of " + profileObj.data.userTotalQuote
                self!.portfolioCollectionView.reloadData()
                }else{
                    self!.showToast(message: "No data found", font: UIFont.systemFont(ofSize: 15.0))
                }
             }
         })
     }

}

//MARK : tableview Delegates & Datasources
extension ProfileViewController : UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PortfolioCollectionViewCell", for: indexPath) as! PortfolioCollectionViewCell
        Alamofire.request(portfolioArray[indexPath.row].portfolioImage).responseImage { response in
            debugPrint(response)

            print(response.request)
            print(response.response)
            debugPrint(response.result)

            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                cell.imageview.image = image

            }
        }
        return cell
    }
    
    
}

