# Video2Audio

This is a single app for macos and ios, maybe watchOS in the feature.

Its functionality is converting videos to audios.

Why do people want to convert videos to audios?

I think there might be some situations when users only want to hear the audio, like musics, conversations, even teleplays.

In such cases:

* The file size of a video usually is five times larger than its audio, this can significantly save your storage.
* Playing audio costs much less power than playing videos, this can significantly save powers.

Other functionalities:

* The app can also play the audios you converted.
* You can create multiple playlists and play them(roadmap).
* You can share the audios with other apps.
* You can manage your converted audios, delete them or export them to a different location.
* You can find the converted audios in the File App. But you should not perform actions directly on that folder(delete files or add files), you should perform the actions inside the app. The reason of exposing this folder is I want users to known where the converted audios are stored.

Currently, the app only support convert videos to audio in a number of formats formats.

* ✅ QuickTime Movie (.mov): A format natively supported by Apple, which supports a wide variety of codecs like H.264, ProRes, and others.
* ✅ MPEG-4 (.mp4, .m4v): This is a widely supported format that works across many devices. The MPEG-4 Part 2 and H.264 (MPEG-4 Part 10) codecs are commonly used.
* ❎ AVI (.avi): While not natively preferred by Apple, certain codecs in AVI files can be handled by AVFoundation through transcoding or conversion.
* ❎ HEVC (.h265): High-Efficiency Video Coding (HEVC), also known as H.265, is supported on modern Apple devices for video playback and encoding.
* ❎ 3GP (.3gp, .3g2): Mobile video format based on the MPEG-4 and H.264 standards.
* ❎ MPEG-2 (.mpg): MPEG-2 encoded video files are used in various applications, including DVDs and broadcast television.

And the videos can be converted to audios in formats below:

* ✅MPEG-4 Audio (.mp4)
* ❎ AAC (.aac): This is the audio format used in MP4/M4A containers.
* ❎ WAV (.wav)
* ❎ Apple Lossless (.caf)

A 10M video usually can produce an audio in 2M or less.
