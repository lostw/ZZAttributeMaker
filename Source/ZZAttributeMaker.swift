//
//  WKZAttributedStringMaker.swift
//  collection
//
//  Created by william on 13/06/2017.
//  Copyright © 2017 william. All rights reserved.
//

import Foundation
import UIKit

public enum ZZAttributeSearchType {
    case number, finance, text(_ :String), regex(_ :String)
}
public typealias ZZAttributeMakerBlock = (_ make: ZZAttributeMaker) -> Void

open class ZZAttributeMaker {
    var text: String
    var attributes = [ZZAttribute]()
    var attachment: NSTextAttachment?
    var attachmentPosition: Int = 0
    init(text: String) {
        self.text = text
    }

    open func make(_ block: ZZAttributeMakerBlock) -> NSAttributedString {
        block(self)
        return self.generate()
    }

    public func generate() -> NSAttributedString {
        let result = NSMutableAttributedString(string: self.text)

        for attribute in self.attributes {
            for range in attribute.ranges {
                result.addAttributes(attribute.attrs, range: NSRange(range))
            }
        }

        if let attachment = self.attachment {
            let attachmentAttr = NSAttributedString(attachment: attachment)
            if attachmentPosition == 0 {
                result.insert(attachmentAttr, at: 0)
                result.insert(NSAttributedString(string: " "), at: 1)
            } else {
                result.append(NSAttributedString(string: " "))
                result.append(attachmentAttr)
            }
        }

        return result.copy() as! NSAttributedString
    }

    open func range(_ range: Range<Int>? = nil) -> ZZAttribute {
        let final = range ?? 0..<self.text.count

        let attribute = ZZAttribute(range: final)
        self.attributes.append(attribute)
        return attribute
    }

     open func find(_ type: ZZAttributeSearchType, options: String.CompareOptions = []) -> ZZAttribute? {
        var range: Range<String.Index>?
        switch type {
        case .number:
            range = self.text.range(of: "[\\d\\.]+", options: .regularExpression)
        case .finance:
            range = self.text.range(of: "\\d+(,\\d{3})*(\\.\\d{2})?", options: .regularExpression)
        case .text(let s):
            range = self.text.range(of: s, options: options)
        case .regex(let r):
            range = self.text.range(of: r, options: .regularExpression)
        }

        guard range != nil else {
            return nil
        }

        let start = self.text.distance(from: self.text.startIndex, to: range!.lowerBound)
        let end = self.text.distance(from: self.text.startIndex, to: range!.upperBound)

        return self.range(start..<end)

    }

    open func findAll(_ type: ZZAttributeSearchType, options: String.CompareOptions = []) -> ZZAttribute? {
        var ranges: [Range<String.Index>]?
        switch type {
        case .number:
            ranges = self.text.ranges(of: "\\d+", options: .regularExpression)
        case .finance:
            ranges = self.text.ranges(of: "\\d+(,\\d{3})*(\\.\\d{2})?", options: .regularExpression)
        case .text(let s):
            ranges = self.text.ranges(of: s, options: options)
        case .regex(let r):
            ranges = self.text.ranges(of: r, options: .regularExpression)
        }

        guard ranges != nil else {
            return nil
        }

        var attributeRanges = [Range<Int>]()

        for range in ranges! {
            let start = self.text.distance(from: self.text.startIndex, to: range.lowerBound)
            let end = self.text.distance(from: self.text.startIndex, to: range.upperBound)
            attributeRanges.append(start..<end)
        }

        let attribute = ZZAttribute(ranges: attributeRanges)
        self.attributes.append(attribute)

        return attribute
    }

    public func prepend(icon: UIImage, adjustY: CGFloat = 0) -> Self {
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: adjustY, width: icon.size.width, height: icon.size.height)

        self.attachment = attachment
        self.attachmentPosition = 0
        return self
    }

    public func append(icon: UIImage, adjustY: CGFloat = 0) -> Self {
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: adjustY, width: icon.size.width, height: icon.size.height)

        self.attachment = attachment
        self.attachmentPosition = 1
        return self
    }
}

public extension String {
    var styled: ZZAttributeMaker {
        return ZZAttributeMaker(text: self)
    }

    func ranges(of search: String, options: NSString.CompareOptions = []) -> [Range<String.Index>]? {
        var ranges: [Range<String.Index>]?
        var searchIndex = self.startIndex

        while searchIndex < self.endIndex {
            if let range = self.range(of: search, options: options, range: searchIndex..<self.endIndex) {
                if ranges == nil {
                    ranges = []
                }

                ranges!.append(range)

                searchIndex = range.upperBound
            } else {
                break
            }
        }

        return ranges
    }
}
