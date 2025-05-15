import SwiftUI

struct NamePicker: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showSheet: Bool
    let names: [String]
    let action: (String) -> Void

    var body: some View {
        NavigationStack {
            VStack {
                List(names, id: \.self) { name in
                    Button {
                        withAnimation {
                            showSheet = false
                        }
                        action(name)
                    } label: {
                        Label {
                            Text(name)
                                .foregroundStyle(Color(.white))
                        } icon: {
                        }
                    }
                }
            }
            .navigationTitle("Choose Name")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private let preview_names = [
    "Shawn",
    "Dicky",
    "Jose",
    "Mimi",
    "Luna",
    "Yeha",
]

#Preview {
    NamePicker(showSheet: .constant(true), names: preview_names) { (name: String) in
        print("Picked ")
    }
}
