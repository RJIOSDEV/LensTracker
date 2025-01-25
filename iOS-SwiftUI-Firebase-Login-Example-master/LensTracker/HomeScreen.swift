import SwiftUI



struct HomeScreen: View {
     var language = LocalizationService.shared.language
    @State private var selectedTab: String? = "lenses" // State to manage which tab is selected
    @State private var showAddLens = false // State to manage if AddLens view should be shown

    let themeColor = UIColor(named: "themeColor") ?? .white
  
    var body: some View {
        ZStack {
            VStack {
                if selectedTab == "lenses" {
                    lensList()
                } else if selectedTab == "settings" {
                    if #available(iOS 14.0, *) {
                        setting()
                    } else {
                        // Fallback on earlier versions
                    }
                } else if showAddLens {
                    addlense()
                }
                // Spacer to push content up to make room for the TabBar
                Spacer()
            }
            .padding(.bottom, 60) // Provide space for the tab bar

            GeometryReader { proxy in
                if #available(iOS 14.0, *) {
                    VStack {
                        Spacer()
                        if #available(iOS 15.0, *) {
                            HStack {
                                TabBarItem(label:  "lenses",
                                           
                                           iconName: "lences"){
                                    selectedTab = "lenses"
                                    showAddLens = false
                                }
                                
                                TabBarItem(label: "settings", iconName: "setting") {
                                    selectedTab = "settings"
                                    showAddLens = false
                                }
                            }
                            .font(.footnote)
                            .padding(.top, 42)
                            .overlay(alignment: .top) {
                                Button(action: {
                                    showAddLens = true
                                    selectedTab = "addlense"
                                }) {
                                    Image("addlence") // "plus_icon"
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                        .frame(width: 60, height: 60)
                                        .foregroundStyle(.white)
                                        .background {
                                            Circle()
                                                .fill(Color(themeColor)) // Fill the circle with the theme color
                                                .overlay(
                                                    Circle()
                                                        .stroke(Color.white, lineWidth: 2) // Add a white border with a width of 2
                                                )
                                                .shadow(color: Color.white, radius: 3) // Set the shadow color to white
                                        }
                                }
                                .padding(9)
                            }
                            .padding(.bottom, max(8, proxy.safeAreaInsets.bottom))
                            .background {
                                TabBarShape()
                                    .fill(Color(themeColor))
                                    .shadow(radius: 3)
                            }
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
}

struct TabBarItem: View {
    var language = LocalizationService.shared.language
    let label: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(iconName)
                    .resizable() // Ensure the image can be resized
                    .scaledToFit() // Scale to fit within the given frame
                    .frame(width: 24, height: 24) // Adjust the frame size as needed
                    .foregroundColor(.white) // Set the icon color to white

                Text(label.localized(language))
                    .font(.custom("Montserrat", size: 14))
                    .foregroundColor(.white) // Set the text color to white
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// Define your other views here, like lensList, setting, addlense

#Preview {
    HomeScreen()
}

// Define the custom shape for the tab bar
struct TabBarShape: Shape {
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let smallCornerRadius: CGFloat = 15
        static let buttonRadius: CGFloat = 30
        static let buttonPadding: CGFloat = 9
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        var x = rect.minX
        var y = rect.maxY
        path.move(to: CGPoint(x: x, y: y))

        x += Constants.cornerRadius
        y = Constants.buttonRadius + Constants.cornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: Constants.cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        x = rect.midX - Constants.buttonRadius - (Constants.buttonPadding / 2) - Constants.smallCornerRadius
        y = Constants.buttonRadius - Constants.smallCornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: Constants.smallCornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(35),
            clockwise: true
        )
        x = rect.midX
        y += Constants.smallCornerRadius + Constants.buttonPadding
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: Constants.buttonRadius + Constants.buttonPadding,
            startAngle: .degrees(215),
            endAngle: .degrees(325),
            clockwise: false
        )
        x += Constants.buttonRadius + (Constants.buttonPadding / 2) + Constants.smallCornerRadius
        y = Constants.buttonRadius - Constants.smallCornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: Constants.smallCornerRadius,
            startAngle: .degrees(145),
            endAngle: .degrees(90),
            clockwise: true
        )
        x = rect.maxX - Constants.cornerRadius
        y = Constants.buttonRadius + Constants.cornerRadius
        path.addArc(
            center: CGPoint(x: x, y: y),
            radius: Constants.cornerRadius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        x = rect.maxX
        y = rect.maxY
        path.addLine(to: CGPoint(x: x, y: y))

        path.closeSubpath()
        return path
    }
}




// Define your other views here, like lensList, setting, addlense

#Preview {
    HomeScreen()
}


// Define the custom shape for the tab bar

