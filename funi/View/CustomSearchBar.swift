//
//  CustomSearchBar.swift
//  funi
//
import UIKit

class CustomSearchBar: UISearchBar {
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    var preferredGlassColor: UIColor!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        for view in subviews[0].subviews {
            if view.isKind(of: UITextField.self) {
                
                // Setting the frame.
                let searchField: UITextField = view as! UITextField
                // Set the font and text color of the search field.
                searchField.font = preferredFont
                searchField.textColor = preferredTextColor
                searchField.autocapitalizationType = .none
                // Glass Icon Customization
                let glassIcon = searchField.leftView as? UIImageView
                glassIcon?.image = glassIcon?.image?.withRenderingMode(.alwaysTemplate)
                glassIcon?.tintColor = preferredGlassColor
                
                break;
            }
        }
        
        super.draw(rect)
    }
    
    
    
    init(frame: CGRect, font: UIFont, textColor: UIColor, glassColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        preferredGlassColor = glassColor
        
        searchBarStyle = UISearchBar.Style.prominent
        isTranslucent = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension CustomSearchBar: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        textField.resignFirstResponder()
        return false
    }
}
