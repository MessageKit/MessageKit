/*
 MIT License

 Copyright (c) 2017-2019 MessageKit

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation
import UIKit

public extension NSAttributedString {

    func width(considering height: CGFloat) -> CGFloat {

        let size = self.size(consideringHeight: height)
        return size.width
        
    }
    
    func height(considering width: CGFloat) -> CGFloat {

        let size = self.size(consideringWidth: width)
        return size.height
        
    }
    
    func size(consideringHeight height: CGFloat) -> CGSize {
        
        let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
        return self.size(considering: constraintBox)
        
    }
    
    func size(consideringWidth width: CGFloat) -> CGSize {
        
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        return self.size(considering: constraintBox)
        
    }
    
    func size(considering size: CGSize) -> CGSize {
        
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
        
    }
}
