use rust_starter::health;

#[test]
fn health_returns_ok() {
    assert_eq!(health(), "ok");
}
