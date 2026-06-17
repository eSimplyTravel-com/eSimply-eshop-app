// Network-related constants shared across layers.
//
// Lives in the domain layer so the presentation layer can reference these
// values without importing data-layer types (e.g. MainTimeoutException).

/// HTTP-style status code used to represent a request timeout.
const int timeoutErrorCode = 408;
