//
//  RecordViewGraphics.swift
//  Dramaq
//
//  Created by Петрос Тепоян on 12/15/20.
//

import SwiftUI

struct RecordViewGraphics: View {
    var record: Record
    var detailed: Bool = true
    
    var body: some View {
        let priceText = String(format: "%g", record.price)
//            + String(record.currency?.first ?? " ")
        
        HStack {
            HStack(spacing: 0) {
                Text(priceText)
                    .font(.title)
                    .fontWeight(.medium)
                    .lineLimit(detailed ? nil : 1)
                    .minimumScaleFactor(0.5)
                Image(systemName: "rublesign.circle")
//                    .resizable()
                    .font(.title)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(record.place ?? "")
                .font(.title)
                .fontWeight(.medium)
                .lineLimit(detailed ? nil : 1)
                .minimumScaleFactor(0.5)
            
            Text(record.date!.getTime())
                .font(.title)
                .fontWeight(.medium)
                .lineLimit(1)
            
        }
        .padding()
        .background(Color(record.category!))
        .cornerRadius(15)
        .overlay(BadgeView(badge: record.purchaseMethod!).offset(x: -10, y: 10), alignment: .bottomTrailing)
        
        
    }
    
    struct BadgeView : View {
        var badge : String
        
        var body: some View {
            Image(badge.capitalized + "Badge")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
}

