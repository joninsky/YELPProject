//
//  EmptyDataSetView.swift
//  WeedmapsChallenge
//
//  Created by Jon Vogel on 4/14/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import UIKit

public class EmptyDataView: UIView {
    //MARK: Properties
    let stack = UIStackView(frame: .zero)
    let label = UILabel(frame: .zero)
    
    public var state: EmptyDataViewState = .hasData {
        didSet {
            self.update(self.state)
        }
    }
    
    
    //MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.prepare()
    }
    
    //MARK: Functions
    func update(_ state: EmptyDataViewState) {
        switch state {
        case .hasData:
            self.label.text = nil
        case .noData(description: let string):
            self.label.text = string
        case .noDataAttributed(description: let string):
            self.label.attributedText = string
        }
    }
    
}


extension EmptyDataView {
    func prepare() {
        //Set up label
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.numberOfLines = 0
        self.label.lineBreakMode = .byWordWrapping
        self.label.textAlignment = .center
        
        //Set up stack
        //        self.stack.translatesAutoresizingMaskIntoConstraints = false
        //        self.stack.axis = .vertical
        //        self.stack.spacing = 12
        //        self.stack.alignment = .fill
        //        self.stack.distribution = .fill
        //        self.stack.addArrangedSubview(self.label)
        
        //Set up self
        self.backgroundColor = UIColor.white
        self.addSubview(self.label)
        self.constrain()
    }
    
    func constrain() {
        self.label.constrainToSuperview(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}
