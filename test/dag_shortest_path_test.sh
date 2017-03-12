. ./test/helper.sh

test_one_path()
{
	assertEquals "A B" "$(
		dag_shortest_path A B <<-"EDGES"
			A B
		EDGES
	)"
}

test_two_paths()
{
	assertEquals "A C" "$(
		dag_shortest_path A C <<-"EDGES"
			A B
			A C
			B C
		EDGES
	)"
}

test_no_edges_returns_null()
{
	expectNull "$( dag_shortest_path A B < /dev/null )"
}

test_unreachable_returns_null()
{
	expectNull "$(
		dag_shortest_path A B <<-"EDGES"
			A C
		EDGES
	)"
}

test_cyclical_terminates()
{
	assertEquals "A B" "$(
		dag_shortest_path A B <<-"EDGES"
			A B
			B A
		EDGES
	)"

	assertEquals "A B C" "$(
		dag_shortest_path A C <<-"EDGES"
			A B
			B A
			B C
		EDGES
	)"

	assertEquals "A B C" "$(
		dag_shortest_path A C <<-"EDGES"
			A B
			A A
			B C
			D E
		EDGES
	)"
}

SHUNIT_PARENT=$0 . $SHUNIT2
