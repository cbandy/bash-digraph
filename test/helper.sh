[ -n "$SHUNIT2" ] || SHUNIT2='/usr/share/shunit2/shunit2'

. ./share/digraph/digraph.sh

oneTimeSetUp() { return; }
setUp() { return; }
tearDown() { return; }
oneTimeTearDown() { return; }

expectNull() {
	assertNull "expected null but was:<$1>" "$1"
}

expectNotNull() {
	assertNotNull "expected not null" "$1"
}
