helper = require('../../helper')

generate = sinon.spy()
Generator = sinon.mock().returns(generate: generate)
starterRun = sinon.spy()
Starter = sinon.mock().returns(run: starterRun)
clearRun = sinon.spy()
Cleaner = sinon.mock().returns(run: clearRun)
testRun = sinon.spy()
TestRunner = sinon.mock().returns(run: testRun)
build = sinon.spy()
Packager = sinon.mock().returns(build: build)

mock('../../../lib/scaffolding/generator', Generator)
mock('../../../lib/starting/starter', Starter)
mock('../../../lib/clearing/cleaner', Cleaner)
mock('../../../lib/testing/test_runner', TestRunner)
mock('../../../lib/packaging/packager', Packager)

runner = require('../../../lib/bin/runner')

describe 'Runner', ->
  after ->
    mock.stopAll()

  describe '#new', ->
    describe 'with name and no options', ->
      before ->
        runner.new('Gistagram')

      after ->
        generate.resetHistory()
        Generator.resetHistory()

      it 'creates Generator instance', ->
        expect(Generator.calledOnce).to.be.true

      it 'passes name and no options to Generator', ->
        expect(Generator.getCall(0).args).to.eql(['Gistagram', undefined])

      it 'calls generate', ->
        expect(generate.calledOnce).to.be.true

    describe 'with name and skip-install option', ->
      before ->
        runner.new('Gistagram', '--skip-install')

      after ->
        generate.resetHistory()
        Generator.resetHistory()

      it 'creates Generator instance', ->
        expect(Generator.calledOnce).to.be.true

      it 'passes name and options to Generator', ->
        expect(Generator.getCall(0).args).to.eql(['Gistagram', '--skip-install'])

      it 'calls generate', ->
        expect(generate.calledOnce).to.be.true

  describe '#start', ->
    describe 'with no options', ->
      before ->
        runner.start()

      after ->
        starterRun.resetHistory()
        Starter.resetHistory()

      it 'creates Starter instance', ->
        expect(Starter.calledOnce).to.be.true

      it 'passes no options to Starter', ->
        expect(Starter.getCall(0).args[0]).to.eq(undefined)

      it 'calls run', ->
        expect(starterRun.calledOnce).to.be.true

    describe 'with --inspect-brk option', ->
      before ->
        runner.start('--inspect-brk')

      after ->
        starterRun.resetHistory()
        Starter.resetHistory()

      it 'creates Starter instance', ->
        expect(Starter.calledOnce).to.be.true

      it 'passes options to Starter', ->
        expect(Starter.getCall(0).args[0]).to.eq('--inspect-brk')

      it 'calls run', ->
        expect(starterRun.calledOnce).to.be.true

  describe '#clear', ->
    describe 'with no options', ->
      before ->
        runner.clear()

      after ->
        clearRun.resetHistory()
        Cleaner.resetHistory()

      it 'creates Cleaner instance', ->
        expect(Cleaner.calledOnce).to.be.true

      it 'calls run', ->
        expect(clearRun.calledOnce).to.be.true

  describe '#test', ->
    describe 'with no options', ->
      before ->
        runner.test()

      after ->
        testRun.resetHistory()
        TestRunner.resetHistory()

      it 'creates TestRunner instance', ->
        expect(TestRunner.calledOnce).to.be.true

      it 'passes no options to TestRunner', ->
        expect(TestRunner.getCall(0).args[0]).to.eq(undefined)

      it 'calls run', ->
        expect(testRun.calledOnce).to.be.true

    describe 'with --inspect-brk option', ->
      before ->
        runner.test(path: './test/features')

      after ->
        testRun.resetHistory()
        TestRunner.resetHistory()

      it 'creates TestRunner instance', ->
        expect(TestRunner.calledOnce).to.be.true

      it 'passes options to TestRunner', ->
        expect(TestRunner.getCall(0).args[0]).to.eql(path: './test/features')

      it 'calls run', ->
        expect(testRun.calledOnce).to.be.true

  describe '#package', ->
    describe 'with platform name', ->
      before ->
        runner.package('mac')

      after ->
        build.resetHistory()
        Packager.resetHistory()

      it 'creates Packager instance', ->
        expect(Packager.calledOnce).to.be.true

      it 'passes platform, env and publish option to Packager', ->
        expect(Packager.getCall(0).args).to.eql(['mac', 'production', false])

      it 'calls build', ->
        expect(build.calledOnce).to.be.true

    describe 'with platform name and publish option', ->
      before ->
        runner.package('windows', true)

      after ->
        build.resetHistory()
        Packager.resetHistory()

      it 'creates Packager instance', ->
        expect(Packager.calledOnce).to.be.true

      it 'passes platform, env and publish option to Packager', ->
        expect(Packager.getCall(0).args).to.eql(['windows', 'production', true])

      it 'calls build', ->
        expect(build.calledOnce).to.be.true

mock.stopAll()
