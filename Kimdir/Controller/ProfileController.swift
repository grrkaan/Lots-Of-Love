//
//  ProfileController.swift
//  Kimdir
//
//  Created by Kaan Sercan Görür on 2.03.2021.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class ProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        tableView.backgroundColor = UIColor(white: 0.2, alpha: 1)
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .interactive
        getUserProfileDatas()
        
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
            
        case 5 :
            lblTitle.text = "Age Range"
            
        default:
            lblTitle.text = "***"
        }
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
        return lblTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 320
        }
        
        return 45
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 5 {
            let ageCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            
            ageCell.minSlider.addTarget(self, action: #selector(minSliderChanged), for: .valueChanged)
            ageCell.maxSlider.addTarget(self, action: #selector(maxSliderChanged), for: .valueChanged)
            ageCell.lblMin.text = "Min \(currentUser?.minAge ?? 18)"
            ageCell.lblMax.text = "Min \(currentUser?.maxAge ?? 65)"
            ageCell.minSlider.value = Float(currentUser?.minAge ?? 18)
            ageCell.maxSlider.value = Float(currentUser?.maxAge ?? 65)
            return ageCell
        }
            
        
        let cell = ProfileCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        
        case 1 :
            cell.textField.placeholder = "John Doe"
            cell.textField.text = currentUser?.userName
            cell.textField.addTarget(self, action: #selector(catchUserNameEdit), for: .editingChanged)
            
        case 2 :
            cell.textField.placeholder = "18"
            cell.textField.keyboardType = .numberPad
            if let age = currentUser?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(catchAgeEdit), for: .editingChanged)
            
        case 3 :
            cell.textField.placeholder = "Astronaut"
            cell.textField.text = currentUser?.job
            cell.textField.addTarget(self, action: #selector(catchJobEdit), for: .editingChanged)
        case 4 :
            cell.textField.placeholder = "I love to explore planets.How about u?"
            
        default:
            cell.textField.placeholder = "***"
        }
        
        
        
        
        return cell
    }
    
    @objc fileprivate func minSliderChanged(slider : UISlider) {
        editMinMax()
    }
    
    @objc fileprivate func maxSliderChanged(slider : UISlider) {
        editMinMax()
    }
    
    fileprivate func editMinMax() {
        
        guard let ageCell = tableView.cellForRow(at: [5,0]) as? AgeRangeCell else { return }
        
        let minAge = Int(ageCell.minSlider.value)
        var maxAge = Int(ageCell.maxSlider.value)
        maxAge = max(minAge,maxAge)
        
        ageCell.maxSlider.value = Float(maxAge)
        ageCell.lblMin.text = "Min \(minAge)"
        ageCell.lblMax.text = "Max \(maxAge)"
        
        currentUser?.minAge = minAge
        currentUser?.maxAge = maxAge
    }
    
    fileprivate func createNavigation() {
        
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backBtnPressed))
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBtnPressed)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveBtnPressed))
        ]
    }
    
    @objc fileprivate func catchUserNameEdit(txtfield : UITextField) {
        self.currentUser?.userName = txtfield.text
    }
    
    @objc fileprivate func catchAgeEdit(txtfield : UITextField) {
        self.currentUser?.age = Int(txtfield.text ?? "")
    }
    
    @objc fileprivate func catchJobEdit(txtfield : UITextField) {
        self.currentUser?.job = txtfield.text
    }
    
    
    @objc fileprivate func saveBtnPressed() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let datas : [String : Any] = [
            "UserId" : uid,
            "UserName" : currentUser?.userName ?? "",
            "Age" : currentUser?.age ?? -1,
            "Job" : currentUser?.job ?? "",
            "ImgUrlFirst" : currentUser?.profileImgUrlFirst ?? "",
            "ImgUrlScnd" : currentUser?.profileImgUrlScnd ?? "",
            "ImgUrlThird" : currentUser?.profileImgUrlThird ?? "",
            "MinAge" : currentUser?.minAge ?? -1,
            "MaxAge" : currentUser?.maxAge ?? -1
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Profile"
        hud.show(in: view)
        
        Firestore.firestore().collection("Users").document(uid).setData(datas) { (error) in
            hud.dismiss()
            if let error = error {
                print(error)
                return
            }
        }
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
        
        
        let imgName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(imgName)")
        guard let data = pickedImg?.jpegData(compressionQuality: 0.8) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading Images"
        hud.show(in: view)
        
        ref.putData(data,metadata: nil) { (nil, error) in
            
            if let error = error {
                hud.dismiss()
                print(error)
                return
            }
            
            ref.downloadURL { (url , error) in
                hud.dismiss()
                if let error = error {
                    print(error)
                    return
                }
                
                if imgPickerBtn == self.imgPickerFirst {
                    self.currentUser?.profileImgUrlFirst = url?.absoluteString
                }else if imgPickerBtn == self.imgPickerScnd {
                    self.currentUser?.profileImgUrlScnd = url?.absoluteString
                }else {
                    self.currentUser?.profileImgUrlThird = url?.absoluteString
                }
                
            }
        }
        
        
    }
    
    var currentUser : User?
    fileprivate func getUserProfileDatas() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot , error) in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let datas = snapshot?.data() else { return }
            self.currentUser = User(datas: datas)
            self.getProfileImg()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func getProfileImg() {
        
        if let imgUrl = currentUser?.profileImgUrlFirst , let url = URL(string: imgUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                
                self.imgPickerFirst.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imgUrl = currentUser?.profileImgUrlScnd , let url = URL(string: imgUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                
                self.imgPickerScnd.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imgUrl = currentUser?.profileImgUrlThird , let url = URL(string: imgUrl) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                
                self.imgPickerThird.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
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
