//
//  RecordsTable.swift
//  DramaqSwiftUI
//
//  Created by Петрос Тепоян on 12/14/20.
//

import SwiftUI
import MapKit
import CoreHaptics

struct RecordsTable: View {
    @Namespace private var ns_table
    @State private var blur: Bool = false
    @State private var selected: Record? = nil
    @State private var flyFromGridToModal: Bool = false
    @State private var detailedRecordViewOffset: CGFloat = 0.0
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Record.id, ascending: true)],
        animation: .default)
    private var records: FetchedResults<Record>
    private var distinctDates: [String] {
        var datesToOutput: [String] = []
        for date in records.map({ $0.date!.getDay() }).reversed() {
            if !datesToOutput.contains(date) {
                datesToOutput.append(date)
            }
        }
        return datesToOutput
    }
    @State private var dxOffsetForDeletion: CGFloat = 0.0
    @State private var draggableRecordID: Int32 = 0
    var body: some View {
        
        ZStack {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(distinctDates, id: \.self) { distinctDate in
                            Section(header: Text(distinctDate)) {
                                ForEach(records.filter { $0.date?.getDay() == distinctDate }.reversed()) { record in
                                    RecordView(record: record,
                                               onTap: { select(record) },
                                               onDelete: { deleteRecord(id: record.id) } ,
                                               namespace: ns_table,
                                               dxOffsetForDragging: $dxOffsetForDeletion,
                                               draggableRecordID: $draggableRecordID)
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
            .zIndex(1)
            
            BlurView(active: blur, onTap: deselect)
                .zIndex(2)
            
            if selected != nil {
                DetailedRecordView(selected: $selected,
                                   flyFromGridToModal: $flyFromGridToModal,
                                   detailedRecordViewOffset: $detailedRecordViewOffset,
                                   deselect: { deselect() },
                                   namespace: ns_table)
            }
            
        }
    }
    
    
    func select(_ record: Record) {
        selected = record
        withAnimation(.spring(response: duration_of_animation)) {
            blur = true
        }
    }
    
    func deselect() {
        withAnimation(.spring(response: duration_of_animation)) {
            selected = nil
            blur = false
        }
    }
    
    private func deleteRecord(id: UUID?) {
//        withAnimation {
//            records.filter { $0.id == id }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }
}


//struct RecordsTable_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        RecordsTable()
//            .environment(\.managedObjectContext, viewContext)
//    }
//}

struct DetailedRecordView : View {
    @Binding var selected : Record?
    @Binding var flyFromGridToModal: Bool
    @Binding var detailedRecordViewOffset : CGFloat

    var deselect : () -> Void
    var matchGridToModal : Bool { !flyFromGridToModal && selected != nil }
    var namespace : Namespace.ID
    
    var body: some View {
        if selected != nil {
            DetailedRecordViewGraphics(record: selected!,
                                       pct: flyFromGridToModal ? 1 : 0,
                                       onClose: deselect)
                .matchedGeometryEffect(id: matchGridToModal ? selected!.id : UUID(), in: namespace, isSource: false)
                .frame(height: 450)
                .padding(.horizontal, 10)
                .onAppear { withAnimation(.fly) { flyFromGridToModal = true } }
                .onDisappear { flyFromGridToModal = false }
                .zIndex(3)
                .gesture(DragGesture(minimumDistance: 25).onChanged{ (value) in
                    detailedRecordViewOffset = value.translation.height
                    if value.translation.height > 30 {
                        let generator = UIImpactFeedbackGenerator(style: .soft)
                        generator.impactOccurred(intensity: 0.1 + (value.translation.height - 30)*0.02)
                    }
                    
                }.onEnded({ (value) in
                    if value.translation.height > 30 {
                        deselect()
                    }
                    detailedRecordViewOffset = 0
                }))
                .offset(y: detailedRecordViewOffset)
                .animation(.spring())
        } else {
            EmptyView()
        }
        
    }
    
}

struct RecordView : View {
    var record : Record
    var onTap : () -> Void = {}
    var onDelete : () -> Void = {}
    var namespace : Namespace.ID
    @Binding var dxOffsetForDragging : CGFloat
    @Binding var draggableRecordID : Int32
//    var showDeleleButton : Bool { dxOffsetForDragging < -50 && draggableRecordID == record.id}
//    var showEditButton : Bool { dxOffsetForDragging > 30 && draggableRecordID == record.id }
    
    var body: some View {
        HStack {
//            if showEditButton {
//                Image(systemName: "pencil.circle.fill")
//                    .resizable()
//                    .foregroundColor(.purple)
//                    .frame(width: 50, height: 50)
//            }
            
            RecordViewGraphics(record: record, detailed: false)
                .padding(.horizontal, 10)
                .onTapGesture(count: 1, perform: onTap)
                .onTapGesture(count: 1, perform: { dxOffsetForDragging = 0 })
                .matchedGeometryEffect(id: record.id, in: namespace, isSource: true)
                .contextMenu {
                    Button(action: onDelete) {
                        Text("Delete")
                        Image(systemName: "trash.circle.fill")
                    }
                }
                .gesture(DragGesture()
                            .onChanged { (value) in
//                                draggableRecordID = record.id
                                dxOffsetForDragging = value.translation.width
                            }
                            .onEnded { (value) in
                                
//                                if showDeleleButton {
//                                    onDelete()
//                                }
                                
                                dxOffsetForDragging = 0.0
                                draggableRecordID = 0
                            })
                
            
//            if showDeleleButton {
//                Image(systemName: "trash.circle.fill")
//                    .resizable()
//                    .foregroundColor(.red)
//                    .frame(width: 50, height: 50)
//            }
            
        }
//        .offset(x: draggableRecordID == record.id ? dxOffsetForDragging : 0)
        .animation(.spring())
        
        
    }
}
