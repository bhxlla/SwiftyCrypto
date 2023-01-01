//
//  LocalFileManager.swift
//  SwiftyCrypto
//
//  Created by varunbhalla19 on 01/01/23.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    
    static let shared = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage, with name: String, in folder: String) {
        DispatchQueue.global(qos: .utility).async {
            self.createDirIfNeeded(with: folder)
            guard let data = image.pngData(), let url = self.getImageUrl(folderName: folder, imageName: name) else { return }
            do {
                try data.write(to: url)
            } catch (let err) {
                print("Err saving image: \(err.localizedDescription)")
            }
        }
    }
    
    func getImage(with name: String, in folder: String) -> UIImage? {
        guard let url = getImageUrl(folderName: folder, imageName: name), FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createDirIfNeeded(with name: String) {
        guard let url = getFolderUrl(name) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch let err {
                print("Can't create directory.", err.localizedDescription)
            }
        }
    }
    
    private func getFolderUrl(_ name: String) -> URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(name)
    }
    
    private func getImageUrl(folderName: String, imageName: String) -> URL? {
        getFolderUrl(folderName)?.appendingPathComponent(imageName).appendingPathExtension("png")
    }
    
}
