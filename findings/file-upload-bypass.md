# File Upload Extension Bypass via Filename Tampering

## Bug Class
Improper Input Validation, File Upload Bypass

## Description
While testing the file upload functionality of a development environment, it was discovered that the application improperly enforced file extension restrictions based solely on client-side or superficial validation. Although the UI appeared to accept only `.pdf`, `.txt`, `.jpg`, `.jpeg`, and `.png` files, it was possible to upload a restricted file type (e.g., `.svg`) by tampering with the `filename` parameter during the HTTP request.

This behavior allows a user to bypass client-side restrictions and upload files that may carry unintended risk, even if rendered as downloads.

## Discovery Method
Manual testing using [Burp Suite](https://portswigger.net/burp), including request interception and filename manipulation.

## Steps to Reproduce

1. Upload a permitted file (e.g., `test.jpg`) through the application's upload interface.
2. Intercept the HTTP POST request in Burp Suite.
3. Modify the `filename` parameter to use a restricted extension (e.g., `test.svg`):
4. Forward the request and observe that the upload still succeeds.
5. The uploaded file will appear in the UI as a downloadable link (e.g., `test.svg`).
6. When clicking the link, the browser prompts the user to download the file instead of rendering it inline.


## Observed Behavior

- The `.svg` file is accepted despite being restricted in the UI.
- The application sets the `Content-Disposition: attachment` header, forcing a download.
- The file executes no active content due to forced download behavior.


## Recommendation
-Perform strict server-side validation of uploaded files, including:
-Whitelisting allowed MIME types and extensions.
-Validating file signatures (magic bytes) to match declared type.
-Avoid relying solely on filename extensions for upload decisions.
-Reject unexpected file types at both client and server layers.
