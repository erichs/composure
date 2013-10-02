
all:
	@echo "Try: make test"
	@false

tests:
	(cd test && make tests)

clean::
	rm -f test/*~ test/t/*~
