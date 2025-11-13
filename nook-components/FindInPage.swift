import SwiftUI

struct FindInPage: View {
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    @State private var isShown: Bool = false
    @State private var currentIndex: Int = 1
    @State private var showResponse: Bool = false

    // streaming state
    @State private var visibleWordCount: Int = 0
    private let responseText =
        "Dia Browser is a Chromium-based web browser by The Browser Company that treats AI as its core."
    private var responseWords: [String] {
        responseText.split(separator: " ").map(String.init)
    }

    let totalResults: Int = 47
    let canGoUp: Bool = false
    let canGoDown: Bool = true

    var body: some View {

        return VStack(alignment: .center) {
            if isShown {
                VStack(spacing: 0){
                    Spacer()
                        .frame(maxHeight: 20)
                    HStack {
                        ZStack {
                            if searchText.isEmpty {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundStyle(.black.opacity(0.7))
                                    .scaledToFill()
                                    .frame(width: 17, height: 17)
                                    .id("search")
                                    .transition(
                                        .blur(intensity: 2, scale: 0.6)
                                            .combined(with: .opacity)
                                    )
                            } else {
                                HStack {
                                    Image("gemini")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 17, height: 17)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 4)
                                        )
                                        .id("ai")
                                        .transition(
                                            .blur(intensity: 2, scale: 0.6)
                                                .combined(with: .opacity)
                                        )


                                }
                            }

                        }
                        .animation(
                            .smooth(duration: 0.3),
                            value: searchText.isEmpty
                        )
                        if(!searchText.isEmpty) {
                            Menu {
                                Button(action: {}) {
                                    Label("Gemini 2.0", image: "gemini.16x16")
                                }
                                .keyboardShortcut("1")
                                Button(action: {}) {
                                    Label("Gemini 2.5 Pro", image: "gemini.16x16")
                                }
                                .keyboardShortcut("2")
                                Button(action: {}) {
                                    Label("GPT 5", image: "gemini.16x16")
                                }
                                .keyboardShortcut("3")
                                Button(action: {}) {
                                    Label("Apple Intelligence", image: "gemini.16x16")
                                }
                                .keyboardShortcut("4")
                                Button(action: {}) {
                                    Label("Grok 4", image: "gemini.16x16")
                                }
                                .keyboardShortcut("5")

                                Button(action: {}) {
                                    Label("Claude 4.5 Sonnet", image: "gemini.16x16")
                                }
                                .keyboardShortcut("6")

                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(
                                        .system(size: 12, weight: .medium)
                                    )
                                    .foregroundStyle(.black.opacity(0.5))
                                    .frame(width: 14, height: 14)
                            }
                            .buttonStyle(.plain)
                            .menuStyle(.button)
                        }
                        ZStack(alignment: .leading) {
                            TextField("", text: $searchText)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(
                                    searchText.isEmpty
                                        ? .black.opacity(0.4) : .black.opacity(0.6)
                                )
                                .focused($isFocused)
                                .textFieldStyle(.plain)
                                .disableAutocorrection(true)
                                .tint(Color.blue)
                                .colorScheme(.dark)
                                .onSubmit {
                                    withAnimation(.smooth(duration: 0.3)) {
                                        showResponse = true
                                    }
                                    startWordStreaming()
                                }
                            Text("Find in page...")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.black.opacity(0.4))
                                .opacity(searchText.isEmpty ? 1 : 0)
                        }

                        Spacer()

                        HStack(spacing: 12) {
                            if currentIndex > 0 {
                                HStack(spacing: 0) {
                                    Text(String(currentIndex))
                                        .font(
                                            .system(
                                                size: 12,
                                                weight: .semibold,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(.black.opacity(0.7))
                                    Text("/")
                                        .font(
                                            .system(
                                                size: 12,
                                                weight: .semibold,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(.black.opacity(0.2))
                                    Text(String(totalResults))
                                        .font(
                                            .system(
                                                size: 12,
                                                weight: .semibold,
                                                design: .monospaced
                                            )
                                        )
                                        .foregroundStyle(.black.opacity(0.7))
                                }
                                Button {

                                } label: {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.black.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                                .disabled(canGoDown)
                                Button {
                                    withAnimation(.smooth(duration: 0.3)) {
                                        showResponse = false
                                    }
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundStyle(.black.opacity(0.6))
                                }
                                .buttonStyle(.plain)
                                .disabled(canGoUp)
                            }

                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundStyle(.black.opacity(0.6))
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isShown = false
                                        searchText = ""
                                    }
                                }
                        }
                    }
                    .padding(12)
                    .background(
                        ZStack {
                            BlurEffectView(material: .headerView, state: .active)
                                .colorScheme(.light)
                            Color.white.opacity(0.4)
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.41,
                                            green: 0.75,
                                            blue: 0.98
                                        ),
                                        location: 0.00
                                    ),
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.73,
                                            green: 0.42,
                                            blue: 0.95
                                        ),
                                        location: 0.35
                                    ),
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.91,
                                            green: 0.41,
                                            blue: 0.37
                                        ),
                                        location: 0.58
                                    ),
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.95,
                                            green: 0.67,
                                            blue: 0.24
                                        ),
                                        location: 1.00
                                    ),
                                ],
                                startPoint: UnitPoint(x: 0.06, y: 0.27),
                                endPoint: UnitPoint(x: 1.06, y: 0.77)
                            )
                            .opacity(searchText.isEmpty ? 0 : 0.07)
                            .animation(
                                .smooth(duration: 0.5),
                                value: searchText.isEmpty
                            )
     

                        }
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(.black.opacity(0.3), lineWidth: 0.5)
                    }
                    .frame(maxWidth: 315)
                    .onTapGesture {
                        isFocused = true
                    }
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(
                                with: .opacity
                            ),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        )
                    )
                    .zIndex(999)
                    
                    if(showResponse) {
                        VStack(alignment: .leading ,spacing: 10) {
                            ViewThatFits {
                                Text(currentStreamingText)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(.black.opacity(0.8))
                                    .contentTransition(.opacity)
                                    .animation(.easeOut(duration: 0.1), value: visibleWordCount)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(width: 265, alignment: .leading)

                            HStack {
                                Text("Generated by Gemini 2.5 Pro")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundStyle(.black.opacity(0.5))
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Text("Follow up in Chat")
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(10)
                        .frame(width:285)
                        .background(
                            ZStack {
                                BlurEffectView(material: .headerView, state: .active)
                                    .colorScheme(.light)
                                Color.white.opacity(0.4)
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(
                                            color: Color(
                                                red: 0.41,
                                                green: 0.75,
                                                blue: 0.98
                                            ),
                                            location: 0.00
                                        ),
                                        Gradient.Stop(
                                            color: Color(
                                                red: 0.73,
                                                green: 0.42,
                                                blue: 0.95
                                            ),
                                            location: 0.35
                                        ),
                                        Gradient.Stop(
                                            color: Color(
                                                red: 0.91,
                                                green: 0.41,
                                                blue: 0.37
                                            ),
                                            location: 0.58
                                        ),
                                        Gradient.Stop(
                                            color: Color(
                                                red: 0.95,
                                                green: 0.67,
                                                blue: 0.24
                                            ),
                                            location: 1.00
                                        ),
                                    ],
                                    startPoint: UnitPoint(x: 0.06, y: 0.27),
                                    endPoint: UnitPoint(x: 1.06, y: 0.77)
                                )
                                .opacity(0.1)
                            }

                        )
                        .clipShape (
                            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 16, bottomTrailingRadius: 16, topTrailingRadius: 0)
                        )
                        .overlay (
                            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 16, bottomTrailingRadius: 16, topTrailingRadius: 0)
                                .stroke(.black.opacity(0.3), lineWidth: 0.5)
                        )
                        .transition(
                            .asymmetric(insertion: .offset(y: -50).combined(with: .opacity),              removal: .offset(y: -20).combined(with: .opacity))
                        )
                        .zIndex(0)
                    }

                }
                .onAppear {
                    isFocused = true
                }
            }
            Spacer()
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isShown.toggle()
                }
            } label: {
                Text("Toggle")
            }
            .background(.red)
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }

    private var currentStreamingText: String {
        guard visibleWordCount > 0 else { return "" }
        return responseWords.prefix(visibleWordCount).joined(separator: " ")
    }

    private func startWordStreaming() {
        visibleWordCount = 0
        Task {
            for i in 1...responseWords.count {
                try? await Task.sleep(nanoseconds: 200_000_000)
                visibleWordCount = i
            }
        }
    }
}

#Preview {
    FindInPage()
        .frame(width: 500, height: 500)
        .background(Image("dia").resizable().scaledToFill())
}
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}
extension AnyTransition {
    static func top(offset: CGFloat = 50) -> AnyTransition {
        let insertion = AnyTransition.offset(y: -offset).combined(with: .opacity)
        let removal = AnyTransition.offset(y: -offset).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

private extension AnyTransition {
    static func offset(x: CGFloat = 0, y: CGFloat = 0) -> AnyTransition {
        .modifier(
            active: OffsetOpacityModifier(x: x, y: y, opacity: 0),
            identity: OffsetOpacityModifier(x: 0, y: 0, opacity: 1)
        )
    }
}

private struct OffsetOpacityModifier: ViewModifier {
    let x: CGFloat
    let y: CGFloat
    let opacity: Double

    func body(content: Content) -> some View {
        content
            .offset(x: x, y: y)
            .opacity(opacity)
    }
}
