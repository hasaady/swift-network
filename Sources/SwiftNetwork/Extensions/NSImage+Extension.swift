//
//  NSImage+Extension.swift
//
//
//  Created by Hanan on 23/12/2023.
//

#if os(macOS)
import AppKit

extension NSImage {
    func jpegData(compressionQuality: CGFloat) -> Data {
        guard let tiffRepresentation = tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation),
              let jpegData = bitmapImage.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality]) else { return Data() }
        return jpegData
    }
}
#endif
