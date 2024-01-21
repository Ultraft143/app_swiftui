import SwiftUI

struct ficheiros: View {
    @State private var selectedTab2: Tab2?
    @Environment (\.colorScheme) private var scheme
    @State private var tab2Progress: CGFloat = 1
    var body: some View {
        VStack (spacing: 15) {
            HStack {
                Button (action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
                Spacer()
                
                Button (action: {}, label: {
                    Image(systemName: "line.3.horizontal.decrease")
                })
            }
            .font(.title2)
            .overlay {
                Text("Detalhes")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(15)
            
            CustomTabBar()
            
            
            
            GeometryReader{
                let size = $0.size
                
                
                LazyHStack(spacing: 0){
                    
                    
                    SampleView(.blue)
                        .id(Tab2.ficheiros)
                        .containerRelativeFrame(.horizontal)
                }
                .scrollTargetLayout()
                .offsetX2 { value in
                    
                    let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                    
                    tab2Progress = max(min(progress, 1), 0)
                }
                
                .scrollPosition(id: $selectedTab2)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                .scrollClipDisabled()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.gray.opacity(0.1))
    }
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack (spacing: 0) {
            ForEach(Tab2.allCases, id: \.rawValue) { tab2 in
                HStack(spacing: 10){
                    Image(systemName: tab2.systemImage)
                    
                    Text(tab2.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture{
                    withAnimation(.snappy){
                        selectedTab2 = tab2
                    }
                    
                }
            }
        }
        .tab2Mask(tab2Progress)
        
        .background(){
            GeometryReader{
                let size = $0.size
                let capusleWidth = size.width / CGFloat(Tab2.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capusleWidth)
                    .offset(x:tab2Progress * (size.width - capusleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical){
            LazyVGrid(columns: Array(repeating: GridItem(),count: 2), content: {
                ForEach(1...10, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 150)
                    
                }
                
            })
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
}

#Preview {
    ficheiros()
}
