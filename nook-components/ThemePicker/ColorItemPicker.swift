import SwiftUI

struct ColorScrollView: View {
    @State private var currentPage: Int = 0
    
    let colors = [
        (color: "F3EAE4", stroke: "DAD3CD"),
        (color: "E8D5C4", stroke: "CFC0B1"),
        (color: "D4BFA8", stroke: "BBB09D"),
        (color: "C0AA8F", stroke: "A79A86"),
        (color: "AC9576", stroke: "93845D"),
        (color: "98805D", stroke: "7F6E44"),
        (color: "846B44", stroke: "6B582B"),
        (color: "70562B", stroke: "574212"),
        (color: "5C4112", stroke: "432C00"),
        (color: "F3EAE4", stroke: "DAD3CD"),
        (color: "E8D5C4", stroke: "CFC0B1"),
        (color: "D4BFA8", stroke: "BBB09D"),
        (color: "C0AA8F", stroke: "A79A86"),
        (color: "AC9576", stroke: "93845D"),
        (color: "98805D", stroke: "7F6E44"),
        (color: "846B44", stroke: "6B582B"),
        (color: "70562B", stroke: "574212"),
        (color: "5C4112", stroke: "432C00")
    ]
    
    let itemSpacing: CGFloat = 10
    let itemWidth: CGFloat = 24
    let itemsPerPage: Int = 9
    
    var totalPages: Int {
        Int(ceil(Double(colors.count) / Double(itemsPerPage)))
    }
    
    var containerWidth: CGFloat {
        CGFloat(itemsPerPage) * itemWidth + CGFloat(itemsPerPage - 1) * itemSpacing
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentPage = max(0, currentPage - 1)
                }
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentPage <= 0)
            .opacity(currentPage <= 0 ? 0.3 : 1.0)
            
            Spacer()
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: itemSpacing) {
                        ForEach(0..<colors.count, id: \.self) { index in
                            ColorItem(
                                color: Color(hex: colors[index].color),
                                strokeColor: Color(hex: colors[index].stroke),
                                onClick: {
                                    print("Color \(index) selected")
                                }
                            )
                            .id(index)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(width: containerWidth)
                .scrollDisabled(true)
                .onChange(of: currentPage) { _, newPage in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        proxy.scrollTo(newPage * itemsPerPage, anchor: .leading)
                    }
                }
            }
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentPage = min(totalPages - 1, currentPage + 1)
                }
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(currentPage >= totalPages - 1)
            .opacity(currentPage >= totalPages - 1 ? 0.3 : 1.0)
        }
        .frame(width: 340)
        .padding(.vertical, 12)
    }
}

#Preview {
    ColorScrollView()
        .padding(24)
}
