all: tmp timestamp
	./cerberus.py | tee --append tmp/readme.md

tmp:
	mkdir -p tmp

deploy:
	mv tmp/readme.md readme.md

timestamp:
	echo Generated $(shell date) > tmp/readme.md
