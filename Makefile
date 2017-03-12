
.PHONY: test
test: share/*/*.sh test/*.sh
	test/runner
