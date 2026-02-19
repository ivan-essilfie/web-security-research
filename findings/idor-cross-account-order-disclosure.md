# Unauthenticated BOLA to PII & Delivery Address Disclosure

## Summary

During a security assessment of a large-scale e-commerce platform, I identified a Broken Object Level Authorization (BOLA) vulnerability in the order tracking API. By chaining this with a secondary endpoint, I demonstrated how an unauthenticated attacker could disclose sensitive purchase history and physical delivery addresses via third-party tracking integrations.

The vulnerability was responsibly disclosed and accepted as a valid security issue.

---

## Vulnerability Type

- Broken Access Control
- Insecure Direct Object Reference (IDOR)
- Broken Object Level Authorization (OWASP API Security)
- Chained Data Exposure

---

## Discovery Process

While reviewing the "My Account" functionality, I observed client-side requests made to an order tracking endpoint similar to:

`GET /api/orders/{userId}`

The endpoint relied on a numeric `userId` parameter to return order history data.

Testing the endpoint without session cookies or authorization headers revealed that the API did not enforce authentication or ownership validation. By modifying the `userId`, I was able to retrieve order metadata associated with other users.

## Technical Analysis

### 1. Initial Access — Cross-Account Order Enumeration

Iterating through predictable numeric `userId` values returned JSON responses containing:

- `orderNumber`
- `orderDate`
- `trackingUrl`

The absence of server-side authorization checks enabled cross-account data retrieval.

### 2. Secondary Pivot — Order Detail Disclosure

Using a discovered `orderNumber`, I queried a related endpoint (e.g., `/orders/{orderNumber}`), which returned itemized purchase details for another user.

This demonstrated that the application trusted client-supplied object identifiers without verifying resource ownership.

### 3. Chained Impact — Physical Address Exposure

The `trackingUrl` referenced a third-party carrier proof-of-delivery page.

Certain delivery confirmation photos visibly displayed the shipping label, exposing:

- Customer Full Name
- Street Address

Although the original API response did not directly include PII, the integration design enabled escalation from order metadata to physical address disclosure.

---

## Impact Assessment

This vulnerability illustrates how seemingly low-sensitivity data (order metadata) can escalate into high-impact privacy exposure when:

- Object references are predictable
- Authorization checks are absent
- Third-party integrations expose additional artifacts

The exposure of physical delivery addresses introduces potential risks including targeted harassment, social engineering, and privacy violations.

---

## Root Cause

- Missing authentication enforcement on order-related endpoints
- No server-side validation binding `userId` to an authenticated session
- Reliance on client-controlled object identifiers
- Overexposure of direct object references enabling enumeration

---

## Recommended Remediation

- Enforce authentication and strict server-side authorization checks on all order endpoints
- Bind resource access to the authenticated user context
- Replace predictable numeric identifiers with indirect references where appropriate
- Review third-party integration flows for unintended data exposure paths
- Conduct a broader authorization audit across related APIs

---

## Key Takeaways

- Broken object-level authorization remains one of the most impactful API security weaknesses.
- Chained impact analysis is critical when evaluating real-world severity.
- Third-party integrations can amplify the impact of otherwise moderate vulnerabilities.
- Authorization must be enforced server-side, independent of client-side logic.
