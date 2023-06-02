//
//  DashedBorderView.swift
//  MacToolBox
//
//  Created by 朱校明 on 2023/6/2.
//

import SwiftUI

struct DashedBorderView: View {
    @Binding var isSuccess: Bool
    
    var body: some View {
        Rectangle()
            .strokeBorder(style: StrokeStyle(lineWidth: 2.0, dash: isSuccess ? [0] : [5]))
    }
}

struct DashedBorder_Previews: PreviewProvider {
    static var previews: some View {
        DashedBorderView(isSuccess: .constant(false))
    }
}
