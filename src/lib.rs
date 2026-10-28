#![forbid(unsafe_code)]
#![deny(missing_docs)]

//! A minimal library crate for the Rust Starter template.
//!
//! Replace this module with your application's public API.

/// Returns a small health-check string.
///
/// This function exists only to demonstrate a working library and test.
pub fn health() -> &'static str {
    "ok"
}
