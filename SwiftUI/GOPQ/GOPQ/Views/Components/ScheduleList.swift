//
//  ScheduleList.swift
//  GOPQ
//
//  Created by Shawn Andrew on 25/03/25.
//


import SwiftUI
import UniformTypeIdentifiers

struct ScheduleList: View {

    @State var showImportSheet: Bool = false
    @Environment(CSVController.self) var csvController
    @Environment(ScheduleController.self) var schedules
    @Environment(UserData.self) var userdata
    
    var body: some View {
        if schedules.data.isEmpty {
            Spacer()
            Button {
                showImportSheet = true
            } label: {
                VStack (spacing: 12){
                    ImportScheduleListButton()
                        .frame(width: 30)
                    Text("Silahkan Masukkan Jadwal Anda")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                }.padding(.init(top: 16, leading: 16, bottom: 12, trailing: 16))
                .background(.darkGray)
                .cornerRadius(20)
            }
            .fileImporter(
                isPresented: $showImportSheet,
                allowedContentTypes: [
                    UTType.commaSeparatedText,
                    UTType(filenameExtension: "csv")!
                ]
            ) { result in
                schedules.set( csvController.handleFileImport(for: result), name: userdata.username)
            }
            Spacer()
        }
        else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    BorderLine()
                    ForEach(schedules.data, id:\.id) { schedule in
                        ScheduleItem(schedule: schedule)
                            .padding(18)
                        BorderLine()
                    }
                    //                ForEach(schedules.data, id: \.self) {schedule in
                    //                    VStack {
                    //                        ScheduleItem(index: schedules.data.firstIndex(where: $0.id == schedule.id))
                    //                            .padding(18)
                    //                        BorderLine()
                    //                    }
                    //                }
                }
            }
        }
    }
}



//#Preview {
//    ZStack {
//        Rectangle()
//            .fill(.black)
//            .ignoresSafeArea()
//        //        ScheduleList()
//        //            .environment(ObservableScheduleList(schedules))
//        EnvironmentalTemp() {
//            ScheduleList()
//        }
//    }
//}
