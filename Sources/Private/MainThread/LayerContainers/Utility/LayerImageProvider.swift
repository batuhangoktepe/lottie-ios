//
//  LayerImageProvider.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/25/19.
//

import Foundation

/// Connects a LottieImageProvider to a group of image layers
final class LayerImageProvider {

  // MARK: Lifecycle

  init(imageProvider: AnimationImageProvider, assets: [String: ImageAsset]?) {
    self.imageProvider = imageProvider
    imageLayers = [ImageCompositionLayer]()
    if let assets = assets {
      imageAssets = assets
    } else {
      imageAssets = [:]
    }
    reloadImages()
  }

  // MARK: Internal

  private(set) var imageLayers: [ImageCompositionLayer]
  let imageAssets: [String: ImageAsset]

  var imageProvider: AnimationImageProvider {
    didSet {
      reloadImages()
    }
  }

  func addImageLayers(_ layers: [ImageCompositionLayer]) {
    for layer in layers {
      if imageAssets[layer.imageReferenceID] != nil {
        /// Found a linking asset in our asset library. Add layer
        imageLayers.append(layer)
      }
    }
  }

    func reloadImages() {
        
        for imageLayer in imageLayers {
            if let asset = imageAssets[imageLayer.imageReferenceID] {
                imageLayer.image = imageProvider.imageForAsset(asset: asset)
                
                let changedAssets = ["user_profile"]
                if changedAssets.contains(asset.name) {
                    let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                    let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
                    let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                    if let dirPath = paths.first {
                        let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("userImage.png")
                        let image    = UIImage(contentsOfFile: imageURL.path)
                        imageLayer.image = image?.cgImage
                    }
                }
            }
        }
    }
}
