all: tmp tmp/swarm.svg

tmp:
	mkdir -p $@

tmp/swarm.dot:
	./swarm.pl > $@

tmp/swarm.svg: tmp/swarm.dot
	dot $< -T svg > $@

clean:
	rm -rf tmp
