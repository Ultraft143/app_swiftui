import SwiftUI

struct OffsetKey2: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat){
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX2(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame (in: .scrollView(axis: .horizontal)).minX

                    Color.clear
                        .preference(key: OffsetKey2.self, value: minX)
                        .onPreferenceChange(OffsetKey2.self, perform: completion)

                }
            }
    }
    @ViewBuilder
    func tab2Mask(_ tab2Progress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)

            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader{
                        let size = $0.size
                        let capusleWidth = size.width / CGFloat(Tab2.allCases.count)

                        Capsule()
                            .frame(width: capusleWidth)
                            .offset(x:tab2Progress * (size.width - capusleWidth))
                    }
                }
        }
    }
}


#Preview {
    ContentView()
}
//isto tem haver com a pasta ficheiros
