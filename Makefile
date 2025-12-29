# Copyright (c) 2025 Shahriar Nasim Nafi, MIT License

.PHONY: build

SQLITE_RELEASE_YEAR := 2024
SQLITE_VERSION := 3460000
ARABIC_TOKENIZER_VERSION := 0.0.3

prepare-src:
	mkdir -p sqlite
	rm -rf sqlite/*

download-sqlite:
	curl -L https://github.com/sqlite/sqlite/raw/master/src/test_windirent.h --output sqlite/test_windirent.h
	curl -L https://sqlite.org/$(SQLITE_RELEASE_YEAR)/sqlite-amalgamation-$(SQLITE_VERSION).zip --output sqlite.zip
	unzip sqlite.zip
	mv sqlite-amalgamation-$(SQLITE_VERSION)/* sqlite
	rmdir sqlite-amalgamation-$(SQLITE_VERSION)
	rm -f sqlite.zip

download-sqlite3_arabic_phonetic_fuzzy_trigram:
	curl -L https://github.com/Greentech-Apps-Limited/sqlite3-arabic-phonetic-fuzzy-trigram/archive/refs/tags/$(ARABIC_TOKENIZER_VERSION).zip --output sqlite3-arabic-phonetic-fuzzy-trigram.zip
	unzip sqlite3-arabic-phonetic-fuzzy-trigram.zip
	mv sqlite3-arabic-phonetic-fuzzy-trigram-$(ARABIC_TOKENIZER_VERSION) pkg-src
	cp pkg-src/src/*.h sqlite/
	cp pkg-src/src/*.c sqlite/
	cat src/init.c >> sqlite/sqlite3.c
	cp src/init.h sqlite
	rm -rf pkg-src
	rm -f sqlite3-arabic-phonetic-fuzzy-trigram.zip

clean:
	rm -rf build/*
	rm -f dist/*
	rm -rf sqlite3_arabic_phonetic_fuzzy_trigram/*.so
	rm -rf sqlite3_arabic_phonetic_fuzzy_trigram.py.egg-info

build:
	python -m pip install --upgrade setuptools wheel
	python setup.py build_ext -i
	python -m test
	python -m pip wheel . -w dist
