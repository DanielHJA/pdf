//
//  PDFContextView.swift
//  Uiviewswitch
//
//  Created by Daniel Hjärtström on 2017-03-16.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit


class PDFContextView: UIView {
    
    var index: Int = 0
    
    override func draw(_ rect: CGRect) {
        
        let page = Singleton.sharedInstance.pages[index]
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.clear(bounds)
        
        context?.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context?.fill(bounds)
        
        context?.translateBy(x: 0.0, y: bounds.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        
        var cropBox = page.getBoxRect(.cropBox)
        cropBox = CGRect(x: cropBox.origin.x, y: cropBox.origin.y, width: ceil(cropBox.width), height: ceil(cropBox.height))
        
        let scaleFactor = min(bounds.size.width/cropBox.size.width, bounds.size.height/cropBox.size.height)
        let scale = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        let scaledInnerRect = cropBox.applying(scale)
        let translate = CGAffineTransform(translationX: ((bounds.size.width - scaledInnerRect.size.width) / 2) - scaledInnerRect.origin.x, y: ((bounds.size.height - scaledInnerRect.size.height) / 2) - scaledInnerRect.origin.y)
        let concat = translate.scaledBy(x: scaleFactor, y: scaleFactor)
        
        context?.concatenate(concat)
        
        let clipRect = cropBox
        context?.addRect(clipRect)
        context?.clip()
        
        context?.drawPDFPage(page)
        
        UIGraphicsEndPDFContext()
        
        getLinksFromPDF()
    }

    
    
    func getLinksFromPDF() {
        
        let page = Singleton.sharedInstance.pages[index]


        //Get the page dictionary
       /* var pageDictionary: CGPDFDictionaryRef = page.dictionary!
        var annotsArray: CGPDFArrayRef? = nil
        //Get the Annots array
        if !CGPDFDictionaryGetArray(pageDictionary, "Annots", &annotsArray) {
            //DLog(@"No Annots found for page %d", page);
            //self.updateProgress()
            return
        }
        var annotsArrayCount: Int = CGPDFArrayGetCount(annotsArray!)

        var touchRectsArray = [Any]() /* capacity: annotsArrayCount */
        var j = annotsArrayCount
        while j >= 0 {
            var destPageNumber: Int = 0
            var uri: String? = nil
            
            var aDictObj: CGPDFObjectRef?
            
            if !CGPDFArrayGetDictionary(annotsArray!, 0, &aDictObj) {
                return
            }
            
            var annotArr: CGPDFArrayRef?
            
            if !CGPDFObjectGetValue(aDictObj!, .array, &annotArr) {
                return
            }
            
            var annotDict: CGPDFDictionaryRef?
            
            if !CGPDFObjectGetValue(annotArr!, .name, &annotDict) {
                return
            }
            //------------
            var aDict: CGPDFDictionaryRef? = nil
            var destArray: CGPDFArrayRef? = nil
            if CGPDFDictionaryGetDictionary(annotDict!, "A", &aDict) {
                var uriStringRef: CGPDFStringRef? = nil
                if CGPDFDictionaryGetString(aDict!, "URI", &uriStringRef) {
                    var uriString = String(describing: CGPDFStringGetBytePtr(uriStringRef!))
                    uri = String(cString: uriString, encoding: String.Encoding.utf8)
                }
            }
            else {
                continue
            }
            j -= 1
        }*/
        
      /*  var pageDictionary: CGPDFDictionaryRef = page.dictionary!
        var resourcesDictionary: CGPDFDictionaryRef?
        CGPDFDictionaryGetDictionary(pageDictionary, "Resources", &resourcesDictionary)
        var fontDictionary: CGPDFDictionaryRef?
        CGPDFDictionaryGetDictionary(resourcesDictionary!, "Font", &fontDictionary)
        var f10FontDictionary: CGPDFDictionaryRef?
        CGPDFDictionaryGetDictionary(fontDictionary!, "F1.0", &f10FontDictionary)
*/
      /*  var outputArray: CGPDFArrayRef? = nil
        
        if !CGPDFDictionaryGetArray(pageDictionary, "Annots", &outputArray) {
            //break;
            return
        }
        
        var arrayCount: Int = 0
        
        arrayCount = CGPDFArrayGetCount(outputArray!)
        
        if arrayCount > 0 {
            for j in 0..<arrayCount {
                var aDictObj: CGPDFObjectRef?
                if !CGPDFArrayGetObject(outputArray!, j, &aDictObj) {
                    return
                }
                
                var annotDict: CGPDFDictionaryRef?
                if !CGPDFObjectGetValue(aDictObj!, .dictionary, &annotDict) {
                    return
                }
                
                var aDict: CGPDFDictionaryRef?
                if !CGPDFDictionaryGetDictionary(annotDict!, "A", &aDict) {
                    return
                }
                
                var uriStringRef: CGPDFStringRef?
                if !CGPDFDictionaryGetString(aDict!, "URI", &uriStringRef) {
                    return
                }
                
                var rectArray: CGPDFArrayRef?
                if !CGPDFDictionaryGetArray(annotDict!, "Rect", &rectArray) {
                    return
                }
                
                var arrayCount: Int = CGPDFArrayGetCount(rectArray!)
                var coords: [CGPDFReal] = [CGPDFReal(integerLiteral: 4)]
                
                for k in 0..<arrayCount {
                    
                    var rectObj: CGPDFObjectRef?
                    if !CGPDFArrayGetObject(rectArray!, k, &rectObj) {
                        return
                    }
                    
                    var coord: CGPDFReal?
                    if !CGPDFObjectGetValue(rectObj!, .real, &coord) {
                        return
                    }
                    
          //          coords[k] = coord!
                }
               
                //var uriString = CChar(CGPDFStringGetBytePtr(uriStringRef!))
                let uriString: String = String(describing: CGPDFStringGetBytePtr(uriStringRef!))
                let uri = String(cString: uriString, encoding: String.Encoding.utf8)

                let lowerLeft = self.convertPDFPoint(pdfPoint: CGPoint(x: CGFloat(coords[0]), y: CGFloat(coords[1])))
                let upperRight = self.convertPDFPoint(pdfPoint: CGPoint(x: CGFloat(coords[2]), y: CGFloat(coords[3])))
                // This is the rectangle positioned under the link
                var viewRect = CGRect(x: CGFloat(lowerLeft.x), y: CGFloat(lowerLeft.y), width: CGFloat(upperRight.x - lowerLeft.x), height: CGFloat(lowerLeft.y - upperRight.y))
                // Now adjusting the rectangle to be on top of the link
                viewRect = CGRect(x: CGFloat(viewRect.origin.x), y: CGFloat(viewRect.origin.y - viewRect.size.height), width: CGFloat(viewRect.size.width), height: CGFloat(viewRect.size.height))
                print("\(uri)")
                let button = UIButton(type: .custom)
                button.frame = viewRect
                button.backgroundColor = UIColor.green
                button.alpha = 0.65
                self.superview?.addSubview(button)
            }
        }*/
    }
    
  /*  func convertPDFPoint(pdfPoint: CGPoint) -> CGPoint {
       
        var viewPoint = CGPoint(x: CGFloat(0), y: CGFloat(0))
        
        let page = Singleton.sharedInstance.pages[index]
        
        let cropBox: CGRect = page.getBoxRect(CGPDFBox.cropBox)
        
        let rotation: Int = Int(page.rotationAngle)
        
        var pageRenderRect: CGRect
        
        switch rotation {
        case 90, -270:
            pageRenderRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(1024), height: CGFloat(768))
            viewPoint.x = pageRenderRect.size.width * (pdfPoint.y - cropBox.origin.y) / cropBox.size.height
            viewPoint.y = pageRenderRect.size.height * (pdfPoint.x - cropBox.origin.x) / cropBox.size.width
        case 180, -180:
            pageRenderRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(1024))
            viewPoint.x = pageRenderRect.size.width * (cropBox.size.width - (pdfPoint.x - cropBox.origin.x)) / cropBox.size.width
            viewPoint.y = pageRenderRect.size.height * (pdfPoint.y - cropBox.origin.y) / cropBox.size.height
        case -90, 270:
            pageRenderRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(1024), height: CGFloat(768))
            viewPoint.x = pageRenderRect.size.width * (cropBox.size.height - (pdfPoint.y - cropBox.origin.y)) / cropBox.size.height
            viewPoint.y = pageRenderRect.size.height * (cropBox.size.width - (pdfPoint.x - cropBox.origin.x)) / cropBox.size.width
        default:
            pageRenderRect = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(1024))
            viewPoint.x = pageRenderRect.size.width * (pdfPoint.x - cropBox.origin.x) / cropBox.size.width
            viewPoint.y = pageRenderRect.size.height * (cropBox.size.height - pdfPoint.y) / cropBox.size.height
        }
        
        viewPoint.x = viewPoint.x + pageRenderRect.origin.x
        viewPoint.y = viewPoint.y + pageRenderRect.origin.y
     
        return viewPoint
    }*/
}
