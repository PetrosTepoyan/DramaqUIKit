//
//  ModalView.swift
//  Wildlife Encyclopedia
//
//  Created by SwiftUI-Lab on 10-Jul-2020.
//  https://swiftui-lab.com/matchedGeometryEffect-part2
//

import SwiftUI
import MapKit

struct DetailedRecordViewGraphics: View {
    let record: Record
    var pct: CGFloat
    let onClose: () -> ()
    
    var body: some View {
        // We use EmptyView, because the modifier actually ignores
        // the value passed to its body() function.
        EmptyView().modifier(ModalMod(record: record, pct: pct, onClose: onClose))
    }
}

struct ModalMod: AnimatableModifier {
    @Environment(\.colorScheme) var scheme
    
    
    @Environment(\.gridRadiusPct) var gridRadiusPct: CGFloat
    @Environment(\.gridShadow) var gridShadow: CGFloat
    
    var record: Record
    var pct: CGFloat
    let onClose: () -> ()
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        let modalRadius = (0.1 - gridRadiusPct) * pct + gridRadiusPct
        let modalShadow = (8 - gridRadiusPct) * pct + gridRadiusPct
        
        let mapPoint = MapAnnotationPoint(record: record)
        let textOpacity = Double((pct - 0.5) * 2)
        
        return GeometryReader { proxy in
            VStack {
                TopMenu(date: record.date!.getDayExpExp(), onTap: onClose)
                    .padding(.top, 10  * pct)
                    .opacity(textOpacity)
//                    .clipShape(RectangleToCircle(cornerRadiusPercent: modalRadius))
                    .contentShape(RectangleToCircle(cornerRadiusPercent: modalRadius))
                GeometryReader { geo in
                    RecordViewGraphics(record: record)
                        .padding(4 * pct)
                        .padding(.bottom, 25  * pct)
                        .frame(width: geo.size.width)
                }
                
                
                Map(coordinateRegion: .constant(mapPoint.region),
                    interactionModes: [],
                    showsUserLocation: false,
                    userTrackingMode: nil,
                    annotationItems: [mapPoint]) { point in
                        MapMarker(coordinate: point.location!, tint: Color(record.category!))
                            
                }
                .opacity(textOpacity)
                .clipShape(RectangleToCircle(cornerRadiusPercent: modalRadius))
                .contentShape(RectangleToCircle(cornerRadiusPercent: modalRadius))
                
            }
        }
        .padding(10 * pct)
        .background(Color(record.category!))
        .background(VisualEffectView(uiVisualEffect: UIBlurEffect(style: scheme == .dark ? .dark : .light)))
        .clipShape(RectangleToCircle(cornerRadiusPercent: modalRadius))
        .contentShape(RectangleToCircle(cornerRadiusPercent: modalRadius))
        .shadow(radius: modalShadow)
        .padding(4 * pct)
        
        
    }
    
}

struct CloseButton: View {
    var onTap: () -> Void
    
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .font(.title)
            .foregroundColor(.secondary)
            //            .padding(30)
            .onTapGesture(perform: onTap)
    }
}

struct TopMenu : View {
    var date: String
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            Text(date)
                .font(.title3)
                .fontWeight(.semibold)
            
            Spacer()
            
            HStack {
                Image(systemName: "pencil.circle.fill")
                    .font(.title3)
                Text("Edit")
                    .font(.title3)
            }
            .padding(5)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 1)
            )
            
            CloseButton(onTap: onTap)
        }
        
    }
}
