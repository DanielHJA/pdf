//
//  PDFContextCreationManager.swift
//  Uiviewswitch
//
//  Created by Daniel Hjärtström on 2017-03-16.
//  Copyright © 2017 Daniel Hjärtström. All rights reserved.
//

import UIKit
import QuartzCore

class PDFContextCreationManager: NSObject {

    func returnContextForPDF() -> [CGPDFPage] {
    
        let file: URL = Bundle.main.url(forResource: "daniel", withExtension: "pdf")!
        
        let pdf: CGPDFDocument? = CGPDFDocument(file.absoluteURL as CFURL)
        
        let pages: Int = pdf!.numberOfPages

        let data: NSMutableData? = NSMutableData()
    
        var pdfContextArray: [CGPDFPage] = []
        
        for i in (1..<pages+1) {
        
           // UIGraphicsBeginPDFContextToData(data!, CGRect.zero, nil)
            
            let currentPage: CGPDFPage = pdf!.page(at: i)!
       
            /*let frame: CGRect = currentPage.getBoxRect(CGPDFBox.mediaBox)

            UIGraphicsBeginPDFPageWithInfo(frame, nil)
            
            let context: CGContext? = UIGraphicsGetCurrentContext()
            context?.saveGState()
            // context?.scaleBy(x: 1, y: -1)
            // context?.translateBy(x: 0, y: -frame.size.height)
            context!.drawPDFPage(currentPage)
            context?.restoreGState()
        */
            pdfContextArray.append(currentPage)
        
          //  UIGraphicsEndPDFContext()
        }
        
        return pdfContextArray
    }
}












