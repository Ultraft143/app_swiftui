import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat){
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame (in: .scrollView(axis: .horizontal)).minX

                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)

                }
            }
    }
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)

            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader{
                        let size = $0.size
                        let capusleWidth = size.width / CGFloat(Tab.allCases.count)

                        Capsule()
                            .frame(width: capusleWidth)
                            .offset(x:tabProgress * (size.width - capusleWidth))
                    }
                }
        }
    }
}


#Preview {
    ContentView()
}
//isto tem haver com a pasta geralquestao
