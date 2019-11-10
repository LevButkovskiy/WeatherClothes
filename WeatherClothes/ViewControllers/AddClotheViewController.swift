//
//  AddClotheViewController.swift
//  WeatherClothes
//
//  Created by Lev Butkovskiy on 07/08/2019.
//  Copyright © 2019 Lev Butkovskiy. All rights reserved.
//

import UIKit
import ColorSlider

class AddClotheViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var inventory = Inventory()
    var clothe : Dictionary<String, Any> = [:]
    let imagePicker = UIImagePickerController()
    
    var type = Int()
    var value = String()
    var color = UIColor()
    
    var helpView = UIView()
    var helpViewActive = Bool()
    var colorSlider = ColorSlider()
    
    var height = CGFloat()
    var clothesImages = Array<Any>()
    var imageViews = [UIImageView]()
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var scrollableImages: ScrollableImagesView!
    @IBOutlet weak var conditionsView: UIView!
    
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var temperatureSliderLabel: UILabel!
    @IBOutlet weak var windSlider: UISlider!
    @IBOutlet weak var windSliderLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var colorSwitcher: UISwitch!
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        type = 0
        color = .white
        helpViewActive = false
        typeCollectionView.register(UINib(nibName: "TypeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "typeCell")
        typeCollectionView.tag = 101
        setDefaultSettings()
        
        /*if(!clothe.isNil()){
            clotheImage.image = UIImage(data: (clothe["image"] as! Data))
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func setDefaultSettings(){
        color = .white
        temperatureSliderLabel.text = String(format: "%@: 0°C", "comfortableTemperature".localized)
        windSliderLabel.text = String(format: "%@: 0 %@", "windProtection".localized, "ms".localized)
        colorLabel.text = "color".localized
        navigationController?.navigationBar.isHidden = false
        
        //imagePicker.delegate = self
        let doneButtonImage = UIImage(named: "doneButton")
        let tintedDoneButtonImage = doneButtonImage?.withRenderingMode(.alwaysTemplate)
        doneButton.setImage(tintedDoneButtonImage, for: .normal)
        doneButton.tintColor = .green
        
        let closeButtonImage = UIImage(named: "closeButton")
        let tintedCloseButtonImage = closeButtonImage?.withRenderingMode(.alwaysTemplate)
        closeButton.setImage(tintedCloseButtonImage, for: .normal)
        closeButton.tintColor = .red
        
        setTheme()
    }
    
    func setTheme(){
        var theme = Settings.shared().theme
        if #available(iOS 13, *) {
            theme = self.traitCollection.userInterfaceStyle == UIUserInterfaceStyle.dark
        }
        if(theme){
            view.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            typeCollectionView.backgroundColor = UIColor(red: 52.0/255.0, green: 52.0/255.0, blue: 54.0/255.0, alpha: 1.0)
            conditionsView.backgroundColor = UIColor(red: 41.0/255.0, green: 42.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            temperatureSliderLabel.textColor = .white
            windSliderLabel.textColor = .white
            colorLabel.textColor = .white
        }
        else{
            view.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            typeCollectionView.backgroundColor = .white
            conditionsView.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 249.0/255.0, alpha: 1.0)
            temperatureSliderLabel.textColor = .black
            windSliderLabel.textColor = .black
            colorLabel.textColor = .black
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == typeCollectionView){
            return 4
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = typeCollectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! TypeCollectionViewCell
        if(indexPath.row == 0){
            cell.imageView.image = UIImage(named: "cap_white_default")
        }
        if(indexPath.row == 1){
            cell.imageView.image = UIImage(named: "tshirt_white_default")
        }
        if(indexPath.row == 2){
            cell.imageView.image = UIImage(named: "pants_white_default")
        }
        if(indexPath.row == 3){
            cell.imageView.image = UIImage(named: "sneakers_white_default")
        }
        cell.imageView.backgroundColor = .lightGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TypeCollectionViewCell
        colorSwitcher.isEnabled = true
        type = indexPath.row
        generateImagesForScrollableView(with: color, toFirst: true)
        deselectAll(collectionView: typeCollectionView)
        cell.imageView.backgroundColor = .blue
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        self.color = slider.color
        self.generateImagesForScrollableView(with: self.color, toFirst: false)
    }
    
    
    func deselectAll(collectionView: UICollectionView){
        for i in 0..<typeCollectionView.numberOfItems(inSection: 0){
            let cell = typeCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! TypeCollectionViewCell
            cell.imageView.backgroundColor = .lightGray
        }
    }
    
    func generateImagesForScrollableView(with color: UIColor, toFirst: Bool){
        var array = Array<Dictionary<String, Any>>()
        switch type {
        case 0:
            array.append(inventory.generateImage(imageName: "cap" , color: color))
            array.append(inventory.generateImage(imageName: "hat" , color: color))
        case 1:
            array.append(inventory.generateImage(imageName: "tshirt" , color: color))
            array.append(inventory.generateImage(imageName: "windbreaker" , color: color))
            array.append(inventory.generateImage(imageName: "insulatedjacket" , color: color))
        case 2:
            array.append(inventory.generateImage(imageName: "pants" , color: color))
            array.append(inventory.generateImage(imageName: "shorts" , color: color))
        case 3:
            array.append(inventory.generateImage(imageName: "winterShoes" , color: color))
            array.append(inventory.generateImage(imageName: "sneakers" , color: color))
            //array.append(generateImage(imageName: "slippers" , color: color))

        default:
            break;
        }
        scrollableImages.setImages(clothesImageViews: array)
        scrollableImages.update(toFirst: toFirst)
    }
    
    @IBAction func colorSwitcherValueChanged(_ sender: Any) {
        color = .white
        if(colorSwitcher.isOn){
            colorSlider = ColorSlider(orientation: .horizontal, previewSide: .top)
            colorSlider.frame = CGRect(x: 20, y: colorSwitcher.frame.maxY + 10, width: view.frame.width - 40, height: 12)
            view.addSubview(colorSlider)
            colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: [.touchUpInside, .touchUpOutside])
        }
        else{
            colorSlider.removeFromSuperview()
            generateImagesForScrollableView(with: .white, toFirst: false)
        }
    }
    
    @IBAction func temperatureSliderChanged(_ sender: Any) {
        temperatureSliderLabel.text = String(format: "%@: %d°C", "comfortableTemperature".localized, Int(temperatureSlider.value))
    }
    
    @IBAction func windSliderChanged(_ sender: Any) {
        windSliderLabel.text = String(format: "%@: %d %@", "windProtection".localized, Int(windSlider.value), "ms".localized)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if(colorSwitcher.isEnabled){
            saveAction()
        }
        else{
            showHelpView(text: "chooseClotheType".localized)
        }

    }
    
    @IBAction func closeButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showHelpView(text: String){
        if(!helpViewActive){
            helpViewActive = true
            self.helpView.frame = CGRect(x: self.closeButton.frame.maxX + 20, y: -20, width: self.doneButton.frame.minX - 50 - self.closeButton.frame.width, height: 20)
            let button = UIButton()
            button.frame = self.helpView.frame
            button.setTitle(text, for: .normal)
            helpView.backgroundColor = .red
            helpView.layer.cornerRadius = 10
            view.addSubview(helpView)
            view.addSubview(button)
            UIView.animate(withDuration: 0.5, animations: {
                self.helpView.frame = CGRect(x: self.closeButton.frame.maxX + 20, y: self.closeButton.frame.minY + 7.5, width: self.doneButton.frame.minX - 50 - self.closeButton.frame.width, height: 20)
                button.frame = self.helpView.frame
            }) { (true) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    UIView.animate(withDuration: 0.5, animations: {
                        self.helpView.frame = CGRect(x: self.closeButton.frame.maxX + 20, y: -20, width: self.doneButton.frame.minX - 50 - self.closeButton.frame.width, height: 20)
                        button.frame = self.helpView.frame
                    }, completion: { (true) in
                        self.helpViewActive = false
                    })
                }
            }
        }
    }
    
    func saveAction(){
        let alert = UIAlertController(title: "addingClothes".localized, message: "enterClotheName".localized, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "save".localized , style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if(textField.text != ""){
                let imageName = self.scrollableImages.getClotheName()
                let color = self.scrollableImages.getClotheColor()
                let clothe = Clothe(name: textField.text!, imageName: imageName, color: color, type: self.type, temperature: Int(self.temperatureSlider.value), wind: Int(self.windSlider.value))
                self.inventory.add(clothe: clothe)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showHelpView(text: "emptyName".localized)
            }
        }
        let closeAction = UIAlertAction(title: "cancel".localized, style: .cancel) { (alertAction) in
        }
        alert.addTextField { (textField) in
            textField.placeholder = "clotheName".localized
            textField.autocapitalizationType = .sentences
        }
        alert.addAction(action)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    /*func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
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
