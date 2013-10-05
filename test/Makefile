
TARGET = tests

all: $(TARGET)

runtests:
	./runtests.sh

runshellcheck:
	./runshellcheck.sh

tests:
	./wvtestrun $(MAKE) runtests
	./wvtestrun $(MAKE) runshellcheck

clean::
	rm -f *~ t/*~
	rm -rf composure_test

