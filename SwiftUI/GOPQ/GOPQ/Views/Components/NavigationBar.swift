//
//  Navbar.swift
//  GOPQ
//
//  Created by Yehezkiel Joseph Widianto on 27/03/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct NavigationBar: View {

    @State var showMapSheet: Bool = false
    @Environment(ScheduleController.self) private var scheduleController
    @Environment(UserData.self) private var userData
    @Environment(AppGlobal.self) private var appGlobal
    @Environment(CSVController.self) private var csvController

    var body: some View {
        HStack {
            // This Button is for the exhibition, to reset the entire app
            Button {
                csvController.reset()
                scheduleController.reset()
                userData.username = ""

            } label: {
                Image("GOPQLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                    .padding(.leading, 32)
                    .padding(.trailing, 30)
            }

            Spacer()
        }
        .padding(.bottom)
        .padding(.top)
        .background(Color("Neutral1"))
    }
}

#Preview {
    let csvController = CSVController()

    EnvironmentalTemp {
        NavigationBar()
    }
}
