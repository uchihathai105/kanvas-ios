//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation

public protocol KanvasCancelable {
    /// Cancels the running operation.
    func cancel()
}

public protocol KanvasStickerLoader {

    func loadSticker(at imageURL: URL, imageView: UIImageView?, completion: @escaping (UIImage?, Error?) -> Void) -> KanvasCancelable

}
