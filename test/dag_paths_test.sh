. ./test/helper.sh

test_one_path()
{
	assertEquals "A B" "$(
		dag_paths A B <<-"EDGES"
			A B
		EDGES
	)"

	assertEquals "A B C" "$(
		dag_paths A C <<-"EDGES"
			A B
			B C
		EDGES
	)"

	assertEquals "A B C D" "$(
		dag_paths A D <<-"EDGES"
			A E
			E F
			A B
			B C
			B E
			C D
			C F
		EDGES
	)"
}

test_two_paths()
{
	assertEquals "$(
		sort <<-"PATHS"
			A C
			A B C
		PATHS
	)" "$(
		dag_paths A C <<-"EDGES" | sort
			A B
			A C
			B C
		EDGES
	)"

	assertEquals "$(
		sort <<-"PATHS"
			A B D
			A C D
		PATHS
	)" "$(
		dag_paths A D <<-"EDGES" | sort
			A B
			A C
			B D
			C D
		EDGES
	)"
}

test_no_edges_returns_null()
{
	expectNull "$( dag_paths A B < /dev/null )"
}

test_unreachable_returns_null()
{
	expectNull "$(
		dag_paths A B <<-"EDGES"
			A C
		EDGES
	)"

	expectNull "$(
		dag_paths A D <<-"EDGES"
			A B
			B C
		EDGES
	)"
}

test_cyclical_terminates()
{
	assertEquals "A B" "$(
		dag_paths A B <<-"EDGES" | sort
			A B
			B A
		EDGES
	)"

	assertEquals "A B C" "$(
		dag_paths A C <<-"EDGES" | sort
			A B
			B A
			B C
		EDGES
	)"

	assertEquals "$(
		sort <<-"PATHS"
			A B C
			A A B C
			A A A B C
		PATHS
	)" "$(
		dag_paths A C <<-"EDGES" | sort
			A B
			A A
			B C
			D E
		EDGES
	)"
}

SHUNIT_PARENT=$0 . $SHUNIT2
