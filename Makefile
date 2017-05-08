bindir=bin
binary=$(bindir)/crass

default: $(binary)

deps:
	shards install

test:
	crystal spec

$(bindir):
	mkdir -p $(bindir)

$(binary): src/crass.cr src/**/*.cr $(bindir)
	crystal build -o $@ $<

release: src/crass.cr src/**/*.cr $(bindir)
	crystal build -o $(binary) --release src/crass.cr
