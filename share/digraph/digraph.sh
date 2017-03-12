
# dag_paths finds all the paths between two nodes in a directed acyclic graph.
# Edges are consumed from STDIN, and paths are printed to STDOUT.
dag_paths()
{
	declare origin=$1 target=$2
	declare -A adjacency nodes

	while read -r src dst desc ; do
		adjacency[$src]="${adjacency[$src]}${adjacency[$src]:+ }$dst"
		nodes[$src]=1
		nodes[$dst]=1
	done

	_dag_paths_dfs "$origin"
}

# _dag_paths_dfs is used by dag_paths to search for the target node depth-first.
# When the target node is found, the path is printed to STDOUT.
_dag_paths_dfs()
{
	declare node=${1##* } path=($1)

	if [ "$node" = "$target" ]; then
		echo "${path[*]}"

	elif [ ${#path[*]} -lt ${#nodes[*]} ]; then
		for n in ${adjacency[$node]} ; do
			_dag_paths_dfs "${path[*]} $n"
		done
	fi
}

# dag_shortest_path finds the shortest path between two nodes in a directed
# acyclic graph. Edges are consumed from STDIN, and the path is printed to
# STDOUT.
dag_shortest_path()
{
	dag_paths "$@" | {
		declare path= shortest=

		while IFS= read -r path; do
			if [ "${#shortest}" -gt "${#path}" ] || [ -z "$shortest" ]; then
				shortest="$path"
			fi
		done

		echo "$shortest"
	}
}
