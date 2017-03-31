//
//  PhotoSelectController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/30/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController {
  
  let cellId = "cellId"
  let headerId = "headerId"
  
  var images = [UIImage]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .yellow
    
    setupNavigationButtons()
    
    collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    
    fetchPhotos()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  fileprivate func setupNavigationButtons() {
    navigationController?.navigationBar.tintColor = .black
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
  }
  
  // MARK: - Handles
  
  func handleCancel() {
    dismiss(animated: true, completion: nil)
  }
  
  func handleNext() {
    print("handling next")
  }
  
  // MARK: - Fetch Photos
  fileprivate func fetchPhotos() {
    let fetchOptions = PHFetchOptions()
    fetchOptions.fetchLimit = 10
    
    let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
    fetchOptions.sortDescriptors = [sortDescriptor]
    
    let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    allPhotos.enumerateObjects({ (asset, count, stop) in
      print(asset)
      
      let imageManager = PHImageManager.default()
      let targetSize = CGSize(width: 350, height: 350)
      let options = PHImageRequestOptions()
      options.isSynchronous = true
      imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
        
        if let image = image {
          self.images.append(image)
        }
        
        if count == allPhotos.count - 1 {
          self.collectionView?.reloadData()
        }
        
      })
    })
  }
  
}



// MARK: - CollectionView Data Source
extension PhotoSelectorController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
    header.backgroundColor = .red
    return header
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
    
    cell.photoImageView.image = images[indexPath.item]
    
    return cell
  }
}

// MARK: - CollectionView Flow Layout
extension PhotoSelectorController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let width = view.frame.width
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 3) / 4
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
}



