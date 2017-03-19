//
//  MSInformationView.swift
//  MattSchrage2
//
//  Created by Matt Schrage on 4/26/15.
//  Copyright (c) 2015 Matt Schrage. All rights reserved.
//

import UIKit

class MSInformationView: UIView {
    //var images = [];
    var label: UILabel;
    var color: UIColor{
        didSet{
            self.label.shadowColor = self.color;
        }
    }
    var text:String{
        didSet{
            
            self.label.text = self.text;
            
            
        }
    }

    override init(frame: CGRect) {
        self.label = UILabel()
        self.text = String()
        self.color = UIColor()
        super.init(frame: frame)
        
        let offset = CGFloat(100);
        let margin = CGFloat(20)
        self.label.frame = CGRect(x: margin/2, y: offset, width: frame.width - margin, height: frame.height - offset);
        //self.label.center = CGPoint(x: CGRectGetMidX(frame),y: CGRectGetMidY(frame));
        self.label.font = UIFont(name: "Avenir-Heavy", size: CGFloat(20))
        self.label.numberOfLines = 0;
        self.label.textColor = UIColor.white;
        self.label.textAlignment = NSTextAlignment.left;
        self.label.shadowOffset = CGSize(width: 0.0, height: 2.0);
        self.addSubview(self.label);

    }
    
    required init?(coder: NSCoder) {
        self.label = UILabel()
        self.text = String()
        self.color = UIColor()

        super.init(coder: coder)
    }
    
    func backgroundView() -> UIView {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = self.color;
        return backgroundView
    }
    
}

