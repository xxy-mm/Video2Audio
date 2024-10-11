#  Errors

* Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
* Attempting to export a document using a content type ("public.audio") not included in its `writableContentTypes`. This content type will not be used for export.
struct AudioResultRow: View {
    @ObservedObject var audioResult: AudioResult
    
    var body: some View {
        HStack {
            Text("\(audioResult.audioURL.lastPathComponent)")
            Spacer()
            statusImage(status: audioResult.status)
        }
    }

    func statusImage(status: VideoConvertStatus) -> some View {
        if status == .error {
            return Image(systemName: "xmark.octagon")
                .foregroundColor(.red)
        } else if status == .success {
            return Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.blue)
        } else {
            return Image(systemName: "arrow.2.circlepath.circle")
                .foregroundColor(.green)
        }
    }
}
