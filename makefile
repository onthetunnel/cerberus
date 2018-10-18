all: tmp
	./arbitrage.py | tee tmp/readme.md

tmp:
	mkdir -p tmp

deploy:
	mv tmp/readme.md readme.md
