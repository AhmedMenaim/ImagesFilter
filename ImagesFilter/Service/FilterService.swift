//
//  FilterService.swift
//  ImagesFilter
//
//  Created by Crypto on 11/16/20.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    //MARK: - vars & inits
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    //MARK: - Using Observable
    
    func applyFilter(inputImage: UIImage,filterName: String,filterValue:Float, filterKey: String) -> Observable<UIImage> {
        
        return Observable<UIImage>.create{ observer in
            self.applyFilter(image: inputImage, filtername: filterName, filterValue: filterValue, filterKey: filterKey) { filteredImage in
                observer.onNext(filteredImage)
                
            }
            return Disposables.create()
            
        }
        
    }
    
    //MARK: - Filter Func
    private func applyFilter(image: UIImage,filtername: String,filterValue:Float, filterKey: String, completion: @escaping (UIImage)-> ()) {
       let filter = CIFilter(name:filtername)!
        filter.setValue(filterValue, forKey: filterKey) // How much intinsity you wanna in the filter
        if let sourceImage = CIImage(image: image) {
            filter.setValue(sourceImage,forKey: kCIInputImageKey) // Passing the image
            
            if let CgImg = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                let processedImage = UIImage(cgImage: CgImg, scale: image.scale, orientation: image.imageOrientation)
                completion(processedImage)
            }
        }
    }
}
