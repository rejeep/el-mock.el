# El mock

[![Build Status](file:https://github.com/rejeep/el-mock.el/actions/workflows/main.yml/badge.svg)](https://github.com/rejeep/el-mock.el/actions/workflows/main.yml)
[![Coverage Status](https://coveralls.io/repos/rejeep/el-mock.el/badge.svg)](https://coveralls.io/r/rejeep/el-mock.el)
[![MELPA](http://melpa.org/packages/el-mock-badge.svg)](http://melpa.org/#/el-mock)
[![MELPA stable](http://stable.melpa.org/packages/el-mock-badge.svg)](http://stable.melpa.org/#/el-mock)
[![Tag Version](https://img.shields.io/github/tag/rejeep/el-mock.el.svg)](https://github.com/rejeep/el-mock.el/tags)
[![License](http://img.shields.io/:license-gpl3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0.html)

_**NOTE**: El mock has moved from
<http://www.emacswiki.org/emacs/el-mock.el> to
<https://github.com/rejeep/el-mock.el> and its new maintainer is
[@rejeep](https://github.com/rejeep)._

El mock is a mocking library for Emacs. 

## How to use it
Add this to your test-helper, [for instance](https://github.com/rejeep/prodigy.el/blob/700eb15293260fdfa2fc0cff38df600693b7e4e5/test/test-helper.el#L107-L109)
```emacs-lisp
(require 'el-mock)
```

An example of a simple mock that displays "/mocked/file/name.el":
```emacs-lisp
(with-mock
  (stub buffer-file-name => "/mocked/file/name.el")
  (display-message-or-buffer (buffer-file-name)))
```

## Documentation

Find the documentation at `M-x describe-function RET with-mock RET`
and `M-x describe-function RET mocklet RET`.

The old documentation is at https://www.emacswiki.org/emacs/EmacsLispMock


## Contribution

Be sure to!

Install [Cask](https://github.com/cask/cask) if you haven't already.

Run the unit tests with:

    $ make test
