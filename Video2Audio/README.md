#  Errors

* Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
* Attempting to export a document using a content type ("public.audio") not included in its `writableContentTypes`. This content type will not be used for export.
