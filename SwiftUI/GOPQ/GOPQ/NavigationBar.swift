//
//  Navbar.swift
//  GOPQ
//
//  Created by Yehezkiel Joseph Widianto on 27/03/25.
//

import SwiftUI

struct NavigationBar: View {
    @Binding var showMapSheet:Bool
    var body: some View {
        HStack {
            Image("gopq")
                .resizable()
                .frame(width:30,height:45)
                .padding(.leading,15)
                .padding(.trailing,30)
            Spacer()
            HStack(spacing: 16) {
                Image(systemName: "square.and.arrow.down")
                    .foregroundColor(.blue)
                    .font(.system(size: 30))
                
                Button{showMapSheet = true} label:{
                    Label("", systemImage: "map").foregroundColor(.blue)
                        .font(.system(size: 30))
                }
            }
        }
        .padding()
        .background(Color.black)
    }
    
}
#Preview {
    
    @Previewable @State var showMapSheet = false
    NavigationBar(showMapSheet:$showMapSheet)
}
