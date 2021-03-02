//
//  ProfileController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 2.03.2021.
//

import UIKit

class ProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        tableView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        
    }
    
    func createButton(selector : Selector) -> UIButton {
        
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.setTitle("Pick an Image", for: .normal)
        btn.addTarget(self, action: #selector(imgSelectorPressed), for: .touchUpInside)
        return btn
    }
    
    lazy var imgPickerFirst = createButton(selector: #selector(imgSelectorPressed))
    lazy var imgPickerScnd = createButton(selector: #selector(imgSelectorPressed))
    lazy var imgPickerThird = createButton(selector: #selector(imgSelectorPressed))
    
    lazy var imgArea : UIView = {
        
        let imgArea = UIView()
        imgArea.addSubview(imgPickerFirst)
        
        _ = imgPickerFirst.anchor(top: imgArea.topAnchor,
                                  bottom: imgArea.bottomAnchor,
                                  trailing: nil,
                                  leading: imgArea.leadingAnchor,
                                  padding: .init(top: 15, left: 15, bottom: 15, right: 0))
        
        imgPickerFirst.widthAnchor.constraint(equalTo: imgArea.widthAnchor, multiplier: 0.42).isActive = true
        
        let imgPickerSV = UIStackView(arrangedSubviews: [imgPickerScnd,imgPickerThird])
        imgPickerSV.axis = .vertical
        imgPickerSV.distribution = .fillEqually
        imgPickerSV.spacing = 16
      
        imgArea.addSubview(imgPickerSV)
        
        _ = imgPickerSV.anchor(top: imgArea.topAnchor,
                               bottom: imgArea.bottomAnchor,
                               trailing: imgArea.trailingAnchor,
                               leading: imgPickerFirst.trailingAnchor,
                               padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        
        return imgArea
    }()
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
        if section == 0 {
            return imgArea
        }
        
        let lblTitle = LblTitle()
        
        switch section {
        
        case 1 :
            lblTitle.text = "Name"
            
        case 2 :
            lblTitle.text = "Age"
            
        case 3 :
            lblTitle.text = "Job"
       
        case 4 :
            lblTitle.text = "About You"
        
        default:
            lblTitle.text = "***"
        }
        
        return lblTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 320
        }
        
        return 45
    }
    
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileCell(style: .default, reuseIdentifier: nil)
       
        switch indexPath.section {
        
        case 1 :
            cell.textField.placeholder = "John Doe"
            
        case 2 :
            cell.textField.placeholder = "18"
            
        case 3 :
            cell.textField.placeholder = "Astronaut"
       
        case 4 :
            cell.textField.placeholder = "I love to explore planets.How about u?"
        
        default:
            cell.textField.placeholder = "***"
        }
        
        return cell
    }
    
    fileprivate func createNavigation() {
        
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backBtnPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBtnPressed))
    }
    
    @objc fileprivate func logoutBtnPressed() {
      
        print("Logout...")
    }
    
    @objc fileprivate func backBtnPressed() {
        
        dismiss(animated: true)
    }
    
    @objc fileprivate func imgSelectorPressed(btn : UIButton) {
        
        let imgPicker = CustomImagePickerController()
        imgPicker.imgPickerBtn = btn
        imgPicker.delegate = self
        present(imgPicker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let pickedImg = info[.originalImage] as? UIImage
        let imgPickerBtn = (picker as? CustomImagePickerController)?.imgPickerBtn
        imgPickerBtn?.setImage(pickedImg?.withRenderingMode(.alwaysOriginal), for: .normal)
        imgPickerBtn?.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
    
    
}

class CustomImagePickerController : UIImagePickerController {
    var imgPickerBtn : UIButton?
}

class LblTitle : UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 15, dy: 0))
    }
}
