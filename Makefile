PACKAGE=pyner
VERSION=0.0.8
SETUPFILE=setup.py

create:
        sed -i -e 's/^version = ".*"/version ="$(VERSION)"/g' $(SETUPFILE)
        python setup.py sdist bdist_wheel


uploadtest:
        python -m twine upload --repository testpypi dist/*
test:
        pip --no-cache-dir install --index-url https://test.pypi.org/simple/ $(PACKAGE)
        make test



uploadpypi:
        python -m twine upload dist/*
install:
        make uninstall
        pip --no-cache-dir install --index-url https://pypi.org/simple/ $(PACKAGE)

test:
        python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier 7class
        python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier 4class
        python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier 3class
        python -m pyner.ner --nertype stanford --sentence 'hello, chongqing, intel, IBM, Tecent. Bill Gates said.' --classifier distsim

uninstall:
        pip uninstall $(PACKAGE) -y
clean:
        /bin/rm -rf dist/* build/*
