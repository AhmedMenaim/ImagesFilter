//
//  CollectionViewController.swift
//  ImagesFilter
//
//  Created by Crypto on 11/15/20.
//

import UIKit
import RxSwift
import Foundation
import Photos

private let reuseIdentifier = "ImageCell"

class ImagesCollectionViewController: UICollectionViewController {
    
    //MARK: - vars
    private var images = [PHAsset]()
    private var selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        linkPhotosLibrary()
        self.title = "Pick an Image"
        
    }
    //MARK: - PhotoLibrary
    private func linkPhotosLibrary() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image,options: nil)
                assets.enumerateObjects { (object, count, stop) in
                    self?.images.append(object)
                }
                self?.images.reverse()
                DispatchQueue.main.async {
                self?.collectionView.reloadData()
                }
            }
            
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        
        let asset = images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 200,height: 200), contentMode: .aspectFit, options: nil) { image, _ in
            
            DispatchQueue.main.async {
                cell.imageViewOutlet.image = image
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedAsset = images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 500, height: 500), contentMode: .aspectFit, options: nil) { [weak self] image , info in
            guard let info = info else {return}
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            // as we will call this function 2 times one for the small image in the collection and one here that's why we use it as this will tell us if the image is thumbnail or original image
            if !isDegradedImage {
                
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    
}

