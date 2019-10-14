//
//  AddClotheViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 07/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class AddClotheViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var inventory = Inventory()
    var clothe : Dictionary<String, Any> = [:]
    let imagePicker = UIImagePickerController()
    
    var type = Int()
    var value = String()
    var color = UIColor()
    
    var height = CGFloat()
    var clothesImages = Array<Any>()
    var imageViews = [UIImageView]()

    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var scrollableImages: ScrollableImagesView!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var colorSwitcher: UISwitch!
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = 0
        color = .white
        typeCollectionView.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "typeCell")
        colorCollectionView.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "colorCell")
        typeCollectionView.tag = 101
        colorCollectionView.tag = 102
        setDefaultSettings()
        /*if(!clothe.isNil()){
            type = inventory.getTypeNameFromIndex(index: clothe["type"] as! Int)
            name = (clothe["name"] as! String)
            nameTextInput.text = (clothe["name"] as! String)
            windSlider.value = clothe["wind"] as! Float
            comfortTemperatureSlider.value = clothe["temperature"] as! Float
            clotheImage.image = UIImage(data: (clothe["image"] as! Data))
            comfortTemperatureSliderLabel.text = String(format: "Комфортная температура: %d˙C", Int(comfortTemperatureSlider.value))
            windSliderLabel.text = String(format: "Ветрозащита: %d м/с", Int(windSlider.value))
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func setDefaultSettings(){
        color = .white
        colorCollectionView.isHidden = true
        navigationController?.navigationBar.isHidden = false
        
        //imagePicker.delegate = self
        //self.nameTextInput.delegate = self
        let doneButtonImage = UIImage(named: "doneButton")
        let tintedDoneButtonImage = doneButtonImage?.withRenderingMode(.alwaysTemplate)
        doneButton.setImage(tintedDoneButtonImage, for: .normal)
        doneButton.tintColor = .green
        
        let closeButtonImage = UIImage(named: "closeButton")
        let tintedCloseButtonImage = closeButtonImage?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(tintedCloseButtonImage, for: .normal)
        closeButton.tintColor = .red
    }
    
    func checkTheme(){
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
            if(theme){
                setDarkTheme()
            }
            else{
                setLightTheme()
            }
        }
    }
    
    func setDarkTheme(){
        view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
    }
    
    func setLightTheme(){
        view.backgroundColor = .groupTableViewBackground
    }
    
    func setColors() -> Array<UIColor>{
        var colors = Array<UIColor>()
        colors.append(.white)
        colors.append(.red)
        colors.append(.green)
        colors.append(.blue)
        colors.append(.yellow)
        colors.append(.purple)
        colors.append(.gray)
        colors.append(.black)
        return colors
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == typeCollectionView){
            return 4
        }
        else if(collectionView == colorCollectionView){
            return setColors().count
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == typeCollectionView){
            let cell = typeCollectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! TypeCollectionViewCell
            if(indexPath.row == 0){
                cell.imageView.image = UIImage(named: "cap_white")
            }
            if(indexPath.row == 1){
                cell.imageView.image = UIImage(named: "tshirt_white")
            }
            if(indexPath.row == 2){
                cell.imageView.image = UIImage(named: "pants_white")
            }
            if(indexPath.row == 3){
                cell.imageView.image = UIImage(named: "sneakers_white")
            }
            cell.imageView.backgroundColor = .lightGray
            return cell
        }
        else{
            let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
            cell.frame.size = CGSize(width: 30, height: 30)
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = cell.frame.width / 2
            let colors = setColors()
            cell.backgroundColor = colors[indexPath.row]
            cell.imageView.backgroundColor = colors[indexPath.row]
            if(!colors.contains(color)){
                let firstCell = colorCollectionView.cellForItem(at: IndexPath(row: 0, section: 0))
                firstCell?.layer.borderColor = UIColor.blue.cgColor
            }
            else{
                if(cell.imageView.backgroundColor == color){
                    cell.layer.borderColor = UIColor.blue.cgColor
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == typeCollectionView){
            let cell = collectionView.cellForItem(at: indexPath) as! TypeCollectionViewCell
            colorSwitcher.isEnabled = true
            type = indexPath.row
            generateImagesForScrollableView(with: color, toFirst: true)
            deselectAll(collectionView: typeCollectionView)
            cell.imageView.backgroundColor = .blue
            colorCollectionView.reloadData()
        }
        else{
            let cell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
            color = cell.imageView.backgroundColor!
            generateImagesForScrollableView(with: color, toFirst: false)
            deselectAll(collectionView: colorCollectionView)
            cell.layer.borderColor = UIColor.blue.cgColor
        }
    }
    
    func deselectAll(collectionView: UICollectionView){
        if(collectionView == typeCollectionView){
            for i in 0..<typeCollectionView.numberOfItems(inSection: 0){
                let cell = typeCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! TypeCollectionViewCell
                cell.imageView.backgroundColor = .lightGray
            }
        }
        else{
            for i in 0..<colorCollectionView.numberOfItems(inSection: 0){
                let cell = colorCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! ColorCollectionViewCell
                cell.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    func generateImagesForScrollableView(with color: UIColor, toFirst: Bool){
        var array = Array<UIImage>()
        switch type {
        case 0:
            array.append(UIImage.init(named: String(format: "%@_%@", "cap", color.name!))!)
            array.append(UIImage.init(named: String(format: "%@_%@", "hat", color.name!))!)
        case 1:
            array.append(UIImage.init(named: String(format: "%@_%@", "tshirt", color.name!))!)
            array.append(UIImage.init(named: String(format: "%@_%@", "windBreaker", color.name!))!)
        case 2:
            array.append(UIImage.init(named: String(format: "%@_%@", "pants", color.name!))!)
            array.append(UIImage.init(named: String(format: "%@_%@", "tshirt", color.name!))!)
        case 3:
            array.append(UIImage.init(named: String(format: "%@_%@", "sneakers", color.name!))!)
            array.append(UIImage.init(named: String(format: "%@_%@", "tshirt", color.name!))!)
        default:
            break;
        }
        scrollableImages.setImages(clothes: array)
        scrollableImages.update(toFirst: toFirst)
    }
    
    @IBAction func colorSwitcherValueChanged(_ sender: Any) {
        color = .white
        colorCollectionView.reloadData()
        if(colorSwitcher.isOn){
            colorCollectionView.isHidden = false
        }
        else{
            colorCollectionView.isHidden = true
        }
    }

    @IBAction func saveButton(_ sender: Any) {
        let clothe = Clothe()
        let imageNamed = String(format: "%@_%@", inventory.getTypeNameFromIndex(type: type, index: scrollableImages.index), color.name!)
        clothe.set(name: "Name", imageNamed: imageNamed, type: type, temperature: -30, wind: 12)
        inventory.add(clothe: clothe)
        navigationController?.popViewController(animated: true)
    }
    
    
    
    /*func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string = inventory.getTypeNameFromIndex(index: row)
        if let unarchivedObject = UserDefaults.standard.object(forKey: "theme") as? NSData {
            let theme = (NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data) as! Bool)
            if(theme){
                return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 17.0)!])
            }
            else{
                return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 17.0)!])
            }
        }
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 17.0)!])
    }*/
    
    /*@IBAction func nameTextInputValueChanged(_ sender: Any) {
        name = nameTextInput.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false;
    }
    
    @IBAction func windSliderValueChanged(_ sender: Any) {
        windSliderLabel.text = String(format: "Ветрозащита: %d м/с", Int(windSlider.value))
    }
    
    @IBAction func comfortTemperatureSliderValueChanged(_ sender: Any) {
        comfortTemperatureSliderLabel.text = String(format: "Комфортная температура: %d˙C", Int(comfortTemperatureSlider.value))
    }*/
    
    
    //MARK: ImagePicker
    /*@IBAction func addPhoto(_ sender: Any){
        let alert = UIAlertController(title: "Выбрать изображение", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler:{ _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler:{ _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom{
        case .pad:
            alert.popoverPresentationController?.sourceView = (sender as! UIView)
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Ошибка", message: "У вас нет камеры", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let resizedImage = pickedImage.convert(toSize:CGSize(width:200.0, height:200.0), scale: UIScreen.main.scale)
            clotheImage.contentMode = .scaleAspectFit
            clotheImage.image = resizedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }*/
}

extension UIImage {
    
    func outline() -> UIImage? {
        
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: rect, blendMode: .normal, alpha: 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(red: 1.0, green: 0.5, blue: 1.0, alpha: 1.0)
        context?.setLineWidth(5.0)
        context?.stroke(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
        
    }
    
}
