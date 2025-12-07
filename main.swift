import Foundation
import ScreenCaptureKit
import CoreImage
import CoreGraphics
import AVFoundation

// Wrap everything in an async function
func runSnapshot() async {
    do {
        // MARK: 1. Get main display
        let content = try await SCShareableContent.current
        guard let display = content.displays.first else {
            fatalError("No display found.")
        }

        // MARK: 2. Configure stream
        let config = SCStreamConfiguration()
        config.width = display.width
        config.height = display.height
        config.queueDepth = 1

        let filter = SCContentFilter(display: display, excludingWindows: [])

        let stream = SCStream(filter: filter, configuration: config, delegate: nil)

        // MARK: 3. Output receiver
        final class Output: NSObject, SCStreamOutput {
            var frame: CGImage?

            func stream(_ stream: SCStream,
                        didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
                        of type: SCStreamOutputType) {

                guard type == .screen else { return }
                guard let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

                let ci = CIImage(cvPixelBuffer: pb)
                let ctx = CIContext()
                if let cg = ctx.createCGImage(ci, from: ci.extent) {
                    frame = cg
                }
            }
        }

        let output = Output()
        try stream.addStreamOutput(output,
                                   type: .screen,
                                   sampleHandlerQueue: .global())

        // MARK: 4. Start stream
        try await stream.startCapture()
        try await Task.sleep(nanoseconds: 200_000_000) // wait for first frame

        guard let captured = output.frame else {
            fatalError("No frame captured.")
        }

        try await stream.stopCapture() // must be await

        // MARK: 5. Convert to CIImage
        let ciImage = CIImage(cgImage: captured)

        // MARK: 6. Black & white
        let bw = CIFilter(name: "CIPhotoEffectMono")!
        bw.setValue(ciImage, forKey: kCIInputImageKey)
        guard let bwImg = bw.outputImage else { fatalError("BW failed") }

        // MARK: 7. Flip vertically
        let flipped = bwImg.transformed(
            by: CGAffineTransform(scaleX: 1, y: -1)
                .translatedBy(x: 0, y: -bwImg.extent.height)
        )

        // MARK: 8. Compress JPEG
      let ctx = CIContext()
guard let jpeg = ctx.jpegRepresentation(
    of: flipped,
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    options: [CIImageRepresentationOption(rawValue: kCGImageDestinationLossyCompressionQuality as String): 0.7]
) else {
    fatalError("JPEG failed")
}


        // MARK: 9. Save to Desktop
        let dest = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop/snapshot.jpg")

        try jpeg.write(to: dest)
        print("Saved to:", dest.path)

    } catch {
        print("Error:", error.localizedDescription)
    }
}

// MARK: - Launch async
Task {
    await runSnapshot()
}

// Keep command-line tool alive until async task finishes
RunLoop.main.run()
