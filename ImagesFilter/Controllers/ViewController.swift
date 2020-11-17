//
//  ViewController.swift
//  ImagesFilter
//
//  Created by Crypto on 11/15/20.
//

import UIKit
import RxSwift
class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var imageViewOutletFilterImage: UIImageView!
    @IBOutlet weak var buttonApplyHalftoneFilterOutlet: UIButton!
    @IBOutlet weak var buttonApplyBlurFilterOutlet: UIButton!
    @IBOutlet weak var buttonRemoveFilterOutlet: UIButton!
    @IBOutlet weak var buttonApplyFilterOutlet: UIButton!
    @IBOutlet weak var filtersStackViewOutlet: UIStackView!
    //MARK: - Dispose
    let disposeBag = DisposeBag()
    var myImage = UIImage()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Passing the Image
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navigationController = segue.destination as? UINavigationController, let imagesCollectionView = navigationController.viewControllers.first as? ImagesCollectionViewController
        else {
            fatalError("Segue destination not found")
        }
        imagesCollectionView.selectedPhoto.subscribe(onNext: { [weak self] image in
            DispatchQueue.main.async {
                self?.updateUI(with: image)
                self!.myImage = image
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - UpdateUI
    private func updateUI(with image: UIImage) {
        self.imageViewOutletFilterImage.image = image
        self.buttonApplyFilterOutlet.isHidden = false
        self.buttonRemoveFilterOutlet.isHidden = false
    }
    
    //MARK: - Set Filter Func
    func applyFilter(filterName: String, filterValue: Float, filterKey: String) {
        guard let sourceImage = imageViewOutletFilterImage.image else {return}
        FilterService().applyFilter(inputImage: sourceImage, filterName: filterName ,filterValue: filterValue,filterKey: filterKey).subscribe(onNext: { filteredImage in
            DispatchQueue.main.async {
                self.imageViewOutletFilterImage.image = filteredImage
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    //MARK: - Apply Or Remove Filters
    
    @IBAction func buttonApplyFilterAction(_ sender: Any) {
        filtersStackViewOutlet.isHidden = false
    }
    
    @IBAction func buttonRemoveFiltersAction(_ sender: Any) {
        filtersStackViewOutlet.isHidden = true
        updateUI(with: myImage)
        
        
    }
    //MARK: - Filters Actions
    @IBAction func buttonApplyHalftoneFilterAction(_ sender: Any) {
        applyFilter(filterName: "CICMYKHalftone", filterValue: 5.0, filterKey: kCIInputWidthKey)
    }
    
    @IBAction func buttonApplyBlurFilterAction(_ sender: Any) {
        applyFilter(filterName: "CIBoxBlur", filterValue: 8.0, filterKey: kCIInputRadiusKey)
    }
    
    @IBAction func buttonApplyBrightnessFilterAction(_ sender: Any) {
        applyFilter(filterName: "CIColorControls", filterValue: 1.0, filterKey: kCIInputBrightnessKey)
        applyFilter(filterName: "CIColorControls", filterValue: 1.0, filterKey: kCIInputContrastKey)
        applyFilter(filterName: "CIColorControls", filterValue: 1.0, filterKey: kCIInputSaturationKey)
    }
    
    @IBAction func buttonApplyEdgesFilterAction(_ sender: Any) {
        applyFilter(filterName: "CIEdges", filterValue: 1.0, filterKey: kCIInputIntensityKey)
    }
    
    @IBAction func buttonApplySharpnessFilterAction(_ sender: Any) {
        applyFilter(filterName: "CISharpenLuminance", filterValue: 1.0, filterKey: kCIInputSharpnessKey)
    }
}
