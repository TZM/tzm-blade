REPORTER = spec

test:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER)

test-d:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--debug \
		--reporter spec

test-w:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--growl \
		--watch \
		--reporter spec

# test-acceptance:
#    @NODE_ENV=test ./node_modules/.bin/mocha \
#       --bail \
#       test/acceptance/*.js

test-cov: app-cov
	@APP_COV=1 $(MAKE) test REPORTER=html-cov > public/coverage.html

app-cov:
	@jscoverage app app-cov

.PHONY: test test-w test-d

# Best practice testing

# add acceptance tests to test/acceptance
# rename test to test-unit and add test: test-unit test-acceptance

# benchmark:
#    @./support/bench

# clean:
#    rm -f coverage.html
#    rm -fr app-cov

# .PHONY: test test-unit test-acceptance benchmark clean