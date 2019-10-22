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
    
    var loadingView = UIView()
    var helpView = UIView()
    var helpViewActive = Bool()
    var colorSlider = ColorSlider()
    
    var height = CGFloat()
    var clothesImages = Array<Any>()
    var imageViews = [UIImageView]()
    
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var scrollableImages: ScrollableImagesView!
    
    
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var temperatureSliderLabel: UILabel!
    @IBOutlet weak var windSlider: UISlider!
    @IBOutlet weak var windSliderLabel: UILabel!
    
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
    
    func setImageColor(imageView: UIImageView, color: UIColor) {
        imageView.image = UIImage(named: "tshirt_gen1")
        var overlayedImage = ((UIImage(named: "tshirt_gen2")))
        overlayedImage = overlayedImage?.tinted(with: color)
        imageView.image = imageView.image!.imageOverlayingImages([overlayedImage!])
        closeLoadingView()
    }
    
    func generateImageView(imageName: String, color: UIColor) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: String(format: "%@_back", imageName))
        var overlayedImage = UIImage(named: String(format: "%@_top", imageName))
        overlayedImage = overlayedImage?.tinted(with: color)
        imageView.image = imageView.image!.imageOverlayingImages([overlayedImage!])
        closeLoadingView()
        return imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func showLoadingView(){
        loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        loadingView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: self.view.frame.width - 25, y: self.view.frame.height - 25, width: 50, height: 50)
        view.addSubview(loadingView)
        spinner.startAnimating()
        loadingView.addSubview(spinner)
    }
    
    func closeLoadingView(){
        loadingView.removeFromSuperview()
    }
    
    func setDefaultSettings(){
        color = .white
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! TypeCollectionViewCell
        colorSwitcher.isEnabled = true
        type = indexPath.row
        generateImagesForScrollableView(with: color, toFirst: true)
        deselectAll(collectionView: typeCollectionView)
        cell.imageView.backgroundColor = .blue
    }
    
    @objc func changedColor(_ slider: ColorSlider) {
        showLoadingView()
        color = slider.color
        generateImagesForScrollableView(with: color, toFirst: false)
    }
    
    func deselectAll(collectionView: UICollectionView){
        for i in 0..<typeCollectionView.numberOfItems(inSection: 0){
            let cell = typeCollectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! TypeCollectionViewCell
            cell.imageView.backgroundColor = .lightGray
        }
    }
    
    func generateImagesForScrollableView(with color: UIColor, toFirst: Bool){
        var array = Array<UIImageView>()

        switch type {
        case 0:
            array.append(generateImageView(imageName: "cap" , color: color))
            array.append(generateImageView(imageName: "hat" , color: color))
        case 1:
            array.append(generateImageView(imageName: "tshirt" , color: color))
            array.append(generateImageView(imageName: "windbreaker" , color: color))
        case 2:
            array.append(generateImageView(imageName: "shorts" , color: color))
            array.append(generateImageView(imageName: "pants" , color: color))
        case 3:
            array.append(generateImageView(imageName: "slippers" , color: color))
            array.append(generateImageView(imageName: "sneakers" , color: color))
            array.append(generateImageView(imageName: "winterShoes" , color: color))

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
            //colorSlider.addTarget(self, action: #selector(changeColor(slider:event:)), for: .valueChanged)
            colorSlider.addTarget(self, action: #selector(changedColor(_:)), for: [.touchUpInside, .touchUpOutside])
        }
        else{
            colorSlider.removeFromSuperview()
            generateImagesForScrollableView(with: .white, toFirst: false)
        }
    }
    
    @IBAction func temperatureSliderChanged(_ sender: Any) {
        /*if(temperatureSlider.value <= -30){
            temperatureSlider.tintColor = UIColor(red:0.04, green:0.00, blue:0.23, alpha:1.0)
        }
        else if(temperatureSlider.value > -30 && temperatureSlider.value <= -25){
            temperatureSlider.tintColor = UIColor(red:0.00, green:0.00, blue:0.35, alpha:1.0)
        }
        else if(temperatureSlider.value > -25 && temperatureSlider.value <= -20){
            temperatureSlider.tintColor = UIColor(red:0.04, green:0.27, blue:0.85, alpha:1.0)
        }
        else if(temperatureSlider.value > -20 && temperatureSlider.value <= -15){
            temperatureSlider.tintColor = UIColor(red:0.04, green:0.58, blue:0.85, alpha:1.0)
        }
        else if(temperatureSlider.value > -15 && temperatureSlider.value <= -10){
            temperatureSlider.tintColor = UIColor(red:0.03, green:0.65, blue:0.96, alpha:1.0)
        }
        else if(temperatureSlider.value > -10 && temperatureSlider.value <= -5){
            temperatureSlider.tintColor = UIColor(red:0.26, green:0.73, blue:0.96, alpha:1.0)
        }
        else if(temperatureSlider.value > -5 && temperatureSlider.value <= 0){
            temperatureSlider.tintColor = UIColor(red:0.54, green:0.80, blue:0.94, alpha:1.0)
        }
        else if(temperatureSlider.value > 0 && temperatureSlider.value <= 5){
            temperatureSlider.tintColor = UIColor(red:1.00, green:1.00, blue:0.75, alpha:1.0)
        }
        else if(temperatureSlider.value > 5 && temperatureSlider.value <= 10){
            temperatureSlider.tintColor = UIColor(red:1.00, green:0.91, blue:0.48, alpha:1.0)
        }
        else if(temperatureSlider.value > 10 && temperatureSlider.value <= 15){
            temperatureSlider.tintColor = UIColor(red:0.97, green:0.63, blue:0.13, alpha:1.0)
        }
        else if(temperatureSlider.value > 15 && temperatureSlider.value <= 20){
            temperatureSlider.tintColor = UIColor(red:0.97, green:0.41, blue:0.13, alpha:1.0)
        }
        else if(temperatureSlider.value > 20 && temperatureSlider.value <= 25){
            temperatureSlider.tintColor = UIColor(red:0.97, green:0.28, blue:0.13, alpha:1.0)
        }
        else if(temperatureSlider.value > 25 && temperatureSlider.value <= 30){
            temperatureSlider.tintColor = UIColor(red:0.97, green:0.13, blue:0.13, alpha:1.0)
        }
        else if(temperatureSlider.value > 30){
            temperatureSlider.tintColor = UIColor(red:0.80, green:0.00, blue:0.00, alpha:1.0)
        }*/
        
        temperatureSliderLabel.text = String(format: "Комфортная температура: %d°C", Int(temperatureSlider.value))
    }
    
    @IBAction func windSliderChanged(_ sender: Any) {
        windSliderLabel.text = String(format: "Ветрозащита: %d м/с", Int(windSlider.value))
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if(colorSwitcher.isEnabled){
            saveAction()
        }
        else{
            showHelpView(text: "Выберите тип одежды")
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
        let alert = UIAlertController(title: "Добавление одежды", message: "Введите название одежды", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Сохранить", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if(textField.text != ""){
                let clothe = Clothe()
                let image = self.scrollableImages.getImageWithIndex()
                clothe.set(name: textField.text!, image: image, type: self.type, temperature: Int(self.temperatureSlider.value), wind: Int(self.windSlider.value))
                self.inventory.add(clothe: clothe)
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.showHelpView(text: "Название не может быть пустым")
            }
        }
        let closeAction = UIAlertAction(title: "Отмена", style: .cancel) { (alertAction) in
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Название одежды"
        }
        alert.addAction(action)
        alert.addAction(closeAction)
        present(alert, animated: true, completion: nil)
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
    
    typealias RectCalculationClosure = (_ parentSize: CGSize, _ newImageSize: CGSize)->(CGRect)
    
    func with(image named: String, rectCalculation: RectCalculationClosure) -> UIImage {
        return with(image: UIImage(named: named), rectCalculation: rectCalculation)
    }
    
    func tinted(with color: UIColor) -> UIImage? {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { _ in
            color.set()
            withRenderingMode(.alwaysTemplate).draw(at: .zero)
        }
    }
    
    func with(image: UIImage?, rectCalculation: RectCalculationClosure) -> UIImage {
        
        if let image = image {
            UIGraphicsBeginImageContext(size)
            
            draw(in: CGRect(origin: .zero, size: size))
            image.draw(in: rectCalculation(size, image.size))
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        return self
    }
    
    func imageOverlayingImages(_ images: [UIImage], scalingBy factors: [CGFloat]? = nil) -> UIImage {
        let size = self.size
        let container = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        UIGraphicsGetCurrentContext()!.interpolationQuality = .high
        
        self.draw(in: container)
        
        let scaleFactors = factors ?? [CGFloat](repeating: 1.0, count: images.count)
        
        for (image, scaleFactor) in zip(images, scaleFactors) {
            let topWidth = size.width / scaleFactor
            let topHeight = size.height / scaleFactor
            let topX = (size.width / 2.0) - (topWidth / 2.0)
            let topY = (size.height / 2.0) - (topHeight / 2.0)
            
            image.draw(in: CGRect(x: topX, y: topY, width: topWidth, height: topHeight), blendMode: .normal, alpha: 1.0)
        }
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        let coloredImage = UIImage(cgImage: cgImage!)
        return coloredImage
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    class func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}
    
extension UIImageView {
    
    enum ImageAddingMode {
        case changeOriginalImage
        case addSubview
    }
    
    func drawOnCurrentImage(anotherImage: UIImage?, mode: ImageAddingMode, rectCalculation: UIImage.RectCalculationClosure) {
        
        guard let image = image else {
            return
        }
        
        switch mode {
        case .changeOriginalImage:
            self.image = image.with(image: anotherImage, rectCalculation: rectCalculation)
            
        case .addSubview:
            let newImageView = UIImageView(frame: rectCalculation(frame.size, image.size))
            newImageView.image = anotherImage
            addSubview(newImageView)
        }
    }
}
