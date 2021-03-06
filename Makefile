PACKAGE=pyner
VERSION := $(shell grep '^__version__ = ' $(PACKAGE)/ner.py | awk -F\" '{print $$2}')
SETUPFILE=setup.py

create:
        @#sed -i -e 's/^version = ".*"/version = "$(VERSION)"/g' $(SETUPFILE)
        python setup.py sdist bdist_wheel

# upload to testpypi
uptest:
        python -m twine upload --repository testpypi dist/*
# uninstall package and test APP
test:
        @echo $(VERSION)
        @#false
        @make uninstall
        pip --no-cache-dir install --index-url https://test.pypi.org/simple/ $(PACKAGE)==$(VERSION)
        @which ner
        @make testapp


# upload to pypi
uppypi:
        python -m twine upload dist/*
# install the latest package
install:
        make uninstall
        pip --no-cache-dir install --index-url https://pypi.org/simple/ $(PACKAGE)==$(VERSION)

# test command
testapp:
        ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier 7class
        @#python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier 4class
        @#python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier 3class
        @#python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier distsim

# uninstall package
uninstall:
        pip uninstall $(PACKAGE) -y
# clean up
clean:
        /bin/rm -rf dist/* build/*
