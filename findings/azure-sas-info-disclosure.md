# Azure SAS Token Disclosure Vulnerability

## Bug Class
Information Disclosure, Insecure Direct Object Reference (IDOR), Improper Access Control

## Description
During testing of a development portal, it was discovered that an endpoint returned a full Azure Storage Account Shared Access Signature (SAS) URL when accessed. This SAS URL was programmatically retrieved by frontend JavaScript and could be accessed directly by any authenticated user.

SAS URLs grant time-bound and permission-specific access to Azure Storage containers and objects. If not properly scoped or exposed unnecessarily, these can be abused by attackers to access or modify cloud resources.

## Discovery Method
Manual testing and inspection of frontend JavaScript files and subsequent API behavior using Burp Suite.

## Steps to Reproduce
1. Log into the development portal.
2. Navigate to: `https://dev.example.com/script.js`.
3. Within the JavaScript file, identify a function that performs a fetch to:  
   `/api/example/saskey`
4. Using Burp Suite, intercept and replay a request to `/api/example/saskey`.
5. Observe that the response includes a **complete SAS URL** in JSON format, such as:

```json
{
  "sasUrl": "https://exampleaccount.blob.core.windows.net/container/resource.json?sv=2020-08-04&ss=b&srt=sco&sp=rwdlacx&se=2025-12-31T08:00:00Z&st=2025-01-01T08:00:00Z&spr=https&sig=REDACTED"
}



## Observations
- Token was time-bound (`st`/`se` parameters).
- `sp=r` confirmed read-only access.
- `sr=b` indicates access to a blob.
- The blob endpoint returned 403 Unauthorized.

## Recommendation
Avoid embedding sensitive keys in frontend assets. Use secure backend calls and rotate keys regularly.

## Status
Reported via VDP. Response received, considered low impact.
