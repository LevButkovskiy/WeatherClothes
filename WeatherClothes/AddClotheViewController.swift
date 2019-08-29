//
//  AddClotheViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 07/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit

class AddClotheViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var inventory = Inventory()
    var clothe : Dictionary<String, Any> = [:]
    let imagePicker = UIImagePickerController()
    
    var name : String = ""
    var type : String = "Головной убор"
    
    @IBOutlet weak var clotheImage: UIImageView!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var nameTextInput: UITextField!
    @IBOutlet weak var windSlider: UISlider!
    @IBOutlet weak var windSliderLabel: UILabel!
    @IBOutlet weak var comfortTemperatureSlider: UISlider!
    @IBOutlet weak var comfortTemperatureSliderLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var minWindLabel: UILabel!
    @IBOutlet weak var maxWindLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var clotheTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultSettings()
        if(!clothe.isNil()){
            type = inventory.getTypeNameFromIndex(index: clothe["type"] as! Int)
            name = (clothe["name"] as! String)
            typePicker.selectRow(clothe["type"] as! Int, inComponent: 0, animated: false)
            nameTextInput.text = (clothe["name"] as! String)
            windSlider.value = clothe["wind"] as! Float
            comfortTemperatureSlider.value = clothe["temperature"] as! Float
            clotheImage.image = UIImage(data: (clothe["image"] as! Data))
            comfortTemperatureSliderLabel.text = String(format: "Комфортная температура: %d˙C", Int(comfortTemperatureSlider.value))
            windSliderLabel.text = String(format: "Ветрозащита: %d м/с", Int(windSlider.value))
        }
    }
    
    func setDefaultSettings(){        
        navigationController?.navigationBar.isHidden = false

        saveButton.layer.cornerRadius = 10
        saveButton.backgroundColor = .green
        clotheImage.layer.cornerRadius = 10
        comfortTemperatureSlider.minimumValue = -30
        comfortTemperatureSlider.maximumValue = 30
        comfortTemperatureSlider.value = 0
        windSlider.minimumValue = 0
        windSlider.maximumValue = 10
        windSlider.value = 0
        typePicker.selectRow(0, inComponent: 0, animated: false)
        
        imagePicker.delegate = self
        self.nameTextInput.delegate = self
        checkTheme()
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
        nameLabel.textColor = .white
        minWindLabel.textColor = .white
        maxWindLabel.textColor = .white
        minTemperatureLabel.textColor = .white
        maxTemperatureLabel.textColor = .white
        clotheTypeLabel.textColor = .white
        windSliderLabel.textColor = .white
        comfortTemperatureSliderLabel.textColor = .white
    }
    
    func setLightTheme(){
        view.backgroundColor = .groupTableViewBackground
        nameLabel.textColor = .black
        minWindLabel.textColor = .black
        maxWindLabel.textColor = .black
        minTemperatureLabel.textColor = .black
        maxTemperatureLabel.textColor = .black
        clotheTypeLabel.textColor = .black
        windSliderLabel.textColor = .black
        comfortTemperatureSliderLabel.textColor = .black
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
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
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        type = inventory.getTypeNameFromIndex(index: row)
    }
    
    @IBAction func nameTextInputValueChanged(_ sender: Any) {
        name = nameTextInput.text!
    }
    
    @IBAction func nameTextInputEditingEnd(_ sender: Any) {
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
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if(!clothe.isNil()){
            inventory.remove(item: clothe)
        }
        var newItem = Dictionary<String, Any>()
        newItem["name"] = name
        newItem["image"] = clotheImage.image!.jpegData(compressionQuality: 0.1)
        newItem["type"] = inventory.getIndexForTypeName(type: type)
        newItem["temperature"] = Int(comfortTemperatureSlider.value)
        newItem["wind"] = Int(windSlider.value)
        inventory.add(item: newItem)
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: ImagePicker
    @IBAction func addPhoto(_ sender: Any){
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
    }
}

extension UIImage
{
    // convenience function in UIImage extension to resize a given image
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage
    {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copied!
    }
}
