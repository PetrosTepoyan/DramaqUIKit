//
//  CategoryView.swift
//  DramaqSwiftUI
//
//  Created by Петрос Тепоян on 5/7/20.
//

import SwiftUI


enum Category: String, CaseIterable{

    case Food
    case Entertainment
    case Shop
    case Transportation
    case Traveling
    case Education
    case Medicine
    case Utilities
    case Sport
    case Religion
    case Beauty
    
    case Unknown
    
    func color_() -> Color {
        return Color(self.rawValue)
    }
    
    func color() -> UIColor {
        return UIColor(named: self.rawValue)!
    }
    
}

struct CategoryView: View {
    
    var category: Category
    
    init(category: Category) {
        self.category = category
        
    }
    
    var body: some View {
        Image(category.rawValue + "Icon")
            .resizable()
            .frame(width: 60, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .Food)
    }
}
